import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/entities/user_entity.dart';
import '../../../core/infra/secure_storage.dart';
import '../../../core/providers/custom_http_client_provider.dart';
import '../../../modules/spaces/domain/entities/access_grant_entity.dart';
import '../../../modules/spaces/domain/value_objects/access_grant_status_vo.dart';
import '../../../modules/spaces/infra/dtos/access_grant_dto.dart';
import '../infra/grant_request_repository.dart';

final grantRequestRepositoryProvider = Provider<GrantRequestRepository>((ref) {
  return GrantRequestRepository(ref.watch(customHttpClientProvider));
});

enum GrantViewType { mine, toReview }

class GrantRequestState {
  const GrantRequestState({
    this.grants = const AsyncLoading(),
    this.viewType = GrantViewType.mine,
    this.statusFilter,
    this.isReviewing = false,
    this.reviewError,
  });

  final AsyncValue<List<AccessGrant>> grants;
  final GrantViewType viewType;
  final AccessGrantStatus? statusFilter;
  final bool isReviewing;
  final String? reviewError;

  bool get hasActiveFilters => statusFilter != null;

  GrantRequestState copyWith({
    AsyncValue<List<AccessGrant>>? grants,
    GrantViewType? viewType,
    AccessGrantStatus? statusFilter,
    bool clearStatusFilter = false,
    bool? isReviewing,
    String? reviewError,
    bool clearReviewError = false,
  }) {
    return GrantRequestState(
      grants: grants ?? this.grants,
      viewType: viewType ?? this.viewType,
      statusFilter: clearStatusFilter
          ? null
          : statusFilter ?? this.statusFilter,
      isReviewing: isReviewing ?? this.isReviewing,
      reviewError: clearReviewError ? null : reviewError ?? this.reviewError,
    );
  }
}

class GrantRequestController extends StateNotifier<GrantRequestState> {
  GrantRequestController(this._repository) : super(const GrantRequestState());

  final GrantRequestRepository _repository;
  String? _cachedUserId;

  Future<String?> _getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final userJson = await SecureStore.getUserJson();
    if (userJson == null) return null;
    final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    _cachedUserId = user.id;
    return _cachedUserId;
  }

  Future<void> load({
    GrantViewType? viewType,
    AccessGrantStatus? status,
    bool clearStatus = false,
  }) async {
    state = state.copyWith(
      grants: const AsyncLoading(),
      viewType: viewType,
      statusFilter: status,
      clearStatusFilter: clearStatus,
    );
    try {
      final data = await _fetch();
      state = state.copyWith(grants: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(grants: AsyncError(e, st));
    }
  }

  Future<List<AccessGrant>> _fetch() async {
    if (state.viewType == GrantViewType.toReview) {
      return _repository.listRequestsToReview(status: state.statusFilter);
    }
    final userId = await _getUserId();
    if (userId == null) return [];
    return _repository.listMyRequests(
      userId: userId,
      status: state.statusFilter,
    );
  }

  Future<void> setViewType(GrantViewType viewType) =>
      load(viewType: viewType, clearStatus: true);

  Future<void> setStatusFilter(AccessGrantStatus? status) =>
      load(status: status, clearStatus: status == null);

  Future<void> clearFilters() => load(clearStatus: true);

  Future<void> refresh() => load();

  Future<bool> approveGrant(int grantId) =>
      _review(grantId, AccessGrantReviewStatus.approved);

  Future<bool> rejectGrant(int grantId) =>
      _review(grantId, AccessGrantReviewStatus.rejected);

  Future<bool> _review(int grantId, AccessGrantReviewStatus status) async {
    state = state.copyWith(isReviewing: true, clearReviewError: true);
    try {
      await _repository.reviewGrant(grantId, status);
      final data = await _fetch();
      state = state.copyWith(isReviewing: false, grants: AsyncData(data));
      return true;
    } catch (e) {
      state = state.copyWith(isReviewing: false, reviewError: e.toString());
      return false;
    }
  }
}

final grantRequestControllerProvider =
    StateNotifierProvider<GrantRequestController, GrantRequestState>((ref) {
      final controller = GrantRequestController(
        ref.watch(grantRequestRepositoryProvider),
      );
      controller.load();
      return controller;
    });
