import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/air_conditioner_state_entity.dart';
import '../../domain/value_objects/equipment_enums.dart';
import 'control_buttons.dart';
import 'equipment_ui_helpers.dart';

class AirConditionerPanel extends StatelessWidget {
  const AirConditionerPanel({
    super.key,
    required this.state,
    required this.enabled,
    required this.sending,
    required this.onChanged,
    this.minTemperature,
    this.maxTemperature,
  });

  final AirConditionerState state;
  final bool enabled;
  final bool sending;
  final ValueChanged<AirConditionerState> onChanged;
  final double? minTemperature;
  final double? maxTemperature;

  double get _min => minTemperature ?? 16;
  double get _max => maxTemperature ?? 30;

  void _change(AirConditionerState next) {
    if (!enabled) return;
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final isOn = state.power;
    final accent = isOn ? GateWiseColors.mint : GateWiseColors.textMuted;
    // Controls stay usable while a command is in flight (the newest state
    // wins) and while it is off (adjustments are sent when it is turned on).
    final controlsEnabled = enabled;

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOn
                          ? context.l.airConditionerOn
                          : context.l.airConditionerOff,
                      style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.mode.label(context),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (sending)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: GateWiseColors.neonCyan,
                    ),
                  ),
                ),
              PowerButton(
                color: isOn ? GateWiseColors.mint : GateWiseColors.danger,
                enabled: enabled,
                onPressed: () => _change(state.copyWith(power: !isOn)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isOn ? 1 : 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: Icons.remove_rounded,
                      onPressed: controlsEnabled && state.degrees > _min
                          ? () => _change(
                              state.copyWith(degrees: state.degrees - 1),
                            )
                          : null,
                    ),
                    const SizedBox(width: 22),
                    Text(
                      '${formatDegrees(state.degrees)}°',
                      style: TextStyle(
                        color: isOn
                            ? GateWiseColors.textPrimary
                            : GateWiseColors.textMuted,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 22),
                    RoundIconButton(
                      icon: Icons.add_rounded,
                      onPressed: controlsEnabled && state.degrees < _max
                          ? () => _change(
                              state.copyWith(degrees: state.degrees + 1),
                            )
                          : null,
                    ),
                  ],
                ),
                if (minTemperature != null || maxTemperature != null)
                  Text(
                    context.l.airConditionerAllowedRange(
                      formatDegrees(_min),
                      formatDegrees(_max),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: GateWiseColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                const SizedBox(height: 18),
                _OptionLabel(context.l.airConditionerModeLabel),
                _ChoiceRow<AirConditionerMode>(
                  values: AirConditionerMode.values,
                  selected: state.mode,
                  enabled: controlsEnabled,
                  label: (mode) => mode.label(context),
                  icon: (mode) => mode.icon,
                  onSelected: (mode) => _change(state.copyWith(mode: mode)),
                ),
                const SizedBox(height: 14),
                _OptionLabel(context.l.airConditionerFanLabel),
                _ChoiceRow<AirConditionerFanSpeed>(
                  values: const [
                    AirConditionerFanSpeed.auto,
                    AirConditionerFanSpeed.low,
                    AirConditionerFanSpeed.medium,
                    AirConditionerFanSpeed.high,
                  ],
                  selected: state.fanSpeed,
                  enabled: controlsEnabled,
                  label: (speed) => speed.label(context),
                  onSelected: (speed) =>
                      _change(state.copyWith(fanSpeed: speed)),
                ),
                const SizedBox(height: 14),
                _OptionLabel(context.l.airConditionerSwingLabel),
                _ChoiceRow<AirConditionerSwingVertical>(
                  values: const [
                    AirConditionerSwingVertical.off,
                    AirConditionerSwingVertical.auto,
                    AirConditionerSwingVertical.low,
                    AirConditionerSwingVertical.middle,
                    AirConditionerSwingVertical.high,
                  ],
                  selected: state.swingVertical,
                  enabled: controlsEnabled,
                  label: (swing) => swing.label(context),
                  onSelected: (swing) =>
                      _change(state.copyWith(swingVertical: swing)),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ToggleChip(
                      label: context.l.airConditionerTurbo,
                      icon: Icons.bolt_rounded,
                      value: state.turbo,
                      enabled: controlsEnabled,
                      onChanged: (v) => _change(state.copyWith(turbo: v)),
                    ),
                    _ToggleChip(
                      label: context.l.airConditionerEcono,
                      icon: Icons.eco_rounded,
                      value: state.econo,
                      enabled: controlsEnabled,
                      onChanged: (v) => _change(state.copyWith(econo: v)),
                    ),
                    _ToggleChip(
                      label: context.l.airConditionerQuiet,
                      icon: Icons.volume_off_rounded,
                      value: state.quiet,
                      enabled: controlsEnabled,
                      onChanged: (v) => _change(state.copyWith(quiet: v)),
                    ),
                    _ToggleChip(
                      label: context.l.airConditionerLight,
                      icon: Icons.light_mode_rounded,
                      value: state.light,
                      enabled: controlsEnabled,
                      onChanged: (v) => _change(state.copyWith(light: v)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionLabel extends StatelessWidget {
  const _OptionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.62),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.values,
    required this.selected,
    required this.enabled,
    required this.label,
    required this.onSelected,
    this.icon,
  });

  final List<T> values;
  final T selected;
  final bool enabled;
  final String Function(T) label;
  final IconData Function(T)? icon;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          ChoiceChip(
            label: Text(label(value)),
            avatar: icon == null ? null : Icon(icon!(value), size: 16),
            selected: value == selected,
            selectedColor: GateWiseColors.electricBlue.withValues(alpha: 0.4),
            backgroundColor: GateWiseColors.surfaceLight.withValues(alpha: 0.4),
            labelStyle: const TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 12,
            ),
            showCheckmark: false,
            onSelected: enabled && value != selected
                ? (_) => onSelected(value)
                : null,
          ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: value,
      selectedColor: GateWiseColors.mint.withValues(alpha: 0.28),
      backgroundColor: GateWiseColors.surfaceLight.withValues(alpha: 0.4),
      labelStyle: const TextStyle(
        color: GateWiseColors.textPrimary,
        fontSize: 12,
      ),
      showCheckmark: false,
      onSelected: enabled ? onChanged : null,
    );
  }
}
