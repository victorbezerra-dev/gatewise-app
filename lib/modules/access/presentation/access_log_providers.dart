import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/custom_http_client_provider.dart';
import '../domain/entities/access_log_entity.dart';
import '../domain/value_objects/access_log_status_vo.dart';
import '../infra/access_log_repository.dart';

final accessLogRepositoryProvider = Provider<AccessLogRepository>((ref) {
  return AccessLogRepository(ref.watch(customHttpClientProvider));
});

enum AccessLogViewMode { myLogs, spaceLogs }

class AccessLogState {
  const AccessLogState({
    this.logs = const AsyncLoading(),
    this.statusFilter,
    this.fromFilter,
    this.toFilter,
    this.viewMode = AccessLogViewMode.myLogs,
    this.selectedSpaceId,
    this.selectedSpaceName,
  });

  final AsyncValue<List<AccessLog>> logs;
  final AccessLogStatus? statusFilter;
  final DateTime? fromFilter;
  final DateTime? toFilter;
  final AccessLogViewMode viewMode;
  final int? selectedSpaceId;
  final String? selectedSpaceName;

  bool get hasActiveFilters =>
      statusFilter != null || fromFilter != null || toFilter != null;

  AccessLogState copyWith({
    AsyncValue<List<AccessLog>>? logs,
    AccessLogStatus? statusFilter,
    DateTime? fromFilter,
    DateTime? toFilter,
    bool clearStatusFilter = false,
    bool clearDateFilter = false,
    AccessLogViewMode? viewMode,
    int? selectedSpaceId,
    String? selectedSpaceName,
    bool clearSpaceSelection = false,
  }) {
    return AccessLogState(
      logs: logs ?? this.logs,
      statusFilter: clearStatusFilter
          ? null
          : statusFilter ?? this.statusFilter,
      fromFilter: clearDateFilter ? null : fromFilter ?? this.fromFilter,
      toFilter: clearDateFilter ? null : toFilter ?? this.toFilter,
      viewMode: viewMode ?? this.viewMode,
      selectedSpaceId: clearSpaceSelection
          ? null
          : selectedSpaceId ?? this.selectedSpaceId,
      selectedSpaceName: clearSpaceSelection
          ? null
          : selectedSpaceName ?? this.selectedSpaceName,
    );
  }
}

class AccessLogController extends StateNotifier<AccessLogState> {
  AccessLogController(this._repository) : super(const AccessLogState());

  final AccessLogRepository _repository;

  Future<void> load({
    AccessLogStatus? status,
    DateTime? from,
    DateTime? to,
    bool clearStatus = false,
    bool clearDate = false,
    AccessLogViewMode? viewMode,
    int? spaceId,
    String? spaceName,
    bool clearSpaceSelection = false,
  }) async {
    state = state.copyWith(
      logs: const AsyncLoading(),
      statusFilter: status,
      fromFilter: from,
      toFilter: to,
      clearStatusFilter: clearStatus,
      clearDateFilter: clearDate,
      viewMode: viewMode,
      selectedSpaceId: spaceId,
      selectedSpaceName: spaceName,
      clearSpaceSelection: clearSpaceSelection,
    );
    try {
      final List<AccessLog> data;
      if (state.viewMode == AccessLogViewMode.spaceLogs &&
          state.selectedSpaceId != null) {
        data = await _repository.listSpaceLogs(
          spaceId: state.selectedSpaceId!,
          status: state.statusFilter,
          from: state.fromFilter,
          to: state.toFilter,
        );
      } else {
        data = await _repository.listMyLogs(
          status: state.statusFilter,
          from: state.fromFilter,
          to: state.toFilter,
        );
      }
      state = state.copyWith(logs: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(logs: AsyncError(e, st));
    }
  }

  Future<void> setMyLogsMode() => load(
    viewMode: AccessLogViewMode.myLogs,
    clearSpaceSelection: true,
  );

  Future<void> setSpaceMode(int spaceId, String spaceName) => load(
    viewMode: AccessLogViewMode.spaceLogs,
    spaceId: spaceId,
    spaceName: spaceName,
  );

  Future<void> setStatusFilter(AccessLogStatus? status) => load(
    status: status,
    clearStatus: status == null,
  );

  Future<void> setDateFilter({required DateTime from, required DateTime to}) =>
      load(from: from, to: to);

  Future<void> clearDateFilter() => load(clearDate: true);

  Future<void> clearFilters() => load(clearStatus: true, clearDate: true);

  Future<void> refresh() => load();
}

final accessLogControllerProvider =
    StateNotifierProvider<AccessLogController, AccessLogState>((ref) {
      final controller = AccessLogController(
        ref.watch(accessLogRepositoryProvider),
      );
      controller.load();
      return controller;
    });
