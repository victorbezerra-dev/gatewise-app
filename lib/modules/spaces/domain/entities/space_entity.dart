class Space {
  const Space({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.hasAccess,
  });

  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Whether the current user has an active grant or manager/owner role for
  /// this specific space. Fail-closed: absent or unparsable on the backend
  /// means false, never assume access by omission.
  final bool hasAccess;
}
