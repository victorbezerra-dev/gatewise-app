import '../value_objects/equipment_enums.dart';
import 'air_conditioner_state_entity.dart';

class Equipment {
  const Equipment({
    required this.id,
    required this.spaceId,
    required this.controllerId,
    required this.controllerName,
    required this.name,
    required this.type,
    required this.isActive,
    this.protocol,
    this.model,
    this.modelName,
    this.airConditionerState,
    this.stateIssuedAt,
    this.stateUpdatedByUserName,
    this.minTemperature,
    this.maxTemperature,
    this.usageStart,
    this.usageEnd,
    required this.autoOffAtUsageEnd,
    required this.canControl,
    required this.canManage,
    this.buttons = const [],
    this.schedules = const [],
  });

  final int id;
  final int spaceId;
  final int controllerId;
  final String controllerName;
  final String name;
  final EquipmentType type;
  final bool isActive;
  final String? protocol;
  final int? model;
  final String? modelName;
  final AirConditionerState? airConditionerState;
  final DateTime? stateIssuedAt;
  final String? stateUpdatedByUserName;
  final double? minTemperature;
  final double? maxTemperature;
  final String? usageStart;
  final String? usageEnd;
  final bool autoOffAtUsageEnd;
  final bool canControl;
  final bool canManage;
  final List<EquipmentButton> buttons;
  final List<EquipmentSchedule> schedules;

  bool get isAirConditioner => type == EquipmentType.airConditioner;
  bool get hasUsageWindow => usageStart != null && usageEnd != null;

  /// The saved state, or — before the first command — the default state
  /// starting at the minimum temperature set on the equipment.
  AirConditionerState get airConditionerStateOrDefault =>
      airConditionerState ?? AirConditionerState(degrees: minTemperature ?? 23);

  Equipment withAirConditionerState(AirConditionerState state) {
    return Equipment(
      id: id,
      spaceId: spaceId,
      controllerId: controllerId,
      controllerName: controllerName,
      name: name,
      type: type,
      isActive: isActive,
      protocol: protocol,
      model: model,
      modelName: modelName,
      airConditionerState: state,
      stateIssuedAt: DateTime.now(),
      stateUpdatedByUserName: stateUpdatedByUserName,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      usageStart: usageStart,
      usageEnd: usageEnd,
      autoOffAtUsageEnd: autoOffAtUsageEnd,
      canControl: canControl,
      canManage: canManage,
      buttons: buttons,
      schedules: schedules,
    );
  }
}

class EquipmentButton {
  const EquipmentButton({
    required this.id,
    required this.name,
    this.icon,
    required this.sortOrder,
    required this.protocol,
  });

  final int id;
  final String name;
  final String? icon;
  final int sortOrder;
  final String protocol;
}

class EquipmentSchedule {
  const EquipmentSchedule({
    required this.id,
    required this.name,
    required this.isActive,
    required this.weekdays,
    required this.time,
    required this.action,
    this.airConditionerState,
    this.buttonId,
    this.lastRunAt,
  });

  final int id;
  final String name;
  final bool isActive;

  /// Dart weekday numbers (DateTime.monday … DateTime.sunday).
  final Set<int> weekdays;
  final String time;
  final EquipmentScheduleAction action;
  final AirConditionerState? airConditionerState;
  final int? buttonId;
  final DateTime? lastRunAt;
}
