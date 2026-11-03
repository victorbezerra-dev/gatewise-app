import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/custom_http_client_provider.dart';
import '../domain/entities/air_conditioner_state_entity.dart';
import '../domain/entities/equipment_command_entity.dart';
import '../domain/entities/equipment_entity.dart';
import '../domain/entities/space_controller_device_entity.dart';
import '../infra/dtos/equipment_dto.dart';
import '../infra/equipment_repository.dart';

typedef EquipmentKey = ({int spaceId, int equipmentId});

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  return EquipmentRepository(ref.watch(customHttpClientProvider));
});

final airConditionerProtocolsProvider =
    FutureProvider<List<AirConditionerProtocol>>((ref) {
      return ref
          .watch(equipmentRepositoryProvider)
          .listAirConditionerProtocols();
    });

final irRemotesProvider = FutureProvider<List<IrRemotePreset>>((ref) {
  return ref.watch(equipmentRepositoryProvider).listIrRemotes();
});

final spaceEquipmentsProvider = FutureProvider.autoDispose
    .family<List<Equipment>, int>((ref, spaceId) {
      return ref.watch(equipmentRepositoryProvider).listEquipments(spaceId);
    });

final spaceControllersProvider = FutureProvider.autoDispose
    .family<List<SpaceControllerDevice>, int>((ref, spaceId) {
      return ref.watch(equipmentRepositoryProvider).listControllers(spaceId);
    });

final equipmentProvider = FutureProvider.autoDispose
    .family<Equipment, EquipmentKey>((ref, key) {
      return ref
          .watch(equipmentRepositoryProvider)
          .getEquipment(key.spaceId, key.equipmentId);
    });

final equipmentHistoryProvider = FutureProvider.autoDispose
    .family<List<EquipmentCommand>, EquipmentKey>((ref, key) {
      return ref
          .watch(equipmentRepositoryProvider)
          .history(key.spaceId, key.equipmentId);
    });

enum EquipmentEventKind { result, learned }

/// A command confirmation pushed by the backend over SignalR
/// (`equipment_result` and `ir_learned`).
class EquipmentEvent {
  const EquipmentEvent({
    required this.kind,
    required this.commandId,
    required this.status,
    this.spaceId,
    this.equipmentId,
    this.controllerId,
    this.error,
    this.airConditionerState,
    this.capture,
  });

  final EquipmentEventKind kind;
  final String commandId;

  /// `ok`, `failed` or `timeout`.
  final String status;
  final int? spaceId;
  final int? equipmentId;
  final int? controllerId;
  final String? error;
  final AirConditionerState? airConditionerState;
  final IrCapture? capture;

  bool get isOk => status == 'ok';

  factory EquipmentEvent.fromHub(EquipmentEventKind kind, Map data) {
    return EquipmentEvent(
      kind: kind,
      commandId: data['commandId']?.toString() ?? '',
      status: data['status']?.toString() ?? 'failed',
      spaceId: (data['spaceId'] as num?)?.toInt(),
      equipmentId: (data['equipmentId'] as num?)?.toInt(),
      controllerId: (data['controllerId'] as num?)?.toInt(),
      error: data['error']?.toString(),
      airConditionerState: AirConditionerStateDto.fromJson(
        data['airConditionerState'],
      ),
      capture: IrCaptureDto.fromJson(data['capture']),
    );
  }
}

/// Fans out the SignalR equipment events and remembers the latest ones, so
/// a confirmation that arrives before the HTTP response is not lost.
class EquipmentEventBus {
  static const _recentLimit = 20;

  final _controller = StreamController<EquipmentEvent>.broadcast();
  final _recent = <EquipmentEvent>[];

  Stream<EquipmentEvent> get stream => _controller.stream;

  void add(EquipmentEvent event) {
    _recent.add(event);
    if (_recent.length > _recentLimit) _recent.removeAt(0);
    _controller.add(event);
  }

  EquipmentEvent? recent(String commandId) {
    for (final event in _recent.reversed) {
      if (event.commandId == commandId) return event;
    }
    return null;
  }

  Future<void> close() => _controller.close();
}

final equipmentEventsProvider = Provider<EquipmentEventBus>((ref) {
  final bus = EquipmentEventBus();
  ref.onDispose(bus.close);
  return bus;
});
