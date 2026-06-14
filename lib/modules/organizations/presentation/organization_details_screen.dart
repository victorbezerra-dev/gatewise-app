import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';

import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../spaces/domain/entities/space_entity.dart';
import '../../spaces/presentation/components/space_card.dart';
import '../../spaces/presentation/space_providers.dart';
import '../domain/entities/organization_entity.dart';
import '../domain/entities/organization_invite_entity.dart';
import '../domain/value_objects/organization_member_role_vo.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref
          .read(organizationControllerProvider.notifier)
          .loadOrganizationDetails(widget.organizationId);
      ref.read(spaceControllerProvider.notifier).loadSpaces(widget.organizationId);
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
        title: Text(context.l.orgDetailsTitle),
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
                title: context.l.orgDetailsErrorLoad,
                message: error.toString(),
                actionLabel: context.l.actionRetry,
                onAction: () =>
                    notifier.loadOrganizationDetails(widget.organizationId),
              ),
            ),
            data: (organization) {
              if (organization == null) {
                return Padding(
                  padding: const EdgeInsets.all(18),
                  child: MessagePanel(
                    icon: Icons.business_rounded,
                    title: context.l.orgDetailsNotFound,
                    message: context.l.orgDetailsNotFoundMessage,
                  ),
                );
              }

              final canManage =
                  state.viewerMembership?.role.canManageOrganization ?? false;
              final canSeeInvites =
                  state.viewerMembership?.role != OrganizationMemberRole.member;
              final expectedTabCount = canSeeInvites ? 3 : 2;
              if (_tabController.length != expectedTabCount) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() {
                    final clampedIndex =
                        _tabController.index.clamp(0, expectedTabCount - 1);
                    _tabController.dispose();
                    _tabController = TabController(
                      initialIndex: clampedIndex,
                      length: expectedTabCount,
                      vsync: this,
                    );
                  });
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: OrganizationHeader(
                      organization: organization,
                      onEdit: canManage
                          ? () => _openEditForm(context, organization, notifier)
                          : null,
                      onDelete: canManage
                          ? () =>
                              _confirmDelete(context, organization, notifier)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _OrganizationTabs(
                      controller: _tabController,
                      canSeeInvites: canSeeInvites,
                    ),
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
                          canManage: canManage,
                          onRemoveMember: (member) => _confirmRemoveMember(
                            context,
                            organization.id,
                            member,
                            notifier,
                          ),
                          onChangeRole: (member) => _changeRole(
                            context,
                            organization.id,
                            member,
                            notifier,
                          ),
                          onRemoveFromSpace: (member) => _confirmRemoveFromSpace(
                            context,
                            organization.id,
                            member,
                            notifier,
                          ),
                        ),
                        if (canSeeInvites)
                          _InvitesTab(
                            state: state,
                            organizationId: organization.id,
                            notifier: notifier,
                            viewerMembership: state.viewerMembership,
                            onCreateInvite: () => _openInviteForm(
                              context,
                              organization.id,
                              notifier,
                              state.viewerMembership,
                            ),
                            onRevokeInvite: (invite) => _confirmRevokeInvite(
                              context,
                              organization.id,
                              invite,
                              notifier,
                            ),
                            onRemoveSpace: (invite, spaceId) =>
                                _confirmRemoveSpaceFromInvite(
                              context,
                              organization.id,
                              invite,
                              spaceId,
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
    showSnack(context, context.l.orgUpdated);
  }

  Future<void> _openInviteForm(
    BuildContext context,
    int organizationId,
    OrganizationController notifier,
    OrganizationMembership? viewerMembership,
  ) async {
    final payload = await showModalBottomSheet<CreateInvitePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteFormSheet(viewerMembership: viewerMembership),
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
    showSnack(context, context.l.orgInviteCreated(invite.code));
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Organization organization,
    OrganizationController notifier,
  ) async {
    final confirmed = await confirm(
      context,
      title: context.l.orgDeleteTitle,
      message: context.l.orgDeleteMessage(organization.name),
      confirmLabel: context.l.orgDeleteConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.deleteOrganization(organization.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, context.l.orgDeleteSuccess);
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
      title: context.l.orgRemoveMemberTitle,
      message: context.l.orgRemoveMemberMessage(member.name),
      confirmLabel: context.l.orgRemoveMemberConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.removeMember(organizationId, member.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, context.l.orgRemoveMemberSuccess);
  }

  Future<void> _changeRole(
    BuildContext context,
    int organizationId,
    OrganizationMember member,
    OrganizationController notifier,
  ) async {
    final availableSpaces =
        ref.read(spaceControllerProvider).spaces.valueOrNull ?? [];

    final result = await showDialog<(OrganizationMemberRole, List<int>)>(
      context: context,
      builder: (_) => _ChangeRoleDialog(
        member: member,
        availableSpaces: availableSpaces,
      ),
    );
    if (result == null || !context.mounted) return;

    final (newRole, spaceIds) = result;
    final ok = await notifier.updateMemberRole(
      organizationId,
      member.id,
      newRole,
      spaceIds: spaceIds,
    );
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    final roleLabel = switch (newRole) {
      OrganizationMemberRole.owner => context.l.roleOwner,
      OrganizationMemberRole.manager => context.l.roleManager,
      OrganizationMemberRole.member => context.l.roleMember,
    };
    showSnack(context, context.l.orgChangeRoleSuccess(member.name, roleLabel));
  }

  Future<void> _confirmRemoveFromSpace(
    BuildContext context,
    int organizationId,
    OrganizationMember member,
    OrganizationController notifier,
  ) async {
    final orgSpaces = ref.read(spaceControllerProvider).spaces.valueOrNull ?? [];

    if (orgSpaces.isEmpty) {
      showSnack(
        context,
        context.l.orgNoSpacesError,
        isError: true,
      );
      return;
    }

    final space = await showDialog<Space>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: GateWiseColors.surface,
        title: Text(
          context.l.orgSelectSpaceDialog(member.name),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        children: orgSpaces
            .map(
              (s) => SimpleDialogOption(
                onPressed: () => Navigator.of(ctx).pop(s),
                child: Row(
                  children: [
                    const Icon(
                      Icons.maps_home_work_rounded,
                      size: 16,
                      color: GateWiseColors.mint,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
    if (space == null || !context.mounted) return;

    final confirmed = await confirm(
      context,
      title: context.l.orgRemoveFromSpaceTitle,
      message: context.l.orgRemoveFromSpaceMessage(member.name, space.name),
      confirmLabel: context.l.orgRemoveFromSpaceConfirm,
      danger: true,
    );
    if (!confirmed || !context.mounted) return;

    final ok = await notifier.removeSpaceManager(
      organizationId,
      space.id,
      member.id,
    );
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, context.l.orgRemoveFromSpaceSuccess(member.name, space.name));
  }

  Future<void> _confirmRevokeInvite(
    BuildContext context,
    int organizationId,
    OrganizationInvite invite,
    OrganizationController notifier,
  ) async {
    final confirmed = await confirm(
      context,
      title: context.l.orgRevokeInviteTitle,
      message: context.l.orgRevokeInviteMessage(invite.code),
      confirmLabel: context.l.orgRevokeInviteConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.revokeInvite(organizationId, invite.id);
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, context.l.orgRevokeInviteSuccess);
  }

  Future<void> _confirmRemoveSpaceFromInvite(
    BuildContext context,
    int organizationId,
    OrganizationInvite invite,
    int spaceId,
    OrganizationController notifier,
  ) async {
    final space = invite.spaces.firstWhere(
      (s) => s.spaceId == spaceId,
      orElse: () => ManagedSpace(spaceId: spaceId, name: context.l.thisSpace),
    );
    final isLast = invite.spaces.length == 1;

    final confirmed = await confirm(
      context,
      title: context.l.orgRemoveSpaceTitle,
      message: isLast
          ? context.l.orgRemoveSpaceMessageLast(space.name, invite.code)
          : context.l.orgRemoveSpaceMessage(space.name, invite.code),
      confirmLabel: context.l.orgRemoveSpaceConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.removeSpaceFromInvite(
      organizationId,
      invite.id,
      spaceId,
    );
    if (!context.mounted) return;
    if (!ok) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, isLast ? context.l.orgRemoveSpaceSuccessDeactivated : context.l.orgRemoveSpaceSuccess);
  }
}

class _OrganizationTabs extends StatelessWidget {
  const _OrganizationTabs({
    required this.controller,
    required this.canSeeInvites,
  });

  final TabController controller;
  final bool canSeeInvites;

  @override
  Widget build(BuildContext context) {
    final allTabs = [
      _OrganizationTabItem(
        label: context.l.orgTabSpaces,
        icon: Icons.maps_home_work_rounded,
        color: GateWiseColors.mint,
      ),
      _OrganizationTabItem(
        label: context.l.orgTabMembers,
        icon: Icons.groups_rounded,
        color: GateWiseColors.neonCyan,
      ),
      _OrganizationTabItem(
        label: context.l.orgTabInvites,
        icon: Icons.mark_email_unread_rounded,
        color: GateWiseColors.amber,
      ),
    ];
    final tabs = canSeeInvites ? allTabs : allTabs.sublist(0, 2);

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
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
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

class _MembersTab extends ConsumerWidget {
  const _MembersTab({
    required this.state,
    required this.organizationId,
    required this.notifier,
    required this.canManage,
    required this.onRemoveMember,
    required this.onChangeRole,
    required this.onRemoveFromSpace,
  });

  final OrganizationState state;
  final int organizationId;
  final OrganizationController notifier;
  final bool canManage;
  final void Function(OrganizationMember) onRemoveMember;
  final void Function(OrganizationMember) onChangeRole;
  final void Function(OrganizationMember) onRemoveFromSpace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userProfileProvider).valueOrNull?.id;

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
              title: context.l.orgMembersUnavailable,
              message: error.toString(),
            ),
            data: (members) => members.isEmpty
                ? MessagePanel(
                    icon: Icons.people_outline_rounded,
                    title: context.l.orgMembersNone,
                    message: context.l.orgMembersNoneMessage,
                  )
                : Column(
                    children: ([...members]
                          ..sort((a, b) {
                            if (a.userId == currentUserId) return -1;
                            if (b.userId == currentUserId) return 1;
                            return 0;
                          }))
                        .map(
                          (member) {
                            final isMe = currentUserId != null &&
                                member.userId == currentUserId;
                            return MemberCard(
                              member: member,
                              isCurrentUser: isMe,
                              onRemove: (canManage && !isMe)
                                  ? () => onRemoveMember(member)
                                  : null,
                              onChangeRole: (canManage && !isMe)
                                  ? () => onChangeRole(member)
                                  : null,
                              onRemoveFromSpace: (canManage &&
                                      !isMe &&
                                      member.role !=
                                          OrganizationMemberRole.owner)
                                  ? () => onRemoveFromSpace(member)
                                  : null,
                            );
                          },
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
    required this.viewerMembership,
    required this.onCreateInvite,
    required this.onRevokeInvite,
    required this.onRemoveSpace,
  });

  final OrganizationState state;
  final int organizationId;
  final OrganizationController notifier;
  final OrganizationMembership? viewerMembership;
  final VoidCallback onCreateInvite;
  final void Function(OrganizationInvite) onRevokeInvite;
  final void Function(OrganizationInvite, int spaceId) onRemoveSpace;

  @override
  Widget build(BuildContext context) {
    final canRevoke = viewerMembership?.role.canManageOrganization ?? false;
    final canRemoveSpace = canRevoke ||
        viewerMembership?.role == OrganizationMemberRole.manager;

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
              Expanded(child: SectionTitle(context.l.orgInvitesSection)),
              TextButton.icon(
                onPressed: onCreateInvite,
                icon: const Icon(Icons.add_link_rounded, size: 17),
                label: Text(context.l.orgInvitesNewButton),
              ),
            ],
          ),
          const SizedBox(height: 10),
          state.invites.when(
            loading: () => const LoadingPanel(),
            error: (error, _) => MessagePanel(
              icon: Icons.lock_outline_rounded,
              title: context.l.orgInvitesUnavailable,
              message: error.toString(),
            ),
            data: (invites) => invites.isEmpty
                ? MessagePanel(
                    icon: Icons.mail_outline_rounded,
                    title: context.l.orgInvitesNone,
                    message: context.l.orgInvitesNoneMessage,
                  )
                : Column(
                    children: invites
                        .map(
                          (invite) => InviteCard(
                            invite: invite,
                            onRevoke: canRevoke
                                ? () => onRevokeInvite(invite)
                                : null,
                            onRemoveSpace: canRemoveSpace
                                ? (spaceId) => onRemoveSpace(invite, spaceId)
                                : null,
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
      onRefresh: () => spaceNotifier.loadSpaces(organizationId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: SectionTitle(context.l.orgSpacesSection)),
                TextButton.icon(
                  onPressed: () => context.push('/spaces'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 17),
                  label: Text(context.l.orgManageButton),
                ),
              ],
            ),
            const SizedBox(height: 10),
            spacesState.spaces.when(
              loading: () => const LoadingPanel(),
              error: (_, __) => MessagePanel(
                icon: Icons.sensor_door_rounded,
                title: context.l.orgSpacesUnavailable,
                message: context.l.orgSpacesUnavailableMessage,
              ),
              data: (spaces) {
                final organizationSpaces = spaces;

                return organizationSpaces.isEmpty
                    ? MessagePanel(
                        icon: Icons.sensor_door_rounded,
                        title: context.l.orgSpacesNone,
                        message: context.l.orgSpacesNoneMessage,
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

class _ChangeRoleDialog extends StatefulWidget {
  const _ChangeRoleDialog({
    required this.member,
    required this.availableSpaces,
  });

  final OrganizationMember member;
  final List<Space> availableSpaces;

  @override
  State<_ChangeRoleDialog> createState() => _ChangeRoleDialogState();
}

class _ChangeRoleDialogState extends State<_ChangeRoleDialog> {
  OrganizationMemberRole? _selectedRole;
  final Set<int> _selectedSpaceIds = {};

  bool get _canConfirm =>
      _selectedRole != null &&
      (_selectedRole != OrganizationMemberRole.manager ||
          _selectedSpaceIds.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final roles = OrganizationMemberRole.values
        .where((r) => r != widget.member.role)
        .toList();

    return Dialog(
      backgroundColor: GateWiseColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l.orgChangeRoleTitle(widget.member.name),
                style: const TextStyle(
                  color: GateWiseColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...roles.map(
                (role) => _RoleOption(
                  role: role,
                  selected: _selectedRole == role,
                  onTap: () => setState(() {
                    _selectedRole = role;
                    if (role != OrganizationMemberRole.manager) {
                      _selectedSpaceIds.clear();
                    }
                  }),
                ),
              ),
              if (_selectedRole == OrganizationMemberRole.manager) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white12),
                const SizedBox(height: 8),
                Text(
                  context.l.orgChangeRoleSelectSpace,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.availableSpaces.map((space) {
                        final checked = _selectedSpaceIds.contains(space.id);
                        return CheckboxListTile(
                          value: checked,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          activeColor: GateWiseColors.electricBlue,
                          checkColor: Colors.white,
                          title: Text(
                            space.name,
                            style: const TextStyle(
                              color: GateWiseColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (_) => setState(() {
                            if (checked) {
                              _selectedSpaceIds.remove(space.id);
                            } else {
                              _selectedSpaceIds.add(space.id);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l.actionCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _canConfirm
                        ? () => Navigator.of(context).pop(
                              (_selectedRole!, _selectedSpaceIds.toList()),
                            )
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: GateWiseColors.electricBlue,
                    ),
                    child: Text(context.l.actionConfirm),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final OrganizationMemberRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      OrganizationMemberRole.owner => GateWiseColors.mint,
      OrganizationMemberRole.manager => GateWiseColors.amber,
      OrganizationMemberRole.member => GateWiseColors.electricBlue,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.6) : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.shield_rounded, size: 16, color: color),
            const SizedBox(width: 10),
            Text(
              switch (role) {
                OrganizationMemberRole.owner => context.l.roleOwner,
                OrganizationMemberRole.manager => context.l.roleManager,
                OrganizationMemberRole.member => context.l.roleMember,
              },
              style: TextStyle(
                color: selected ? color : GateWiseColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
