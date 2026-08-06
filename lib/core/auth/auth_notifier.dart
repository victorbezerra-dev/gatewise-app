import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:openid_client/openid_client_io.dart';
import 'auth_config.dart';
import 'auth_state.dart';
import '../infra/secure_storage.dart';

const _refreshBuffer = Duration(seconds: 30);
const _minRefreshDelay = Duration(seconds: 5);

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
  Timer? _refreshTimer;
  Future<void>? _refreshFuture;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

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

  Uri _logoutUri({String? idToken}) {
    final issuerUri = Uri.parse(AuthConfig.issuer);
    final normalizedIssuerPath = issuerUri.path.replaceAll(RegExp(r'/+$'), '');
    final queryParameters = <String, String>{
      'client_id': AuthConfig.clientId,
      'post_logout_redirect_uri': AuthConfig.redirectUri,
    };

    if (idToken != null && idToken.isNotEmpty) {
      queryParameters['id_token_hint'] = idToken;
    }

    return issuerUri.replace(
      path: '$normalizedIssuerPath/protocol/openid-connect/logout',
      queryParameters: queryParameters,
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

    await _saveSession(tokenResponse, fallbackRefreshToken: '');
  }

  Future<void> _saveSession(
    TokenResponse tokenResponse, {
    String? fallbackRefreshToken,
  }) async {
    final accessToken = tokenResponse.accessToken!;
    await SecureStore.saveTokens(
      accessToken: accessToken,
      refreshToken: tokenResponse.refreshToken ?? fallbackRefreshToken,
      idToken: tokenResponse.idToken.toCompactSerialization(),
      expiresAt: tokenResponse.expiresAt,
    );

    state = AuthAuthenticated(accessToken);
    _scheduleRefresh(tokenResponse.expiresAt);
  }

  void _scheduleRefresh(DateTime? expiresAt) {
    _refreshTimer?.cancel();
    if (expiresAt == null) return;

    var delay = expiresAt.difference(DateTime.now()) - _refreshBuffer;
    if (delay < _minRefreshDelay) delay = _minRefreshDelay;

    _refreshTimer = Timer(delay, () {
      refresh();
    });
  }

  Future<void> _bootstrap() async {
    final token = await SecureStore.accessToken;
    if (token != null) {
      state = AuthAuthenticated(token);
      _scheduleRefresh(await SecureStore.expiresAt);
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

  Future<void> refresh() {
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<void> _doRefresh() async {
    try {
      final refreshToken = await SecureStore.refreshToken;
      if (refreshToken == null) {
        await _forceLogout();
        return;
      }

      final issuer = await Issuer.discover(Uri.parse(AuthConfig.issuer));
      final client = Client(issuer, AuthConfig.clientId);
      final credential = client.createCredential(refreshToken: refreshToken);
      final tokenResponse = await credential.getTokenResponse();

      await _saveSession(tokenResponse, fallbackRefreshToken: refreshToken);
    } catch (e) {
      log('Error refreshing token: $e');
      await _forceLogout(error: e.toString());
    }
  }

  Future<void> _forceLogout({String? error}) async {
    _refreshTimer?.cancel();
    await SecureStore.clearAll();
    state = AuthUnauthenticated(error: error);
  }

  Future<void> logout() async {
    state = AuthLoading();
    final idToken = await SecureStore.idToken;

    try {
      await FlutterWebAuth2.authenticate(
        url: _logoutUri(idToken: idToken).toString(),
        callbackUrlScheme: AuthConfig.redirectUri.split('://').first,
        options: const FlutterWebAuth2Options(
          preferEphemeral: true,
          intentFlags: ephemeralIntentFlags,
        ),
      );
    } catch (e) {
      log('Error ending Keycloak session: $e');
    } finally {
      _refreshTimer?.cancel();
      await SecureStore.clearAll();
      state = AuthUnauthenticated();
    }
  }
}
