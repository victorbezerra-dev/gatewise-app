import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../domain/entities/equipment_command_entity.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/value_objects/equipment_enums.dart';
import '../../infra/dtos/equipment_dto.dart';
import '../equipment_providers.dart';
import 'equipment_ui_helpers.dart';
import 'learn_signal_sheet.dart';

/// Creates or edits an equipment. Pops with the saved [Equipment] when
/// creating, or with `true` after a successful update.
class EquipmentFormSheet extends ConsumerStatefulWidget {
  const EquipmentFormSheet({super.key, required this.spaceId, this.equipment});

  final int spaceId;
  final Equipment? equipment;

  @override
  ConsumerState<EquipmentFormSheet> createState() => _EquipmentFormSheetState();
}

class _EquipmentFormSheetState extends ConsumerState<EquipmentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  late EquipmentType _type;
  int? _controllerId;
  String? _protocol;
  int? _model;
  LearnedSignal? _learned;
  String? _remotePresetId;
  late bool _isActive;
  late bool _hasUsageWindow;
  TimeOfDay _usageStart = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _usageEnd = const TimeOfDay(hour: 22, minute: 0);
  late bool _autoOff;
  bool _saving = false;

  bool get _isEditing => widget.equipment != null;

  @override
  void initState() {
    super.initState();
    final equipment = widget.equipment;
    _nameController = TextEditingController(text: equipment?.name ?? '');
    _minController = TextEditingController(
      text: equipment?.minTemperature == null
          ? ''
          : formatDegrees(equipment!.minTemperature!),
    );
    _maxController = TextEditingController(
      text: equipment?.maxTemperature == null
          ? ''
          : formatDegrees(equipment!.maxTemperature!),
    );
    _type = equipment?.type ?? EquipmentType.airConditioner;
    _controllerId = equipment?.controllerId;
    _protocol = equipment?.protocol;
    _model = equipment?.model;
    _isActive = equipment?.isActive ?? true;
    _hasUsageWindow = equipment?.hasUsageWindow ?? false;
    if (equipment?.usageStart != null) {
      _usageStart = _parseTime(equipment!.usageStart!);
    }
    if (equipment?.usageEnd != null) {
      _usageEnd = _parseTime(equipment!.usageEnd!);
    }
    _autoOff = equipment?.autoOffAtUsageEnd ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 0,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _usageStart : _usageEnd,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() => isStart ? _usageStart = picked : _usageEnd = picked);
  }

  Future<void> _learnFromRemote() async {
    final controllerId = _controllerId;
    if (controllerId == null) return;
    final signal = await showModalBottomSheet<LearnedSignal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LearnSignalSheet(
        spaceId: widget.spaceId,
        controllerId: controllerId,
        requireAirConditioner: true,
      ),
    );
    if (signal == null) return;
    setState(() {
      _learned = signal;
      _protocol = signal.capture.protocol;
      _model = signal.capture.model;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final isAirConditioner = _type == EquipmentType.airConditioner;

    final payload = EquipmentPayload(
      name: _nameController.text.trim(),
      type: _type,
      controllerId: _controllerId!,
      isActive: _isActive,
      protocol: isAirConditioner ? _protocol : null,
      model: isAirConditioner ? _model : null,
      fromLearnCommandId: isAirConditioner ? _learned?.commandId : null,
      remotePresetId: !isAirConditioner && !_isEditing ? _remotePresetId : null,
      minTemperature: isAirConditioner
          ? double.tryParse(_minController.text.replaceAll(',', '.'))
          : null,
      maxTemperature: isAirConditioner
          ? double.tryParse(_maxController.text.replaceAll(',', '.'))
          : null,
      usageStart: _hasUsageWindow ? _formatTime(_usageStart) : null,
      usageEnd: _hasUsageWindow ? _formatTime(_usageEnd) : null,
      autoOffAtUsageEnd: isAirConditioner && _hasUsageWindow && _autoOff,
    );

    setState(() => _saving = true);
    final repository = ref.read(equipmentRepositoryProvider);
    final result = await runEquipmentAction<Object>(context, () async {
      if (_isEditing) {
        await repository.updateEquipment(
          widget.spaceId,
          widget.equipment!.id,
          payload,
        );
        return true;
      }
      return repository.createEquipment(widget.spaceId, payload);
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(spaceControllersProvider(widget.spaceId));
    final remotes = ref.watch(irRemotesProvider).valueOrNull ?? const [];
    final isAirConditioner = _type == EquipmentType.airConditioner;
    final typeRemotes = remotes.where((r) => r.type == _type).toList();

    return SheetScaffold(
      title: _isEditing
          ? context.l.equipmentFormEditTitle
          : context.l.equipmentFormNewTitle,
      subtitle: context.l.equipmentFormSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: context.l.equipmentFormNameLabel,
                hintText: context.l.equipmentFormNameHint,
                prefixIcon: const Icon(Icons.label_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l.formValidationName
                  : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<EquipmentType>(
              initialValue: _type,
              isExpanded: true,
              dropdownColor: GateWiseColors.surface,
              decoration: InputDecoration(
                labelText: context.l.equipmentFormTypeLabel,
                prefixIcon: Icon(_type.icon),
              ),
              items: [
                // Without IR learning only types the app can control without
                // cloning are offered: air conditioners (by protocol) and types
                // with a brand remote in the catalog. Keep the current type
                // when editing.
                for (final type in EquipmentType.values)
                  if (irLearningEnabled ||
                      type == EquipmentType.airConditioner ||
                      remotes.any((r) => r.type == type) ||
                      type == widget.equipment?.type)
                    DropdownMenuItem(
                      value: type,
                      child: Text(type.label(context)),
                    ),
              ],
              onChanged: (value) => setState(() {
                _type = value ?? _type;
                _remotePresetId = null;
              }),
            ),
            if (!isAirConditioner && !_isEditing && typeRemotes.isNotEmpty) ...[
              const SizedBox(height: 14),
              _RemotePresetField(
                remotes: typeRemotes,
                value: _remotePresetId,
                required: !irLearningEnabled,
                onChanged: (value) => setState(() => _remotePresetId = value),
              ),
            ],
            const SizedBox(height: 14),
            controllers.when(
              loading: () =>
                  const LinearProgressIndicator(color: GateWiseColors.neonCyan),
              error: (error, _) => Text(
                equipmentErrorMessage(context, error),
                style: const TextStyle(color: GateWiseColors.danger),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: items.any((c) => c.id == _controllerId)
                    ? _controllerId
                    : null,
                isExpanded: true,
                dropdownColor: GateWiseColors.surface,
                decoration: InputDecoration(
                  labelText: context.l.equipmentFormControllerLabel,
                  helperText: items.isEmpty
                      ? context.l.equipmentFormNoControllers
                      : context.l.equipmentFormControllerHint,
                  helperMaxLines: 3,
                  prefixIcon: const Icon(Icons.memory_rounded),
                ),
                items: [
                  for (final controller in items)
                    DropdownMenuItem(
                      value: controller.id,
                      child: Text('${controller.name}  ·  #${controller.id}'),
                    ),
                ],
                validator: (value) => value == null
                    ? context.l.equipmentFormControllerRequired
                    : null,
                onChanged: (value) => setState(() => _controllerId = value),
              ),
            ),
            if (isAirConditioner) ...[
              const SizedBox(height: 18),
              _AirConditionerProtocolFields(
                protocol: _protocol,
                model: _model,
                learned: _learned,
                canLearn: _controllerId != null,
                onLearn: _learnFromRemote,
                onProtocolChanged: (value) => setState(() {
                  _protocol = value;
                  _model = null;
                  _learned = null;
                }),
                onModelChanged: (value) => setState(() => _model = value),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _TemperatureField(
                      controller: _minController,
                      label: context.l.equipmentFormMinTemperature,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TemperatureField(
                      controller: _maxController,
                      label: context.l.equipmentFormMaxTemperature,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _hasUsageWindow,
              activeThumbColor: GateWiseColors.mint,
              title: Text(
                context.l.equipmentFormUsageWindow,
                style: const TextStyle(color: GateWiseColors.textPrimary),
              ),
              subtitle: Text(
                context.l.equipmentFormUsageWindowHint,
                style: const TextStyle(
                  color: GateWiseColors.textMuted,
                  fontSize: 12,
                ),
              ),
              onChanged: (value) => setState(() => _hasUsageWindow = value),
            ),
            if (_hasUsageWindow) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(true),
                      icon: const Icon(Icons.schedule_rounded, size: 17),
                      label: Text(
                        '${context.l.equipmentFormUsageStart} ${_formatTime(_usageStart)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(false),
                      icon: const Icon(Icons.schedule_rounded, size: 17),
                      label: Text(
                        '${context.l.equipmentFormUsageEnd} ${_formatTime(_usageEnd)}',
                      ),
                    ),
                  ),
                ],
              ),
              if (isAirConditioner)
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _autoOff,
                  activeThumbColor: GateWiseColors.mint,
                  title: Text(
                    context.l.equipmentFormAutoOff,
                    style: const TextStyle(color: GateWiseColors.textPrimary),
                  ),
                  subtitle: Text(
                    context.l.equipmentFormAutoOffHint,
                    style: const TextStyle(
                      color: GateWiseColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (value) => setState(() => _autoOff = value),
                ),
            ],
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _isActive,
              activeThumbColor: GateWiseColors.mint,
              title: Text(
                context.l.equipmentFormActive,
                style: const TextStyle(color: GateWiseColors.textPrimary),
              ),
              subtitle: Text(
                context.l.equipmentFormActiveHint,
                style: const TextStyle(
                  color: GateWiseColors.textMuted,
                  fontSize: 12,
                ),
              ),
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: context.l.spaceFormSaveButton,
              icon: Icons.save_rounded,
              isLoading: _saving,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _AirConditionerProtocolFields extends ConsumerWidget {
  const _AirConditionerProtocolFields({
    required this.protocol,
    required this.model,
    required this.learned,
    required this.canLearn,
    required this.onLearn,
    required this.onProtocolChanged,
    required this.onModelChanged,
  });

  final String? protocol;
  final int? model;
  final LearnedSignal? learned;
  final bool canLearn;
  final VoidCallback onLearn;
  final ValueChanged<String?> onProtocolChanged;
  final ValueChanged<int?> onModelChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocols = ref.watch(airConditionerProtocolsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l.equipmentFormProtocolTitle,
          style: const TextStyle(
            color: GateWiseColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (irLearningEnabled) ...[
          const SizedBox(height: 4),
          Text(
            context.l.equipmentFormProtocolHint,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.52),
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: canLearn ? onLearn : null,
            icon: Icon(
              learned == null
                  ? Icons.settings_remote_rounded
                  : Icons.check_circle_rounded,
              size: 17,
            ),
            label: Text(
              learned == null
                  ? context.l.equipmentFormLearnButton
                  : context.l.equipmentFormLearned(learned!.capture.protocol),
            ),
          ),
        ],
        const SizedBox(height: 12),
        protocols.when(
          loading: () =>
              const LinearProgressIndicator(color: GateWiseColors.neonCyan),
          error: (error, _) => Text(
            equipmentErrorMessage(context, error),
            style: const TextStyle(color: GateWiseColors.danger),
          ),
          data: (items) {
            final selected = items
                .where((p) => p.protocol == protocol)
                .cast<AirConditionerProtocol?>()
                .firstOrNull;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey('protocol-${selected?.protocol}'),
                  initialValue: selected?.protocol,
                  isExpanded: true,
                  dropdownColor: GateWiseColors.surface,
                  menuMaxHeight: 420,
                  decoration: InputDecoration(
                    labelText: context.l.equipmentFormProtocolLabel,
                    prefixIcon: const Icon(Icons.ac_unit_rounded),
                  ),
                  items: [
                    for (final item in items)
                      DropdownMenuItem(
                        value: item.protocol,
                        child: Text(
                          item.displayName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  validator: (value) => value == null
                      ? context.l.equipmentFormProtocolRequired
                      : null,
                  onChanged: onProtocolChanged,
                ),
                if (selected != null && selected.models.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    key: ValueKey('model-${selected.protocol}-$model'),
                    initialValue: selected.models.any((m) => m.value == model)
                        ? model
                        : null,
                    isExpanded: true,
                    dropdownColor: GateWiseColors.surface,
                    decoration: InputDecoration(
                      labelText: context.l.equipmentFormModelLabel,
                      prefixIcon: const Icon(Icons.tune_rounded),
                    ),
                    items: [
                      for (final item in selected.models)
                        DropdownMenuItem(
                          value: item.value,
                          child: Text(item.name),
                        ),
                    ],
                    onChanged: onModelChanged,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RemotePresetField extends StatelessWidget {
  const _RemotePresetField({
    required this.remotes,
    required this.value,
    required this.required,
    required this.onChanged,
  });

  final List<IrRemotePreset> remotes;
  final String? value;
  final bool required;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = remotes.where((r) => r.id == value).firstOrNull;
    return DropdownButtonFormField<String>(
      initialValue: selected?.id,
      isExpanded: true,
      dropdownColor: GateWiseColors.surface,
      decoration: InputDecoration(
        labelText: context.l.equipmentFormRemoteLabel,
        helperText: selected == null
            ? context.l.equipmentFormRemoteHint
            : context.l.equipmentFormRemoteButtons(selected.buttonCount),
        helperMaxLines: 3,
        prefixIcon: const Icon(Icons.settings_remote_rounded),
      ),
      items: [
        if (!required)
          DropdownMenuItem(
            value: null,
            child: Text(context.l.equipmentFormRemoteNone),
          ),
        for (final remote in remotes)
          DropdownMenuItem(value: remote.id, child: Text(remote.label)),
      ],
      validator: (value) => required && value == null
          ? context.l.equipmentFormRemoteRequired
          : null,
      onChanged: onChanged,
    );
  }
}

class _TemperatureField extends StatelessWidget {
  const _TemperatureField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: '°C'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed == null || parsed < 10 || parsed > 35) {
          return context.l.equipmentFormTemperatureInvalid;
        }
        return null;
      },
    );
  }
}
