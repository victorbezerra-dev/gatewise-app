import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/entities/organization_member_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import 'role_badge.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.member,
    this.isCurrentUser = false,
    this.onRemove,
    this.onChangeRole,
    this.onRemoveFromSpace,
  });

  final OrganizationMember member;
  final bool isCurrentUser;
  final VoidCallback? onRemove;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemoveFromSpace;

  @override
  Widget build(BuildContext context) {
    final hasActions = !isCurrentUser &&
        (onRemove != null || onChangeRole != null || onRemoveFromSpace != null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        borderRadius: 18,
        opacity: isCurrentUser ? 0.72 : 0.56,
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                UserAvatar(
                  name: member.name,
                  avatarUrl: member.userAvatarUrl,
                  backgroundColor: isCurrentUser
                      ? GateWiseColors.electricBlue
                      : GateWiseColors.surfaceLight,
                ),
                if (isCurrentUser)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: GateWiseColors.electricBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name.isEmpty ? context.l.memberUnnamed : member.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: GateWiseColors.electricBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: GateWiseColors.electricBlue.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            context.l.memberYou,
                            style: TextStyle(
                              color: GateWiseColors.electricBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
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
                itemBuilder: (ctx) => [
                  if (onChangeRole != null)
                    PopupMenuItem(
                      value: _MemberAction.changeRole,
                      child: _MenuRow(
                        icon: Icons.manage_accounts_rounded,
                        label: ctx.l.memberActionChangeRole,
                        color: GateWiseColors.electricBlue,
                      ),
                    ),
                  if (onRemoveFromSpace != null)
                    PopupMenuItem(
                      value: _MemberAction.removeFromSpace,
                      child: _MenuRow(
                        icon: Icons.door_back_door_rounded,
                        label: ctx.l.memberActionRemoveFromSpace,
                        color: GateWiseColors.amber,
                      ),
                    ),
                  if (onRemove != null && member.role != OrganizationMemberRole.owner)
                    PopupMenuItem(
                      value: _MemberAction.remove,
                      child: _MenuRow(
                        icon: Icons.person_remove_alt_1_rounded,
                        label: ctx.l.memberActionRemove,
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
