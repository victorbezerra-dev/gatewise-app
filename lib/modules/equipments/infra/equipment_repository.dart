import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/domain/interfaces/custom_http_client.dart';
import '../domain/entities/air_conditioner_state_entity.dart';
import '../domain/entities/equipment_command_entity.dart';
import '../domain/entities/equipment_entity.dart';
import '../domain/entities/space_controller_device_entity.dart';
import 'dtos/equipment_dto.dart';

class EquipmentApiException implements Exception {
  const EquipmentApiException({
    required this.statusCode,
    this.errorCode,
    this.serverMessage,
  });

  final int statusCode;
  final String? errorCode;
  final String? serverMessage;

  @override
  String toString() => serverMessage ?? errorCode ?? 'HTTP $statusCode';
}

class EquipmentRepository {
  EquipmentRepository(this.httpClient);

  final CustomHttpClient httpClient;

  String _equipments(int spaceId) => '/api/spaces/$spaceId/equipments';
  String _controllers(int spaceId) => '/api/spaces/$spaceId/controllers';

  Future<List<AirConditionerProtocol>> listAirConditionerProtocols() async {
    final data = await _send(
      'GET',
      '/api/equipments/air-conditioner-protocols',
    );
    return _list(data, AirConditionerProtocolDto.fromJson);
  }

  Future<List<IrRemotePreset>> listIrRemotes() async {
    final data = await _send('GET', '/api/equipments/ir-remotes');
    return _list(data, IrRemotePresetDto.fromJson);
  }

  Future<List<Equipment>> listEquipments(int spaceId) async {
    final data = await _send('GET', _equipments(spaceId));
    return _list(data, EquipmentDto.fromJson);
  }

  Future<Equipment> getEquipment(int spaceId, int id) async {
    final data = await _send('GET', '${_equipments(spaceId)}/$id');
    return EquipmentDto.fromJson(_map(data));
  }

  Future<Equipment> createEquipment(
    int spaceId,
    EquipmentPayload payload,
  ) async {
    final data = await _send(
      'POST',
      _equipments(spaceId),
      body: payload.toJson(),
    );
    return EquipmentDto.fromJson(_map(data));
  }

  Future<void> updateEquipment(
    int spaceId,
    int id,
    EquipmentPayload payload,
  ) async {
    await _send('PUT', '${_equipments(spaceId)}/$id', body: payload.toJson());
  }

  Future<void> deleteEquipment(int spaceId, int id) async {
    await _send('DELETE', '${_equipments(spaceId)}/$id');
  }

  Future<String> sendAirConditionerState(
    int spaceId,
    int id,
    AirConditionerState state,
  ) async {
    final data = await _send(
      'POST',
      '${_equipments(spaceId)}/$id/air-conditioner',
      body: AirConditionerStateDto.toJson(state),
    );
    return _map(data)['commandId'].toString();
  }

  Future<String> pressButton(int spaceId, int id, int buttonId) async {
    final data = await _send(
      'POST',
      '${_equipments(spaceId)}/$id/buttons/$buttonId/press',
    );
    return _map(data)['commandId'].toString();
  }

  Future<List<EquipmentCommand>> history(int spaceId, int id) async {
    final data = await _send('GET', '${_equipments(spaceId)}/$id/history');
    return _list(data, EquipmentCommandDto.fromJson);
  }

  Future<void> createButton(
    int spaceId,
    int id,
    EquipmentButtonPayload payload,
  ) async {
    await _send(
      'POST',
      '${_equipments(spaceId)}/$id/buttons',
      body: payload.toJson(),
    );
  }

  Future<void> updateButton(
    int spaceId,
    int id,
    int buttonId,
    EquipmentButtonPayload payload,
  ) async {
    await _send(
      'PUT',
      '${_equipments(spaceId)}/$id/buttons/$buttonId',
      body: payload.toJson(),
    );
  }

  Future<void> deleteButton(int spaceId, int id, int buttonId) async {
    await _send('DELETE', '${_equipments(spaceId)}/$id/buttons/$buttonId');
  }

