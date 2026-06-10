import '../value_objects/organization_member_role_vo.dart';

class OrganizationInvite {
  const OrganizationInvite({
    required this.id,
    required this.code,
    required this.role,
    required this.isActive,
    required this.maxUses,
    required this.usesCount,
    required this.expiresAt,
    required this.createdAt,
    this.memberStartsAt,
    this.memberExpiresAt,
    this.spaceIds = const [],
  });

  final int id;
  final String code;
  final OrganizationMemberRole role;
  final bool isActive;
  final int? maxUses;
  final int usesCount;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? memberStartsAt;
  final DateTime? memberExpiresAt;
  final List<int> spaceIds;
}
