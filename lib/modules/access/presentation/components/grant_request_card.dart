import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../../spaces/domain/entities/access_grant_entity.dart';
import '../../../spaces/domain/value_objects/access_grant_status_vo.dart';

class GrantRequestCard extends StatelessWidget {
  const GrantRequestCard({
    super.key,
    required this.grant,
    this.showUser = false,
    this.onApprove,
    this.onReject,
  });

  final AccessGrant grant;
  final bool showUser;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(grant.status);
    final date = grant.createdAt ?? grant.grantedAt;
    final dateLabel = date != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal())
        : '';

    return GlassPanel(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showUser)
                CircleAvatar(
                  radius: 20,
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
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color.withValues(alpha: 0.14),
                    border: Border.all(color: color.withValues(alpha: 0.28)),
                  ),
                  child: Icon(
                    Icons.sensor_door_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showUser
                          ? (grant.authorizedUserName.isEmpty
                              ? 'Usuário'
                              : grant.authorizedUserName)
                          : (grant.spaceName ?? 'Espaço'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      showUser
                          ? (grant.spaceName ?? dateLabel)
                          : dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    if (showUser && dateLabel.isNotEmpty)
                      Text(
                        dateLabel,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.36),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(status: grant.status, color: color),
            ],
          ),
          if (grant.reason.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: GateWiseColors.surfaceLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      grant.reason,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
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
        ],
      ),
    );
  }

  static Color _statusColor(AccessGrantStatus s) => switch (s) {
    AccessGrantStatus.pending => GateWiseColors.amber,
    AccessGrantStatus.granted => GateWiseColors.mint,
    AccessGrantStatus.rejected => GateWiseColors.danger,
  };
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.color});

  final AccessGrantStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        status.label(context).toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
