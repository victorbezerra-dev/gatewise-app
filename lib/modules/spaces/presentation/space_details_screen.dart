import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../../../modules/home/presentation/rsa_signing_service_provider.dart';
import '../../../modules/host/presentation/dialog_notifier.dart';
import '../domain/entities/access_grant_entity.dart';
import '../domain/entities/space_entity.dart';
import '../domain/value_objects/access_grant_status_vo.dart';
import '../infra/dtos/access_grant_dto.dart';
import '../infra/dtos/space_payload_dto.dart';
import 'components/access_grant_card.dart';
import 'components/key_export_sheet.dart';
import 'components/request_access_sheet.dart';
import 'components/space_form_sheet.dart';
import 'components/space_header.dart';
import 'components/space_ui_helpers.dart';
import 'space_providers.dart';
import '../../../modules/organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../../modules/organizations/presentation/components/status_panels.dart';
import '../../../modules/organizations/presentation/organization_providers.dart';

enum _MemberAccess { noRequest, pending, rejected, granted }

class SpaceDetailsScreen extends ConsumerStatefulWidget {
  const SpaceDetailsScreen({super.key, required this.spaceId});

  final int spaceId;

  @override
  ConsumerState<SpaceDetailsScreen> createState() => _SpaceDetailsScreenState();
}

class _SpaceDetailsScreenState extends ConsumerState<SpaceDetailsScreen> {
  bool _isOpening = false;

