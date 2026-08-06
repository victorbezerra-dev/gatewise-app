enum JoinOrganizationStatus {
  joined('Joined'),
  alreadyMemberSpacesAdded('AlreadyMemberSpacesAdded'),
  alreadyMemberAlreadyInSpaces('AlreadyMemberAlreadyInSpaces');

  const JoinOrganizationStatus(this.apiValue);

  final String apiValue;

  static JoinOrganizationStatus fromJson(dynamic value) {
    return JoinOrganizationStatus.values.firstWhere(
      (status) =>
          status.apiValue.toLowerCase() == value?.toString().toLowerCase(),
      orElse: () => JoinOrganizationStatus.joined,
    );
  }
}
