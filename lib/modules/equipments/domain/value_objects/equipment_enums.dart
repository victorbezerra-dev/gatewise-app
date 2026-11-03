import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

T _enumFromJson<T extends Enum>(List<T> values, dynamic value, T fallback) {
  if (value is String) {
    return values.firstWhere(
      (v) => v.name.toLowerCase() == value.toLowerCase(),
      orElse: () => fallback,
    );
  }
  if (value is int && value >= 0 && value < values.length) {
    return values[value];
  }
  return fallback;
}

String _apiName(Enum value) =>
    value.name[0].toUpperCase() + value.name.substring(1);

enum EquipmentType {
  airConditioner,
  tv,
  projector,
  fan,
  light,
  sound,
  screen,
  other;

  String get apiValue => _apiName(this);

  static EquipmentType fromJson(dynamic value) =>
      _enumFromJson(values, value, EquipmentType.other);

  IconData get icon {
    switch (this) {
      case EquipmentType.airConditioner:
        return Icons.ac_unit_rounded;
      case EquipmentType.tv:
        return Icons.tv_rounded;
      case EquipmentType.projector:
        return Icons.videocam_rounded;
      case EquipmentType.fan:
        return Icons.wind_power_rounded;
      case EquipmentType.light:
        return Icons.lightbulb_rounded;
      case EquipmentType.sound:
        return Icons.speaker_rounded;
      case EquipmentType.screen:
        return Icons.fit_screen_rounded;
      case EquipmentType.other:
        return Icons.settings_remote_rounded;
    }
  }

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case EquipmentType.airConditioner:
        return l.equipmentTypeAirConditioner;
      case EquipmentType.tv:
        return l.equipmentTypeTv;
      case EquipmentType.projector:
        return l.equipmentTypeProjector;
      case EquipmentType.fan:
        return l.equipmentTypeFan;
      case EquipmentType.light:
        return l.equipmentTypeLight;
      case EquipmentType.sound:
        return l.equipmentTypeSound;
      case EquipmentType.screen:
        return l.equipmentTypeScreen;
      case EquipmentType.other:
        return l.equipmentTypeOther;
    }
  }
}

enum AirConditionerMode {
  auto,
  cool,
  heat,
  dry,
  fan;

  String get apiValue => _apiName(this);

  static AirConditionerMode fromJson(dynamic value) =>
      _enumFromJson(values, value, AirConditionerMode.cool);

  IconData get icon {
    switch (this) {
      case AirConditionerMode.auto:
        return Icons.autorenew_rounded;
      case AirConditionerMode.cool:
        return Icons.ac_unit_rounded;
      case AirConditionerMode.heat:
        return Icons.wb_sunny_rounded;
      case AirConditionerMode.dry:
        return Icons.water_drop_rounded;
      case AirConditionerMode.fan:
        return Icons.air_rounded;
    }
  }

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case AirConditionerMode.auto:
        return l.airConditionerModeAuto;
      case AirConditionerMode.cool:
        return l.airConditionerModeCool;
      case AirConditionerMode.heat:
        return l.airConditionerModeHeat;
      case AirConditionerMode.dry:
        return l.airConditionerModeDry;
      case AirConditionerMode.fan:
        return l.airConditionerModeFan;
    }
  }
}

enum AirConditionerFanSpeed {
  auto,
  min,
  low,
  medium,
  high,
  max;

  String get apiValue => _apiName(this);

  static AirConditionerFanSpeed fromJson(dynamic value) =>
      _enumFromJson(values, value, AirConditionerFanSpeed.auto);

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case AirConditionerFanSpeed.auto:
        return l.airConditionerLevelAuto;
      case AirConditionerFanSpeed.min:
        return l.airConditionerFanMin;
      case AirConditionerFanSpeed.low:
        return l.airConditionerFanLow;
      case AirConditionerFanSpeed.medium:
        return l.airConditionerFanMedium;
      case AirConditionerFanSpeed.high:
        return l.airConditionerFanHigh;
      case AirConditionerFanSpeed.max:
        return l.airConditionerFanMax;
    }
  }
}

enum AirConditionerSwingVertical {
  off,
  auto,
  lowest,
  low,
  middle,
  high,
  highest;