  bool get _canManage {
    final role = ref
        .read(organizationControllerProvider)
        .viewerMembership
        ?.role;
    return role == null ||
        role == OrganizationMemberRole.owner ||
        role == OrganizationMemberRole.manager;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(spaceControllerProvider.notifier)
          .loadSpaceDetails(widget.spaceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spaceControllerProvider);
    final notifier = ref.read(spaceControllerProvider.notifier);

    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: const Text('Espaço'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: TechBackground(
        showTechIcons: false,
        child: SafeArea(
          top: false,
          child: state.selectedSpace.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: GateWiseColors.electricBlue,
                strokeWidth: 2.5,
              ),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(18),
              child: MessagePanel(
                icon: Icons.error_outline_rounded,
                title: 'Erro ao abrir espaço',
                message: error.toString(),
                actionLabel: 'Tentar novamente',
                onAction: () => notifier.loadSpaceDetails(widget.spaceId),
              ),
            ),
            data: (space) {
              if (space == null) {
                return const Padding(
                  padding: EdgeInsets.all(18),
                  child: MessagePanel(
                    icon: Icons.sensor_door_rounded,
                    title: 'Espaço não encontrado',
                    message: 'Não foi possível localizar os dados solicitados.',
                  ),
                );
              }

              if (!_canManage) {
                return _MemberSpaceBody(space: space);
              }

              return RefreshIndicator(
                color: GateWiseColors.electricBlue,
                backgroundColor: GateWiseColors.surface,
                onRefresh: () => notifier.loadSpaceDetails(space.id),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SpaceHeader(
                        space: space,
                        isOpening: _isOpening,
                        onOpen: () => _openDoor(context, space, notifier),
                        onEdit: () => _openEditForm(context, space, notifier),
                        onDelete: () => _confirmDelete(context, space, notifier),
                      ),
                      const SizedBox(height: 18),
                      _DeviceSection(
                        space: space,
                        notifier: notifier,
                        onProvision: () => _provisionDevice(context, space),
                        onDownloadKey: () =>
                            _downloadBackendKey(context, notifier),
                      ),
                      const SizedBox(height: 18),
                      _GrantsSection(
                        state: state,
                        space: space,
                        notifier: notifier,
                        parentContext: context,
                        parentRef: ref,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openDoor(
    BuildContext context,
    Space space,
    SpaceController notifier,
  ) async {
    setState(() => _isOpening = true);
    ref.read(dialogProvider.notifier).showLoading();
    try {
      final signingService = ref.read(signingServiceProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final signature = await signingService.signOpenLock(timestamp);
      final ok = await notifier.openSpace(
        space.id,
        timestamp: timestamp,
        signature: signature,
      );
      if (!ok && context.mounted) {
        ref.read(dialogProvider.notifier).showError(
          ref.read(spaceControllerProvider).actionErrorMessage ??
              'Não foi possível enviar o comando.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        ref.read(dialogProvider.notifier).showError('Erro ao abrir o espaço.');
      }
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  Future<void> _openEditForm(
    BuildContext context,
    Space space,
    SpaceController notifier,
  ) async {
    final payload = await showModalBottomSheet<SpacePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpaceFormSheet(space: space),
    );
    if (payload == null) return;

    final orgId = ref
        .read(organizationControllerProvider)
        .selectedOrganization
        .valueOrNull
        ?.id;
    if (orgId == null) return;

    final ok = await notifier.updateSpace(orgId, space.id, payload);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceActionError(context, ref);
      return;
    }
    showSpaceSnack(context, 'Espaço atualizado.');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Space space,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: 'Deletar espaço?',
      message: 'Esta ação removerá "${space.name}" permanentemente.',
      confirmLabel: 'Deletar',
      danger: true,
    );
    if (!confirmed) return;

    final orgId = ref
        .read(organizationControllerProvider)
        .selectedOrganization
        .valueOrNull
        ?.id;
    if (orgId == null) return;

    final ok = await notifier.deleteSpace(orgId, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceActionError(context, ref);
      return;
    }
    showSpaceSnack(context, 'Espaço deletado.');
    context.pop();
  }

  Future<void> _provisionDevice(
    BuildContext context,
    Space space,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: 'Reprovisionar dispositivo?',
      message:
          'Isso irá gerar novas chaves RSA para o ESP32 de "${space.name}". '
          'Se já existe um dispositivo configurado, ele será desconectado.',
      confirmLabel: 'Continuar',
    );
    if (!confirmed || !context.mounted) return;
    context.push('/spaces/${space.id}/provision');
  }

  Future<void> _downloadBackendKey(
    BuildContext context,
    SpaceController notifier,
  ) async {
    final action = await showModalBottomSheet<KeyExportAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const KeyExportSheet(title: 'Chave pública do backend'),
    );
    if (action == null || !context.mounted) return;

    final pem = await notifier.fetchBackendPublicKey();
    if (!context.mounted) return;
    if (pem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível obter a chave pública do backend.'),
          backgroundColor: GateWiseColors.danger,
        ),
      );
      return;
    }

    await executeKeyAction(
      context: context,
      action: action,
      filename: 'backend_public_key.pem',
      content: pem,
    );
  }
}

class _MemberSpaceBody extends ConsumerStatefulWidget {
  const _MemberSpaceBody({required this.space});

  final Space space;

  @override
  ConsumerState<_MemberSpaceBody> createState() => _MemberSpaceBodyState();
}

class _MemberSpaceBodyState extends ConsumerState<_MemberSpaceBody> {
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
            title: 'Erro ao carregar acesso',
            message: e.toString(),
            actionLabel: 'Tentar novamente',
            onAction: () => notifier.loadMyGrantsForCurrentUser(widget.space.id),
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
    ref.read(dialogProvider.notifier).showLoading();
    try {
      final signingService = ref.read(signingServiceProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final signature = await signingService.signOpenLock(timestamp);
      final ok = await ref.read(spaceControllerProvider.notifier).openSpace(
        widget.space.id,
        timestamp: timestamp,
        signature: signature,
      );
      if (!ok && context.mounted) {
        ref.read(dialogProvider.notifier).showError(
          ref.read(spaceControllerProvider).actionErrorMessage ??
              'Não foi possível enviar o comando.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        ref
            .read(dialogProvider.notifier)
            .showError('Erro ao abrir o espaço.');
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
            'Não foi possível enviar a solicitação.',
        isError: true,
      );
      return;
    }

    await notifier.loadMyGrantsForCurrentUser(widget.space.id);
    if (context.mounted) {
      showSpaceSnack(context, 'Solicitação enviada com sucesso.');
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
    final (message, chipLabel, chipIcon, chipColor, buttonLabel) =
        switch (access) {
      _MemberAccess.pending => (
        'Sua solicitação está aguardando aprovação.',
        'AGUARDANDO',
        Icons.schedule_rounded,
        GateWiseColors.amber,
        'Aguardando aprovação',
      ),
      _MemberAccess.rejected => (
        'Sua solicitação de acesso foi rejeitada.',
        'REJEITADO',
        Icons.gpp_bad_rounded,
        GateWiseColors.danger,
        'Solicitar novamente',
      ),
      _ => (
        'Você não tem acesso a este espaço.',
        null,
        Icons.lock_rounded,
        GateWiseColors.electricBlue,
        'Solicitar Acesso',
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
            TechStatusPill(
              label: chipLabel,
              icon: chipIcon,
              color: chipColor,
            ),
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
        const Text(
          'Meu acesso',
          style: TextStyle(
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
                        const TechStatusPill(
                          label: 'AUTORIZADO',
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
                'Módulo conectado ao controle de acesso. Acione a fechadura apenas quando estiver próximo ao ambiente autorizado.',
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
          label: isOpening ? 'Abrindo porta...' : 'Entrar no espaço',
          icon: Icons.lock_rounded,
          isLoading: isOpening,
          gradient: GateWiseColors.successGradient,
          onPressed: isOpening ? null : onOpen,
        ),
      ],
    );
  }
}

class _GrantsSection extends StatelessWidget {
  const _GrantsSection({
    required this.state,
    required this.space,
    required this.notifier,
    required this.parentContext,
    required this.parentRef,
  });

  final SpaceState state;
  final Space space;
  final SpaceController notifier;
  final BuildContext parentContext;
  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context) {
    final viewerRole = parentRef
        .read(organizationControllerProvider)
        .viewerMembership
        ?.role;
    final canRequestAccess = viewerRole == null ||
        viewerRole == OrganizationMemberRole.member;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: SectionTitle('Solicitações de acesso')),
            if (canRequestAccess)
              TextButton.icon(
                onPressed: () =>
                    _openRequestAccess(parentContext, space, notifier),
                icon: const Icon(Icons.add_rounded, size: 17),
                label: const Text('Solicitar'),
              ),
          ],
        ),
        const SizedBox(height: 10),
        state.grants.when(
          loading: () => const LoadingPanel(),
          error: (error, _) => MessagePanel(
            icon: Icons.lock_outline_rounded,
            title: 'Solicitações indisponíveis',
            message: error.toString(),
          ),
          data: (grants) {
            if (grants.isEmpty) {
              return const MessagePanel(
                icon: Icons.how_to_reg_rounded,
                title: 'Nenhuma solicitação',
                message:
                    'Solicitações de acesso aparecerão aqui para aprovação.',
              );
            }
            return Column(
              children: grants
                  .map(
                    (grant) => AccessGrantCard(
                      grant: grant,
                      onApprove: grant.status == AccessGrantStatus.pending
                          ? () =>
                                _confirmApprove(parentContext, grant, notifier)
                          : null,
                      onReject: grant.status == AccessGrantStatus.pending
                          ? () => _confirmReject(parentContext, grant, notifier)
                          : null,
                      onDelete: grant.status != AccessGrantStatus.pending
                          ? () => _confirmDeleteGrant(
                              parentContext,
                              grant,
                              notifier,
                            )
                          : null,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Future<void> _openRequestAccess(
    BuildContext context,
    Space space,
    SpaceController notifier,
  ) async {
    final payload = await showModalBottomSheet<RequestAccessPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RequestAccessSheet(space: space),
    );
    if (payload == null) return;

    final ok = await notifier.requestAccess(payload);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            'Não foi possível enviar a solicitação.',
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, 'Solicitação enviada com sucesso.');
  }

  Future<void> _confirmApprove(
    BuildContext context,
    AccessGrant grant,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: 'Aprovar acesso?',
      message: 'Autorizar ${grant.authorizedUserName} a acessar este space?',
      confirmLabel: 'Aprovar',
    );
    if (!confirmed) return;

    final ok = await notifier.approveGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            'Não foi possível aprovar.',
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, 'Acesso aprovado.');
  }

  Future<void> _confirmReject(
    BuildContext context,
    AccessGrant grant,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: 'Rejeitar acesso?',
      message: 'Rejeitar a solicitação de ${grant.authorizedUserName}?',
      confirmLabel: 'Rejeitar',
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.rejectGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            'Não foi possível rejeitar.',
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, 'Acesso rejeitado.');
  }

  Future<void> _confirmDeleteGrant(
    BuildContext context,
    AccessGrant grant,
    SpaceController notifier,
  ) async {
    final grants = state.grants.valueOrNull ?? [];
    final hasOtherGrantsForUser = grants.any(
      (g) =>
          g.id != grant.id &&
          g.authorizedUserId == grant.authorizedUserId &&
          g.status == AccessGrantStatus.granted,
    );
    final message = hasOtherGrantsForUser
        ? 'Remover o registro de acesso de ${grant.authorizedUserName}?'
        : 'Remover o registro de acesso de ${grant.authorizedUserName}?\n\n'
            'Este é o último acesso deste usuário neste espaço. Se não houver '
            'outros vínculos na organização, ele será removido automaticamente.';

    final confirmed = await confirmSpace(
      context,
      title: 'Remover acesso?',
      message: message,
      confirmLabel: 'Remover',
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.deleteGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            'Não foi possível remover.',
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, 'Registro removido.');
  }
}

class _DeviceSection extends StatelessWidget {
  const _DeviceSection({
    required this.space,
    required this.notifier,
    required this.onProvision,
    required this.onDownloadKey,
  });

  final Space space;
  final SpaceController notifier;
  final VoidCallback onProvision;
  final VoidCallback onDownloadKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Dispositivo'),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.memory_rounded,
                      color: GateWiseColors.electricBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hardware ESP32',
                          style: TextStyle(
                            color: GateWiseColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Gere as chaves RSA para flashar no dispositivo.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.48),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onProvision,
                icon: const Icon(Icons.settings_input_component_rounded, size: 17),
                label: const Text('Provisionar dispositivo'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onDownloadKey,
                icon: const Icon(Icons.ios_share_rounded, size: 17),
                label: const Text('Chave pública do backend'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

