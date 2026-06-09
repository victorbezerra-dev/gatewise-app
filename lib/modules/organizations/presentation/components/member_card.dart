import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_member_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import 'role_badge.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, required this.onRemove});

  final OrganizationMember member;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              onPressed: member.role == OrganizationMemberRole.owner
                  ? null
                  : onRemove,
              icon: Icon(
                Icons.person_remove_alt_1_rounded,
                color: member.role == OrganizationMemberRole.owner
                    ? GateWiseColors.textMuted
                    : GateWiseColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
