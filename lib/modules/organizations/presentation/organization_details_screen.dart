import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../../spaces/presentation/components/space_card.dart';
import '../../spaces/presentation/space_providers.dart';
import '../domain/entities/organization_entity.dart';
import '../domain/entities/organization_invite_entity.dart';
import '../domain/entities/organization_member_entity.dart';
import '../infra/dtos/create_invite_dto.dart';
import '../infra/dtos/organization_payload_dto.dart';
import 'components/invite_card.dart';
import 'components/member_card.dart';
import 'components/organization_header.dart';
import 'components/status_panels.dart';
import 'organization_providers.dart';
import 'components/invite_form_sheet.dart';
import 'components/organization_form_sheet.dart';
import 'components/org_ui_helpers.dart';

class OrganizationDetailsScreen extends ConsumerStatefulWidget {
  const OrganizationDetailsScreen({super.key, required this.organizationId});

  final int organizationId;

  @override
  ConsumerState<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState
    extends ConsumerState<OrganizationDetailsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref
          .read(organizationControllerProvider.notifier)
          .loadOrganizationDetails(widget.organizationId);
      ref.read(spaceControllerProvider.notifier).loadSpaces();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizationControllerProvider);
    final notifier = ref.read(organizationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: const Text('Organização'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: TechBackground(
        showTechIcons: false,
        child: SafeArea(
          top: false,
          child: state.selectedOrganization.when(
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
                title: 'Erro ao abrir organização',
                message: error.toString(),
                actionLabel: 'Tentar novamente',
                onAction: () =>
                    notifier.loadOrganizationDetails(widget.organizationId),
              ),
            ),
            data: (organization) {
              if (organization == null) {
                return const Padding(
                  padding: EdgeInsets.all(18),
                  child: MessagePanel(
                    icon: Icons.business_rounded,
                    title: 'Organização não encontrada',
                    message: 'Não foi possível localizar os dados solicitados.',
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: OrganizationHeader(
                      organization: organization,
                      onEdit: () =>
                          _openEditForm(context, organization, notifier),
                      onDelete: () =>
                          _confirmDelete(context, organization, notifier),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _OrganizationTabs(controller: _tabController),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _SpacesTab(organizationId: organization.id),
                        _MembersTab(
                          state: state,
                          organizationId: organization.id,
                          notifier: notifier,
                          onRemoveMember: (member) => _confirmRemoveMember(
                            context,
                            organization.id,
                            member,
                            notifier,
                          ),
                        ),
                        _InvitesTab(
                          state: state,
                          organizationId: organization.id,
                          notifier: notifier,
                          onCreateInvite: () => _openInviteForm(
                            context,
                            organization.id,
                            notifier,
                          ),
                          onRevokeInvite: (invite) => _confirmRevokeInvite(
                            context,
                            organization.id,
                            invite,
                            notifier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openEditForm(
    BuildContext context,
    Organization organization,
    OrganizationController notifier,
  ) async {
    final payload = await showModalBottomSheet<OrganizationPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrganizationFormSheet(organization: organization),
    );
    if (payload == null) return;

    final ok = await notifier.updateOrganization(organization.id, payload);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Organização atualizada.');
  }

  Future<void> _openInviteForm(
    BuildContext context,
    int organizationId,
    OrganizationController notifier,
  ) async {
    final payload = await showModalBottomSheet<CreateInvitePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InviteFormSheet(),
    );
    if (payload == null) return;

    final invite = await notifier.createInvite(organizationId, payload);
    if (!context.mounted) return;
    if (invite == null) {
      showActionError(context, ref);
      return;
    }
    await Clipboard.setData(ClipboardData(text: invite.code));
    if (!context.mounted) return;
    showSnack(context, 'Convite ${invite.code} criado e copiado.');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Organization organization,
    OrganizationController notifier,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Deletar organização?',
      message: 'Esta ação removerá ${organization.name}.',
      confirmLabel: 'Deletar',
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.deleteOrganization(organization.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Organização deletada.');
    context.pop();
  }

  Future<void> _confirmRemoveMember(
    BuildContext context,
    int organizationId,
    OrganizationMember member,
    OrganizationController notifier,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Remover membro?',
      message: 'Remover ${member.name} da organização?',
      confirmLabel: 'Remover',
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.removeMember(organizationId, member.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Membro removido.');
  }

  Future<void> _confirmRevokeInvite(
    BuildContext context,
    int organizationId,
    OrganizationInvite invite,
    OrganizationController notifier,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Revogar convite?',
      message: 'O código ${invite.code} deixará de funcionar.',
      confirmLabel: 'Revogar',
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.revokeInvite(organizationId, invite.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Convite revogado.');
  }
}

class _OrganizationTabs extends StatelessWidget {
  const _OrganizationTabs({required this.controller});

  final TabController controller;

  static const _tabs = [
    _OrganizationTabItem(
      label: 'Espaços',
      icon: Icons.maps_home_work_rounded,
      color: GateWiseColors.mint,
    ),
    _OrganizationTabItem(
      label: 'Membros',
      icon: Icons.groups_rounded,
      color: GateWiseColors.neonCyan,
    ),
    _OrganizationTabItem(
      label: 'Convites',
      icon: Icons.mark_email_unread_rounded,
      color: GateWiseColors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceGlass.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: controller.animation ?? controller,
        builder: (context, _) {
          final animationValue =
              controller.animation?.value ?? controller.index.toDouble();

          return Row(
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final selectedAmount = (1 - (animationValue - index).abs()).clamp(
                0.0,
                1.0,
              );

              return Expanded(
                child: _OrganizationTabButton(
                  tab: tab,
                  selectedAmount: selectedAmount,
                  onTap: () {
                    if (controller.index == index) return;
                    HapticFeedback.selectionClick();
                    controller.animateTo(
                      index,
                      duration: const Duration(milliseconds: 130),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _OrganizationTabItem {
  const _OrganizationTabItem({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class _OrganizationTabButton extends StatelessWidget {
  const _OrganizationTabButton({
    required this.tab,
    required this.selectedAmount,
    required this.onTap,
  });

  final _OrganizationTabItem tab;
  final double selectedAmount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = selectedAmount >= 0.5;
    final foreground = Color.lerp(
      GateWiseColors.textMuted,
      Colors.white,
      selectedAmount,
    )!;
    final surfaceColor = GateWiseColors.surfaceLight.withValues(alpha: 0.32);
    final firstGradientColor = Color.lerp(
      surfaceColor,
      tab.color.withValues(alpha: 0.92),
      selectedAmount,
    )!;
    final secondGradientColor = Color.lerp(
      surfaceColor,
      GateWiseColors.electricBlue.withValues(alpha: 0.95),
      selectedAmount,
    )!;

    return Semantics(
      selected: selected,
      button: true,
      label: tab.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [firstGradientColor, secondGradientColor],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.055 + (0.105 * selectedAmount),
              ),
            ),
            boxShadow: selectedAmount == 0
                ? null
                : [
                    BoxShadow(
                      color: tab.color.withValues(alpha: 0.18 * selectedAmount),
                      blurRadius: 8 + (6 * selectedAmount),
                      offset: Offset(0, 3 + (4 * selectedAmount)),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(
                          tab.color.withValues(alpha: 0.09),
                          Colors.white.withValues(alpha: 0.18),
                          selectedAmount,
                        ),
                        border: Border.all(
                          color: Color.lerp(
                            tab.color.withValues(alpha: 0.18),
                            Colors.white.withValues(alpha: 0.2),
                            selectedAmount,
                          )!,
                        ),
                      ),
                      child: Icon(tab.icon, color: foreground, size: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tab.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 12.5,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  const _MembersTab({
    required this.state,
    required this.organizationId,
    required this.notifier,
    required this.onRemoveMember,
  });

  final OrganizationState state;
  final int organizationId;
  final OrganizationController notifier;
  final void Function(OrganizationMember) onRemoveMember;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: GateWiseColors.electricBlue,
      backgroundColor: GateWiseColors.surface,
      onRefresh: () => notifier.loadMembers(organizationId),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          state.members.when(
            loading: () => const LoadingPanel(),
            error: (error, _) => MessagePanel(
              icon: Icons.lock_outline_rounded,
              title: 'Membros indisponíveis',
              message: error.toString(),
            ),
            data: (members) => members.isEmpty
                ? const MessagePanel(
                    icon: Icons.people_outline_rounded,
                    title: 'Nenhum membro listado',
                    message:
                        'A listagem de membros aparece para admin, Owner ou Manager.',
                  )
                : Column(
                    children: members
                        .map(
                          (member) => MemberCard(
                            member: member,
                            onRemove: () => onRemoveMember(member),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _InvitesTab extends StatelessWidget {
  const _InvitesTab({
    required this.state,
    required this.organizationId,
    required this.notifier,
    required this.onCreateInvite,
    required this.onRevokeInvite,
  });

  final OrganizationState state;
  final int organizationId;
  final OrganizationController notifier;
  final VoidCallback onCreateInvite;
  final void Function(OrganizationInvite) onRevokeInvite;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: GateWiseColors.electricBlue,
      backgroundColor: GateWiseColors.surface,
      onRefresh: () => notifier.loadInvites(organizationId),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          Row(
            children: [
              const Expanded(child: SectionTitle('Convites ativos')),
              TextButton.icon(
                onPressed: onCreateInvite,
                icon: const Icon(Icons.add_link_rounded, size: 17),
                label: const Text('Novo'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          state.invites.when(
            loading: () => const LoadingPanel(),
            error: (error, _) => MessagePanel(
              icon: Icons.lock_outline_rounded,
              title: 'Convites indisponíveis',
              message: error.toString(),
            ),
            data: (invites) => invites.isEmpty
                ? const MessagePanel(
                    icon: Icons.mail_outline_rounded,
                    title: 'Nenhum convite ativo',
                    message:
                        'Crie convites para permitir a entrada de novos membros.',
                  )
                : Column(
                    children: invites
                        .map(
                          (invite) => InviteCard(
                            invite: invite,
                            onRevoke: () => onRevokeInvite(invite),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SpacesTab extends ConsumerWidget {
  const _SpacesTab({required this.organizationId});

  final int organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacesState = ref.watch(spaceControllerProvider);
    final spaceNotifier = ref.read(spaceControllerProvider.notifier);

    return RefreshIndicator(
      color: GateWiseColors.electricBlue,
      backgroundColor: GateWiseColors.surface,
      onRefresh: spaceNotifier.loadSpaces,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(child: SectionTitle('Espaços da organização')),
                TextButton.icon(
                  onPressed: () => context.push('/spaces'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 17),
                  label: const Text('Gerenciar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            spacesState.spaces.when(
              loading: () => const LoadingPanel(),
              error: (_, __) => const MessagePanel(
                icon: Icons.sensor_door_rounded,
                title: 'Espaços indisponíveis',
                message: 'Não foi possível carregar os espaços.',
              ),
              data: (spaces) {
                final organizationSpaces = spaces
                    .where((space) => space.organizationId == organizationId)
                    .toList();

                return organizationSpaces.isEmpty
                    ? const MessagePanel(
                        icon: Icons.sensor_door_rounded,
                        title: 'Nenhum espaço cadastrado',
                        message:
                            'Adicione espaços para controlar o acesso às portas.',
                      )
                    : Column(
                        children: organizationSpaces
                            .take(3)
                            .map(
                              (space) => SpaceCard(
                                space: space,
                                onTap: () =>
                                    context.push('/spaces/${space.id}'),
                              ),
                            )
                            .toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
