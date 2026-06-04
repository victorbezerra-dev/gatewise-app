import '../config/app_config.dart';

class AuthConfig {
  static const String issuer = AppConfig.authIssuerUrl;
  static const String clientId = 'gatewise-app';
  static const String redirectUri = 'com.gatewise.app://auth';
  static const List<String> scopes = ['openid', 'profile', 'email'];
}
