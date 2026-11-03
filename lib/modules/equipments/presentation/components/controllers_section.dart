import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../../organizations/presentation/components/status_panels.dart';
import '../../../spaces/presentation/components/space_ui_helpers.dart';
import '../../../spaces/presentation/space_providers.dart';
import '../../domain/entities/equipment_command_entity.dart';
import '../../domain/entities/space_controller_device_entity.dart';
import '../equipment_providers.dart';
import 'equipment_ui_helpers.dart';

/// Extra ESP32s of a space. The lock controller is not listed here: it is
/// the space's main device and stays highlighted on the space screen.
class ControllersSection extends ConsumerWidget {
  const ControllersSection({super.key, required this.spaceId});

  final int spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref
        .watch(spaceControllersProvider(spaceId))
        .whenData((items) => items.where((c) => !c.hasLock).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SectionTitle(context.l.controllersSection)),
            TextButton.icon(
              onPressed: () => _create(context, ref),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: Text(context.l.controllersAddButton),
            ),
          ],
        ),
        const SizedBox(height: 10),
        controllers.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: GateWiseColors.electricBlue,
                strokeWidth: 2.5,
              ),
            ),
          ),
          error: (error, _) => MessagePanel(
            icon: Icons.memory_rounded,
            title: context.l.controllersLoadError,
            message: equipmentErrorMessage(context, error),
            actionLabel: context.l.actionRetry,
            onAction: () => ref.invalidate(spaceControllersProvider(spaceId)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return MessagePanel(
                icon: Icons.memory_rounded,
                title: context.l.controllersEmpty,
                message: context.l.controllersEmptyMessage,
              );
            }
            return Column(
              children: [
                for (final controller in items)
                  _ControllerCard(
                    controller: controller,
                    onSelected: (action) =>
                        _onAction(context, ref, controller, action),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ControllerFormSheet(),
    );
    if (name == null || !context.mounted) return;

    final keys = await runEquipmentAction(
      context,
      () => ref
          .read(equipmentRepositoryProvider)
          .createController(spaceId, name: name, hasLock: false),
    );
    ref.invalidate(spaceControllersProvider(spaceId));
    if (keys == null || !context.mounted) return;
    _showKeys(context, keys);
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    SpaceControllerDevice controller,
    _ControllerAction action,
  ) async {
    final repository = ref.read(equipmentRepositoryProvider);
    switch (action) {
      case _ControllerAction.edit:
        final name = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _ControllerFormSheet(controller: controller),
        );
        if (name == null || !context.mounted) return;
        await runEquipmentAction(
          context,
          () => repository.updateController(
            spaceId,
            controller.id,
            name: name,
            hasLock: controller.hasLock,
          ),
          successMessage: context.l.controllerUpdated,
        );
      case _ControllerAction.rotateKeys:
        final confirmed = await confirmSpace(
          context,
          title: context.l.controllerRotateKeysTitle,
          message: context.l.controllerRotateKeysMessage(controller.name),
          confirmLabel: context.l.spaceProvisionConfirm,
        );
        if (!confirmed || !context.mounted) return;
        final keys = await runEquipmentAction(
          context,
          () => repository.rotateControllerKeys(spaceId, controller.id),
        );
        if (keys != null && context.mounted) _showKeys(context, keys);
      case _ControllerAction.delete:
        final confirmed = await confirmSpace(
          context,
          title: context.l.controllerDeleteTitle,
          message: context.l.controllerDeleteMessage(controller.name),
          confirmLabel: context.l.spaceDeleteConfirm,
          danger: true,
        );
        if (!confirmed || !context.mounted) return;
        await runEquipmentAction(
          context,
          () => repository.deleteController(spaceId, controller.id),
          successMessage: context.l.controllerDeleted,
        );
    }
    ref.invalidate(spaceControllersProvider(spaceId));
  }

  void _showKeys(BuildContext context, ControllerKeys keys) {
    context.push(
      '/spaces/$spaceId/provision',
      extra: DeviceProvisionResult(
        devicePrivateKeyPem: keys.devicePrivateKeyPem,
        backendPublicKeyPem: keys.backendPublicKeyPem,
        controllerId: keys.controllerId,
        mqttTopic: keys.mqttTopic,
      ),
    );
  }
}

enum _ControllerAction { edit, rotateKeys, delete }

class _ControllerCard extends StatelessWidget {
  const _ControllerCard({required this.controller, required this.onSelected});

  final SpaceControllerDevice controller;
  final ValueChanged<_ControllerAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final online =
        controller.lastSeenAt != null &&
        DateTime.now().difference(controller.lastSeenAt!.toLocal()) <
            const Duration(minutes: 10);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
        borderRadius: 18,
        opacity: 0.56,
        child: Row(
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
                  Text(
                    '${controller.name}  ·  #${controller.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: GateWiseColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (!controller.hasKeys)
                        TechStatusPill(
                          label: context.l.controllerNoKeysBadge,
                          icon: Icons.key_off_rounded,
                          color: GateWiseColors.amber,
                        ),
                      TechStatusPill(
                        label: formatLastSeen(context, controller.lastSeenAt),
                        icon: online
                            ? Icons.wifi_rounded
                            : Icons.wifi_off_rounded,
                        color: online
                            ? GateWiseColors.mint
                            : GateWiseColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<_ControllerAction>(
              color: GateWiseColors.surface,
              icon: const Icon(
                Icons.more_vert_rounded,
                color: GateWiseColors.textSecondary,
              ),
              onSelected: onSelected,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _ControllerAction.edit,
                  child: Text(context.l.actionEdit),
                ),
                PopupMenuItem(
                  value: _ControllerAction.rotateKeys,
                  child: Text(context.l.controllerRotateKeysAction),
                ),
                PopupMenuItem(
                  value: _ControllerAction.delete,
                  child: Text(
                    context.l.actionDelete,
                    style: const TextStyle(color: GateWiseColors.danger),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pops with the controller name.
class _ControllerFormSheet extends StatefulWidget {
  const _ControllerFormSheet({this.controller});

  final SpaceControllerDevice? controller;

  @override
  State<_ControllerFormSheet> createState() => _ControllerFormSheetState();
}

class _ControllerFormSheetState extends State<_ControllerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.controller != null;

    return SheetScaffold(
      title: isEditing
          ? context.l.controllerFormEditTitle
          : context.l.controllerFormNewTitle,
      subtitle: context.l.controllerFormSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: context.l.controllerFormNameLabel,
                hintText: context.l.controllerFormNameHint,
                prefixIcon: const Icon(Icons.memory_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l.formValidationName
                  : null,
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: isEditing
                  ? context.l.spaceFormSaveButton
                  : context.l.controllerFormCreateButton,
              icon: Icons.save_rounded,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(_nameController.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}
