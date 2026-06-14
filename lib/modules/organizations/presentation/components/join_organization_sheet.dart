import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import 'sheet_scaffold.dart';

class JoinOrganizationSheet extends StatefulWidget {
  const JoinOrganizationSheet({super.key});

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
    return SheetScaffold(
      title: context.l.joinTitle,
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
              icon: const Icon(Icons.login_rounded, size: 19),
              label: Text(
                context.l.joinButton,
                style: TextStyle(
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
