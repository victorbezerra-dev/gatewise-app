import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../space_providers.dart';

Future<bool> confirmSpace(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool danger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: GateWiseColors.surface,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(
        message,
        style: const TextStyle(color: GateWiseColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor:
                danger ? GateWiseColors.danger : GateWiseColors.electricBlue,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showSpaceSnack(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      backgroundColor:
          isError ? GateWiseColors.danger : GateWiseColors.surfaceLight,
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSpaceActionError(BuildContext context, WidgetRef ref) {
  final message = ref.read(spaceControllerProvider).actionErrorMessage;
  showSpaceSnack(
    context,
    message?.trim().isNotEmpty == true
        ? message!.trim()
        : 'Não foi possível concluir a ação. Tente novamente.',
    isError: true,
  );
}

String formatSpaceDate(DateTime? date) {
  if (date == null) return 'sem data';
  final local = date.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year}';
}
