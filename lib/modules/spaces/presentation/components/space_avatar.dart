import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/space_entity.dart';

class SpaceAvatar extends StatelessWidget {
  const SpaceAvatar({super.key, required this.space, this.size = 50});

  final Space space;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accentColor = space.isActive
        ? GateWiseColors.mint
        : GateWiseColors.amber;
    final gradientColors = space.isActive
        ? GateWiseColors.primaryGradient
        : [GateWiseColors.surfaceLight, GateWiseColors.amber];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -size * 0.1,
            top: -size * 0.16,
            child: Icon(
              Icons.wifi_tethering_rounded,
              color: Colors.white.withValues(alpha: 0.16),
              size: size * 0.64,
            ),
          ),
          Center(
            child: Icon(
              Icons.sensor_door_rounded,
              color: Colors.white,
              size: size * 0.46,
            ),
          ),
          Positioned(
            right: size * 0.13,
            bottom: size * 0.13,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: GateWiseColors.background.withValues(alpha: 0.84),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
