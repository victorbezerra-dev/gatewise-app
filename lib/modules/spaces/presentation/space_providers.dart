import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/entities/user_entity.dart';
import '../../../core/infra/secure_storage.dart';
import '../../../core/providers/custom_http_client_provider.dart';
import '../domain/entities/access_grant_entity.dart';
import '../domain/entities/space_entity.dart';
import '../infra/dtos/access_grant_dto.dart';
import '../infra/dtos/space_payload_dto.dart';
import '../infra/space_repository.dart';

final spaceRepositoryProvider = Provider<SpaceRepository>((ref) {
  return SpaceRepository(ref.watch(customHttpClientProvider));
});

final spaceControllerProvider =
    StateNotifierProvider<SpaceController, SpaceState>((ref) {
      return SpaceController(ref.watch(spaceRepositoryProvider));
    });

class SpaceState {
  const SpaceState({
    this.spaces = const AsyncLoading(),
    this.selectedSpace = const AsyncData(null),
    this.grants = const AsyncData([]),
    this.myGrants = const AsyncData([]),
    this.action = const AsyncData(null),
    this.actionErrorMessage,
    this.membershipExpired = false,
  });

  final AsyncValue<List<Space>> spaces;
  final AsyncValue<Space?> selectedSpace;
  final AsyncValue<List<AccessGrant>> grants;
  final AsyncValue<List<AccessGrant>> myGrants;
  final AsyncValue<void> action;
  final String? actionErrorMessage;
  final bool membershipExpired;

  SpaceState copyWith({
    AsyncValue<List<Space>>? spaces,
    AsyncValue<Space?>? selectedSpace,
    AsyncValue<List<AccessGrant>>? grants,
    AsyncValue<List<AccessGrant>>? myGrants,
    AsyncValue<void>? action,
    String? actionErrorMessage,
    bool clearActionErrorMessage = false,
    bool membershipExpired = false,
  }) {
    return SpaceState(
      spaces: spaces ?? this.spaces,
      selectedSpace: selectedSpace ?? this.selectedSpace,
      grants: grants ?? this.grants,
      myGrants: myGrants ?? this.myGrants,
      action: action ?? this.action,
      actionErrorMessage: clearActionErrorMessage
          ? null
          : actionErrorMessage ?? this.actionErrorMessage,
      membershipExpired: membershipExpired,
    );
  }
}

class DeviceProvisionResult {
  const DeviceProvisionResult({
    required this.devicePrivateKeyPem,
    required this.backendPublicKeyPem,
  });

  final String devicePrivateKeyPem;
  final String backendPublicKeyPem;
}

class SpaceController extends StateNotifier<SpaceState> {
  SpaceController(this._repository) : super(const SpaceState());

  final SpaceRepository _repository;

  Future<void> loadSpaces(int organizationId) async {
    state = state.copyWith(spaces: const AsyncLoading());
    try {
      final data = await _repository.listSpaces(organizationId);
      state = state.copyWith(spaces: AsyncData(data));
    } on SpaceApiException catch (e, st) {
      if (e.statusCode == 403) {
        state = state.copyWith(spaces: const AsyncData([]));
        return;
      }
      state = state.copyWith(spaces: AsyncError(e, st));
    } catch (e, st) {
      state = state.copyWith(spaces: AsyncError(e, st));
    }
  }

  Future<void> loadSpaceDetails(int id) async {
    state = state.copyWith(
      selectedSpace: const AsyncLoading(),
      grants: const AsyncLoading(),
      myGrants: const AsyncLoading(),
    );
    await Future.wait([loadSpace(id), loadGrants(id), loadMyGrantsForCurrentUser(id)]);
  }

  Future<void> loadMyGrantsForCurrentUser(int spaceId) async {
    try {
      final userJson = await SecureStore.getUserJson();
      if (userJson == null) {
        state = state.copyWith(myGrants: const AsyncData([]));
        return;
      }
      final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      final data = await _repository.listMyGrants(user.id);
      final filtered = data.where((g) => g.spaceId == spaceId).toList();
      state = state.copyWith(myGrants: AsyncData(filtered));
    } catch (_) {
      state = state.copyWith(myGrants: const AsyncData([]));
    }
  }

