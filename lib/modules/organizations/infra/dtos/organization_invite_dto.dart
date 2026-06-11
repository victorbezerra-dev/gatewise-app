import '../../domain/entities/organization_entity.dart';
import '../../domain/entities/organization_invite_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';

class OrganizationInviteDto {
  static OrganizationInvite fromJson(Map<String, dynamic> json) =>
      OrganizationInvite(
        id: (json['id'] as num?)?.toInt() ?? 0,
        code: json['code']?.toString() ?? '',
        role: OrganizationMemberRole.fromJson(json['role']),
        isActive: json['isActive'] as bool? ?? true,
        maxUses: (json['maxUses'] as num?)?.toInt(),
        usesCount: (json['usesCount'] as num?)?.toInt() ?? 0,
        expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
        memberStartsAt:
            DateTime.tryParse(json['memberStartsAt']?.toString() ?? ''),
        memberExpiresAt:
            DateTime.tryParse(json['memberExpiresAt']?.toString() ?? ''),
        spaces: (json['spaces'] as List<dynamic>?)
                ?.map((e) {
                  final m = (e as Map).cast<String, dynamic>();
                  return ManagedSpace(
                    spaceId: (m['spaceId'] as num?)?.toInt() ?? 0,
                    name: m['name']?.toString() ?? '',
                  );
                })
                .toList() ??
            const [],
      );
}
