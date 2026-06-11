import '../value_objects/organization_member_role_vo.dart';

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class ManagedSpace {
  const ManagedSpace({required this.spaceId, required this.name});

  final int spaceId;
  final String name;
}

class OrganizationMembership {
  const OrganizationMembership({
    required this.organization,
    required this.role,
    required this.joinedAt,
    this.startsAt,
    this.expiresAt,
    this.managedSpaces = const [],
  });

  final Organization organization;
  final OrganizationMemberRole role;
  final DateTime? joinedAt;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final List<ManagedSpace> managedSpaces;
}
