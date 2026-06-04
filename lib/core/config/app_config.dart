class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://gatewiseiot.com',
  );

  static const String authIssuerUrl = String.fromEnvironment(
    'AUTH_ISSUER_URL',
    defaultValue: 'https://auth.gatewiseiot.com/realms/master',
  );

  static const String accessConfirmationHubUrl = String.fromEnvironment(
    'ACCESS_CONFIRMATION_HUB_URL',
    defaultValue: '$apiBaseUrl/accessconfirmationhub',
  );

  static const String suapMediaBaseUrl = String.fromEnvironment(
    'SUAP_MEDIA_BASE_URL',
    defaultValue: 'https://suap.ifro.edu.br/media',
  );
}
