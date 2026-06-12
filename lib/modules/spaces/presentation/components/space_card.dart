import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/space_entity.dart';
import 'space_avatar.dart';

class SpaceCard extends StatelessWidget {
  const SpaceCard({super.key, required this.space, required this.onTap});

  final Space space;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = space.isActive
        ? GateWiseColors.mint
        : GateWiseColors.amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: space.isActive ? 1.0 : 0.68,
        child: GlassPanel(
          padding: EdgeInsets.zero,
          borderRadius: 24,
          opacity: space.isActive ? 0.66 : 0.46,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onTap,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            statusColor,
                            GateWiseColors.electricBlue.withValues(alpha: 0.24),
                          ],
                        ),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SpaceAvatar(space: space, size: 54),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    space.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: GateWiseColors.textPrimary,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.25,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    space.description?.trim().isNotEmpty == true
                                        ? space.description!.trim()
                                        : 'Sem descrição cadastrada',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.58,
                                      ),
                                      fontSize: 12,
                                      height: 1.32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: GateWiseColors.surfaceLight.withValues(
                                  alpha: 0.42,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: GateWiseColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TechStatusPill(
                              label: space.isActive ? 'ATIVO' : 'INATIVO',
                              icon: space.isActive
                                  ? Icons.check_circle_rounded
                                  : Icons.pause_circle_outline_rounded,
                              color: statusColor,
                            ),
                            _SpaceInfoChip(
                              icon: Icons.tag_rounded,
                              label: 'ID ${space.id}',
                            ),
                            if (space.updatedAt != null)
                              _SpaceInfoChip(
                                icon: Icons.update_rounded,
                                label: _formatDate(space.updatedAt!),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }
}

class _SpaceInfoChip extends StatelessWidget {
  const _SpaceInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceLight.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
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
