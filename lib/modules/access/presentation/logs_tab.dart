import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import 'access_log_providers.dart';
import 'components/access_log_card.dart';
import 'components/log_mode_toggle.dart';
import 'components/space_picker_button.dart';
import 'components/status_filter_row.dart';

class LogsTab extends ConsumerWidget {
  const LogsTab({
    super.key,
    required this.canViewSpaceLogs,
    required this.onOpenSpacePicker,
  });

  final bool canViewSpaceLogs;
  final Future<void> Function(AccessLogController) onOpenSpacePicker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final state = ref.watch(accessLogControllerProvider);
    final controller = ref.read(accessLogControllerProvider.notifier);

    return RefreshIndicator(
      color: GateWiseColors.neonCyan,
      backgroundColor: GateWiseColors.surface,
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (canViewSpaceLogs) ...[
                  LogModeToggle(
                    viewMode: state.viewMode,
                    onMyLogs: controller.setMyLogsMode,
                    onSpaceLogs: () => onOpenSpacePicker(controller),
                  ),
                  if (state.viewMode == AccessLogViewMode.spaceLogs) ...[
                    const SizedBox(height: 10),
                    SpacePickerButton(
                      spaceName: state.selectedSpaceName,
                      onTap: () => onOpenSpacePicker(controller),
                    ),
                  ],
                  const SizedBox(height: 14),
                ],
                StatusFilterRow(
                  selected: state.statusFilter,
                  fromDate: state.fromFilter,
                  toDate: state.toFilter,
                  hasActiveFilters: state.hasActiveFilters,
                  onStatusSelected: controller.setStatusFilter,
                  onDateRangeSelected: (range) {
                    if (range == null) {
                      controller.clearDateFilter();
                      return;
                    }
                    controller.setDateFilter(
                      from: DateTime(
                        range.start.year,
                        range.start.month,
                        range.start.day,
                      ),
                      to: DateTime(
                        range.end.year,
                        range.end.month,
                        range.end.day,
                        23,
                        59,
                        59,
                        999,
                      ),
                    );
                  },
                  onClearFilters: controller.clearFilters,
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          if (state.viewMode == AccessLogViewMode.spaceLogs &&
              state.selectedSpaceId == null)
            _buildSelectSpacePrompt()
          else
            state.logs.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: GateWiseColors.neonCyan,
                  ),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Center(
                    child: GlassPanel(
                      padding: const EdgeInsets.all(18),
                      borderRadius: 18,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            color: GateWiseColors.danger,
                            size: 34,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Erro ao carregar histórico',
                            style: TextStyle(
                              color: GateWiseColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.58),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: controller.refresh,
                            child: Text(
                              l.actionRetry,
                              style: const TextStyle(
                                color: GateWiseColors.neonCyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              data: (logs) {
                if (logs.isEmpty) {
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 122),
                    sliver: SliverToBoxAdapter(
                      child: GlassPanel(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: GateWiseColors.electricBlue.withValues(
                                  alpha: 0.14,
                                ),
                                border: Border.all(
                                  color: GateWiseColors.electricBlue.withValues(
                                    alpha: 0.24,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                Icons.history_rounded,
                                color: GateWiseColors.electricBlue,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l.historyNone,
                                    style: const TextStyle(
                                      color: GateWiseColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    l.historyNoneMessage,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.58,
                                      ),
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 122),
                  sliver: SliverList.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => AccessLogCard(
                      log: logs[i],
                      showUser: state.viewMode == AccessLogViewMode.spaceLogs,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSelectSpacePrompt() {
    return const SliverPadding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 122),
      sliver: SliverToBoxAdapter(
        child: GlassPanel(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              _SpacePromptIcon(),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selecione um espaço',
                      style: TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Toque em "Por Espaço" acima para monitorar acessos de um espaço específico.',
                      style: TextStyle(
                        color: GateWiseColors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpacePromptIcon extends StatelessWidget {
  const _SpacePromptIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
        border: Border.all(
          color: GateWiseColors.electricBlue.withValues(alpha: 0.24),
        ),
      ),
      child: const Icon(
        Icons.sensor_door_rounded,
        color: GateWiseColors.electricBlue,
      ),
    );
  }
}
