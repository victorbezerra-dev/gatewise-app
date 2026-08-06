import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import 'sheet_scaffold.dart';

class JoinOrganizationSheet extends StatefulWidget {
  const JoinOrganizationSheet({super.key, this.addSpaceVariant = false});

  /// When true, the sheet is framed as "add access to new space(s)" for a
  /// user who is already a member, instead of "join organization".
  final bool addSpaceVariant;

  @override
  State<JoinOrganizationSheet> createState() => _JoinOrganizationSheetState();
}

class _JoinOrganizationSheetState extends State<JoinOrganizationSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.addSpaceVariant
        ? context.l.orgAddSpaceSheetTitle
        : context.l.joinTitle;
    final subtitle =
        widget.addSpaceVariant ? context.l.orgAddSpaceSheetSubtitle : null;
    final buttonLabel = widget.addSpaceVariant
        ? context.l.orgAddSpaceSheetButton
        : context.l.joinButton;
    final buttonIcon =
        widget.addSpaceVariant ? Icons.add_business_rounded : Icons.login_rounded;

    return SheetScaffold(
      title: title,
      subtitle: subtitle,
      showGradientBackground: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: context.l.joinCodeLabel,
              hintText: context.l.joinCodeHint,
              prefixIcon: const Icon(Icons.key_rounded),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(_controller.text.trim()),
              icon: Icon(buttonIcon, size: 19),
              label: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
