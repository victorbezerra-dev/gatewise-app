import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';
import '../../domain/entities/equipment_entity.dart';

const _buttonIcons = <String, IconData>{
  'power': Icons.power_settings_new_rounded,
  'volume_up': Icons.volume_up_rounded,
  'volume_down': Icons.volume_down_rounded,
  'mute': Icons.volume_off_rounded,
  'channel_up': Icons.keyboard_arrow_up_rounded,
  'channel_down': Icons.keyboard_arrow_down_rounded,
  'input': Icons.input_rounded,
  'menu': Icons.menu_rounded,
  'ok': Icons.radio_button_checked_rounded,
  'back': Icons.undo_rounded,
  'home': Icons.home_rounded,
  'info': Icons.info_outline_rounded,
  'exit': Icons.logout_rounded,
  'digit': Icons.dialpad_rounded,
  'play': Icons.play_arrow_rounded,
  'pause': Icons.pause_rounded,
  'up': Icons.arrow_upward_rounded,
  'down': Icons.arrow_downward_rounded,
  'left': Icons.arrow_back_rounded,
  'right': Icons.arrow_forward_rounded,
  'light': Icons.lightbulb_rounded,
  'fan': Icons.air_rounded,
};

IconData buttonIconFor(String? name) =>
    _buttonIcons[name] ?? Icons.radio_button_unchecked_rounded;

class ButtonFormResult {
  const ButtonFormResult({required this.name, this.icon});

  final String name;
  final String? icon;
}

class ButtonFormSheet extends StatefulWidget {
  const ButtonFormSheet({super.key, this.button});

  final EquipmentButton? button;

  @override
  State<ButtonFormSheet> createState() => _ButtonFormSheetState();
}

class _ButtonFormSheetState extends State<ButtonFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _icon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.button?.name ?? '');
    _icon = widget.button?.icon ?? 'power';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.button == null
          ? context.l.buttonFormNewTitle
          : context.l.buttonFormEditTitle,
      subtitle: context.l.buttonFormSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: context.l.buttonFormNameLabel,
                hintText: context.l.buttonFormNameHint,
                prefixIcon: Icon(buttonIconFor(_icon)),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l.formValidationName
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              context.l.buttonFormIconLabel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in _buttonIcons.entries)
                  ChoiceChip(
                    label: Icon(entry.value, size: 20),
                    selected: _icon == entry.key,
                    showCheckmark: false,
                    selectedColor: GateWiseColors.electricBlue.withValues(
                      alpha: 0.45,
                    ),
                    backgroundColor: GateWiseColors.surfaceLight.withValues(
                      alpha: 0.4,
                    ),
                    onSelected: (_) => setState(() => _icon = entry.key),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: context.l.spaceFormSaveButton,
              icon: Icons.save_rounded,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  ButtonFormResult(
                    name: _nameController.text.trim(),
                    icon: _icon,
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
