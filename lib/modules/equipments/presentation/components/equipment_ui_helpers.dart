import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../spaces/presentation/components/space_ui_helpers.dart';
import '../../infra/equipment_repository.dart';
import '../equipment_providers.dart';

/// Remote-control cloning (IR learning). Off while the controllers have no
/// universal IR receiver; flip to true to show the learn flows again.
const irLearningEnabled = false;

String equipmentErrorMessage(BuildContext context, Object error) {
  final l = context.l;
  if (error is! EquipmentApiException) return l.actionGenericError;

  switch (error.errorCode) {
    case 'outside_usage_window':
    case 'temperature_out_of_range':
      return error.serverMessage ?? l.actionGenericError;
    case 'controller_has_equipments':
      return l.controllerErrorHasEquipments;
    case 'controller_without_keys':
      return l.controllerErrorWithoutKeys;
    case 'capture_not_air_conditioner':
      return l.learnErrorNotAirConditioner;
    case 'unsupported_air_conditioner_protocol':
      return l.equipmentErrorProtocol;
  }

  if (error.statusCode == 403) return l.equipmentErrorForbidden;
  if (error.statusCode == 404) return l.equipmentErrorNotFound;
  return error.serverMessage ?? l.actionGenericError;
}

/// Runs an API call and shows a snack bar if it fails. Returns null on error.
Future<T?> runEquipmentAction<T>(
  BuildContext context,
  Future<T> Function() action, {
  String? successMessage,
}) async {
  try {
    final result = await action();
    if (successMessage != null && context.mounted) {
      showSpaceSnack(context, successMessage);
    }
    return result;
  } catch (error) {
    if (context.mounted) {
      showSpaceSnack(
        context,
        equipmentErrorMessage(context, error),
        isError: true,
      );
    }
    return null;
  }
}

/// Waits for the SignalR confirmation of [commandId]. If the event never
/// arrives (for example, the hub was disconnected), asks the API for the
/// command status once the timeout expires.
Future<EquipmentEvent> waitForEquipmentCommand(
  WidgetRef ref,
  String commandId, {
  required EquipmentEventKind kind,
  Duration timeout = const Duration(seconds: 35),
}) async {
  final bus = ref.read(equipmentEventsProvider);
  final alreadyArrived = bus.recent(commandId);
  if (alreadyArrived != null) return alreadyArrived;
  try {
    return await bus.stream
        .firstWhere((e) => e.commandId == commandId)
        .timeout(timeout);
  } on TimeoutException {
    try {
      final command = await ref
          .read(equipmentRepositoryProvider)
          .getCommand(commandId);
      final status = switch (command.status.apiValue) {
        'CONFIRMED' => 'ok',
        'FAILED' => 'failed',
        _ => 'timeout',
      };
      return EquipmentEvent(
        kind: kind,
        commandId: commandId,
        status: status,
        error: command.error,
        capture: command.capture,
      );
    } catch (_) {
      return EquipmentEvent(
        kind: kind,
        commandId: commandId,
        status: 'timeout',
      );
    }
  }
}

String formatLastSeen(BuildContext context, DateTime? lastSeen) {
  if (lastSeen == null) return context.l.controllerNeverSeen;
  final difference = DateTime.now().difference(lastSeen.toLocal());
  if (difference.inMinutes < 1) return context.l.controllerSeenNow;
  if (difference.inHours < 1) {
    return context.l.controllerSeenMinutes(difference.inMinutes);
  }
  if (difference.inDays < 1) {
    return context.l.controllerSeenHours(difference.inHours);
  }
  return context.l.controllerSeenDays(difference.inDays);
}

String formatDegrees(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);
