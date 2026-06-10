class Space {
  const Space({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.organizationId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final int? organizationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
