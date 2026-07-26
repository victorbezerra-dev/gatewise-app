import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DialogStatus { idle, loading, success, error, timeout }

class DialogState {
  final DialogStatus status;
  final String? message;
  final bool isOpen;
  final String? spaceName;

  DialogState({
    required this.status,
    this.message,
    this.isOpen = false,
    this.spaceName,
  });

  DialogState copyWith({
    DialogStatus? status,
    String? message,
    bool? isOpen,
    String? spaceName,
  }) => DialogState(
    status: status ?? this.status,
    message: message ?? this.message,
    isOpen: isOpen ?? this.isOpen,
    spaceName: spaceName ?? this.spaceName,
  );

  factory DialogState.idle() =>
      DialogState(status: DialogStatus.idle, isOpen: false);
  factory DialogState.loading([String? spaceName]) => DialogState(
    status: DialogStatus.loading,
    isOpen: true,
    spaceName: spaceName,
  );
}

class DialogNotifier extends StateNotifier<DialogState> {
  Timer? _timeoutTimer;

  DialogNotifier() : super(DialogState.idle());

  void showLoading({
    String? spaceName,
    Duration timeout = const Duration(seconds: 15),
  }) {
    _cancelTimeout();
    state = DialogState.loading(spaceName);
    _timeoutTimer = Timer(timeout, () {
      if (state.status == DialogStatus.loading) {
        state = state.copyWith(status: DialogStatus.timeout, isOpen: true);
      }
    });
  }

  void showSuccess([String? msg]) {
    _cancelTimeout();
    state = state.copyWith(
      status: DialogStatus.success,
      isOpen: true,
      message: msg,
    );
  }

  void showError([String? msg]) {
    _cancelTimeout();
    state = state.copyWith(
      status: DialogStatus.error,
      isOpen: true,
      message: msg,
    );
  }

  void showTimeout([String? msg]) {
    _cancelTimeout();
    state = state.copyWith(
      status: DialogStatus.timeout,
      isOpen: true,
      message: msg,
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
