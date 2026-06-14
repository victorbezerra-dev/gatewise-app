import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/space_entity.dart';
import '../../infra/dtos/access_grant_dto.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../../../core/l10n/l10n.dart';

class RequestAccessSheet extends StatefulWidget {
  const RequestAccessSheet({super.key, required this.space});

  final Space space;

  @override
  State<RequestAccessSheet> createState() => _RequestAccessSheetState();
}

class _RequestAccessSheetState extends State<RequestAccessSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: context.l.requestAccessTitle,
      subtitle: context.l.requestAccessSubtitle(widget.space.name),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: context.l.requestAccessReasonLabel,
                hintText: context.l.requestAccessReasonHint,
                prefixIcon: const Icon(Icons.notes_rounded),
              ),
              minLines: 3,
              maxLines: 5,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? context.l.formValidationReason
                      : null,
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: context.l.requestAccessButton,
              icon: Icons.send_rounded,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  RequestAccessPayload(
                    spaceId: widget.space.id,
                    reason: _reasonController.text.trim(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
