import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import 'organization_avatar.dart';
import 'role_badge.dart';

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    super.key,
    required this.organization,
    required this.subtitle,
    required this.onTap,
    this.role,
  });

  final Organization organization;
  final String subtitle;
  final OrganizationMemberRole? role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: organization.isActive ? 1.0 : 0.52,
        child: GlassPanel(
          padding: EdgeInsets.zero,
          borderRadius: 20,
          opacity: 0.6,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    OrganizationAvatar(organization: organization),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organization.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: GateWiseColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.56),
                              fontSize: 12,
                            ),
                          ),
                          if (!organization.isActive) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Organização inativa',
                              style: TextStyle(
                                color: GateWiseColors.amber.withValues(alpha: 0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (role != null) ...[
                            const SizedBox(height: 8),
                            RoleBadge(role: role!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: GateWiseColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
