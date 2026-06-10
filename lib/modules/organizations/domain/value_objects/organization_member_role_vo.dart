enum OrganizationMemberRole {
  admin('Admin'),
  owner('Owner'),
  manager('Manager'),
  member('Member');

  const OrganizationMemberRole(this.apiValue);

  final String apiValue;

  String get label {
    switch (this) {
      case OrganizationMemberRole.admin:
        return 'Admin';
      case OrganizationMemberRole.owner:
        return 'Owner';
      case OrganizationMemberRole.manager:
        return 'Manager';
      case OrganizationMemberRole.member:
        return 'Member';
    }
  }

  bool get canManageOrganization =>
      this == OrganizationMemberRole.admin ||
      this == OrganizationMemberRole.owner;

  static OrganizationMemberRole fromJson(String? value) {
    return OrganizationMemberRole.values.firstWhere(
      (role) => role.apiValue.toLowerCase() == value?.toLowerCase(),
      orElse: () => OrganizationMemberRole.member,
    );
  }
}
