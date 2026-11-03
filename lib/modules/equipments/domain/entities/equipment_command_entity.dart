import '../value_objects/equipment_enums.dart';
import 'air_conditioner_state_entity.dart';

class IrCapture {
  const IrCapture({
    required this.protocol,
    this.code,
    required this.bits,
    this.model,
    this.airConditioner,
  });

  final String protocol;
  final String? code;
  final int bits;
  final int? model;
  final AirConditionerState? airConditioner;

  bool get isAirConditioner => airConditioner != null;
}

class EquipmentCommand {
  const EquipmentCommand({
    required this.commandId,
    required this.kind,
    required this.source,
    required this.status,
    this.userName,
    this.error,
    this.capture,
    required this.issuedAt,
    this.confirmedAt,
  });

  final String commandId;
  final String kind;
  final String source;
  final EquipmentCommandStatus status;
  final String? userName;
  final String? error;
  final IrCapture? capture;
  final DateTime issuedAt;
  final DateTime? confirmedAt;
}

class AirConditionerProtocol {
  const AirConditionerProtocol({
    required this.protocol,
    required this.brands,
    this.models = const [],
  });

  final String protocol;
  final List<String> brands;
  final List<AirConditionerModel> models;

  String get displayName =>
      brands.isEmpty ? protocol : '${brands.join(', ')} ($protocol)';
}

class AirConditionerModel {
  const AirConditionerModel({required this.value, required this.name});

  final int value;
  final String name;
}

class ControllerKeys {
  const ControllerKeys({
    required this.controllerId,
    required this.devicePrivateKeyPem,
    required this.backendPublicKeyPem,
    required this.mqttTopic,
  });

  final int controllerId;
  final String devicePrivateKeyPem;
  final String backendPublicKeyPem;
  final String mqttTopic;
}

/// A brand's standard remote from the backend catalog. Creating an equipment
/// with it adds the remote's buttons without cloning.
class IrRemotePreset {
  const IrRemotePreset({
    required this.id,
    required this.type,
    required this.brand,
    required this.label,
    required this.buttonCount,
  });

  final String id;
  final EquipmentType type;
  final String brand;
  final String label;
  final int buttonCount;
}
