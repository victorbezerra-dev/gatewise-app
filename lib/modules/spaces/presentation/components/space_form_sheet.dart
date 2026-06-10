import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/space_entity.dart';
import '../../infra/dtos/space_payload_dto.dart';
import '../../../organizations/presentation/components/sheet_scaffold.dart';

class SpaceFormSheet extends StatefulWidget {
  const SpaceFormSheet({super.key, this.space});

  final Space? space;

  @override
  State<SpaceFormSheet> createState() => _SpaceFormSheetState();
}

class _SpaceFormSheetState extends State<SpaceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.space?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.space?.description ?? '',
    );
    _isActive = widget.space?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.space != null;

    return SheetScaffold(
      title: isEditing ? 'Editar espaço' : 'Novo espaço',
      subtitle: isEditing
          ? 'Atualize os dados e status do espaço.'
          : 'Configure um novo espaço para controlar o acesso à porta.',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex: Laboratório 66',
                prefixIcon: Icon(Icons.sensor_door_rounded),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Informe o nome.' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Detalhes sobre o space',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _SpaceActiveToggle(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 18),
            NeonGradientButton(
              label: 'Salvar espaço',
              icon: Icons.save_rounded,
              gradient: const [
                GateWiseColors.electricBlue,
                GateWiseColors.electricBlue,
              ],
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  SpacePayload(
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

class _SpaceActiveToggle extends StatelessWidget {
  const _SpaceActiveToggle({required this.value, required this.onChanged});

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
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                  ),
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
                      'Status do space',
                      style: TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value ? 'Ativo e disponível.' : 'Inativo temporariamente.',
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
