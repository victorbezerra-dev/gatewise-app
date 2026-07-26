import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_entity.dart';
import 'organization_avatar.dart';

class OrganizationHeader extends StatelessWidget {
  const OrganizationHeader({
    super.key,
    required this.organization,
    this.onEdit,
    this.onDelete,
  });

  final Organization organization;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      opacity: 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OrganizationAvatar(organization: organization, size: 62),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      style: const TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 22,
                        height: 1.08,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TechStatusPill(
                          label: organization.isActive
                              ? context.l.statusActiveFem
                              : context.l.statusInactiveFem,
                          icon: organization.isActive
                              ? Icons.check_circle_rounded
                              : Icons.pause_circle_outline_rounded,
                          color: organization.isActive
                              ? GateWiseColors.mint
                              : GateWiseColors.amber,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            organization.description?.trim().isNotEmpty == true
                ? organization.description!.trim()
                : context.l.noDescription,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 13,
              height: 1.42,
            ),
          ),
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(height: 14),
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
                          color: GateWiseColors.danger.withValues(alpha: 0.42),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: Text(context.l.actionDelete),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
