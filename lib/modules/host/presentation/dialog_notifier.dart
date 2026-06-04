import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DialogStatus { idle, loading, success, error, timeout }

class DialogState {
  final DialogStatus status;
  final String? message;
  final bool isOpen;

  DialogState({required this.status, this.message, this.isOpen = false});

  DialogState copyWith({DialogStatus? status, String? message, bool? isOpen}) =>
      DialogState(
        status: status ?? this.status,
        message: message ?? this.message,
        isOpen: isOpen ?? this.isOpen,
      );

  factory DialogState.idle() =>
      DialogState(status: DialogStatus.idle, isOpen: false);
  factory DialogState.loading() =>
      DialogState(status: DialogStatus.loading, isOpen: true);
  factory DialogState.success([String? msg]) =>
      DialogState(status: DialogStatus.success, isOpen: true, message: msg);
  factory DialogState.error([String? msg]) =>
      DialogState(status: DialogStatus.error, isOpen: true, message: msg);
  factory DialogState.timeout([String? msg]) =>
      DialogState(status: DialogStatus.timeout, isOpen: true, message: msg);
}

class DialogNotifier extends StateNotifier<DialogState> {
  Timer? _timeoutTimer;

  DialogNotifier() : super(DialogState.idle());

  void showLoading({Duration timeout = const Duration(seconds: 15)}) {
    _cancelTimeout();
    state = DialogState.loading();
    _timeoutTimer = Timer(timeout, () {
      if (state.status == DialogStatus.loading) {
        state = DialogState.timeout(
          "A operação excedeu o tempo limite. Não obtive resposta do GateWise. "
          "Verifique se a fechadura abriu, ou tente novamente.",
        );
      }
    });
  }

  void showSuccess([String? msg]) {
    _cancelTimeout();
    state = DialogState.success(msg);
  }

  void showError([String? msg]) {
    _cancelTimeout();
    state = DialogState.error(msg);
  }

  void showTimeout([String? msg]) {
    _cancelTimeout();
    state = DialogState.timeout(
      msg ??
          "A operação excedeu o tempo limite. Não obtive resposta do GateWise. "
              "Verifique se a fechadura abriu, ou tente novamente.",
    );
  }

  void close() {
    _cancelTimeout();
    state = DialogState.idle();
  }

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }
}

final dialogProvider = StateNotifierProvider<DialogNotifier, DialogState>(
  (ref) => DialogNotifier(),
);
