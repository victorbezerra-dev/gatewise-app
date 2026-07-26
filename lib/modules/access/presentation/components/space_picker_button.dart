import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';

class SpacePickerButton extends StatelessWidget {
  const SpacePickerButton({
    super.key,
    required this.spaceName,
    required this.onTap,
  });

  final String? spaceName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasSpace = spaceName != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: hasSpace
              ? GateWiseColors.electricBlue.withValues(alpha: 0.12)
              : GateWiseColors.surfaceGlass.withValues(alpha: 0.72),
          border: Border.all(
            color: hasSpace
                ? GateWiseColors.electricBlue.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sensor_door_rounded,
              color: hasSpace
                  ? GateWiseColors.electricBlue
                  : GateWiseColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                spaceName ?? 'Selecionar espaço...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasSpace
                      ? GateWiseColors.textPrimary
                      : GateWiseColors.textSecondary,
                  fontSize: 13,
                  fontWeight: hasSpace ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.expand_more_rounded,
              color: hasSpace
                  ? GateWiseColors.electricBlue
                  : GateWiseColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
