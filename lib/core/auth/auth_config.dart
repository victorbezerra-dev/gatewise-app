class AuthConfig {
  static const String issuer =
      'https://3kb5qjd2-8080.brs.devtunnels.ms/realms/master';
  static const String clientId = 'gatewise-app';
  static const String redirectUri = 'com.gatewise.app://auth';
  static const List<String> scopes = ['openid', 'profile', 'email'];
}
