import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../infra/equipment_repository.dart';
import '../equipment_providers.dart';

/// Compact summary of a space's equipments that opens the equipments screen.
/// Hidden for members when there is nothing to control.
class EquipmentsEntryCard extends ConsumerWidget {
  const EquipmentsEntryCard({
    super.key,
    required this.spaceId,
    required this.canManage,
  });

  final int spaceId;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipments = ref.watch(spaceEquipmentsProvider(spaceId));
    final error = equipments.error;
    if (error is EquipmentApiException && error.statusCode == 403) {
      return const SizedBox.shrink();
    }
    final items = equipments.valueOrNull;
    if (!canManage && (items == null || items.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await context.push(
            '/spaces/$spaceId/equipments${canManage ? '?manage=true' : ''}',
          );
          ref.invalidate(spaceEquipmentsProvider(spaceId));
        },
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
                  color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_remote_rounded,
                  color: GateWiseColors.electricBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l.equipmentsSection,
                      style: const TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (items == null && equipments.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 6, right: 40),
                        child: LinearProgressIndicator(
                          minHeight: 2,
                          color: GateWiseColors.neonCyan,
                        ),
                      )
                    else
                      Text(
                        _summary(context, items),
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
              if (items != null && items.isNotEmpty) ...[
                const SizedBox(width: 8),
                _TypeIcons(equipments: items),
              ],
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: GateWiseColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _summary(BuildContext context, List<Equipment>? items) {
    final l = context.l;
    if (items == null) return l.equipmentsLoadError;
    if (items.isEmpty) {
      return '${l.equipmentsEmpty}  ·  ${l.equipmentsEntryManagerHint}';
    }
    final onCount = items
        .where(
          (e) => e.isAirConditioner && e.airConditionerState?.power == true,
        )
        .length;
    return [
      l.equipmentsCount(items.length),
      if (onCount > 0) l.equipmentsOnCount(onCount),
    ].join('  ·  ');
  }
}

/// Up to three icons of the distinct equipment types in the space.
class _TypeIcons extends StatelessWidget {
  const _TypeIcons({required this.equipments});

  final List<Equipment> equipments;

  @override
  Widget build(BuildContext context) {
    final types = equipments.map((e) => e.type).toSet().take(3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final type in types)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(type.icon, size: 16, color: GateWiseColors.textMuted),
          ),
      ],
    );
  }
}
