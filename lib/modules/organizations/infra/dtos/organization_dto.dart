import '../../domain/entities/organization_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';

class OrganizationDto {
  static Organization fromJson(Map<String, dynamic> json) => Organization(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString(),
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
  );
}

class OrganizationMembershipDto {
  static OrganizationMembership fromJson(Map<String, dynamic> json) =>
      OrganizationMembership(
        organization: OrganizationDto.fromJson(
          (json['organization'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
        role: OrganizationMemberRole.fromJson(json['role']?.toString()),
        joinedAt: DateTime.tryParse(json['joinedAt']?.toString() ?? ''),
      );
}
