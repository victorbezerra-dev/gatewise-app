import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../../modules/home/presentation/rsa_signing_service_provider.dart';
import '../../../modules/host/presentation/dialog_notifier.dart';
import '../../../modules/organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../../modules/organizations/presentation/components/status_panels.dart';
import '../../../modules/organizations/presentation/organization_providers.dart';
import '../domain/entities/space_entity.dart';
import '../infra/dtos/space_payload_dto.dart';
import 'components/device_section.dart';
import 'components/grants_section.dart';
import 'components/key_export_sheet.dart';
import 'components/member_space_body.dart';
import 'components/space_form_sheet.dart';
import 'components/space_header.dart';
import 'components/space_ui_helpers.dart';
import 'space_providers.dart';

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
        title: Text(context.l.spaceDetailsTitle),
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
                title: context.l.spaceDetailsErrorLoad,
                message: error.toString(),
                actionLabel: context.l.actionRetry,
                onAction: () => notifier.loadSpaceDetails(widget.spaceId),
              ),
            ),
            data: (space) {
              if (space == null) {
                return Padding(
                  padding: const EdgeInsets.all(18),
                  child: MessagePanel(
                    icon: Icons.sensor_door_rounded,
                    title: context.l.spaceDetailsNotFound,
                    message: context.l.spaceDetailsNotFoundMessage,
                  ),
                );
              }

              if (!_canManage) {
                return MemberSpaceBody(space: space);
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
                        onDelete: () =>
                            _confirmDelete(context, space, notifier),
                      ),
                      const SizedBox(height: 18),
                      DeviceSection(
                        space: space,
                        notifier: notifier,
                        onProvision: () => _provisionDevice(context, space),
                        onDownloadKey: () =>
                            _downloadBackendKey(context, notifier),
                      ),
                      const SizedBox(height: 18),
                      GrantsSection(
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
    showSpaceSnack(context, context.l.spaceUpdated);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Space space,
    SpaceController notifier,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.spaceDeleteTitle,
      message: context.l.spaceDeleteMessage(space.name),
      confirmLabel: context.l.spaceDeleteConfirm,
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
    showSpaceSnack(context, context.l.spaceDeleteSuccess);
    context.pop();
  }

  Future<void> _provisionDevice(BuildContext context, Space space) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.spaceProvisionTitle,
      message: context.l.spaceProvisionMessage(space.name),
      confirmLabel: context.l.spaceProvisionConfirm,
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
      builder: (_) =>
          KeyExportSheet(title: context.l.spaceBackendKeySheetTitle),
    );
    if (action == null || !context.mounted) return;

    final pem = await notifier.fetchBackendPublicKey();
    if (!context.mounted) return;
    if (pem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l.spaceBackendKeyError),
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