  String get apiValue => _apiName(this);

  static AirConditionerSwingVertical fromJson(dynamic value) =>
      _enumFromJson(values, value, AirConditionerSwingVertical.auto);

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case AirConditionerSwingVertical.off:
        return l.airConditionerLevelOff;
      case AirConditionerSwingVertical.auto:
        return l.airConditionerLevelAuto;
      case AirConditionerSwingVertical.lowest:
        return l.airConditionerSwingLowest;
      case AirConditionerSwingVertical.low:
        return l.airConditionerSwingLow;
      case AirConditionerSwingVertical.middle:
        return l.airConditionerSwingMiddle;
      case AirConditionerSwingVertical.high:
        return l.airConditionerSwingHigh;
      case AirConditionerSwingVertical.highest:
        return l.airConditionerSwingHighest;
    }
  }
}

enum AirConditionerSwingHorizontal {
  off,
  auto,
  leftMax,
  left,
  middle,
  right,
  rightMax,
  wide;

  String get apiValue => _apiName(this);

  static AirConditionerSwingHorizontal fromJson(dynamic value) =>
      _enumFromJson(values, value, AirConditionerSwingHorizontal.off);

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case AirConditionerSwingHorizontal.off:
        return l.airConditionerLevelOff;
      case AirConditionerSwingHorizontal.auto:
        return l.airConditionerLevelAuto;
      case AirConditionerSwingHorizontal.leftMax:
        return l.airConditionerSwingLeftMax;
      case AirConditionerSwingHorizontal.left:
        return l.airConditionerSwingLeft;
      case AirConditionerSwingHorizontal.middle:
        return l.airConditionerSwingMiddle;
      case AirConditionerSwingHorizontal.right:
        return l.airConditionerSwingRight;
      case AirConditionerSwingHorizontal.rightMax:
        return l.airConditionerSwingRightMax;
      case AirConditionerSwingHorizontal.wide:
        return l.airConditionerSwingWide;
    }
  }
}

enum EquipmentScheduleAction {
  turnOn,
  turnOff,
  pressButton;

  String get apiValue => _apiName(this);

  static EquipmentScheduleAction fromJson(dynamic value) =>
      _enumFromJson(values, value, EquipmentScheduleAction.turnOff);

  String label(BuildContext context) {
    final l = context.l;
    switch (this) {
      case EquipmentScheduleAction.turnOn:
        return l.scheduleActionTurnOn;
      case EquipmentScheduleAction.turnOff:
        return l.scheduleActionTurnOff;
      case EquipmentScheduleAction.pressButton:
        return l.scheduleActionPressButton;
    }
  }
}

enum EquipmentCommandStatus {
  pendingConfirmation('PENDING_CONFIRMATION'),
  confirmed('CONFIRMED'),
  failed('FAILED'),
  noConfirmation('NO_CONFIRMATION');

  const EquipmentCommandStatus(this.apiValue);

  final String apiValue;

  static EquipmentCommandStatus fromJson(dynamic value) {
    if (value is String) {
      return values.firstWhere(
        (s) => s.apiValue == value.toUpperCase(),
        orElse: () => EquipmentCommandStatus.pendingConfirmation,
      );
    }
    if (value is int && value >= 0 && value < values.length) {
      return values[value];
    }
    return EquipmentCommandStatus.pendingConfirmation;
  }
}

/// Dart weekday numbering (Monday = 1 … Sunday = 7) mapped to the .NET
/// DayOfWeek names the API expects.
const weekdayApiNames = {
  DateTime.monday: 'Monday',
  DateTime.tuesday: 'Tuesday',
  DateTime.wednesday: 'Wednesday',
  DateTime.thursday: 'Thursday',
  DateTime.friday: 'Friday',
  DateTime.saturday: 'Saturday',
  DateTime.sunday: 'Sunday',
};

int? weekdayFromJson(dynamic value) {
  if (value is int) return value == 0 ? DateTime.sunday : value;
  if (value is String) {
    for (final entry in weekdayApiNames.entries) {
      if (entry.value.toLowerCase() == value.toLowerCase()) return entry.key;
    }
  }
  return null;
}
