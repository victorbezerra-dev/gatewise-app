import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../theme/gatewise_theme.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.radius = 20,
    this.backgroundColor = GateWiseColors.surfaceLight,
  });

  final String name;
  final String? avatarUrl;
  final double radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveUrl(avatarUrl);

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: resolvedUrl != null ? NetworkImage(resolvedUrl) : null,
      child: resolvedUrl == null
          ? Text(
              _initials(name),
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.63,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
  }

  static String? _resolveUrl(String? value) {
    final avatarPath = value?.trim() ?? '';
    if (avatarPath.isEmpty) return null;
    if (avatarPath.startsWith('http://') || avatarPath.startsWith('https://')) {
      return avatarPath;
    }

    final baseUrl = AppConfig.suapMediaBaseUrl.replaceAll(RegExp(r'/+$'), '');
    final normalizedPath = avatarPath.replaceAll(RegExp(r'^/+'), '');
    return '$baseUrl/$normalizedPath';
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
