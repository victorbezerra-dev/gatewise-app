import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/gatewise_theme.dart';
import '../infra/dtos/organization_payload_dto.dart';
import 'components/organization_card.dart';
import 'components/status_panels.dart';
import 'organization_providers.dart';
import 'components/join_organization_sheet.dart';
import 'components/organization_form_sheet.dart';
import 'components/org_ui_helpers.dart';

class OrganizationsScreen extends ConsumerStatefulWidget {
  const OrganizationsScreen({super.key});

  @override
  ConsumerState<OrganizationsScreen> createState() =>
      _OrganizationsScreenState();
}

class _OrganizationsScreenState extends ConsumerState<OrganizationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(organizationControllerProvider.notifier).loadInitial(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizationControllerProvider);
    final notifier = ref.read(organizationControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          const PageTitle('Organizações'),
          const SizedBox(height: 4),
          Text(
            'Gerencie membros, convites e acessos.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.46),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: () => _openOrganizationForm(context, notifier),
                    style: FilledButton.styleFrom(
                      backgroundColor: GateWiseColors.electricBlue,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add_business_rounded, size: 18),
                    label: const Text('Nova organização'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () => _openJoinSheet(context, notifier),
                  icon: const Icon(Icons.key_rounded, size: 18),
                  label: const Text('Código'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: RefreshIndicator(
              color: GateWiseColors.electricBlue,
              backgroundColor: GateWiseColors.surface,
              onRefresh: notifier.loadInitial,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 122),
                children: [
                  const SectionTitle('Minhas organizações'),
                  const SizedBox(height: 10),
                  state.memberships.when(
                    loading: () => const LoadingPanel(),
                    error: (error, _) => MessagePanel(
                      icon: Icons.error_outline_rounded,
                      title: 'Erro ao carregar organizações',
                      message: error.toString(),
                      actionLabel: 'Tentar novamente',
                      onAction: notifier.loadMemberships,
                    ),
                    data: (memberships) {
                      if (memberships.isEmpty) {
                        return const MessagePanel(
                          icon: Icons.business_rounded,
                          title: 'Nenhuma organização encontrada',
                          message:
                              'Crie uma organização ou entre usando um código de convite.',
                        );
                      }

                      return Column(
                        children: memberships
                            .map(
                              (membership) => OrganizationCard(
                                organization: membership.organization,
                                role: membership.role,
                                subtitle:
                                    'Membro desde ${formatDate(membership.joinedAt)}',
                                onTap: () => context.push(
                                  '/organizations/${membership.organization.id}',
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  state.adminOrganizations.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (organizations) {
                      if (organizations.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          const SectionTitle('Todas as organizações (admin)'),
                          const SizedBox(height: 10),
                          ...organizations.map(
                            (organization) => OrganizationCard(
                              organization: organization,
                              subtitle: organization.isActive
                                  ? 'Organização ativa'
                                  : 'Organização inativa',
                              onTap: () => context.push(
                                '/organizations/${organization.id}',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOrganizationForm(
    BuildContext context,
    OrganizationController notifier,
  ) async {
    final payload = await showModalBottomSheet<OrganizationPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OrganizationFormSheet(),
    );
    if (payload == null) return;

    final organization = await notifier.createOrganization(payload);
    if (!context.mounted) return;
    if (organization == null) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Organização criada com sucesso.');
    context.push('/organizations/${organization.id}');
  }

  Future<void> _openJoinSheet(
    BuildContext context,
    OrganizationController notifier,
  ) async {
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JoinOrganizationSheet(),
    );
    if (code == null || code.trim().isEmpty) return;

    final organization = await notifier.joinByCode(code);
    if (!context.mounted) return;
    if (organization == null) {
      showActionError(context, ref);
      return;
    }
    showSnack(context, 'Você entrou em ${organization.name}.');
    context.push('/organizations/${organization.id}');
  }
}
