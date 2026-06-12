import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../../../modules/home/presentation/rsa_signing_service_provider.dart';
import '../domain/entities/access_grant_entity.dart';
import '../domain/entities/space_entity.dart';
import '../domain/value_objects/access_grant_status_vo.dart';
import '../infra/dtos/access_grant_dto.dart';
import '../infra/dtos/space_payload_dto.dart';
import 'components/access_grant_card.dart';
import 'components/request_access_sheet.dart';
import 'components/space_form_sheet.dart';
import 'components/space_header.dart';
import 'components/space_ui_helpers.dart';
import 'space_providers.dart';
import '../../../modules/organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../../modules/organizations/presentation/components/status_panels.dart';
import '../../../modules/organizations/presentation/organization_providers.dart';

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
                        onEdit: _canManage
                            ? () => _openEditForm(context, space, notifier)
                            : null,
                        onDelete: _canManage
                            ? () => _confirmDelete(context, space, notifier)
                            : null,
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
    try {
      final signingService = ref.read(signingServiceProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final signature = await signingService.signOpenLock(timestamp);
      final ok = await notifier.openSpace(
        space.id,
        timestamp: timestamp,
        signature: signature,
      );
      if (!context.mounted) return;
      if (!ok) {
        showSpaceActionError(context, ref);
      } else {
        showSpaceSnack(context, 'Comando enviado. Aguarde...');
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
