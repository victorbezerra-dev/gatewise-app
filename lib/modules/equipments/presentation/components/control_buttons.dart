import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';

/// Round power button shared by the air conditioner and remote panels.
class PowerButton extends StatelessWidget {
  const PowerButton({
    super.key,
    required this.color,
    required this.enabled,
    required this.onPressed,
    this.onLongPress,
    this.tooltip,
  });

  final Color color;
  final bool enabled;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: color.withValues(alpha: enabled ? 0.16 : 0.06),
      shape: CircleBorder(
        side: BorderSide(color: color.withValues(alpha: enabled ? 0.5 : 0.2)),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onPressed : null,
        onLongPress: onLongPress,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.power_settings_new_rounded,
            color: color.withValues(alpha: enabled ? 1 : 0.4),
            size: 28,
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.size = 52,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      onLongPress: onLongPress,
      tooltip: tooltip,
      iconSize: size / 2,
      style: IconButton.styleFrom(
        backgroundColor: GateWiseColors.electricBlue.withValues(alpha: 0.16),
        foregroundColor: GateWiseColors.neonCyan,
        minimumSize: Size(size, size),
      ),
      icon: Icon(icon),
    );
  }
}
