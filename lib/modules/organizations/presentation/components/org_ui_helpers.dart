import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/join_organization_result_entity.dart';
import '../../domain/value_objects/join_organization_status_vo.dart';
import '../organization_providers.dart';

Future<bool> confirm(
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
          child: Text(context.l.actionCancel),
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

void showSnack(BuildContext context, String message, {bool isError = false}) {
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

void showActionError(BuildContext context, WidgetRef ref) {
  final message = ref.read(organizationControllerProvider).actionErrorMessage;
  showSnack(
    context,
    message?.trim().isNotEmpty == true
        ? message!.trim()
        : context.l.actionGenericError,
    isError: true,
  );
}

void showJoinActionError(BuildContext context, WidgetRef ref) {
  final message = ref.read(organizationControllerProvider).actionErrorMessage;
  final normalized = message?.trim().toLowerCase() ?? '';
  final isRoleMismatch = normalized.contains('different role');
  final isWrongOrganization = normalized.contains('different organization');
  showSnack(
    context,
    isRoleMismatch
        ? context.l.orgsJoinRoleMismatch
        : isWrongOrganization
            ? context.l.orgAddSpaceWrongOrgError
            : (message?.trim().isNotEmpty == true
                ? message!.trim()
                : context.l.actionGenericError),
    isError: true,
  );
}

String messageForJoinResult(BuildContext context, JoinOrganizationResult result) {
  return switch (result.status) {
    JoinOrganizationStatus.joined =>
      context.l.orgsJoinedSuccess(result.organization.name),
    JoinOrganizationStatus.alreadyMemberSpacesAdded =>
      context.l.orgsJoinSpacesAdded(result.organization.name),
    JoinOrganizationStatus.alreadyMemberAlreadyInSpaces =>
      context.l.orgsJoinAlreadyInSpaces,
  };
}

String formatDate(DateTime? date, {BuildContext? context}) {
  if (date == null) return context?.l.noDate ?? 'sem data';
  final local = date.toLocal();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year}';
}
