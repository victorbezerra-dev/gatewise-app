import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../modules/organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../../../modules/organizations/presentation/components/status_panels.dart';
import '../../../../modules/organizations/presentation/organization_providers.dart';
import '../../domain/entities/access_grant_entity.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/value_objects/access_grant_status_vo.dart';
import '../../infra/dtos/access_grant_dto.dart';
import '../space_providers.dart';
import 'access_grant_card.dart';
import 'request_access_sheet.dart';
import 'space_ui_helpers.dart';

class GrantsSection extends StatelessWidget {
  const GrantsSection({
    super.key,
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
    final canRequestAccess =
        viewerRole == null || viewerRole == OrganizationMemberRole.member;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SectionTitle(context.l.spaceGrantsSection)),
            if (canRequestAccess)
              TextButton.icon(
                onPressed: () =>
                    _openRequestAccess(parentContext, space, notifier),
                icon: const Icon(Icons.add_rounded, size: 17),
                label: Text(context.l.spaceGrantsRequestButton),
              ),
          ],
        ),
        const SizedBox(height: 10),
        state.grants.when(
          loading: () => const LoadingPanel(),
          error: (error, _) => MessagePanel(
            icon: Icons.lock_outline_rounded,
            title: context.l.spaceGrantsUnavailable,
            message: error.toString(),
          ),
          data: (grants) {
            if (grants.isEmpty) {
              return MessagePanel(
                icon: Icons.how_to_reg_rounded,
                title: context.l.spaceGrantsNone,
                message: context.l.spaceGrantsNoneMessage,
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
            context.l.spaceGrantsCannotSend,
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, context.l.spaceGrantsSentSuccess);
  }

  Future<void> _confirmApprove(
    BuildContext context,
    AccessGrant grant,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.spaceGrantsApproveTitle,
      message: context.l.spaceGrantsApproveMessage(grant.authorizedUserName),
      confirmLabel: context.l.spaceGrantsApproveConfirm,
    );
    if (!confirmed) return;

    final ok = await notifier.approveGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            context.l.spaceGrantsCannotApprove,
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, context.l.spaceGrantsApproveSuccess);
  }

  Future<void> _confirmReject(
    BuildContext context,
    AccessGrant grant,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.spaceGrantsRejectTitle,
      message: context.l.spaceGrantsRejectMessage(grant.authorizedUserName),
      confirmLabel: context.l.spaceGrantsRejectConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.rejectGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            context.l.spaceGrantsCannotReject,
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, context.l.spaceGrantsRejectSuccess);
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
        ? context.l.spaceGrantsDeleteMessage(grant.authorizedUserName)
        : context.l.spaceGrantsDeleteMessageLast(grant.authorizedUserName);

    final confirmed = await confirmSpace(
      context,
      title: context.l.spaceGrantsDeleteTitle,
      message: message,
      confirmLabel: context.l.spaceGrantsDeleteConfirm,
      danger: true,
    );
    if (!confirmed) return;

    final ok = await notifier.deleteGrant(grant.id, space.id);
    if (!context.mounted) return;
    if (!ok) {
      showSpaceSnack(
        context,
        parentRef.read(spaceControllerProvider).actionErrorMessage ??
            context.l.spaceGrantsCannotRemove,
        isError: true,
      );
      return;
    }
    showSpaceSnack(context, context.l.spaceGrantsDeleteSuccess);
  }
}
