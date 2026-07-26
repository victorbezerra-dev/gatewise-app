import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/access_log_entity.dart';
import '../../domain/value_objects/access_log_status_vo.dart';

class AccessLogCard extends StatelessWidget {
  const AccessLogCard({
    super.key,
    required this.log,
    this.showUser = false,
  });

  final AccessLog log;
  final bool showUser;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(log.status);
    final dateLabel =
        DateFormat('dd/MM/yyyy HH:mm').format(log.issuedAt.toLocal());

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: color.withValues(alpha: 0.14),
              border: Border.all(color: color.withValues(alpha: 0.28)),
            ),
            child: Icon(_statusIcon(log.status), color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showUser ? log.userName : log.spaceName,
                  style: const TextStyle(
                    color: GateWiseColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  showUser ? '${log.spaceName} · $dateLabel' : dateLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StatusChip(status: log.status, color: color),
        ],
      ),
    );
  }

  static Color _statusColor(AccessLogStatus s) {
    if (s.isSuccess) return GateWiseColors.mint;
    if (s.isFailure) return GateWiseColors.danger;
    return GateWiseColors.amber;
  }

  static IconData _statusIcon(AccessLogStatus s) {
    if (s.isSuccess) return Icons.check_circle_rounded;
    if (s.isFailure) return Icons.cancel_rounded;
    return Icons.schedule_rounded;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.color});

  final AccessLogStatus status;
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
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
