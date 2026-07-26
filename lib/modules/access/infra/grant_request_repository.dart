import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/domain/interfaces/custom_http_client.dart';
import '../../../modules/spaces/domain/entities/access_grant_entity.dart';
import '../../../modules/spaces/domain/value_objects/access_grant_status_vo.dart';
import '../../../modules/spaces/infra/dtos/access_grant_dto.dart';

class GrantRequestApiException implements Exception {
  const GrantRequestApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class GrantRequestRepository {
  GrantRequestRepository(this.httpClient);

  final CustomHttpClient httpClient;
  static const _basePath = '/api/accessgrants';

  Future<List<AccessGrant>> listMyRequests({
    required String userId,
    AccessGrantStatus? status,
  }) async {
    var path = '$_basePath/user/$userId';
    if (status != null) path += '?status=${status.index}';
    _log('GET', path);
    final response = await httpClient.get(path);
    _logResp('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessGrantDto.fromJson);
  }

  Future<List<AccessGrant>> listRequestsToReview({
    AccessGrantStatus? status,
  }) async {
    var path = _basePath;
    if (status != null) path += '?status=${status.index}';
    _log('GET', path);
    final response = await httpClient.get(path);
    _logResp('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, AccessGrantDto.fromJson);
  }

  Future<void> reviewGrant(int id, AccessGrantReviewStatus status) async {
    final path = '$_basePath/$id/review';
    final body = jsonEncode({'status': status.value});
    _log('PUT', path, body: body);
    final response = await httpClient.put(path, body: body);
    _logResp('PUT', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 204],
    );
  }

  void _log(String method, String path, {String? body}) {
    log(
      '[GrantReq API] $method $path${body == null ? '' : ' body=$body'}',
      name: 'GrantRequestRepository',
    );
  }

  void _logResp(String method, String path, Response<dynamic> r) {
    log(
      '[GrantReq API] $method $path -> ${r.statusCode}',
      name: 'GrantRequestRepository',
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
    throw GrantRequestApiException(
      _messageForStatus(statusCode ?? 0, body),
      statusCode: statusCode,
    );
  }

  String _messageForStatus(int code, String body) {
    if (code == 403) return 'Você não tem permissão para esta ação.';

    final apiMessage = _extractErrorMessage(body);
    if (apiMessage != null) return apiMessage;

    return 'Erro ao carregar solicitações. Tente novamente.';
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
        'Failed to decode grant request error response body.',
        name: 'GrantRequestRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return null;
  }
}
