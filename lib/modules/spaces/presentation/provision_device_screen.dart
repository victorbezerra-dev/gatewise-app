import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../../modules/organizations/presentation/components/status_panels.dart';
import 'components/key_export_sheet.dart';
import 'space_providers.dart';
import '../../../core/l10n/l10n.dart';

class ProvisionDeviceScreen extends ConsumerStatefulWidget {
  const ProvisionDeviceScreen({super.key, required this.spaceId});

  final int spaceId;

  @override
  ConsumerState<ProvisionDeviceScreen> createState() =>
      _ProvisionDeviceScreenState();
}

class _ProvisionDeviceScreenState extends ConsumerState<ProvisionDeviceScreen> {
  AsyncValue<DeviceProvisionResult> _result = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    Future.microtask(_provision);
  }

  Future<void> _provision() async {
    setState(() => _result = const AsyncLoading());
    try {
      final result = await ref
          .read(spaceControllerProvider.notifier)
          .provisionDevice(widget.spaceId);
      if (result == null) {
        final errorMsg = ref.read(spaceControllerProvider).actionErrorMessage ??
            context.l.provisionErrorGenKeys;
        setState(() => _result = AsyncError(errorMsg, StackTrace.empty));
      } else {
        setState(() => _result = AsyncData(result));
      }
    } catch (e, st) {
      setState(() => _result = AsyncError(e, st));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: Text(context.l.provisionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: TechBackground(
        child: SafeArea(
          top: false,
          child: _result.when(
            loading: () => const _LoadingView(),
            error: (e, _) => _ErrorView(
              message: e.toString(),
              onRetry: _provision,
            ),
            data: (keys) => _KeysView(
              keys: keys,
              spaceId: widget.spaceId,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: GateWiseColors.electricBlue,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 20),
          Text(
            context.l.provisionLoading,
            style: const TextStyle(
              color: GateWiseColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: MessagePanel(
        icon: Icons.error_outline_rounded,
        title: context.l.provisionErrorTitle,
        message: message,
        actionLabel: context.l.actionRetry,
        onAction: onRetry,
      ),
    );
  }
}

class _KeysView extends StatelessWidget {
  const _KeysView({required this.keys, required this.spaceId});

  final DeviceProvisionResult keys;
  final int spaceId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SuccessHeader(),
          const SizedBox(height: 20),
          _PrivateKeyWarning(),
          const SizedBox(height: 20),
          _KeyCard(
            title: context.l.provisionBackendKeyTitle,
            subtitle: context.l.provisionBackendKeyDesc,
            badge: context.l.provisionBackendKeyBadge,
            badgeColor: GateWiseColors.mint,
            icon: Icons.cloud_done_rounded,
            iconColor: GateWiseColors.electricBlue,
            pem: keys.backendPublicKeyPem,
            filename: 'backend_public_key.pem',
            downloadNote: context.l.provisionBackendKeyNote,
          ),
          const SizedBox(height: 14),
          _KeyCard(
            title: context.l.provisionDeviceKeyTitle,
            subtitle: context.l.provisionDeviceKeyDesc,
            badge: context.l.provisionDeviceKeyBadge,
            badgeColor: GateWiseColors.danger,
            icon: Icons.lock_rounded,
            iconColor: GateWiseColors.amber,
            pem: keys.devicePrivateKeyPem,
            filename: 'device_private_key.pem',
            downloadNote: null,
          ),
          const SizedBox(height: 28),
          NeonGradientButton(
            label: context.l.provisionGoToSpaceButton,
            icon: Icons.arrow_forward_rounded,
            gradient: GateWiseColors.successGradient,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _SuccessHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: GateWiseColors.mint.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.memory_rounded,
            color: GateWiseColors.mint,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l.provisionSuccessTitle,
                style: const TextStyle(
                  color: GateWiseColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                context.l.provisionSuccessSubtitle,
                style: const TextStyle(
                  color: GateWiseColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrivateKeyWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GateWiseColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: GateWiseColors.danger.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: GateWiseColors.danger,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l.provisionWarningTitle,
                  style: const TextStyle(
                    color: GateWiseColors.danger,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l.provisionWarningMessage,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyCard extends StatefulWidget {
  const _KeyCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
    required this.pem,
    required this.filename,
    required this.downloadNote,
  });

  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;
  final String pem;
  final String filename;
  final String? downloadNote;

  @override
  State<_KeyCard> createState() => _KeyCardState();
}

class _KeyCardState extends State<_KeyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: widget.badgeColor.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Text(
                        widget.badge,
                        style: TextStyle(
                          color: widget.badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.56),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          if (widget.downloadNote != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.downloadNote!,
              style: TextStyle(
                color: GateWiseColors.mint.withValues(alpha: 0.8),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GateWiseColors.background.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.iconColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.pem,
                  maxLines: _expanded ? null : 4,
                  overflow: _expanded ? TextOverflow.visible : TextOverflow.fade,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9.5,
                    color: GateWiseColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _expanded ? context.l.provisionViewLess : context.l.provisionViewMore,
                        style: TextStyle(
                          color: widget.iconColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: widget.iconColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _CopyButton(pem: widget.pem, iconColor: widget.iconColor),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => exportKey(
                context: context,
                filename: widget.filename,
                content: widget.pem,
                sheetTitle: widget.title,
              ),
              icon: const Icon(Icons.ios_share_rounded, size: 17),
              label: Text(widget.title),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.pem, required this.iconColor});

  final String pem;
  final Color iconColor;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.pem));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copied ? null : _copy,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _copied ? Icons.check_rounded : Icons.copy_rounded,
            color: _copied ? GateWiseColors.mint : widget.iconColor,
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            _copied ? context.l.provisionCopiedButton : context.l.provisionCopyButton,
            style: TextStyle(
              color: _copied ? GateWiseColors.mint : widget.iconColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
