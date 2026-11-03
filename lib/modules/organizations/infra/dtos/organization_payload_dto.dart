class OrganizationPayload {
  const OrganizationPayload({
    required this.name,
    this.description,
    this.isActive = true,
    this.timeZoneId,
  });

  final String name;
  final String? description;
  final bool isActive;
  final String? timeZoneId;

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null && description!.trim().isNotEmpty)
      'description': description!.trim(),
    'isActive': isActive,
    if (timeZoneId != null) 'timeZoneId': timeZoneId,
  };
}

const organizationTimeZones = [
  'America/Porto_Velho',
  'America/Manaus',
  'America/Rio_Branco',
  'America/Cuiaba',
  'America/Campo_Grande',
  'America/Boa_Vista',
  'America/Sao_Paulo',
  'America/Bahia',
  'America/Fortaleza',
  'America/Recife',
  'America/Belem',
  'America/Noronha',
];
