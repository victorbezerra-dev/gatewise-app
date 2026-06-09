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

  static OrganizationMemberRole fromJson(String? value) {
    return OrganizationMemberRole.values.firstWhere(
      (role) => role.apiValue.toLowerCase() == value?.toLowerCase(),
      orElse: () => OrganizationMemberRole.member,
    );
  }
}
