import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/config/app_config.dart';
import '../../../core/domain/entities/user_entity.dart';
import '../../../core/domain/value_objects/user_type_vo.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/gatewise_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () => const _ProfileLoadingView(),
      error: (error, _) => _ProfileMessageView(
        icon: Icons.error_outline_rounded,
        title: 'Erro ao carregar perfil',
        message: error.toString(),
        actionLabel: 'Tentar novamente',
        onAction: () => ref.invalidate(userProfileProvider),
      ),
      data: (user) {
        if (user == null) {
          return const _ProfileMessageView(
            icon: Icons.person_off_outlined,
            title: 'Usuário não encontrado',
            message: 'Faça login novamente para atualizar seus dados.',
          );
        }

        return RefreshIndicator(
          color: GateWiseColors.electricBlue,
          backgroundColor: GateWiseColors.surface,
          onRefresh: () async => ref.refresh(userProfileProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 104),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Meu Perfil',
                        style: TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 25,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ProfileHeader(user: user),
                const SizedBox(height: 18),
                const _SectionTitle(title: 'Dados da conta'),
                const SizedBox(height: 8),
                _InfoList(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Nome',
                      value: user.name,
                    ),
                    _InfoRow(
                      icon: Icons.mail_outline_rounded,
                      label: 'E-mail',
                      value: user.email,
                    ),
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Matrícula',
                      value: user.registrationNumber,
                      showDivider: false,
                    ),
                  ],
                ),
                if (_hasDeviceInfo(user)) ...[
                  const SizedBox(height: 18),
                  const _SectionTitle(title: 'Dispositivo'),
                  const SizedBox(height: 8),
                  _InfoList(
                    children: [
                      _InfoRow(
                        icon: Icons.phone_android_rounded,
                        label: 'Modelo',
                        value: user.deviceModel,
                      ),
                      _InfoRow(
                        icon: Icons.precision_manufacturing_outlined,
                        label: 'Fabricante',
                        value: user.deviceManufactureName,
                      ),
                      _InfoRow(
                        icon: Icons.memory_rounded,
                        label: 'Sistema',
                        value: _formatOperationalSystem(user),
                        showDivider: false,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 22),
                _LogoutButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    ref.invalidate(userProfileProvider);
                    if (context.mounted) {
                      context.go('/auth-login');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static bool _hasDeviceInfo(User user) {
    return user.deviceModel.trim().isNotEmpty ||
        user.deviceManufactureName.trim().isNotEmpty ||
        user.operationalSystem.trim().isNotEmpty ||
        user.operationalSystemVersion.trim().isNotEmpty;
  }

  static String _formatOperationalSystem(User user) {
    final system = user.operationalSystem.trim();
    final version = user.operationalSystemVersion.trim();

    if (system.isEmpty && version.isEmpty) return '-';
    if (system.isEmpty) return version;
    if (version.isEmpty) return system;
    return '$system $version';
  }

  static String _safeUserTypeLabel(int value) {
    if (value < 0 || value >= UserType.values.length) {
      return 'Não informado';
    }

    return UserType.fromInt(value).label;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 22,
      opacity: 0.68,
      child: Row(
        children: [
          _ProfileAvatar(user: user),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isNotEmpty ? user.name : 'Usuário GateWise',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user.email.isNotEmpty ? user.email : 'E-mail não informado',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                _CompactBadge(
                  text: ProfileScreen._safeUserTypeLabel(user.userType),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _avatarUrl(user.userAvatarUrl);

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: GateWiseColors.electricBlue.withValues(alpha: 0.72),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: GateWiseColors.surfaceLight,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null
            ? Text(
                _initials(user.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              )
            : null,
      ),
    );
  }

  static String? _avatarUrl(String value) {
    final avatarPath = value.trim();
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

class _CompactBadge extends StatelessWidget {
  const _CompactBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: GateWiseColors.electricBlue.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: GateWiseColors.electricBlue,
            size: 13,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: GateWiseColors.electricBlue,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.76),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _InfoList extends StatelessWidget {
  const _InfoList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 18,
      opacity: 0.56,
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value.trim().isNotEmpty ? value.trim() : '-';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: GateWiseColors.electricBlue.withValues(alpha: 0.9),
                size: 19,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 76,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.48),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  normalizedValue,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            color: Colors.white.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: GateWiseColors.danger,
          side: BorderSide(
            color: GateWiseColors.danger.withValues(alpha: 0.42),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text(
          'Sair da conta',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          color: GateWiseColors.electricBlue,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}

class _ProfileMessageView extends StatelessWidget {
  const _ProfileMessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: GlassPanel(
          padding: const EdgeInsets.all(18),
          borderRadius: 18,
          opacity: 0.68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 38, color: GateWiseColors.electricBlue),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 12,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 14),
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
