import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_entity.dart';
import '../../infra/dtos/organization_payload_dto.dart';
import 'sheet_scaffold.dart';

class OrganizationFormSheet extends StatefulWidget {
  const OrganizationFormSheet({super.key, this.organization});

  final Organization? organization;

  @override
  State<OrganizationFormSheet> createState() => _OrganizationFormSheetState();
}

class _OrganizationFormSheetState extends State<OrganizationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final organization = widget.organization;
    _nameController = TextEditingController(text: organization?.name ?? '');
    _descriptionController = TextEditingController(
      text: organization?.description ?? '',
    );
    _isActive = organization?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.organization != null;

    return SheetScaffold(
      title: isEditing ? 'Editar organização' : 'Nova organização',
      subtitle: isEditing
          ? 'Atualize os dados e status da sua organização.'
          : 'Configure uma nova organização para gerenciar membros e convites.',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex: Laboratório GateWise',
                prefixIcon: Icon(Icons.business_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o nome.'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Detalhes sobre a organização',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _OrganizationActiveToggle(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: 'Salvar organização',
              icon: Icons.save_rounded,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  OrganizationPayload(
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    isActive: _isActive,
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

class _OrganizationActiveToggle extends StatelessWidget {
  const _OrganizationActiveToggle({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final statusColor = value ? GateWiseColors.mint : GateWiseColors.amber;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GateWiseColors.surfaceLight.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withValues(alpha: 0.28)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha: 0.12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Icon(
                  value
                      ? Icons.check_circle_rounded
                      : Icons.pause_circle_outline_rounded,
                  color: statusColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status da organização',
                      style: TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value
                          ? 'Ativa e disponível para membros.'
                          : 'Inativa temporariamente.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.56),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                activeThumbColor: GateWiseColors.mint,
                activeTrackColor: GateWiseColors.mint.withValues(alpha: 0.34),
                inactiveThumbColor: GateWiseColors.textSecondary,
                inactiveTrackColor: GateWiseColors.surface,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
