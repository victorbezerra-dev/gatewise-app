import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/domain/interfaces/custom_http_client.dart';
import '../domain/entities/access_log_entity.dart';
import '../domain/value_objects/access_log_status_vo.dart';
import 'dtos/access_log_dto.dart';

class AccessLogApiException implements Exception {
  const AccessLogApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AccessLogRepository {
  AccessLogRepository(this.httpClient);

  final CustomHttpClient httpClient;

  Future<List<AccessLog>> listMyLogs({
    AccessLogStatus? status,
    int? spaceId,
    DateTime? from,
    DateTime? to,
  }) async {
    const path = '/api/accesslogs/my';
    final params = <String, String>{};
    if (status != null) params['status'] = status.statusCode.toString();
    if (spaceId != null) params['spaceId'] = spaceId.toString();
    if (from != null) params['from'] = from.toUtc().toIso8601String();
    if (to != null) params['to'] = to.toUtc().toIso8601String();

    final fullPath = _buildPath(path, params);
    _logRequest('GET', fullPath);
    final response = await httpClient.get(fullPath);
    _logResponse('GET', fullPath, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessLogDto.fromJson);
  }

  Future<List<AccessLog>> listSpaceLogs({
    required int spaceId,
    AccessLogStatus? status,
    String? userId,
    DateTime? from,
    DateTime? to,
  }) async {
    final path = '/api/accesslogs/space/$spaceId';
    final params = <String, String>{};
    if (status != null) params['status'] = status.statusCode.toString();
    if (userId != null && userId.isNotEmpty) params['userId'] = userId;
    if (from != null) params['from'] = from.toUtc().toIso8601String();
    if (to != null) params['to'] = to.toUtc().toIso8601String();

    final fullPath = _buildPath(path, params);
    _logRequest('GET', fullPath);
    final response = await httpClient.get(fullPath);
    _logResponse('GET', fullPath, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessLogDto.fromJson);
  }

  String _buildPath(String base, Map<String, String> params) {
    if (params.isEmpty) return base;
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$base?$query';
  }

  void _logRequest(String method, String path) {
    log('[AccessLog API] $method $path', name: 'AccessLogRepository');
  }

  void _logResponse(String method, String path, Response<dynamic> response) {
    log(
      '[AccessLog API] $method $path -> ${response.statusCode}',
      name: 'AccessLogRepository',
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
    throw AccessLogApiException(
      _messageForStatus(statusCode ?? 0, body),
      statusCode: statusCode,
    );
  }

  String _messageForStatus(int statusCode, String body) {
    switch (statusCode) {
      case 401:
        return 'Sessão expirada. Faça login novamente.';
      case 403:
        return 'Você não tem permissão para acessar este histórico.';
      default:
        final apiMessage = _extractErrorMessage(body);
        if (apiMessage != null) return apiMessage;
        return 'Erro ao carregar histórico. Tente novamente.';
    }
  }

  String? _extractErrorMessage(String body) {
    if (body.isEmpty) return null;

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final message = decoded['message']?.toString().trim();
        if (message != null && message.isNotEmpty) return message;
      }
    } on FormatException catch (error, stackTrace) {
      log(
        'Failed to decode access log error response body.',
        name: 'AccessLogRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return null;
  }
}
