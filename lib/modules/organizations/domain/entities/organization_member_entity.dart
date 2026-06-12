import '../value_objects/organization_member_role_vo.dart';
import 'organization_entity.dart';

class OrganizationMember {
  const OrganizationMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
    this.spaces = const [],
  });

  final int id;
  final String userId;
  final String name;
  final String email;
  final OrganizationMemberRole role;
  final DateTime? joinedAt;
  final List<ManagedSpace> spaces;
}
