import '../../domain/entities/air_conditioner_state_entity.dart';
import '../../domain/entities/equipment_command_entity.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/entities/space_controller_device_entity.dart';
import '../../domain/value_objects/equipment_enums.dart';

double? _toDouble(dynamic value) => (value as num?)?.toDouble();

DateTime? _toDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? value.cast<String, dynamic>() : null;

class AirConditionerStateDto {
  static AirConditionerState? fromJson(dynamic value) {
    final json = _asMap(value);
    if (json == null) return null;
    return AirConditionerState(
      power: json['power'] == true,
      mode: AirConditionerMode.fromJson(json['mode']),
      degrees: _toDouble(json['degrees']) ?? 23,
      fanSpeed: AirConditionerFanSpeed.fromJson(json['fanSpeed']),
      swingVertical: AirConditionerSwingVertical.fromJson(
        json['swingVertical'],
      ),
      swingHorizontal: AirConditionerSwingHorizontal.fromJson(
        json['swingHorizontal'],
      ),
      turbo: json['turbo'] == true,
      econo: json['econo'] == true,
      quiet: json['quiet'] == true,
      light: json['light'] != false,
      clean: json['clean'] == true,
      filter: json['filter'] == true,
      beep: json['beep'] != false,
      sleep: (json['sleep'] as num?)?.toInt() ?? -1,
    );
  }

  static Map<String, dynamic> toJson(AirConditionerState state) => {
    'power': state.power,
    'mode': state.mode.apiValue,
    'degrees': state.degrees,
    'fanSpeed': state.fanSpeed.apiValue,
    'swingVertical': state.swingVertical.apiValue,
    'swingHorizontal': state.swingHorizontal.apiValue,
    'turbo': state.turbo,
    'econo': state.econo,
    'quiet': state.quiet,
    'light': state.light,
    'clean': state.clean,
    'filter': state.filter,
    'beep': state.beep,
    'sleep': state.sleep,
  };
}

class EquipmentDto {
  static Equipment fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      spaceId: (json['spaceId'] as num?)?.toInt() ?? 0,
      controllerId: (json['controllerId'] as num?)?.toInt() ?? 0,
      controllerName: json['controllerName']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: EquipmentType.fromJson(json['type']),
      isActive: json['isActive'] != false,
      protocol: json['protocol']?.toString(),
      model: (json['model'] as num?)?.toInt(),
      modelName: json['modelName']?.toString(),
      airConditionerState: AirConditionerStateDto.fromJson(
        json['airConditionerState'],
      ),
      stateIssuedAt: _toDate(json['stateIssuedAt']),
      stateUpdatedByUserName: json['stateUpdatedByUserName']?.toString(),
      minTemperature: _toDouble(json['minTemperature']),
      maxTemperature: _toDouble(json['maxTemperature']),
      usageStart: json['usageStart']?.toString(),
      usageEnd: json['usageEnd']?.toString(),
      autoOffAtUsageEnd: json['autoOffAtUsageEnd'] == true,
      canControl: json['canControl'] == true,
      canManage: json['canManage'] == true,
      buttons: ((json['buttons'] as List?) ?? const [])
          .map((b) => EquipmentButtonDto.fromJson(_asMap(b)!))
          .toList(),
      schedules: ((json['schedules'] as List?) ?? const [])
          .map((s) => EquipmentScheduleDto.fromJson(_asMap(s)!))
          .toList(),
    );
  }
}

class EquipmentButtonDto {
  static EquipmentButton fromJson(Map<String, dynamic> json) {
    return EquipmentButton(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      protocol: json['protocol']?.toString() ?? '',
    );
  }
}

class EquipmentScheduleDto {
  static EquipmentSchedule fromJson(Map<String, dynamic> json) {
    return EquipmentSchedule(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      isActive: json['isActive'] != false,
      weekdays: ((json['daysOfWeek'] as List?) ?? const [])
          .map(weekdayFromJson)
          .whereType<int>()
          .toSet(),
      time: json['time']?.toString() ?? '00:00',
      action: EquipmentScheduleAction.fromJson(json['action']),
      airConditionerState: AirConditionerStateDto.fromJson(
        json['airConditionerState'],
      ),
      buttonId: (json['buttonId'] as num?)?.toInt(),
      lastRunAt: _toDate(json['lastRunAt']),
    );
  }
}

