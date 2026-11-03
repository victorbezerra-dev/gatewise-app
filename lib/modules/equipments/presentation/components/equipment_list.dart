import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/status_panels.dart';
import '../../domain/entities/equipment_entity.dart';
import '../equipment_providers.dart';
import 'equipment_ui_helpers.dart';

/// The equipments of a space, listed on the space equipments screen.
class EquipmentList extends ConsumerWidget {
  const EquipmentList({
    super.key,
    required this.spaceId,
    required this.canManage,
  });

  final int spaceId;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipments = ref.watch(spaceEquipmentsProvider(spaceId));

    return equipments.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(
            color: GateWiseColors.electricBlue,
            strokeWidth: 2.5,
          ),
        ),
      ),
      error: (error, _) => MessagePanel(
        icon: Icons.settings_remote_rounded,
        title: context.l.equipmentsLoadError,
        message: equipmentErrorMessage(context, error),
        actionLabel: context.l.actionRetry,
        onAction: () => ref.invalidate(spaceEquipmentsProvider(spaceId)),
      ),
      data: (items) {
        if (items.isEmpty) {
          return MessagePanel(
            icon: Icons.settings_remote_rounded,
            title: context.l.equipmentsEmpty,
            message: canManage
                ? context.l.equipmentsEmptyManagerMessage
                : context.l.equipmentsEmptyMessage,
          );
        }
        return Column(
          children: [
            for (final equipment in items)
              _EquipmentCard(
                equipment: equipment,
                onTap: () async {
                  await context.push(
                    '/spaces/$spaceId/equipments/${equipment.id}',
                  );
                  ref.invalidate(spaceEquipmentsProvider(spaceId));
                },
              ),
          ],
        );
      },
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  const _EquipmentCard({required this.equipment, required this.onTap});

  final Equipment equipment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = equipment.airConditionerState;
    final isOn = equipment.isAirConditioner && state?.power == true;
    final accent = !equipment.isActive
        ? GateWiseColors.textMuted
        : isOn
        ? GateWiseColors.mint
        : GateWiseColors.electricBlue;

    final details = <String>[
      equipment.type.label(context),
      if (equipment.hasUsageWindow)
        '${equipment.usageStart}–${equipment.usageEnd}',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: GlassPanel(
            padding: const EdgeInsets.all(14),
            borderRadius: 18,
            opacity: 0.56,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(equipment.type.icon, color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        equipment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        details.join('  ·  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!equipment.isActive)
                  TechStatusPill(
                    label: context.l.equipmentInactiveBadge,
                    icon: Icons.pause_circle_outline_rounded,
                    color: GateWiseColors.amber,
                  )
                else if (equipment.isAirConditioner && state != null)
                  TechStatusPill(
                    label: isOn
                        ? '${formatDegrees(state.degrees)}°C'
                        : context.l.airConditionerOff,
                    icon: Icons.power_settings_new_rounded,
                    color: isOn
                        ? GateWiseColors.mint
                        : GateWiseColors.textMuted,
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: GateWiseColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
