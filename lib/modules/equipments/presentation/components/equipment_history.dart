import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/status_panels.dart';
import '../../domain/entities/equipment_command_entity.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/value_objects/equipment_enums.dart';
import '../equipment_providers.dart';
import 'equipment_ui_helpers.dart';

/// The latest commands of an equipment, with the full list in a bottom sheet.
class EquipmentHistorySection extends ConsumerWidget {
  const EquipmentHistorySection({
    super.key,
    required this.equipment,
    required this.equipmentKey,
  });

  static const _previewCount = 3;

  final Equipment equipment;
  final EquipmentKey equipmentKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final history = ref.watch(equipmentHistoryProvider(equipmentKey));
    final commands = history.valueOrNull ?? const <EquipmentCommand>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SectionTitle(l.historySection)),
            if (commands.length > _previewCount)
              TextButton(
                onPressed: () => _showAll(context),
                child: Text(l.historySeeAll(commands.length)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        history.when(
          loading: () =>
              const LinearProgressIndicator(color: GateWiseColors.neonCyan),
          error: (error, _) => Text(
            equipmentErrorMessage(context, error),
            style: const TextStyle(color: GateWiseColors.danger, fontSize: 12),
          ),
          data: (commands) {
            if (commands.isEmpty) {
              return Text(
                l.historyEmpty,
                style: const TextStyle(
                  color: GateWiseColors.textMuted,
                  fontSize: 12,
                ),
              );
            }
            return GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              borderRadius: 18,
              opacity: 0.5,
              child: Column(
                children: [
                  for (final command in commands.take(_previewCount))
                    _HistoryTile(command: command, equipment: equipment),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAll(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: GateWiseColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) => _HistorySheet(
          equipment: equipment,
          equipmentKey: equipmentKey,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _HistorySheet extends ConsumerWidget {
  const _HistorySheet({
    required this.equipment,
    required this.equipmentKey,
    required this.scrollController,
  });

  final Equipment equipment;
  final EquipmentKey equipmentKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commands =
        ref.watch(equipmentHistoryProvider(equipmentKey)).valueOrNull ??
        const <EquipmentCommand>[];

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l.historySection,
                  style: const TextStyle(
                    color: GateWiseColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                equipment.name,
                style: const TextStyle(
                  color: GateWiseColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            itemCount: commands.length,
            itemBuilder: (context, index) =>
                _HistoryTile(command: commands[index], equipment: equipment),
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.command, required this.equipment});

  final EquipmentCommand command;
  final Equipment equipment;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final (icon, color) = switch (command.status) {
      EquipmentCommandStatus.confirmed => (
        Icons.check_circle_rounded,
        GateWiseColors.mint,
      ),
      EquipmentCommandStatus.pendingConfirmation => (
        Icons.hourglass_top_rounded,
        GateWiseColors.amber,
      ),
      _ => (Icons.error_outline_rounded, GateWiseColors.danger),
    };
    final who = switch (command.source) {
      'Schedule' => l.historySourceSchedule,
      'AutoOff' => l.historySourceAutoOff,
      _ => command.userName ?? l.historySourceManual,
    };
    final failed =
        command.status != EquipmentCommandStatus.confirmed &&
        command.status != EquipmentCommandStatus.pendingConfirmation;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: color),
      title: Text(
        _describe(context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: GateWiseColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        [
          who,
          _formatDateTime(command.issuedAt),
          if (failed)
            command.error?.isNotEmpty == true
                ? l.equipmentCommandFailedReason(command.error!)
                : l.equipmentCommandFailed,
        ].join('  ·  '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: failed ? GateWiseColors.danger : GateWiseColors.textMuted,
          fontSize: 11,
        ),
      ),
    );
  }

  String _describe(BuildContext context) {
    final l = context.l;
    return switch (command.kind) {
      'AirConditionerState' => l.historyAirConditioner,
      'Button' => l.historyButtonPressed,
      'Learn' => l.historyLearn,
      _ => command.kind,
    };
  }

  String _formatDateTime(DateTime date) {
    final local = date.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)} ${two(local.hour)}:${two(local.minute)}';
  }
}