class SpaceControllerDeviceDto {
  static SpaceControllerDevice fromJson(Map<String, dynamic> json) {
    return SpaceControllerDevice(
      id: (json['id'] as num?)?.toInt() ?? 0,
      spaceId: (json['spaceId'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      hasLock: json['hasLock'] == true,
      hasKeys: json['hasKeys'] == true,
      lastSeenAt: _toDate(json['lastSeenAt']),
    );
  }
}

class ControllerKeysDto {
  static ControllerKeys fromJson(Map<String, dynamic> json) {
    return ControllerKeys(
      controllerId: (json['controllerId'] as num?)?.toInt() ?? 0,
      devicePrivateKeyPem: json['devicePrivateKeyPem']?.toString() ?? '',
      backendPublicKeyPem: json['backendPublicKeyPem']?.toString() ?? '',
      mqttTopic: json['mqttTopic']?.toString() ?? '',
    );
  }
}

class IrCaptureDto {
  static IrCapture? fromJson(dynamic value) {
    final json = _asMap(value);
    if (json == null) return null;
    return IrCapture(
      protocol: json['protocol']?.toString() ?? '',
      code: json['code']?.toString(),
      bits: (json['bits'] as num?)?.toInt() ?? 0,
      model: (json['model'] as num?)?.toInt(),
      airConditioner: AirConditionerStateDto.fromJson(json['airConditioner']),
    );
  }
}

class EquipmentCommandDto {
  static EquipmentCommand fromJson(Map<String, dynamic> json) {
    return EquipmentCommand(
      commandId: json['commandId']?.toString() ?? '',
      kind: json['kind']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      status: EquipmentCommandStatus.fromJson(json['status']),
      userName: json['userName']?.toString(),
      error: json['error']?.toString(),
      capture: IrCaptureDto.fromJson(json['capture']),
      issuedAt: _toDate(json['issuedAt']) ?? DateTime.now(),
      confirmedAt: _toDate(json['confirmedAt']),
    );
  }
}

class IrRemotePresetDto {
  static IrRemotePreset fromJson(Map<String, dynamic> json) {
    return IrRemotePreset(
      id: json['id']?.toString() ?? '',
      type: EquipmentType.fromJson(json['type']),
      brand: json['brand']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      buttonCount: ((json['buttons'] as List?) ?? const []).length,
    );
  }
}

class AirConditionerProtocolDto {
  static AirConditionerProtocol fromJson(Map<String, dynamic> json) {
    return AirConditionerProtocol(
      protocol: json['protocol']?.toString() ?? '',
      brands: ((json['brands'] as List?) ?? const [])
          .map((b) => b.toString())
          .toList(),
      models: ((json['models'] as List?) ?? const [])
          .map(_asMap)
          .whereType<Map<String, dynamic>>()
          .map(
            (m) => AirConditionerModel(
              value: (m['value'] as num?)?.toInt() ?? 0,
              name: m['name']?.toString() ?? '',
            ),
          )
          .toList(),
    );
  }
}

class EquipmentPayload {
  const EquipmentPayload({
    required this.name,
    required this.type,
    required this.controllerId,
    this.isActive = true,
    this.protocol,
    this.model,
    this.fromLearnCommandId,
    this.remotePresetId,
    this.minTemperature,
    this.maxTemperature,
    this.usageStart,
    this.usageEnd,
    this.autoOffAtUsageEnd = false,
  });

  final String name;
  final EquipmentType type;
  final int controllerId;
  final bool isActive;
  final String? protocol;
  final int? model;
  final String? fromLearnCommandId;
  final String? remotePresetId;
  final double? minTemperature;
  final double? maxTemperature;
  final String? usageStart;
  final String? usageEnd;
  final bool autoOffAtUsageEnd;

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.apiValue,
    'controllerId': controllerId,
    'isActive': isActive,
    'protocol': protocol,
    'model': model,
    'fromLearnCommandId': fromLearnCommandId,
    if (remotePresetId != null) 'remotePresetId': remotePresetId,
    'minTemperature': minTemperature,
    'maxTemperature': maxTemperature,
    'usageStart': usageStart,
    'usageEnd': usageEnd,
    'autoOffAtUsageEnd': autoOffAtUsageEnd,
  };
}

class EquipmentButtonPayload {
  const EquipmentButtonPayload({
    required this.name,
    this.icon,
    this.sortOrder = 0,
    this.fromLearnCommandId,
  });

  final String name;
  final String? icon;
  final int sortOrder;
  final String? fromLearnCommandId;

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'sortOrder': sortOrder,
    if (fromLearnCommandId != null) 'fromLearnCommandId': fromLearnCommandId,
  };
}

class EquipmentSchedulePayload {
  const EquipmentSchedulePayload({
    required this.name,
    required this.isActive,
    required this.weekdays,
    required this.time,
    required this.action,
    this.airConditionerState,
    this.buttonId,
  });

  final String name;
  final bool isActive;
  final Set<int> weekdays;
  final String time;
  final EquipmentScheduleAction action;
  final AirConditionerState? airConditionerState;
  final int? buttonId;

  Map<String, dynamic> toJson() => {
    'name': name,
    'isActive': isActive,
    'daysOfWeek': (weekdays.toList()..sort())
        .map((d) => weekdayApiNames[d])
        .toList(),
    'time': time,
    'action': action.apiValue,
    'airConditionerState': airConditionerState == null
        ? null
        : AirConditionerStateDto.toJson(airConditionerState!),
    'buttonId': buttonId,
  };
}
