import '../../domain/entities/organization_entity.dart';
import '../../domain/entities/organization_member_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';

class OrganizationMemberDto {
  static OrganizationMember fromJson(Map<String, dynamic> json) => OrganizationMember(
    id: (json['id'] as num?)?.toInt() ?? 0,
    userId: json['userId']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    role: OrganizationMemberRole.fromJson(json['role']?.toString()),
    joinedAt: DateTime.tryParse(json['joinedAt']?.toString() ?? ''),
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
