import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../../organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../organizations/presentation/organization_providers.dart';
import '../../spaces/domain/entities/access_grant_entity.dart';
import '../../spaces/domain/value_objects/access_grant_status_vo.dart';
import 'components/grant_filter_row.dart';
import 'components/grant_request_card.dart';
import 'grant_request_providers.dart';

class GrantsTab extends ConsumerWidget {
  const GrantsTab({super.key});

  bool _canReview(WidgetRef ref) {
    final role = ref
        .watch(organizationControllerProvider)
        .viewerMembership
        ?.role;
    return role == null ||
        role == OrganizationMemberRole.owner ||
        role == OrganizationMemberRole.manager;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(grantRequestControllerProvider);
    final controller = ref.read(grantRequestControllerProvider.notifier);
    final canReview = _canReview(ref);

    return RefreshIndicator(
      color: GateWiseColors.neonCyan,
      backgroundColor: GateWiseColors.surface,
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GrantFilterRow(
                  viewType: state.viewType,
                  statusFilter: state.statusFilter,
                  canReview: canReview,
                  hasActiveFilters: state.hasActiveFilters,
                  onViewTypeChanged: controller.setViewType,
                  onStatusChanged: controller.setStatusFilter,
                  onClearFilters: controller.clearFilters,
                ),
                const SizedBox(height: 12),
                if (state.isReviewing)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      color: GateWiseColors.neonCyan,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                if (state.reviewError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      state.reviewError!,
                      style: const TextStyle(
                        color: GateWiseColors.danger,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
              ]),
            ),
          ),
          state.grants.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: GateWiseColors.neonCyan,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: GlassPanel(
                    padding: const EdgeInsets.all(18),
                    borderRadius: 18,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: GateWiseColors.danger,
                          size: 34,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Erro ao carregar solicitações',
                          style: TextStyle(
                            color: GateWiseColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.58),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: controller.refresh,
                          child: const Text(
                            'Tentar novamente',
                            style: TextStyle(color: GateWiseColors.neonCyan),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            data: (grants) {
              if (grants.isEmpty) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 122),
                  sliver: SliverToBoxAdapter(
                    child: GlassPanel(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: GateWiseColors.electricBlue.withValues(
                                alpha: 0.14,
                              ),
                              border: Border.all(
                                color: GateWiseColors.electricBlue.withValues(
                                  alpha: 0.24,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.how_to_reg_rounded,
                              color: GateWiseColors.electricBlue,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Nenhuma solicitação',
                                  style: TextStyle(
                                    color: GateWiseColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.viewType == GrantViewType.mine
                                      ? 'Você ainda não solicitou acesso a nenhum espaço.'
                                      : 'Não há solicitações pendentes de revisão.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.58),
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 122),
                sliver: SliverList.builder(
                  itemCount: grants.length,
                  itemBuilder: (context, i) {
                    final grant = grants[i];
                    final isToReview = state.viewType == GrantViewType.toReview;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GrantRequestCard(
                        grant: grant,
                        showUser: isToReview,
                        onApprove:
                            isToReview &&
                                grant.status == AccessGrantStatus.pending
                            ? () => _confirmAction(
                                context,
                                grant,
                                approve: true,
                                controller: controller,
                              )
                            : null,
                        onReject:
                            isToReview &&
                                grant.status == AccessGrantStatus.pending
                            ? () => _confirmAction(
                                context,
                                grant,
                                approve: false,
                                controller: controller,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAction(
    BuildContext context,
    AccessGrant grant, {
    required bool approve,
    required GrantRequestController controller,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GateWiseColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          approve ? 'Aprovar acesso' : 'Rejeitar solicitação',
          style: const TextStyle(
            color: GateWiseColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          approve
              ? 'Conceder acesso de "${grant.spaceName ?? 'espaço'}" para ${grant.authorizedUserName}?'
              : 'Rejeitar a solicitação de ${grant.authorizedUserName} para "${grant.spaceName ?? 'espaço'}"?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: approve
                  ? GateWiseColors.mint
                  : GateWiseColors.danger,
              foregroundColor: GateWiseColors.background,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(approve ? 'Aprovar' : 'Rejeitar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      if (approve) {
        controller.approveGrant(grant.id);
      } else {
        controller.rejectGrant(grant.id);
      }
    }
  }
}
