import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:openid_client/openid_client_io.dart';
import 'auth_config.dart';
import 'auth_state.dart';
import '../infra/secure_storage.dart';

class AuthCancelledException implements Exception {
  const AuthCancelledException();
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial()) {
    _bootstrap();
  }
  late Flow _flow;

  Uri _registrationUriFrom(Uri authenticationUri) {
    return authenticationUri.replace(
      path: authenticationUri.path.replaceFirst(
        '/protocol/openid-connect/auth',
        '/protocol/openid-connect/registrations',
      ),
    );
  }

  Uri _forceInteractiveLogin(Uri authenticationUri) {
    return authenticationUri.replace(
      queryParameters: {
        ...authenticationUri.queryParameters,
        'prompt': 'login',
        'max_age': '0',
      },
    );
  }

  Future<void> _authenticate({bool openRegistration = false}) async {
    final issuer = await Issuer.discover(Uri.parse(AuthConfig.issuer));
    final client = Client(issuer, AuthConfig.clientId);
    _flow = Flow.authorizationCodeWithPKCE(client, scopes: AuthConfig.scopes);
    _flow.redirectUri = Uri.parse(AuthConfig.redirectUri);

    final authenticationUri = _forceInteractiveLogin(_flow.authenticationUri);
    final url = openRegistration
        ? _registrationUriFrom(authenticationUri).toString()
        : authenticationUri.toString();

    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: AuthConfig.redirectUri.split('://').first,
        options: const FlutterWebAuth2Options(
          preferEphemeral: true,
          intentFlags: ephemeralIntentFlags,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED' || e.code == 'canceled') {
        throw const AuthCancelledException();
      }
      rethrow;
    }

    final uri = Uri.parse(result);
    final params = uri.queryParameters;
    final credential = await _flow.callback(params);
    final tokenResponse = await credential.getTokenResponse();

    log(tokenResponse.accessToken ?? '');

    await SecureStore.saveTokens(
      accessToken: tokenResponse.accessToken!,
      refreshToken: tokenResponse.refreshToken ?? '',
      idToken: tokenResponse.idToken.toCompactSerialization(),
    );

    state = AuthAuthenticated(tokenResponse.accessToken!);
  }

  Future<void> _bootstrap() async {
    final token = await SecureStore.accessToken;
    if (token != null) {
      state = AuthAuthenticated(token);
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<void> login() async {
    state = AuthLoading();
    try {
      await _authenticate();
    } on AuthCancelledException {
      state = AuthUnauthenticated();
      rethrow;
    } catch (e) {
      log("Error authenticating: $e");
      state = AuthUnauthenticated(error: e.toString());
      rethrow;
    }
  }

  Future<void> register() async {
    state = AuthLoading();
    try {
      await _authenticate(openRegistration: true);
    } on AuthCancelledException {
      state = AuthUnauthenticated();
      rethrow;
    } catch (e) {
      log("Error authenticating: $e");
      state = AuthUnauthenticated(error: e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async {
    try {
      final refreshToken = await SecureStore.refreshToken;
      if (refreshToken == null) {
        state = AuthUnauthenticated();
        return;
      }

      final issuer = await Issuer.discover(Uri.parse(AuthConfig.issuer));
      final client = Client(issuer, AuthConfig.clientId);
      final credential = client.createCredential(refreshToken: refreshToken);
      final tokenResponse = await credential.getTokenResponse();

      await SecureStore.saveTokens(
        accessToken: tokenResponse.accessToken!,
        refreshToken: tokenResponse.refreshToken ?? refreshToken,
        idToken: tokenResponse.idToken.toCompactSerialization(),
      );

      state = AuthAuthenticated(tokenResponse.accessToken!);
    } catch (e) {
      state = AuthUnauthenticated(error: e.toString());
    }
  }

  Future<void> logout() async {
    await SecureStore.clearAll();
    state = AuthUnauthenticated();
  }
}
