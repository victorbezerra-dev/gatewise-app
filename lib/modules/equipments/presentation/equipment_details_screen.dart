import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../organizations/presentation/components/status_panels.dart';
import '../../spaces/presentation/components/space_ui_helpers.dart';
import '../domain/entities/air_conditioner_state_entity.dart';
import '../domain/entities/equipment_entity.dart';
import '../domain/value_objects/equipment_enums.dart';
import '../infra/dtos/equipment_dto.dart';
import 'components/air_conditioner_panel.dart';
import 'components/button_form_sheet.dart';
import 'components/equipment_form_sheet.dart';
import 'components/equipment_history.dart';
import 'components/equipment_ui_helpers.dart';
import 'components/learn_signal_sheet.dart';
import 'components/remote_control_panel.dart';
import 'components/schedule_form_sheet.dart';
import 'equipment_providers.dart';

class EquipmentDetailsScreen extends ConsumerStatefulWidget {
  const EquipmentDetailsScreen({
    super.key,
    required this.spaceId,
    required this.equipmentId,
  });

  final int spaceId;
  final int equipmentId;

  @override
  ConsumerState<EquipmentDetailsScreen> createState() =>
      _EquipmentDetailsScreenState();
}

class _EquipmentDetailsScreenState
    extends ConsumerState<EquipmentDetailsScreen> {
  bool _sending = false;

  /// Button presses waiting for the controller. Presses never block the
  /// remote, so volume can be tapped several times in a row.
  int _pendingPresses = 0;

  /// State shown while it is not confirmed by the controller: changes the user
  /// made (sent or waiting for the debounce), or adjustments made while the
  /// air conditioner is off, which are only sent when it is turned on.
  AirConditionerState? _draftState;
  Timer? _sendTimer;

  /// Increases on every send; results of older sends are ignored.
  int _sendSeq = 0;

  EquipmentKey get _key =>
      (spaceId: widget.spaceId, equipmentId: widget.equipmentId);

  @override
  void dispose() {
    _sendTimer?.cancel();
    super.dispose();
  }

  void _reload() {
    ref.invalidate(equipmentProvider(_key));
    ref.invalidate(equipmentHistoryProvider(_key));
  }

  void _changeAirConditioner(
    AirConditionerState current,
    AirConditionerState next,
  ) {
    _sendTimer?.cancel();
    setState(() => _draftState = next);

    // While it is off, keep the adjustments locally; turning it on sends them.
    if (!current.power && !next.power) return;

    // Power is sent at once; other changes wait so quick taps (+ + +) become
    // a single command with the final state.
    _sendTimer = Timer(
      current.power != next.power
          ? Duration.zero
          : const Duration(milliseconds: 600),
      () => _sendAirConditionerState(next),
    );
  }

  Future<void> _sendAirConditionerState(AirConditionerState state) async {
    final seq = ++_sendSeq;
    setState(() => _sending = true);

    final commandId = await runEquipmentAction(
      context,
      () => ref
          .read(equipmentRepositoryProvider)
          .sendAirConditionerState(widget.spaceId, widget.equipmentId, state),
    );
    if (!mounted || seq != _sendSeq) return;
    if (commandId == null) {
      setState(() {
        _sending = false;
        _draftState = null;
      });
      return;
    }

    final event = await waitForEquipmentCommand(
      ref,
      commandId,
      kind: EquipmentEventKind.result,
    );
    if (!mounted || seq != _sendSeq) return;
    if (event.status != 'ok') _showCommandResult(event);

    // Keep the draft on screen until the confirmed state is loaded, so the
    // panel does not flash back to the previous state.
    ref.invalidate(equipmentHistoryProvider(_key));
    ref.invalidate(equipmentProvider(_key));
    try {
      await ref.read(equipmentProvider(_key).future);
    } catch (_) {}
    if (!mounted || seq != _sendSeq) return;
    setState(() {
      _sending = false;
      _draftState = null;
    });
  }

  Future<void> _pressButton(EquipmentButton button) async {
    HapticFeedback.selectionClick();
    setState(() => _pendingPresses++);
    final commandId = await runEquipmentAction(
      context,
      () => ref
          .read(equipmentRepositoryProvider)
          .pressButton(widget.spaceId, widget.equipmentId, button.id),
    );
    if (commandId != null && mounted) {
      final event = await waitForEquipmentCommand(
        ref,
        commandId,
        kind: EquipmentEventKind.result,
      );
      if (mounted && event.status != 'ok') _showCommandResult(event);
    }
    if (mounted) setState(() => _pendingPresses--);
  }

  void _showCommandResult(EquipmentEvent event) {
    final l = context.l;
    switch (event.status) {
      case 'ok':
        showSpaceSnack(context, l.equipmentCommandOk);
      case 'timeout':
        showSpaceSnack(context, l.equipmentCommandTimeout, isError: true);
      default:
        showSpaceSnack(
          context,
          event.error?.isNotEmpty == true
              ? l.equipmentCommandFailedReason(event.error!)
              : l.equipmentCommandFailed,
          isError: true,
        );
    }
  }

  Future<void> _edit(Equipment equipment) async {
    final saved = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          EquipmentFormSheet(spaceId: widget.spaceId, equipment: equipment),
    );
    if (saved != null && mounted) {
      showSpaceSnack(context, context.l.equipmentUpdated);
      _reload();
    }
  }

  Future<void> _delete(Equipment equipment) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.equipmentDeleteTitle,
      message: context.l.equipmentDeleteMessage(equipment.name),
      confirmLabel: context.l.spaceDeleteConfirm,
      danger: true,
    );
    if (!confirmed || !mounted) return;
    final ok = await runEquipmentAction(context, () async {
      await ref
          .read(equipmentRepositoryProvider)
          .deleteEquipment(widget.spaceId, equipment.id);
      return true;
    });
    if (ok == true && mounted) {
      showSpaceSnack(context, context.l.equipmentDeleted);
      context.pop();
    }
  }

  Future<void> _addButton(Equipment equipment) async {
    final signal = await showModalBottomSheet<LearnedSignal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LearnSignalSheet(
        spaceId: widget.spaceId,
        controllerId: equipment.controllerId,
      ),
    );
    if (signal == null || !mounted) return;

    final details = await showModalBottomSheet<ButtonFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ButtonFormSheet(),
    );
    if (details == null || !mounted) return;

    await runEquipmentAction(
      context,
      () => ref
          .read(equipmentRepositoryProvider)
          .createButton(
            widget.spaceId,
            equipment.id,
            EquipmentButtonPayload(
              name: details.name,
              icon: details.icon,
              sortOrder: equipment.buttons.length,
              fromLearnCommandId: signal.commandId,
            ),
          ),
      successMessage: context.l.buttonCreated,
    );
    _reload();
  }

  Future<void> _manageButton(
    Equipment equipment,
    EquipmentButton button,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: GateWiseColors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text(context.l.actionEdit),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                color: GateWiseColors.danger,
              ),
              title: Text(
                context.l.actionDelete,
                style: const TextStyle(color: GateWiseColors.danger),
              ),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    final repository = ref.read(equipmentRepositoryProvider);

    if (action == 'edit') {
      final details = await showModalBottomSheet<ButtonFormResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ButtonFormSheet(button: button),
      );
      if (details == null || !mounted) return;
      await runEquipmentAction(
        context,
        () => repository.updateButton(
          widget.spaceId,
          equipment.id,
          button.id,
          EquipmentButtonPayload(
            name: details.name,
            icon: details.icon,
            sortOrder: button.sortOrder,
          ),
        ),
      );
    } else {
      final confirmed = await confirmSpace(
        context,
        title: context.l.buttonDeleteTitle,
        message: context.l.buttonDeleteMessage(button.name),
        confirmLabel: context.l.spaceDeleteConfirm,
        danger: true,
      );
      if (!confirmed || !mounted) return;
      await runEquipmentAction(
        context,
        () => repository.deleteButton(widget.spaceId, equipment.id, button.id),
      );
    }
    _reload();
  }

  Future<void> _editSchedule(
    Equipment equipment, [
    EquipmentSchedule? schedule,
  ]) async {
    final payload = await showModalBottomSheet<EquipmentSchedulePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ScheduleFormSheet(equipment: equipment, schedule: schedule),
    );
    if (payload == null || !mounted) return;
    final repository = ref.read(equipmentRepositoryProvider);
    await runEquipmentAction(
      context,
      () => schedule == null
          ? repository.createSchedule(widget.spaceId, equipment.id, payload)
          : repository.updateSchedule(
              widget.spaceId,
              equipment.id,
              schedule.id,
              payload,
            ),
      successMessage: context.l.scheduleSaved,
    );
    _reload();
  }

  Future<void> _deleteSchedule(
    Equipment equipment,
    EquipmentSchedule schedule,
  ) async {
    final confirmed = await confirmSpace(
      context,
      title: context.l.scheduleDeleteTitle,
      message: context.l.scheduleDeleteMessage,
      confirmLabel: context.l.spaceDeleteConfirm,
      danger: true,
    );
    if (!confirmed || !mounted) return;
    await runEquipmentAction(
      context,
      () => ref
          .read(equipmentRepositoryProvider)
          .deleteSchedule(widget.spaceId, equipment.id, schedule.id),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final equipment = ref.watch(equipmentProvider(_key));

    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: Text(
          equipment.valueOrNull?.name ?? context.l.equipmentDetailsTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (equipment.valueOrNull?.canManage == true)
            PopupMenuButton<String>(
              color: GateWiseColors.surface,
              onSelected: (value) => value == 'edit'
                  ? _edit(equipment.value!)
                  : _delete(equipment.value!),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(context.l.actionEdit)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    context.l.actionDelete,
                    style: const TextStyle(color: GateWiseColors.danger),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: TechBackground(
        child: SafeArea(
          top: false,
          child: equipment.when(
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
                title: context.l.equipmentLoadError,
                message: equipmentErrorMessage(context, error),
                actionLabel: context.l.actionRetry,
                onAction: _reload,
              ),
            ),
            data: (item) => RefreshIndicator(
              color: GateWiseColors.electricBlue,
              backgroundColor: GateWiseColors.surface,
              onRefresh: () async => _reload(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: _buildContent(context, item),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, Equipment equipment) {
    final l = context.l;
    final infoLines = <String>[
      equipment.type.label(context),
      if (equipment.modelName != null || equipment.protocol != null)
        equipment.modelName ?? equipment.protocol!,
      if (equipment.hasUsageWindow)
        l.equipmentUsageWindow(equipment.usageStart!, equipment.usageEnd!),
      if (equipment.canManage)
        l.equipmentControllerInfo(equipment.controllerName),
    ];

    return [
      Text(
        infoLines.join('  ·  '),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.55),
          fontSize: 12,
          height: 1.4,
        ),
      ),
      if (!equipment.isActive) ...[
        const SizedBox(height: 10),
        TechStatusPill(
          label: l.equipmentInactiveBadge,
          icon: Icons.pause_circle_outline_rounded,
          color: GateWiseColors.amber,
        ),
      ],
      if (!equipment.canControl) ...[
        const SizedBox(height: 12),
        MessagePanel(
          icon: Icons.lock_outline_rounded,
          title: l.equipmentNoControlTitle,
          message: l.equipmentNoControlMessage,
        ),
      ],
      const SizedBox(height: 16),
      if (equipment.isAirConditioner) ...[
        Builder(
          builder: (context) {
            final current =
                _draftState ?? equipment.airConditionerStateOrDefault;
            // The default (or last) temperature may be outside the range set
            // later on the equipment; the backend rejects those commands.
            final degrees = current.degrees
                .clamp(
                  equipment.minTemperature ?? double.negativeInfinity,
                  equipment.maxTemperature ?? double.infinity,
                )
                .toDouble();
            final state = degrees == current.degrees
                ? current
                : current.copyWith(degrees: degrees);
            return AirConditionerPanel(
              state: state,
              enabled: equipment.canControl,
              sending: _sending,
              minTemperature: equipment.minTemperature,
              maxTemperature: equipment.maxTemperature,
              onChanged: (next) => _changeAirConditioner(state, next),
            );
          },
        ),
        if (equipment.stateIssuedAt != null &&
            equipment.stateUpdatedByUserName != null) ...[
          const SizedBox(height: 8),
          Text(
            l.equipmentLastChange(
              equipment.stateUpdatedByUserName!,
              formatSpaceDate(context, equipment.stateIssuedAt),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: GateWiseColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
        const SizedBox(height: 22),
      ],
      if (equipment.buttons.isNotEmpty ||
          (equipment.canManage && irLearningEnabled)) ...[
        // The remote panel has its own title; the header is only needed for
        // the add button or the empty state.
        if (equipment.buttons.isEmpty ||
            (equipment.canManage && irLearningEnabled)) ...[
          Row(
            children: [
              Expanded(child: SectionTitle(l.buttonsSection)),
              if (equipment.canManage && irLearningEnabled)
                TextButton.icon(
                  onPressed: () => _addButton(equipment),
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: Text(l.buttonsAddButton),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        if (equipment.buttons.isEmpty)
          MessagePanel(
            icon: Icons.settings_remote_rounded,
            title: l.buttonsEmpty,
            message: l.buttonsEmptyMessage,
          )
        else
          RemoteControlPanel(
            buttons: equipment.buttons,
            enabled: equipment.canControl,
            sending: _pendingPresses > 0,
            onPressed: _pressButton,
            onLongPress: equipment.canManage
                ? (button) => _manageButton(equipment, button)
                : null,
          ),
        const SizedBox(height: 22),
      ],
      if (equipment.canManage) ...[
        Row(
          children: [
            Expanded(child: SectionTitle(l.schedulesSection)),
            TextButton.icon(
              onPressed: () => _editSchedule(equipment),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: Text(l.schedulesAddButton),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (equipment.schedules.isEmpty)
          MessagePanel(
            icon: Icons.event_repeat_rounded,
            title: l.schedulesEmpty,
            message: l.schedulesEmptyMessage,
          )
        else
          for (final schedule in equipment.schedules)
            _ScheduleCard(
              schedule: schedule,
              equipment: equipment,
              onTap: () => _editSchedule(equipment, schedule),
              onDelete: () => _deleteSchedule(equipment, schedule),
            ),
        const SizedBox(height: 22),
        EquipmentHistorySection(equipment: equipment, equipmentKey: _key),
      ],
    ];
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.schedule,
    required this.equipment,
    required this.onTap,
    required this.onDelete,
  });

  final EquipmentSchedule schedule;
  final Equipment equipment;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final buttonName = equipment.buttons
        .where((b) => b.id == schedule.buttonId)
        .map((b) => b.name)
        .firstOrNull;
    final action = switch (schedule.action) {
      EquipmentScheduleAction.turnOn
          when schedule.airConditionerState != null =>
        l.scheduleTurnOnAt(
          formatDegrees(schedule.airConditionerState!.degrees),
        ),
      EquipmentScheduleAction.pressButton when buttonName != null =>
        l.schedulePress(buttonName),
      _ => schedule.action.label(context),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: GlassPanel(
            padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
            borderRadius: 18,
            opacity: 0.56,
            child: Row(
              children: [
                Text(
                  schedule.time,
                  style: TextStyle(
                    color: schedule.isActive
                        ? GateWiseColors.textPrimary
                        : GateWiseColors.textMuted,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.name.isEmpty ? action : schedule.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [
                          if (schedule.name.isNotEmpty) action,
                          _weekdaysLabel(context, schedule.weekdays),
                          if (!schedule.isActive) l.scheduleInactive,
                        ].join('  ·  '),
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: GateWiseColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _weekdaysLabel(BuildContext context, Set<int> weekdays) {
    final l = context.l;
    if (weekdays.length == 7) return l.scheduleEveryDay;
    if (weekdays.length == 5 &&
        !weekdays.contains(DateTime.saturday) &&
        !weekdays.contains(DateTime.sunday)) {
      return l.scheduleWeekdays;
    }
    final names = MaterialLocalizations.of(context).narrowWeekdays;
    final sorted = weekdays.toList()..sort();
    return sorted.map((d) => names[d % 7]).join(' ');
  }
}
