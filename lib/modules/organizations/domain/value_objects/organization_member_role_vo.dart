enum OrganizationMemberRole {
  owner('Owner'),
  manager('Manager'),
  member('Member');

  const OrganizationMemberRole(this.apiValue);

  final String apiValue;

  String get label {
    switch (this) {
      case OrganizationMemberRole.owner:
        return 'Owner';
      case OrganizationMemberRole.manager:
        return 'Manager';
      case OrganizationMemberRole.member:
        return 'Member';
    }
  }

  bool get canManageOrganization => this == OrganizationMemberRole.owner;

  // Backend: Owner=0, Manager=1, Member=2
  int get apiInt {
    switch (this) {
      case OrganizationMemberRole.owner:
        return 0;
      case OrganizationMemberRole.manager:
        return 1;
      case OrganizationMemberRole.member:
        return 2;
    }
  }

  // Aceita string ("Owner") ou int (0) — memberships usam string, invites usam int
  static OrganizationMemberRole fromJson(dynamic value) {
    if (value is int) {
      switch (value) {
        case 0:
          return OrganizationMemberRole.owner;
        case 1:
          return OrganizationMemberRole.manager;
        case 2:
          return OrganizationMemberRole.member;
        default:
          return OrganizationMemberRole.member;
      }
    }
    return OrganizationMemberRole.values.firstWhere(
      (role) => role.apiValue.toLowerCase() == value?.toString().toLowerCase(),
      orElse: () => OrganizationMemberRole.member,
    );
  }
}
