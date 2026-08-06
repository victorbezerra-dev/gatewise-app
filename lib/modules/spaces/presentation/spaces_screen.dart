import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../domain/entities/space_entity.dart';
import '../domain/value_objects/access_grant_status_vo.dart';
import '../infra/dtos/space_payload_dto.dart';
import 'components/space_card.dart';
import 'components/space_form_sheet.dart';
import 'components/space_ui_helpers.dart';
import 'space_providers.dart';
import '../../../modules/organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../../modules/organizations/presentation/components/join_organization_sheet.dart';
import '../../../modules/organizations/presentation/components/org_ui_helpers.dart';
import '../../../modules/organizations/presentation/components/status_panels.dart';
import '../../../modules/organizations/presentation/organization_providers.dart';
import '../../../core/l10n/l10n.dart';

class SpacesScreen extends ConsumerStatefulWidget {
  const SpacesScreen({super.key});

  @override
  ConsumerState<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends ConsumerState<SpacesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final orgId = ref
          .read(organizationControllerProvider)
          .selectedOrganization
          .valueOrNull
          ?.id;
      if (orgId != null) {
        ref.read(spaceControllerProvider.notifier).loadSpaces(orgId);
      }
      ref.read(spaceControllerProvider.notifier).loadAllMyGrantsForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spaceControllerProvider);
    final notifier = ref.read(spaceControllerProvider.notifier);
    final spacesSnapshot = state.spaces.maybeWhen(
      data: (spaces) => spaces,
      orElse: () => const <Space>[],
    );
    final role = ref
        .watch(organizationControllerProvider)
        .viewerMembership
        ?.role;
    final canCreate = role == null || role == OrganizationMemberRole.owner;
    final pendingSpaceIds = (state.myGrants.valueOrNull ?? const [])
        .where((g) => g.status == AccessGrantStatus.pending)
        .map((g) => g.spaceId)
        .toSet();

    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: Text(context.l.spacesTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: TechBackground(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            color: GateWiseColors.electricBlue,
            backgroundColor: GateWiseColors.surface,
            onRefresh: () {
              final orgId = ref
                  .read(organizationControllerProvider)
                  .selectedOrganization
                  .valueOrNull
                  ?.id;
              if (orgId != null) return notifier.loadSpaces(orgId);
              return Future<void>.value();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 14),
                  _SpacesHero(
                    spaces: spacesSnapshot,
                    canCreate: canCreate,
                    onCreate: () => _openSpaceForm(context, notifier),
                    onAddByCode: () => _openAddSpaceByCode(context, notifier),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: SectionTitle(context.l.spacesOrgSection),
                      ),
                      _CountPill(count: spacesSnapshot.length),
                    ],
                  ),
                  const SizedBox(height: 10),
                  state.spaces.when(
                    loading: () => const LoadingPanel(),
                    error: (error, _) => MessagePanel(
                      icon: Icons.error_outline_rounded,
                      title: context.l.spacesErrorLoad,
                      message: error.toString(),
                      actionLabel: context.l.actionRetry,
                      onAction: () {
                        final orgId = ref
                            .read(organizationControllerProvider)
                            .selectedOrganization
                            .valueOrNull
                            ?.id;
                        if (orgId != null) notifier.loadSpaces(orgId);
                      },
                    ),
                    data: (spaces) {
                      if (spaces.isEmpty) {
                        return MessagePanel(
                          icon: Icons.sensor_door_rounded,
                          title: context.l.spacesNone,
                          message: context.l.spacesNoneMessage,
                        );
                      }
                      return Column(
                        children: spaces
                            .map(
                              (space) => SpaceCard(
                                space: space,
                                locked: !canCreate && !space.hasAccess,
                                pending: pendingSpaceIds.contains(space.id),
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
          ),
        ),
      ),
    );
  }

  Future<void> _openSpaceForm(
    BuildContext context,
    SpaceController notifier,
  ) async {
    final orgId = ref
        .read(organizationControllerProvider)
        .selectedOrganization
        .valueOrNull
        ?.id;
    if (orgId == null) return;

    final payload = await showModalBottomSheet<SpacePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SpaceFormSheet(),
    );
    if (payload == null) return;

    final space = await notifier.createSpace(orgId, payload);
    if (!context.mounted) return;
    if (space == null) {
      showSpaceActionError(context, ref);
      return;
    }
    context.push('/spaces/${space.id}/provision');
  }

  Future<void> _openAddSpaceByCode(
    BuildContext context,
    SpaceController notifier,
  ) async {
    final orgId = ref
        .read(organizationControllerProvider)
        .selectedOrganization
        .valueOrNull
        ?.id;
    if (orgId == null) return;

    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JoinOrganizationSheet(addSpaceVariant: true),
    );
    if (code == null || code.trim().isEmpty) return;

    final result = await ref
        .read(organizationControllerProvider.notifier)
        .joinByCode(code, organizationId: orgId);
    if (!context.mounted) return;
    if (result == null) {
      showJoinActionError(context, ref);
      return;
    }
    showSnack(context, messageForJoinResult(context, result));
    await notifier.loadSpaces(orgId);
  }
}

class _SpacesHero extends StatelessWidget {
  const _SpacesHero({
    required this.spaces,
    required this.canCreate,
    required this.onCreate,
    required this.onAddByCode,
  });

  final List<Space> spaces;
  final bool canCreate;
  final VoidCallback onCreate;
  final VoidCallback onAddByCode;

  @override
  Widget build(BuildContext context) {
    final activeSpaces = spaces.where((space) => space.isActive).length;
    final inactiveSpaces = spaces.length - activeSpaces;

    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 30,
      opacity: 0.74,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GateWiseColors.electricBlue.withValues(alpha: 0.26),
                      GateWiseColors.surfaceGlass.withValues(alpha: 0.16),
                      GateWiseColors.mint.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TechStatusPill(
                    label: context.l.spacesHeroPill,
                    icon: Icons.hub_rounded,
                    color: GateWiseColors.neonCyan,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.l.spacesHeroTitle,
                    style: const TextStyle(
                      color: GateWiseColors.textPrimary,
                      fontSize: 27,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.9,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    canCreate
                        ? context.l.spacesHeroDescOwner
                        : context.l.spacesHeroDescMember,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.64),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroMetric(
                          label: context.l.spacesMetricTotal,
                          value: spaces.length.toString(),
                          icon: Icons.grid_view_rounded,
                          color: GateWiseColors.neonCyan,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HeroMetric(
                          label: context.l.spacesMetricActive,
                          value: activeSpaces.toString(),
                          icon: Icons.check_circle_rounded,
                          color: GateWiseColors.mint,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HeroMetric(
                          label: context.l.spacesMetricPaused,
                          value: inactiveSpaces.toString(),
                          icon: Icons.pause_circle_outline_rounded,
                          color: GateWiseColors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (canCreate)
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onCreate,
                        style: FilledButton.styleFrom(
                          backgroundColor: GateWiseColors.electricBlue,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(context.l.spacesNewButton),
                      ),
                    )
                  else
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onAddByCode,
                        icon: const Icon(Icons.vpn_key_rounded, size: 18),
                        label: Text(context.l.orgAddSpaceByCodeButton),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GateWiseColors.background.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceLight.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: GateWiseColors.electricBlue.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        context.l.spacesCountPill(count),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.66),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