  /// Loads every access-grant request the current user has made, across all
  /// spaces, so space lists can flag which locked cards have a pending
  /// request instead of just showing them all as plain "no access".
  Future<void> loadAllMyGrantsForCurrentUser() async {
    try {
      final userJson = await SecureStore.getUserJson();
      if (userJson == null) {
        state = state.copyWith(myGrants: const AsyncData([]));
        return;
      }
      final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      final data = await _repository.listMyGrants(user.id);
      state = state.copyWith(myGrants: AsyncData(data));
    } catch (_) {
      state = state.copyWith(myGrants: const AsyncData([]));
    }
  }

  Future<void> loadSpace(int id) async {
    try {
      final space = await _repository.getSpaceById(id);
      state = state.copyWith(selectedSpace: AsyncData(space));
    } catch (e, st) {
      state = state.copyWith(selectedSpace: AsyncError(e, st));
    }
  }

  Future<void> loadGrants(int spaceId) async {
    try {
      final all = await _repository.listAllGrants();
      final filtered = all.where((g) => g.spaceId == spaceId).toList();
      state = state.copyWith(grants: AsyncData(filtered));
    } on SpaceApiException catch (e, st) {
      if (e.statusCode == 403) {
        state = state.copyWith(grants: const AsyncData([]));
        return;
      }
      state = state.copyWith(grants: AsyncError(e, st));
    } catch (e, st) {
      state = state.copyWith(grants: AsyncError(e, st));
    }
  }

  Future<void> loadMyGrants(String userId) async {
    state = state.copyWith(myGrants: const AsyncLoading());
    try {
      final data = await _repository.listMyGrants(userId);
      state = state.copyWith(myGrants: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(myGrants: AsyncError(e, st));
    }
  }

  Future<Space?> createSpace(int organizationId, SpacePayload payload) async {
    return _runAction(() async {
      final space = await _repository.createSpace(organizationId, payload);
      await loadSpaces(organizationId);
      return space;
    });
  }

  Future<bool> updateSpace(int organizationId, int id, SpacePayload payload) async {
    final result = await _runAction(() async {
      await _repository.updateSpace(id, payload);
      await loadSpaceDetails(id);
      await loadSpaces(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> deleteSpace(int organizationId, int id) async {
    final result = await _runAction(() async {
      await _repository.deleteSpace(id);
      await loadSpaces(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> openSpace(
    int id, {
    required int timestamp,
    required String signature,
  }) async {
    final result = await _runAction(() async {
      await _repository.openSpace(
        id,
        timestamp: timestamp,
        signature: signature,
      );
      return true;
    });
    return result ?? false;
  }

  Future<String?> fetchBackendPublicKey() async {
    return _runAction(() => _repository.getBackendPublicKey());
  }

  Future<DeviceProvisionResult?> provisionDevice(int spaceId) async {
    return _runAction(() async {
      final results = await Future.wait([
        _repository.generateDeviceKeys(spaceId),
        _repository.getBackendPublicKey(),
      ]);
      return DeviceProvisionResult(
        devicePrivateKeyPem: results[0],
        backendPublicKeyPem: results[1],
      );
    });
  }

  Future<bool> requestAccess(RequestAccessPayload payload) async {
    final result = await _runAction(() async {
      await _repository.requestAccess(payload);
      return true;
    });
    return result ?? false;
  }

  Future<bool> approveGrant(int grantId, int spaceId, {String? reason}) async {
    final result = await _runAction(() async {
      await _repository.reviewGrant(
        grantId,
        AccessGrantReviewPayload(status: AccessGrantReviewStatus.approved, reason: reason),
      );
      await loadGrants(spaceId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> rejectGrant(int grantId, int spaceId, {String? reason}) async {
    final result = await _runAction(() async {
      await _repository.reviewGrant(
        grantId,
        AccessGrantReviewPayload(status: AccessGrantReviewStatus.rejected, reason: reason),
      );
      await loadGrants(spaceId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> deleteGrant(int grantId, int spaceId) async {
    final result = await _runAction(() async {
      await _repository.deleteGrant(grantId);
      await loadGrants(spaceId);
      return true;
    });
    return result ?? false;
  }

  Future<T?> _runAction<T>(Future<T> Function() action) async {
    state = state.copyWith(
      action: const AsyncLoading(),
      clearActionErrorMessage: true,
    );
    try {
      final result = await action();
      state = state.copyWith(
        action: const AsyncData(null),
        clearActionErrorMessage: true,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        action: const AsyncData(null),
        actionErrorMessage: e.toString(),
        membershipExpired: e is SpaceApiException && e.reasonCode == 'membership_expired',
      );
      return null;
    }
  }
}
