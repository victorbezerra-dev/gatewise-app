import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/space_entity.dart';
import 'space_avatar.dart';

class SpaceHeader extends StatelessWidget {
  const SpaceHeader({
    super.key,
    required this.space,
    required this.onOpen,
    this.onEdit,
    this.onDelete,
    this.isOpening = false,
  });

  final Space space;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onOpen;
  final bool isOpening;

  @override
  Widget build(BuildContext context) {
    final statusColor = space.isActive
        ? GateWiseColors.mint
        : GateWiseColors.amber;

    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 28,
      opacity: 0.74,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GateWiseColors.electricBlue.withValues(alpha: 0.18),
                      GateWiseColors.surfaceGlass.withValues(alpha: 0.12),
                      statusColor.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SpaceAvatar(space: space, size: 66),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              space.name,
                              style: const TextStyle(
                                color: GateWiseColors.textPrimary,
                                fontSize: 24,
                                height: 1.05,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.7,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                TechStatusPill(
                                  label: space.isActive
                                      ? context.l.statusActive
                                      : context.l.statusInactive,
                                  icon: space.isActive
                                      ? Icons.check_circle_rounded
                                      : Icons.pause_circle_outline_rounded,
                                  color: statusColor,
                                ),
                                _HeaderInfoChip(
                                  icon: Icons.tag_rounded,
                                  label: 'ID ${space.id}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    space.description?.trim().isNotEmpty == true
                        ? space.description!.trim()
                        : context.l.noDescription,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.66),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  if (!space.isActive) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GateWiseColors.amber.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: GateWiseColors.amber.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: GateWiseColors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Este space está inativo. Ative-o para liberar comandos de abertura.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.68),
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  NeonGradientButton(
                    label: isOpening
                        ? context.l.spaceOpeningButton
                        : context.l.spaceOpenButton,
                    icon: Icons.lock_rounded,
                    height: 50,
                    gradient: GateWiseColors.successGradient,
                    isLoading: isOpening,
                    onPressed: space.isActive && !isOpening ? onOpen : null,
                  ),
                  if (onEdit != null || onDelete != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (onEdit != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_rounded, size: 18),
                              label: Text(context.l.actionEdit),
                            ),
                          ),
                        if (onEdit != null && onDelete != null)
                          const SizedBox(width: 10),
                        if (onDelete != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onDelete,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: GateWiseColors.danger,
                                side: BorderSide(
                                  color: GateWiseColors.danger.withValues(
                                    alpha: 0.42,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                              label: Text(context.l.actionDelete),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderInfoChip extends StatelessWidget {
  const _HeaderInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceLight.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: GateWiseColors.textMuted, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
