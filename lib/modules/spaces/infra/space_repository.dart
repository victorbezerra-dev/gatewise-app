import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/domain/interfaces/custom_http_client.dart';
import '../domain/entities/access_grant_entity.dart';
import '../domain/entities/space_entity.dart';
import 'dtos/access_grant_dto.dart';
import 'dtos/space_dto.dart';
import 'dtos/space_payload_dto.dart';

class SpaceApiException implements Exception {
  const SpaceApiException(this.message, {this.statusCode, this.reasonCode});

  final String message;
  final int? statusCode;
  final String? reasonCode;

  @override
  String toString() => message;
}

class SpaceRepository {
  SpaceRepository(this.httpClient);

  final CustomHttpClient httpClient;
  static const _spacesPath = '/api/spaces';
  static const _grantsPath = '/api/accessgrants';

  Future<List<Space>> listSpaces(int organizationId) async {
    final path = '/api/organizations/$organizationId/spaces';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, SpaceDto.fromJson);
  }

  Future<Space> getSpaceById(int id) async {
    final path = '$_spacesPath/$id';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return SpaceDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Space> createSpace(int organizationId, SpacePayload payload) async {
    final path = '/api/organizations/$organizationId/spaces';
    final body = jsonEncode(payload.toJson());
    _logRequest('POST', path, body: body);
    final response = await httpClient.post(path, body: body);
    _logResponse('POST', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 201],
    );
    return SpaceDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateSpace(int id, SpacePayload payload) async {
    final path = '$_spacesPath/$id';
    final body = jsonEncode(payload.toJson());
    _logRequest('PUT', path, body: body);
    final response = await httpClient.put(path, body: body);
    _logResponse('PUT', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 204],
    );
  }

  Future<void> deleteSpace(int id) async {
    final path = '$_spacesPath/$id';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 204],
    );
  }

  Future<void> openSpace(
    int id, {
    required int timestamp,
    required String signature,
  }) async {
    final path = '$_spacesPath/$id/open';
    final body = jsonEncode({'timestamp': timestamp, 'signature': signature});
    _logRequest('POST', path, body: body);
    final response = await httpClient.post(path, body: body);
    _logResponse('POST', path, response);
    if (response.statusCode == 400) {
      throw SpaceApiException(
        _messageFromBody(response.data) ??
            'Dispositivo não configurado. Provisione o hardware primeiro.',
        statusCode: 400,
      );
    }
    if (response.statusCode == 403) {
      throw SpaceApiException(
        _messageForOpenSpace403(response.data),
        statusCode: 403,
        reasonCode: _reasonCodeForOpenSpace403(response.data),
      );
    }
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
  }

  Future<String> generateDeviceKeys(int spaceId) async {
    final path = '$_spacesPath/$spaceId/generate-device-keys';
    _logRequest('POST', path);
    final response = await httpClient.post(path, body: '{}');
    _logResponse('POST', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    final data = response.data as Map<String, dynamic>;
    return data['devicePrivateKeyPem'] as String;
  }

  Future<String> getBackendPublicKey() async {
    const path = '/api/system/backend-public-key';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    final data = response.data as Map<String, dynamic>;
    return data['publicKeyPem'] as String;
  }

  String? _messageFromBody(dynamic data) {
    if (data is Map) return data['message']?.toString();
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return decoded['message']?.toString();
      } catch (_) {}
    }
    return null;
  }

  String? _reasonCodeForOpenSpace403(dynamic data) {
    final raw = data is String
        ? data.toLowerCase()
        : data is Map
        ? jsonEncode(data).toLowerCase()
        : '';
    if (raw.contains('not_organization_member')) return 'not_organization_member';
    if (raw.contains('membership_not_started')) return 'membership_not_started';
    if (raw.contains('membership_expired')) return 'membership_expired';
    if (raw.contains('missing_active_access_grant')) return 'missing_active_access_grant';
    return null;
  }

  String _messageForOpenSpace403(dynamic data) {
    final raw = data is String
        ? data.toLowerCase()
        : data is Map
        ? jsonEncode(data).toLowerCase()
        : '';
    if (raw.contains('not started') ||
        raw.contains('not_started') ||
        raw.contains('nao iniciado')) {
      return 'Seu acesso a este espaço ainda não começou.';
    }
    if (raw.contains('expired') || raw.contains('expirado')) {
      return 'Seu acesso a este espaço expirou.';
    }
    return 'Você não tem permissão para abrir este espaço.';
  }

  Future<void> requestAccess(RequestAccessPayload payload) async {
    const path = '$_grantsPath/request-access';
    final body = jsonEncode(payload.toJson());
    _logRequest('POST', path, body: body);
    final response = await httpClient.post(path, body: body);
    _logResponse('POST', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 201],
    );
  }

  Future<List<AccessGrant>> listMyGrants(String userId) async {
    final path = '$_grantsPath/user/$userId';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessGrantDto.fromJson);
  }

  Future<List<AccessGrant>> listAllGrants() async {
    _logRequest('GET', _grantsPath);
    final response = await httpClient.get(_grantsPath);
    _logResponse('GET', _grantsPath, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessGrantDto.fromJson);
  }

  Future<AccessGrant> getGrantById(int id) async {
    final path = '$_grantsPath/$id';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return AccessGrantDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> reviewGrant(int id, AccessGrantReviewPayload payload) async {
    final path = '$_grantsPath/$id/review';
    final body = jsonEncode(payload.toJson());
    _logRequest('PUT', path, body: body);
    final response = await httpClient.put(path, body: body);
    _logResponse('PUT', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 204],
    );
  }

  Future<void> deleteGrant(int id) async {
    final path = '$_grantsPath/$id';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 204],
    );
  }

  void _logRequest(String method, String path, {String? body}) {
    log(
      '[Spaces API] $method $path${body == null ? '' : ' body=$body'}',
      name: 'SpaceRepository',
    );
  }

  void _logResponse(String method, String path, Response<dynamic> response) {
    log(
      '[Spaces API] $method $path -> ${response.statusCode} body=${response.data}',
      name: 'SpaceRepository',
    );
  }

  List<T> _decodeList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = data as List<dynamic>;
    return list
        .map((item) => fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }

  void _ensureSuccess(
    int? statusCode,
    dynamic data, {
    required List<int> expected,
  }) {
    if (expected.contains(statusCode)) return;
    final body = data == null
        ? ''
        : data is String
        ? data
        : jsonEncode(data);
    throw SpaceApiException(
      _messageForStatus(statusCode ?? 0, body),
      statusCode: statusCode,
    );
  }

  String _messageForStatus(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return 'Dados inválidos ou requisição incorreta.';
      case 403:
        return 'Você não tem permissão para executar esta ação.';
      case 404:
        return 'Space não encontrado.';
      case 409:
        return 'Já existe uma solicitação de acesso para este space.';
      default:
        try {
          final decoded = jsonDecode(body);
          if (decoded is Map) {
            final msg = decoded['message']?.toString();
            if (msg != null && msg.isNotEmpty) return msg;
          }
        } catch (_) {}
        return 'Erro inesperado. Tente novamente.';
    }
  }
}
