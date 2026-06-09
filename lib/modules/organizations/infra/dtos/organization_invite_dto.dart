import '../../domain/entities/organization_invite_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';

class OrganizationInviteDto {
  static OrganizationInvite fromJson(Map<String, dynamic> json) => OrganizationInvite(
    id: (json['id'] as num?)?.toInt() ?? 0,
    code: json['code']?.toString() ?? '',
    role: OrganizationMemberRole.fromJson(json['role']?.toString()),
    isActive: json['isActive'] as bool? ?? true,
    maxUses: (json['maxUses'] as num?)?.toInt(),
    usesCount: (json['usesCount'] as num?)?.toInt() ?? 0,
    expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
    createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
  );
}
