import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../domain/entities/air_conditioner_state_entity.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/value_objects/equipment_enums.dart';
import '../../infra/dtos/equipment_dto.dart';
import 'equipment_ui_helpers.dart';

/// Pops with an [EquipmentSchedulePayload] ready to send.
class ScheduleFormSheet extends StatefulWidget {
  const ScheduleFormSheet({super.key, required this.equipment, this.schedule});

  final Equipment equipment;
  final EquipmentSchedule? schedule;

  @override
  State<ScheduleFormSheet> createState() => _ScheduleFormSheetState();
}

class _ScheduleFormSheetState extends State<ScheduleFormSheet> {
  late final TextEditingController _nameController;
  late Set<int> _weekdays;
  late TimeOfDay _time;
  late EquipmentScheduleAction _action;
  int? _buttonId;
  late AirConditionerState _airConditionerState;
  late bool _isActive;
  String? _error;

  List<EquipmentScheduleAction> get _actions =>
      widget.equipment.isAirConditioner
      ? const [
          EquipmentScheduleAction.turnOn,
          EquipmentScheduleAction.turnOff,
          EquipmentScheduleAction.pressButton,
        ]
      : const [EquipmentScheduleAction.pressButton];

  double get _minDegrees => widget.equipment.minTemperature ?? 16;

