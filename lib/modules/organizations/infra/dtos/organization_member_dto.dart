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
  );
}
