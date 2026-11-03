import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../domain/entities/equipment_command_entity.dart';
import '../equipment_providers.dart';
import 'equipment_ui_helpers.dart';

class LearnedSignal {
  const LearnedSignal({required this.commandId, required this.capture});

  final String commandId;
  final IrCapture capture;
}

/// Puts a controller in learning mode and waits for the remote control
/// signal it captures. Pops with a [LearnedSignal] when the user accepts it.
class LearnSignalSheet extends ConsumerStatefulWidget {
  const LearnSignalSheet({
    super.key,
    required this.spaceId,
    required this.controllerId,
    this.requireAirConditioner = false,
  });

  final int spaceId;
  final int controllerId;
  final bool requireAirConditioner;

  @override
  ConsumerState<LearnSignalSheet> createState() => _LearnSignalSheetState();
}

enum _LearnStep { starting, listening, captured, failed }

class _LearnSignalSheetState extends ConsumerState<LearnSignalSheet> {
  static const _listenSeconds = 20;

  _LearnStep _step = _LearnStep.starting;
  String? _errorMessage;
  LearnedSignal? _signal;
  int _secondsLeft = _listenSeconds;
  Timer? _countdown;

  @override
  void initState() {
    super.initState();
    Future.microtask(_start);
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _step = _LearnStep.starting;
      _errorMessage = null;
      _signal = null;
    });

    final String commandId;
    try {
      commandId = await ref
          .read(equipmentRepositoryProvider)
          .startLearning(widget.spaceId, widget.controllerId);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _step = _LearnStep.failed;
        _errorMessage = equipmentErrorMessage(context, error);
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _step = _LearnStep.listening;
      _secondsLeft = _listenSeconds;
    });
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });

    final event = await waitForEquipmentCommand(
      ref,
      commandId,
      kind: EquipmentEventKind.learned,
      timeout: const Duration(seconds: _listenSeconds + 18),
    );
    _countdown?.cancel();
    if (!mounted) return;

    final capture = event.capture;
    if (!event.isOk || capture == null) {
      setState(() {
        _step = _LearnStep.failed;
        _errorMessage = event.status == 'timeout'
            ? context.l.learnTimeout
            : (event.error ?? context.l.learnFailed);
      });
      return;
    }

    if (widget.requireAirConditioner && !capture.isAirConditioner) {
      setState(() {
        _step = _LearnStep.failed;
        _errorMessage = context.l.learnNotAirConditioner(capture.protocol);
      });
      return;
    }

    setState(() {
      _step = _LearnStep.captured;
      _signal = LearnedSignal(commandId: commandId, capture: capture);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: context.l.learnTitle,
      subtitle: widget.requireAirConditioner
          ? context.l.learnSubtitleAirConditioner
          : context.l.learnSubtitleButton,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [const SizedBox(height: 8), _buildBody(context)],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_step) {
      case _LearnStep.starting:
        return _StatusBlock(
          icon: Icons.settings_remote_rounded,
          color: GateWiseColors.neonCyan,
          title: context.l.learnStarting,
          showProgress: true,
        );
      case _LearnStep.listening:
        return _StatusBlock(
          icon: Icons.settings_remote_rounded,
          color: GateWiseColors.neonCyan,
          title: context.l.learnListening,
          message: context.l.learnListeningHint(_secondsLeft),
          showProgress: true,
        );
      case _LearnStep.failed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusBlock(
              icon: Icons.error_outline_rounded,
              color: GateWiseColors.danger,
              title: context.l.learnFailedTitle,
              message: _errorMessage,
            ),
            const SizedBox(height: 16),
            NeonGradientButton(
              label: context.l.actionRetry,
              icon: Icons.refresh_rounded,
              onPressed: _start,
            ),
          ],
        );
      case _LearnStep.captured:
        final capture = _signal!.capture;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusBlock(
              icon: Icons.check_circle_rounded,
              color: GateWiseColors.mint,
              title: context.l.learnCaptured,
              message: capture.isAirConditioner
                  ? context.l.learnCapturedAirConditioner(capture.protocol)
                  : context.l.learnCapturedButton(capture.protocol),
            ),
            const SizedBox(height: 16),
            NeonGradientButton(
              label: context.l.learnUseSignal,
              icon: Icons.check_rounded,
              gradient: GateWiseColors.successGradient,
              onPressed: () => Navigator.of(context).pop(_signal),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _start,
              child: Text(context.l.learnCaptureAgain),
            ),
          ],
        );
    }
  }
}

class _StatusBlock extends StatelessWidget {
  const _StatusBlock({
    required this.icon,
    required this.color,
    required this.title,
    this.message,
    this.showProgress = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? message;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 34),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: GateWiseColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 6),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
        if (showProgress) ...[
          const SizedBox(height: 18),
          const LinearProgressIndicator(
            color: GateWiseColors.neonCyan,
            backgroundColor: GateWiseColors.surfaceLight,
          ),
        ],
      ],
    );
  }
}
