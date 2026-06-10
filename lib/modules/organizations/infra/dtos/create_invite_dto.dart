import '../../domain/value_objects/organization_member_role_vo.dart';

class CreateInvitePayload {
  const CreateInvitePayload({
    this.role = OrganizationMemberRole.member,
    this.expiresInDays,
    this.maxUses,
    this.memberStartsAt,
    this.memberExpiresAt,
    this.spaceIds,
  });

  final OrganizationMemberRole role;
  final int? expiresInDays;
  final int? maxUses;
  final DateTime? memberStartsAt;
  final DateTime? memberExpiresAt;
  final List<int>? spaceIds;

  Map<String, dynamic> toJson() => {
    'role': role.apiValue,
    if (expiresInDays != null) 'expiresInDays': expiresInDays,
    if (maxUses != null) 'maxUses': maxUses,
    if (memberStartsAt != null)
      'memberStartsAt': memberStartsAt!.toUtc().toIso8601String(),
    if (memberExpiresAt != null)
      'memberExpiresAt': memberExpiresAt!.toUtc().toIso8601String(),
    if (spaceIds != null && spaceIds!.isNotEmpty) 'spaceIds': spaceIds,
  };
}
