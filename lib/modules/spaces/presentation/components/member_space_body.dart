import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../../modules/home/presentation/rsa_signing_service_provider.dart';
import '../../../../modules/host/presentation/dialog_notifier.dart';
import '../../../../modules/organizations/presentation/components/status_panels.dart';
import '../../domain/entities/access_grant_entity.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/value_objects/access_grant_status_vo.dart';
import '../../infra/dtos/access_grant_dto.dart';
import '../space_providers.dart';
import 'request_access_sheet.dart';
import 'space_ui_helpers.dart';

enum _MemberAccess { noRequest, pending, rejected, granted }

class MemberSpaceBody extends ConsumerStatefulWidget {
  const MemberSpaceBody({super.key, required this.space});

  final Space space;

  @override
  ConsumerState<MemberSpaceBody> createState() => _MemberSpaceBodyState();
}

class _MemberSpaceBodyState extends ConsumerState<MemberSpaceBody> {
  bool _isOpening = false;

  _MemberAccess _resolveAccess(List<AccessGrant> grants) {
    if (grants.any((g) => g.status == AccessGrantStatus.granted)) {
      return _MemberAccess.granted;
    }
    if (grants.any((g) => g.status == AccessGrantStatus.pending)) {
      return _MemberAccess.pending;
    }
    if (grants.any((g) => g.status == AccessGrantStatus.rejected)) {
      return _MemberAccess.rejected;
    }
    return _MemberAccess.noRequest;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spaceControllerProvider);
    final notifier = ref.read(spaceControllerProvider.notifier);

    return RefreshIndicator(
      color: GateWiseColors.electricBlue,
      backgroundColor: GateWiseColors.surface,
      onRefresh: () => notifier.loadMyGrantsForCurrentUser(widget.space.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        child: state.myGrants.when(
          loading: () => const SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(
                color: GateWiseColors.electricBlue,
                strokeWidth: 2.5,
              ),
            ),
          ),
          error: (e, _) => MessagePanel(
            icon: Icons.error_outline_rounded,
            title: context.l.spaceLoadAccessError,
            message: e.toString(),
            actionLabel: context.l.actionRetry,
            onAction: () =>
                notifier.loadMyGrantsForCurrentUser(widget.space.id),
          ),
          data: (grants) {
            final access = _resolveAccess(grants);

            if (access == _MemberAccess.granted) {
              return _GrantedAccessView(
                space: widget.space,
                isOpening: _isOpening,
                onOpen: () => _openDoor(context),
              );
            }

            return _LockScreen(
              space: widget.space,
              access: access,
              onRequestAccess: access != _MemberAccess.pending
                  ? () => _requestAccess(context, notifier)
                  : null,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openDoor(BuildContext context) async {
    setState(() => _isOpening = true);
    ref.read(dialogProvider.notifier).showLoading(spaceName: widget.space.name);
    try {
      final signingService = ref.read(signingServiceProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final signature = await signingService.signOpenLock(timestamp);
      final ok = await ref
          .read(spaceControllerProvider.notifier)
          .openSpace(
            widget.space.id,
            timestamp: timestamp,
            signature: signature,
          );
      if (!ok && context.mounted) {
        ref
            .read(dialogProvider.notifier)
            .showError(
              ref.read(spaceControllerProvider).actionErrorMessage ??
                  context.l.spaceCommandError,
            );
      }
    } catch (_) {
      if (context.mounted) {
        ref.read(dialogProvider.notifier).showError(context.l.spaceOpenError);
      }
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  Future<void> _requestAccess(
    BuildContext context,
    SpaceController notifier,
  ) async {
    final payload = await showModalBottomSheet<RequestAccessPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RequestAccessSheet(space: widget.space),
    );
    if (payload == null) return;

    final ok = await notifier.requestAccess(payload);
    if (!context.mounted) return;

    if (!ok) {
      showSpaceSnack(
        context,
        ref.read(spaceControllerProvider).actionErrorMessage ??
            context.l.spaceGrantsCannotSend,
        isError: true,
      );
      return;
    }

    await notifier.loadMyGrantsForCurrentUser(widget.space.id);
    if (context.mounted) {
      showSpaceSnack(context, context.l.spaceGrantsSentSuccess);
    }
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({
    required this.space,
    required this.access,
    this.onRequestAccess,
  });

  final Space space;
  final _MemberAccess access;
  final VoidCallback? onRequestAccess;

  @override
  Widget build(BuildContext context) {
    final (
      message,
      chipLabel,
      chipIcon,
      chipColor,
      buttonLabel,
    ) = switch (access) {
      _MemberAccess.pending => (
        context.l.spacePendingMessage,
        context.l.spacePendingChip,
        Icons.schedule_rounded,
        GateWiseColors.amber,
        context.l.spacePendingButton,
      ),
      _MemberAccess.rejected => (
        context.l.spaceRejectedMessage,
        context.l.spaceRejectedChip,
        Icons.gpp_bad_rounded,
        GateWiseColors.danger,
        context.l.spaceRejectedButton,
      ),
      _ => (
        context.l.spaceNoAccessMessage,
        null,
        Icons.lock_rounded,
        GateWiseColors.electricBlue,
        context.l.spaceRequestAccessButton,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GateWiseColors.surfaceGlass.withValues(alpha: 0.18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.07),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.lock_rounded,
              size: 56,
              color: Colors.white.withValues(alpha: 0.28),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            space.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: GateWiseColors.textPrimary,
              letterSpacing: -0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.50),
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          if (chipLabel != null) ...[
            const SizedBox(height: 16),
            TechStatusPill(label: chipLabel, icon: chipIcon, color: chipColor),
          ],
          const SizedBox(height: 32),
          NeonGradientButton(
            label: buttonLabel,
            icon: Icons.key_rounded,
            gradient: [
              GateWiseColors.electricBlue,
              GateWiseColors.electricBlue.withValues(alpha: 0.7),
            ],
            onPressed: onRequestAccess,
          ),
        ],
      ),
    );
  }
}

class _GrantedAccessView extends StatelessWidget {
  const _GrantedAccessView({
    required this.space,
    required this.isOpening,
    required this.onOpen,
  });

  final Space space;
  final bool isOpening;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l.spaceMyAccess,
          style: const TextStyle(
            fontSize: 25,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: GateWiseColors.textPrimary,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 18),
        GlassPanel(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          GateWiseColors.mint.withValues(alpha: 0.9),
                          GateWiseColors.electricBlue.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          space.name,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: GateWiseColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 7),
                        TechStatusPill(
                          label: context.l.spaceAuthorizedChip,
                          icon: Icons.verified_user_rounded,
                          color: GateWiseColors.mint,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                context.l.spaceAccessInfo,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.58),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        NeonGradientButton(
          label: isOpening
              ? context.l.spaceOpeningButton
              : context.l.spaceEnterButton,
          icon: Icons.lock_rounded,
          isLoading: isOpening,
          gradient: GateWiseColors.successGradient,
          onPressed: isOpening ? null : onOpen,
        ),
      ],
    );
  }
}
