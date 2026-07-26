import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../access_log_providers.dart';

class LogModeToggle extends StatelessWidget {
  const LogModeToggle({
    super.key,
    required this.viewMode,
    required this.onMyLogs,
    required this.onSpaceLogs,
  });

  final AccessLogViewMode viewMode;
  final VoidCallback onMyLogs;
  final VoidCallback onSpaceLogs;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(5),
      borderRadius: 18,
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'Meus Logs',
              icon: Icons.person_rounded,
              isSelected: viewMode == AccessLogViewMode.myLogs,
              onTap: onMyLogs,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _ToggleButton(
              label: 'Por Espaço',
              icon: Icons.sensor_door_rounded,
              isSelected: viewMode == AccessLogViewMode.spaceLogs,
              onTap: onSpaceLogs,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected
              ? GateWiseColors.neonCyan.withValues(alpha: 0.18)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? GateWiseColors.neonCyan.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? GateWiseColors.neonCyan
                  : GateWiseColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? GateWiseColors.neonCyan
                    : GateWiseColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
