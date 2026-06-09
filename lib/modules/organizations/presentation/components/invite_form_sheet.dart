import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import '../../infra/dtos/create_invite_dto.dart';
import 'sheet_scaffold.dart';

class InviteFormSheet extends StatefulWidget {
  const InviteFormSheet({super.key});

  @override
  State<InviteFormSheet> createState() => _InviteFormSheetState();
}

class _InviteFormSheetState extends State<InviteFormSheet> {
  OrganizationMemberRole _role = OrganizationMemberRole.member;
  final _expiresController = TextEditingController(text: '7');
  final _usesController = TextEditingController(text: '10');
  DateTime? _memberStartsAt;
  DateTime? _memberExpiresAt;

  @override
  void dispose() {
    _expiresController.dispose();
    _usesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Criar convite',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<OrganizationMemberRole>(
            initialValue: _role,
            dropdownColor: GateWiseColors.surface,
            decoration: const InputDecoration(
              labelText: 'Role',
              prefixIcon: Icon(Icons.shield_rounded),
            ),
            items: OrganizationMemberRole.values
                .map(
                  (role) =>
                      DropdownMenuItem(value: role, child: Text(role.label)),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _role = value ?? OrganizationMemberRole.member),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _expiresController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Expira em dias',
              hintText: 'Vazio = sem expiração',
              prefixIcon: Icon(Icons.event_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _usesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Máximo de usos',
              hintText: 'Vazio = ilimitado',
              prefixIcon: Icon(Icons.group_add_rounded),
            ),
          ),
          const SizedBox(height: 12),
          _DatePickerField(
            label: 'Início do acesso do membro',
            icon: Icons.play_circle_outline_rounded,
            value: _memberStartsAt,
            onChanged: (date) => setState(() => _memberStartsAt = date),
          ),
          const SizedBox(height: 12),
          _DatePickerField(
            label: 'Expiração do acesso do membro',
            icon: Icons.stop_circle_outlined,
            value: _memberExpiresAt,
            onChanged: (date) => setState(() => _memberExpiresAt = date),
          ),
          const SizedBox(height: 16),
          NeonGradientButton(
            label: 'Gerar convite',
            icon: Icons.add_link_rounded,
            gradient: const [
              GateWiseColors.electricBlue,
              GateWiseColors.electricBlue,
            ],
            onPressed: () => Navigator.of(context).pop(
              CreateInvitePayload(
                role: _role,
                expiresInDays: _parseOptionalInt(_expiresController.text),
                maxUses: _parseOptionalInt(_usesController.text),
                memberStartsAt: _memberStartsAt,
                memberExpiresAt: _memberExpiresAt,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int? _parseOptionalInt(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final displayText = value == null
        ? 'Vazio = sem restrição'
        : '${value!.day.toString().padLeft(2, '0')}/'
              '${value!.month.toString().padLeft(2, '0')}/'
              '${value!.year}';

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: GateWiseColors.electricBlue,
                surface: GateWiseColors.surface,
              ),
            ),
            child: child!,
          ),
        );
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: value != null
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.calendar_today_rounded, size: 18),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            color: value == null
                ? GateWiseColors.textMuted
                : GateWiseColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
