import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final OrganizationMemberRole role;

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      OrganizationMemberRole.owner => GateWiseColors.mint,
      OrganizationMemberRole.manager => GateWiseColors.amber,
      OrganizationMemberRole.member => GateWiseColors.electricBlue,
    };
    return TechStatusPill(
      label: role.label.toUpperCase(),
      icon: Icons.shield_rounded,
      color: color,
    );
  }
}