  // Never below the minimum, or clamp() throws (e.g. min 31 with no max).
  double get _maxDegrees =>
      math.max(widget.equipment.maxTemperature ?? 30, _minDegrees);

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    _nameController = TextEditingController(text: schedule?.name ?? '');
    _weekdays = {
      ...(schedule?.weekdays ??
          const {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
          }),
    };
    final parts = (schedule?.time ?? '07:00').split(':');
    _time = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 7,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    _action = schedule?.action ?? _actions.first;
    _buttonId = schedule?.buttonId;
    final initial =
        schedule?.airConditionerState ??
        widget.equipment.airConditionerStateOrDefault.copyWith(power: true);
    // Keep the temperature inside the equipment's range, as the slider does.
    _airConditionerState = initial.copyWith(
      degrees: initial.degrees.clamp(_minDegrees, _maxDegrees).toDouble(),
    );
    _isActive = schedule?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    final l = context.l;
    if (_weekdays.isEmpty) {
      setState(() => _error = l.scheduleFormDaysRequired);
      return;
    }
    if (_action == EquipmentScheduleAction.pressButton && _buttonId == null) {
      setState(() => _error = l.scheduleFormButtonRequired);
      return;
    }
    Navigator.of(context).pop(
      EquipmentSchedulePayload(
        name: _nameController.text.trim(),
        isActive: _isActive,
        weekdays: _weekdays,
        time: _formatTime(_time),
        action: _action,
        airConditionerState: _action == EquipmentScheduleAction.turnOn
            ? _airConditionerState.copyWith(power: true)
            : null,
        buttonId: _action == EquipmentScheduleAction.pressButton
            ? _buttonId
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final locale = Localizations.localeOf(context).toString();
    final firstMonday = DateTime(2024, 1, 1);
    final min = _minDegrees;
    final max = _maxDegrees;

    return SheetScaffold(
      title: widget.schedule == null
          ? l.scheduleFormNewTitle
          : l.scheduleFormEditTitle,
      subtitle: l.scheduleFormSubtitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: l.scheduleFormNameLabel,
              hintText: l.scheduleFormNameHint,
              prefixIcon: const Icon(Icons.label_rounded),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var weekday = 1; weekday <= 7; weekday++)
                FilterChip(
                  label: Text(
                    DateFormat.E(
                      locale,
                    ).format(firstMonday.add(Duration(days: weekday - 1))),
                  ),
                  selected: _weekdays.contains(weekday),
                  showCheckmark: false,
                  selectedColor: GateWiseColors.electricBlue.withValues(
                    alpha: 0.4,
                  ),
                  backgroundColor: GateWiseColors.surfaceLight.withValues(
                    alpha: 0.4,
                  ),
                  labelStyle: const TextStyle(
                    color: GateWiseColors.textPrimary,
                    fontSize: 12,
                  ),
                  onSelected: (selected) => setState(() {
                    selected
                        ? _weekdays.add(weekday)
                        : _weekdays.remove(weekday);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _pickTime,
            icon: const Icon(Icons.schedule_rounded, size: 17),
            label: Text('${l.scheduleFormTimeLabel} ${_formatTime(_time)}'),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<EquipmentScheduleAction>(
            initialValue: _action,
            isExpanded: true,
            dropdownColor: GateWiseColors.surface,
            decoration: InputDecoration(
              labelText: l.scheduleFormActionLabel,
              prefixIcon: const Icon(Icons.bolt_rounded),
            ),
            items: [
              for (final action in _actions)
                DropdownMenuItem(
                  value: action,
                  child: Text(action.label(context)),
                ),
            ],
            onChanged: (value) => setState(() => _action = value ?? _action),
          ),
          if (_action == EquipmentScheduleAction.pressButton) ...[
            const SizedBox(height: 14),
            if (widget.equipment.buttons.isEmpty)
              Text(
                l.scheduleFormNoButtons,
                style: const TextStyle(
                  color: GateWiseColors.amber,
                  fontSize: 12,
                ),
              )
            else
              DropdownButtonFormField<int>(
                initialValue: _buttonId,
                isExpanded: true,
                dropdownColor: GateWiseColors.surface,
                decoration: InputDecoration(
                  labelText: l.scheduleFormButtonLabel,
                  prefixIcon: const Icon(Icons.radio_button_checked_rounded),
                ),
                items: [
                  for (final button in widget.equipment.buttons)
                    DropdownMenuItem(
                      value: button.id,
                      child: Text(button.name),
                    ),
                ],
                onChanged: (value) => setState(() => _buttonId = value),
              ),
          ],
          if (_action == EquipmentScheduleAction.turnOn) ...[
            const SizedBox(height: 14),
            Text(
              l.scheduleFormTemperature(
                formatDegrees(_airConditionerState.degrees),
              ),
              style: const TextStyle(color: GateWiseColors.textPrimary),
            ),
            Slider(
              value: _airConditionerState.degrees.clamp(min, max),
              min: min,
              max: max,
              divisions: (max - min).round().clamp(1, 40),
              activeColor: GateWiseColors.neonCyan,
              onChanged: (value) => setState(
                () => _airConditionerState = _airConditionerState.copyWith(
                  degrees: value.roundToDouble(),
                ),
              ),
            ),
            DropdownButtonFormField<AirConditionerMode>(
              initialValue: _airConditionerState.mode,
              isExpanded: true,
              dropdownColor: GateWiseColors.surface,
              decoration: InputDecoration(
                labelText: l.airConditionerModeLabel,
                prefixIcon: Icon(_airConditionerState.mode.icon),
              ),
              items: [
                for (final mode in AirConditionerMode.values)
                  DropdownMenuItem(
                    value: mode,
                    child: Text(mode.label(context)),
                  ),
              ],
              onChanged: (value) => setState(
                () => _airConditionerState = _airConditionerState.copyWith(
                  mode: value,
                ),
              ),
            ),
          ],
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _isActive,
            activeThumbColor: GateWiseColors.mint,
            title: Text(
              l.scheduleFormActive,
              style: const TextStyle(color: GateWiseColors.textPrimary),
            ),
            onChanged: (value) => setState(() => _isActive = value),
          ),
          if (_error != null) ...[
            Text(
              _error!,
              style: const TextStyle(
                color: GateWiseColors.danger,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          NeonGradientButton(
            label: l.spaceFormSaveButton,
            icon: Icons.save_rounded,
            gradient: const [
              GateWiseColors.electricBlue,
              GateWiseColors.electricBlue,
            ],
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
