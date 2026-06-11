import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_member_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import 'role_badge.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.member,
    this.onRemove,
    this.onChangeRole,
    this.onRemoveFromSpace,
  });

  final OrganizationMember member;
  final VoidCallback? onRemove;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemoveFromSpace;

  @override
  Widget build(BuildContext context) {
    final hasActions = onRemove != null || onChangeRole != null || onRemoveFromSpace != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        borderRadius: 18,
        opacity: 0.56,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: GateWiseColors.surfaceLight,
              child: Text(
                member.name.trim().isEmpty
                    ? '?'
                    : member.name.trim()[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name.isEmpty ? 'Usuário sem nome' : member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RoleBadge(role: member.role),
                ],
              ),
            ),
            if (hasActions)
              PopupMenuButton<_MemberAction>(
                icon: const Icon(Icons.more_vert_rounded, color: GateWiseColors.textMuted),
                color: GateWiseColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                onSelected: (action) {
                  switch (action) {
                    case _MemberAction.changeRole:
                      onChangeRole?.call();
                    case _MemberAction.removeFromSpace:
                      onRemoveFromSpace?.call();
                    case _MemberAction.remove:
                      onRemove?.call();
                  }
                },
                itemBuilder: (_) => [
                  if (onChangeRole != null)
                    const PopupMenuItem(
                      value: _MemberAction.changeRole,
                      child: _MenuRow(
                        icon: Icons.manage_accounts_rounded,
                        label: 'Alterar role',
                        color: GateWiseColors.electricBlue,
                      ),
                    ),
                  if (onRemoveFromSpace != null)
                    const PopupMenuItem(
                      value: _MemberAction.removeFromSpace,
                      child: _MenuRow(
                        icon: Icons.door_back_door_rounded,
                        label: 'Remover de espaço',
                        color: GateWiseColors.amber,
                      ),
                    ),
                  if (onRemove != null && member.role != OrganizationMemberRole.owner)
                    const PopupMenuItem(
                      value: _MemberAction.remove,
                      child: _MenuRow(
                        icon: Icons.person_remove_alt_1_rounded,
                        label: 'Remover membro',
                        color: GateWiseColors.danger,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

enum _MemberAction { changeRole, removeFromSpace, remove }

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
