import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/domain/entities/user_entity.dart';
import '../../../core/domain/value_objects/user_type_vo.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../../core/widgets/user_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final profileAsync = ref.watch(userProfileProvider);
    final currentLocale = ref.watch(localeProvider);

    return profileAsync.when(
      loading: () => const _ProfileLoadingView(),
      error: (error, _) => _ProfileMessageView(
        icon: Icons.error_outline_rounded,
        title: l.profileErrorLoad,
        message: error.toString(),
        actionLabel: l.profileRetry,
        onAction: () => ref.invalidate(userProfileProvider),
      ),
      data: (user) {
        if (user == null) {
          return _ProfileMessageView(
            icon: Icons.person_off_outlined,
            title: l.profileNotFound,
            message: l.profileNotFoundMessage,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.profileTitle,
                        style: const TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 25,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    _LanguageButton(
                      code: currentLocale.languageCode.toUpperCase(),
                      tooltip: l.profileLanguageDialogTitle,
                      onTap: () => _showLanguageSheet(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ProfileHeader(user: user),
                const SizedBox(height: 18),
                _SectionTitle(title: l.profileSectionAccount),
                const SizedBox(height: 8),
                _InfoList(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: l.profileLabelName,
                      value: user.name,
                    ),
                    _InfoRow(
                      icon: Icons.mail_outline_rounded,
                      label: l.profileLabelEmail,
                      value: user.email,
                    ),
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      label: l.profileLabelRegistration,
                      value: user.registrationNumber,
                      showDivider: false,
                    ),
                  ],
                ),
                if (_hasDeviceInfo(user)) ...[
                  const SizedBox(height: 18),
                  _SectionTitle(title: l.profileSectionDevice),
                  const SizedBox(height: 8),
                  _InfoList(
                    children: [
                      _InfoRow(
                        icon: Icons.phone_android_rounded,
                        label: l.profileLabelModel,
                        value: user.deviceModel,
                      ),
                      _InfoRow(
                        icon: Icons.precision_manufacturing_outlined,
                        label: l.profileLabelManufacturer,
                        value: user.deviceManufactureName,
                      ),
                      _InfoRow(
                        icon: Icons.memory_rounded,
                        label: l.profileLabelSystem,
                        value: _formatOperationalSystem(user),
                        showDivider: false,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 22),
                _LogoutButton(
                  label: l.profileLogout,
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

  static String safeUserTypeLabel(int value, AppLocalizations l) {
    if (value < 0 || value >= UserType.values.length) return l.userTypeUnknown;
    return switch (UserType.fromInt(value)) {
      UserType.professor => l.userTypeProfessor,
      UserType.student => l.userTypeStudent,
      UserType.admin => l.userTypeAdmin,
      UserType.visitor => l.userTypeVisitor,
    };
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final current = ref.read(localeProvider);

    final languages = [
      (code: 'pt', label: l.langPt, flag: '🇧🇷'),
      (code: 'en', label: l.langEn, flag: '🇺🇸'),
      (code: 'es', label: l.langEs, flag: '🇪🇸'),
      (code: 'fr', label: l.langFr, flag: '🇫🇷'),
      (code: 'de', label: l.langDe, flag: '🇩🇪'),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (sheetContext) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: GateWiseColors.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: GateWiseColors.electricBlue.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GateWiseColors.electricBlue.withValues(alpha: 0.95),
                          GateWiseColors.neonCyan.withValues(alpha: 0.72),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: GateWiseColors.electricBlue.withValues(
                            alpha: 0.22,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.profileLanguageDialogTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l.profileSectionLanguage,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.54),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.07),
                      foregroundColor: Colors.white.withValues(alpha: 0.72),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final lang in languages) ...[
                _LanguageOptionTile(
                  flag: lang.flag,
                  code: lang.code.toUpperCase(),
                  label: lang.label,
                  isSelected: lang.code == current.languageCode,
                  onTap: () {
                    if (lang.code != current.languageCode) {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(Locale(lang.code));
                    }
                    Navigator.of(sheetContext).pop();
                  },
                ),
                if (lang != languages.last) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
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
                  user.name.isNotEmpty ? user.name : l.profileGuestName,
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
                  user.email.isNotEmpty ? user.email : l.profileNoEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                _CompactBadge(
                  text: ProfileScreen.safeUserTypeLabel(user.userType, l),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.code,
    required this.tooltip,
    required this.onTap,
  });

  final String code;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: GateWiseColors.electricBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: GateWiseColors.electricBlue.withValues(alpha: 0.28),
              ),
              boxShadow: [
                BoxShadow(
                  color: GateWiseColors.electricBlue.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: GateWiseColors.neonCyan,
                  size: 17,
                ),
                const SizedBox(width: 7),
                Text(
                  code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withValues(alpha: 0.58),
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.flag,
    required this.code,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String code;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = isSelected ? GateWiseColors.electricBlue : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? GateWiseColors.electricBlue.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.045),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? GateWiseColors.electricBlue.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(flag, style: const TextStyle(fontSize: 21)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.86),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      code,
                      style: TextStyle(
                        color: accent.withValues(
                          alpha: isSelected ? 0.82 : 0.42,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? GateWiseColors.electricBlue
                      : Colors.white.withValues(alpha: 0.055),
                  border: Border.all(
                    color: isSelected
                        ? GateWiseColors.neonCyan.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 17,
                      )
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withValues(alpha: 0.34),
                        size: 12,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
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
      child: UserAvatar(
        name: user.name,
        avatarUrl: user.userAvatarUrl,
        radius: 35,
      ),
    );
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
  const _LogoutButton({required this.label, required this.onPressed});

  final String label;
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
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
