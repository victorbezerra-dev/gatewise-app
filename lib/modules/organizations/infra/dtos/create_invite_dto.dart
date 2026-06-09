import '../../domain/value_objects/organization_member_role_vo.dart';

class CreateInvitePayload {
  const CreateInvitePayload({
    this.role = OrganizationMemberRole.member,
    this.expiresInDays,
    this.maxUses,
  });

  final OrganizationMemberRole role;
  final int? expiresInDays;
  final int? maxUses;

  Map<String, dynamic> toJson() => {
    'role': role.apiValue,
    if (expiresInDays != null) 'expiresInDays': expiresInDays,
    if (maxUses != null) 'maxUses': maxUses,
  };
}
