import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../spaces/domain/entities/space_entity.dart';
import '../../../spaces/presentation/space_providers.dart';
import '../../domain/entities/organization_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import '../../infra/dtos/create_invite_dto.dart';
import 'sheet_scaffold.dart';

class InviteFormSheet extends ConsumerStatefulWidget {
  const InviteFormSheet({super.key, this.viewerMembership});

  final OrganizationMembership? viewerMembership;

  @override
  ConsumerState<InviteFormSheet> createState() => _InviteFormSheetState();
}

class _InviteFormSheetState extends ConsumerState<InviteFormSheet> {
  OrganizationMemberRole _role = OrganizationMemberRole.member;
  final _expiresController = TextEditingController(text: '7');
  final _usesController = TextEditingController(text: '10');
  DateTime? _memberStartsAt;
  DateTime? _memberExpiresAt;
  final Set<int> _selectedSpaceIds = {};

  bool get _viewerIsManager =>
      widget.viewerMembership?.role == OrganizationMemberRole.manager;

  Set<int> get _managedSpaceIds =>
      widget.viewerMembership?.managedSpaces.map((s) => s.spaceId).toSet() ??
      {};

  @override
  void dispose() {
    _expiresController.dispose();
    _usesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRole =
        _viewerIsManager ? OrganizationMemberRole.member : _role;
    final isInvitingManager =
        !_viewerIsManager && _role == OrganizationMemberRole.manager;

    final allSpacesAsync = ref.watch(spaceControllerProvider).spaces;
    final spacesAsync = _viewerIsManager
        ? allSpacesAsync.whenData(
            (spaces) =>
                spaces.where((s) => _managedSpaceIds.contains(s.id)).toList(),
          )
        : allSpacesAsync;

    return SheetScaffold(
      title: context.l.inviteFormTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_viewerIsManager)
            InputDecorator(
              decoration: InputDecoration(
                labelText: context.l.inviteFormRoleLabel,
                prefixIcon: const Icon(Icons.shield_rounded),
              ),
              child: Text(
                OrganizationMemberRole.member.label,
                style: const TextStyle(color: Colors.white),
              ),
            )
          else
            DropdownButtonFormField<OrganizationMemberRole>(
              initialValue: _role,
              dropdownColor: GateWiseColors.surface,
              decoration: InputDecoration(
                labelText: context.l.inviteFormRoleLabel,
                prefixIcon: const Icon(Icons.shield_rounded),
              ),
              items: OrganizationMemberRole.values
                  .map(
                    (role) =>
                        DropdownMenuItem(value: role, child: Text(role.label)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _role = value ?? OrganizationMemberRole.member;
                _selectedSpaceIds.clear();
              }),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _expiresController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.l.inviteFormExpiresLabel,
              hintText: context.l.inviteFormExpiresHint,
              prefixIcon: const Icon(Icons.event_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _usesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.l.inviteFormMaxUsesLabel,
              hintText: context.l.inviteFormMaxUsesHint,
              prefixIcon: const Icon(Icons.group_add_rounded),
            ),
          ),
          const SizedBox(height: 12),
          _DatePickerField(
            label: context.l.inviteFormStartsAtLabel,
            icon: Icons.play_circle_outline_rounded,
            value: _memberStartsAt,
            onChanged: (date) => setState(() => _memberStartsAt = date),
          ),
          const SizedBox(height: 12),
          _DatePickerField(
            label: context.l.inviteFormExpiresAtLabel,
            icon: Icons.stop_circle_outlined,
            value: _memberExpiresAt,
            onChanged: (date) => setState(() => _memberExpiresAt = date),
          ),
          const SizedBox(height: 16),
          _SpaceSelector(
            spacesAsync: spacesAsync,
            selectedIds: _selectedSpaceIds,
            label: isInvitingManager ? context.l.inviteFormSpacesManagerLabel : context.l.inviteFormSpacesLabel,
            onToggle: (id) => setState(() {
              if (_selectedSpaceIds.contains(id)) {
                _selectedSpaceIds.remove(id);
              } else {
                _selectedSpaceIds.add(id);
              }
            }),
          ),
          const SizedBox(height: 16),
          NeonGradientButton(
            label: context.l.inviteFormGenerateButton,
            icon: Icons.add_link_rounded,
            gradient: const [
              GateWiseColors.electricBlue,
              GateWiseColors.electricBlue,
            ],
            onPressed: _selectedSpaceIds.isEmpty
                ? null
                : () => Navigator.of(context).pop(
                    CreateInvitePayload(
                      role: effectiveRole,
                      expiresInDays: _parseOptionalInt(_expiresController.text),
                      maxUses: _parseOptionalInt(_usesController.text),
                      memberStartsAt: _memberStartsAt,
                      memberExpiresAt: _memberExpiresAt,
                      spaceIds: _selectedSpaceIds.toList(),
                    ),
                  ),
          ),
          if (_selectedSpaceIds.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                isInvitingManager
                    ? context.l.inviteFormSelectSpaceManager
                    : context.l.inviteFormSelectSpace,
                style: TextStyle(
                  color: GateWiseColors.danger.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
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

class _SpaceSelector extends StatelessWidget {
  const _SpaceSelector({
    required this.spacesAsync,
    required this.selectedIds,
    required this.label,
    required this.onToggle,
  });

  final AsyncValue<List<Space>> spacesAsync;
  final Set<int> selectedIds;
  final String label;
  final void Function(int) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.sensor_door_rounded,
              size: 16,
              color: GateWiseColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        spacesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                color: GateWiseColors.electricBlue,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (_, __) => Text(
            context.l.inviteFormSpacesLoadError,
            style: TextStyle(
              color: GateWiseColors.danger.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          data: (spaces) {
            if (spaces.isEmpty) {
              return Text(
                context.l.inviteFormNoSpaces,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final space in spaces)
                  FilterChip(
                    label: Text(space.name),
                    selected: selectedIds.contains(space.id),
                    onSelected: (_) => onToggle(space.id),
                    backgroundColor: GateWiseColors.surfaceLight.withValues(
                      alpha: 0.3,
                    ),
                    selectedColor: GateWiseColors.electricBlue.withValues(
                      alpha: 0.22,
                    ),
                    checkmarkColor: GateWiseColors.electricBlue,
                    side: BorderSide(
                      color: selectedIds.contains(space.id)
                          ? GateWiseColors.electricBlue.withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.12),
                    ),
                    labelStyle: TextStyle(
                      color: selectedIds.contains(space.id)
                          ? GateWiseColors.electricBlue
                          : Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
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

  bool get _hasValue => value != null;

  String get _formattedDate {
    final d = value!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$day/$month/${d.year}  $hour:$minute';
  }

  Future<void> _pick(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: _pickerTheme,
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _hasValue ? TimeOfDay.fromDateTime(value!) : TimeOfDay.now(),
      builder: _pickerTheme,
    );
    if (!context.mounted) return;

    onChanged(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? 0,
        pickedTime?.minute ?? 0,
      ),
    );
  }

  static Widget _pickerTheme(BuildContext context, Widget? child) => Theme(
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: GateWiseColors.electricBlue,
        surface: GateWiseColors.surface,
      ),
    ),
    child: child!,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pick(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _hasValue
              ? GateWiseColors.electricBlue.withValues(alpha: 0.08)
              : GateWiseColors.surfaceLight.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasValue
                ? GateWiseColors.electricBlue.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.1),
            width: _hasValue ? 1.4 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: _hasValue
                    ? GateWiseColors.electricBlue
                    : GateWiseColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: _hasValue
                            ? GateWiseColors.electricBlue
                            : GateWiseColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _hasValue ? _formattedDate : context.l.inviteFormDateNotSet,
                      style: TextStyle(
                        color: _hasValue
                            ? GateWiseColors.textPrimary
                            : Colors.white.withValues(alpha: 0.3),
                        fontSize: 14,
                        fontWeight: _hasValue
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasValue)
                GestureDetector(
                  onTap: () => onChanged(null),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                )
              else
                Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
