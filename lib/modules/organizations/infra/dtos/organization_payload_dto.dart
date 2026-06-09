class OrganizationPayload {
  const OrganizationPayload({
    required this.name,
    this.description,
    this.isActive = true,
  });

  final String name;
  final String? description;
  final bool isActive;

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null && description!.trim().isNotEmpty)
      'description': description!.trim(),
    'isActive': isActive,
  };
}