  Future<void> createSchedule(
    int spaceId,
    int id,
    EquipmentSchedulePayload payload,
  ) async {
    await _send(
      'POST',
      '${_equipments(spaceId)}/$id/schedules',
      body: payload.toJson(),
    );
  }

  Future<void> updateSchedule(
    int spaceId,
    int id,
    int scheduleId,
    EquipmentSchedulePayload payload,
  ) async {
    await _send(
      'PUT',
      '${_equipments(spaceId)}/$id/schedules/$scheduleId',
      body: payload.toJson(),
    );
  }

  Future<void> deleteSchedule(int spaceId, int id, int scheduleId) async {
    await _send('DELETE', '${_equipments(spaceId)}/$id/schedules/$scheduleId');
  }

  Future<List<SpaceControllerDevice>> listControllers(int spaceId) async {
    final data = await _send('GET', _controllers(spaceId));
    return _list(data, SpaceControllerDeviceDto.fromJson);
  }

  Future<ControllerKeys> createController(
    int spaceId, {
    required String name,
    required bool hasLock,
  }) async {
    final data = await _send(
      'POST',
      _controllers(spaceId),
      body: {'name': name, 'hasLock': hasLock},
    );
    return ControllerKeysDto.fromJson(_map(data));
  }

  Future<void> updateController(
    int spaceId,
    int id, {
    required String name,
    required bool hasLock,
  }) async {
    await _send(
      'PUT',
      '${_controllers(spaceId)}/$id',
      body: {'name': name, 'hasLock': hasLock},
    );
  }

  Future<ControllerKeys> rotateControllerKeys(int spaceId, int id) async {
    final data = await _send('POST', '${_controllers(spaceId)}/$id/keys');
    return ControllerKeysDto.fromJson(_map(data));
  }

  Future<void> deleteController(int spaceId, int id) async {
    await _send('DELETE', '${_controllers(spaceId)}/$id');
  }

  Future<String> startLearning(int spaceId, int controllerId) async {
    final data = await _send(
      'POST',
      '${_controllers(spaceId)}/$controllerId/learn',
    );
    return _map(data)['commandId'].toString();
  }

  Future<EquipmentCommand> getCommand(String commandId) async {
    final data = await _send('GET', '/api/equipment-commands/$commandId');
    return EquipmentCommandDto.fromJson(_map(data));
  }

  Future<void> updateDeviceControl(int grantId, bool canControlDevices) async {
    await _send(
      'PUT',
      '/api/accessgrants/$grantId/device-control',
      body: {'canControlDevices': canControlDevices},
    );
  }

  Future<dynamic> _send(String method, String path, {Object? body}) async {
    final encoded = body == null ? null : jsonEncode(body);
    log(
      '[Equipments API] $method $path${encoded == null ? '' : ' body=$encoded'}',
      name: 'EquipmentRepository',
    );

    final Response<dynamic> response;
    switch (method) {
      case 'GET':
        response = await httpClient.get(path);
      case 'POST':
        response = await httpClient.post(path, body: encoded ?? '{}');
      case 'PUT':
        response = await httpClient.put(path, body: encoded);
      default:
        response = await httpClient.delete(path);
    }

    log(
      '[Equipments API] $method $path -> ${response.statusCode} body=${response.data}',
      name: 'EquipmentRepository',
    );

    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) return response.data;

    final errorBody = _decodeErrorBody(response.data);
    throw EquipmentApiException(
      statusCode: status,
      errorCode: errorBody?['error']?.toString(),
      serverMessage: errorBody?['message']?.toString(),
    );
  }

  Map<String, dynamic>? _decodeErrorBody(dynamic data) {
    if (data is Map) return data.cast<String, dynamic>();
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return decoded.cast<String, dynamic>();
      } catch (_) {}
    }
    return null;
  }

  Map<String, dynamic> _map(dynamic data) =>
      (data as Map).cast<String, dynamic>();

  List<T> _list<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) =>
      (data as List<dynamic>)
          .map((item) => fromJson((item as Map).cast<String, dynamic>()))
          .toList();
}
