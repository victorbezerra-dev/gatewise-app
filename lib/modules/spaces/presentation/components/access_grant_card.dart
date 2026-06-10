import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/access_grant_entity.dart';
import '../../domain/value_objects/access_grant_status_vo.dart';

class AccessGrantCard extends StatelessWidget {
  const AccessGrantCard({
    super.key,
    required this.grant,
    this.onApprove,
    this.onReject,
    this.onDelete,
  });

  final AccessGrant grant;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(grant.status);
    final statusIcon = _statusIcon(grant.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        borderRadius: 18,
        opacity: 0.56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: GateWiseColors.surfaceLight,
                  child: Text(
                    grant.authorizedUserName.trim().isEmpty
                        ? '?'
                        : grant.authorizedUserName.trim()[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grant.authorizedUserName.isEmpty
                            ? 'Usuário sem nome'
                            : grant.authorizedUserName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (grant.authorizedUserEmail.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          grant.authorizedUserEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.54),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TechStatusPill(
                  label: grant.status.label.toUpperCase(),
                  icon: statusIcon,
                  color: statusColor,
                ),
              ],
            ),
            if (grant.reason.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: GateWiseColors.surfaceLight.withValues(alpha: 0.34),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        grant.reason,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.68),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (grant.status == AccessGrantStatus.pending &&
                (onApprove != null || onReject != null)) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (onApprove != null)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onApprove,
                        style: FilledButton.styleFrom(
                          backgroundColor: GateWiseColors.mint,
                          foregroundColor: GateWiseColors.background,
                        ),
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: const Text('Aprovar'),
                      ),
                    ),
                  if (onApprove != null && onReject != null)
                    const SizedBox(width: 8),
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GateWiseColors.danger,
                          side: BorderSide(
                            color: GateWiseColors.danger.withValues(alpha: 0.42),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 16),
                        label: const Text('Rejeitar'),
                      ),
                    ),
                ],
              ),
            ],
            if (onDelete != null &&
                grant.status != AccessGrantStatus.pending) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: GateWiseColors.danger,
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Remover'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(AccessGrantStatus status) => switch (status) {
    AccessGrantStatus.pending => GateWiseColors.amber,
    AccessGrantStatus.granted => GateWiseColors.mint,
    AccessGrantStatus.rejected => GateWiseColors.danger,
  };

  IconData _statusIcon(AccessGrantStatus status) => switch (status) {
    AccessGrantStatus.pending => Icons.schedule_rounded,
    AccessGrantStatus.granted => Icons.verified_user_rounded,
    AccessGrantStatus.rejected => Icons.gpp_bad_rounded,
  };
}
