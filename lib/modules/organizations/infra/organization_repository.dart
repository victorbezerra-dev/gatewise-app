import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/domain/interfaces/custom_http_client.dart';
import '../domain/entities/organization_entity.dart';
import '../domain/value_objects/organization_member_role_vo.dart';
import '../domain/entities/organization_invite_entity.dart';
import '../domain/entities/organization_member_entity.dart';
import 'dtos/create_invite_dto.dart';
import 'dtos/organization_dto.dart';
import 'dtos/organization_invite_dto.dart';
import 'dtos/organization_member_dto.dart';
import 'dtos/organization_payload_dto.dart';

class OrganizationApiException implements Exception {
  const OrganizationApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class OrganizationRepository {
  OrganizationRepository(this.httpClient);

  final CustomHttpClient httpClient;
  static const _basePath = '/api/organizations';

  Future<List<Organization>> listOrganizations() async {
    _logRequest('GET', _basePath);
    final response = await httpClient.get(_basePath);
    _logResponse('GET', _basePath, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, OrganizationDto.fromJson);
  }

  Future<List<OrganizationMembership>> listMemberships() async {
    const path = '$_basePath/memberships';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, OrganizationMembershipDto.fromJson);
  }

  Future<OrganizationMembership> getById(int id) async {
    final path = '$_basePath/$id';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return OrganizationMembershipDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<Organization> create(OrganizationPayload payload) async {
    final body = jsonEncode(payload.toJson());
    _logRequest('POST', _basePath, body: body);
    final response = await httpClient.post(_basePath, body: body);
    _logResponse('POST', _basePath, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [201]);
    return OrganizationDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> update(int id, OrganizationPayload payload) async {
    final path = '$_basePath/$id';
    final body = jsonEncode(payload.toJson());
    _logRequest('PUT', path, body: body);
    final response = await httpClient.put(path, body: body);
    _logResponse('PUT', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<void> deleteOrganization(int id) async {
    final path = '$_basePath/$id';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<OrganizationInvite> createInvite(
    int organizationId,
    CreateInvitePayload payload,
  ) async {
    final path = '$_basePath/$organizationId/invites';
    final body = jsonEncode(payload.toJson());
    _logRequest('POST', path, body: body);
    final response = await httpClient.post(path, body: body);
    _logResponse('POST', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [200, 201],
    );
    return OrganizationInviteDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<List<OrganizationInvite>> listInvites(int organizationId) async {
    final path = '$_basePath/$organizationId/invites';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, OrganizationInviteDto.fromJson);
  }

  Future<Organization> joinByCode(String code) async {
    const path = '$_basePath/join';
    final body = jsonEncode({'code': code.trim()});
    _logRequest('POST', path, body: body);
    final response = await httpClient.post(path, body: body);
    _logResponse('POST', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return OrganizationDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<OrganizationMember>> listMembers(int organizationId) async {
    final path = '$_basePath/$organizationId/members';
    _logRequest('GET', path);
    final response = await httpClient.get(path);
    _logResponse('GET', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [200]);
    return _decodeList(response.data, OrganizationMemberDto.fromJson);
  }

  Future<void> leaveOrganization(int organizationId) async {
    final path = '$_basePath/$organizationId/leave';
    _logRequest('POST', path);
    final response = await httpClient.post(path);
    _logResponse('POST', path, response);
    _ensureSuccess(
      response.statusCode,
      response.data,
      expected: const [204],
      badRequestMessage: _messageForLeaveBadRequest,
    );
  }

  Future<void> removeMember(int organizationId, int memberId) async {
    final path = '$_basePath/$organizationId/members/$memberId';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<void> revokeInvite(int organizationId, int inviteId) async {
    final path = '$_basePath/$organizationId/invites/$inviteId';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<void> removeSpaceFromInvite(
    int organizationId,
    int inviteId,
    int spaceId,
  ) async {
    final path = '$_basePath/$organizationId/invites/$inviteId/spaces/$spaceId';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<void> updateMemberRole(
    int organizationId,
    int memberId,
    OrganizationMemberRole role, {
    List<int> spaceIds = const [],
  }) async {
    final path = '$_basePath/$organizationId/members/$memberId/role';
    final body = jsonEncode({
      'role': role.apiValue,
      if (role == OrganizationMemberRole.manager) 'spaceIds': spaceIds,
    });
    _logRequest('PUT', path, body: body);
    final response = await httpClient.put(path, body: body);
    _logResponse('PUT', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  Future<void> removeSpaceManager(
    int organizationId,
    int spaceId,
    int spaceManagerId,
  ) async {
    final path =
        '$_basePath/$organizationId/spaces/$spaceId/managers/$spaceManagerId';
    _logRequest('DELETE', path);
    final response = await httpClient.delete(path);
    _logResponse('DELETE', path, response);
    _ensureSuccess(response.statusCode, response.data, expected: const [204]);
  }

  void _logRequest(String method, String path, {String? body}) {
    log(
      '[Organizations API] $method $path${body == null ? '' : ' body=$body'}',
      name: 'OrganizationRepository',
    );
  }

  void _logResponse(String method, String path, Response<dynamic> response) {
    log(
      '[Organizations API] $method $path -> ${response.statusCode} body=${response.data}',
      name: 'OrganizationRepository',
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
    String Function(String body)? badRequestMessage,
  }) {
    if (expected.contains(statusCode)) return;
    final body = data == null
        ? ''
        : data is String
            ? data
            : jsonEncode(data);
    if (statusCode == 400 && badRequestMessage != null) {
      throw OrganizationApiException(
        badRequestMessage(body),
        statusCode: statusCode,
      );
    }
    throw OrganizationApiException(
      _messageForStatus(statusCode ?? 0, body),
      statusCode: statusCode,
    );
  }

  String _messageForLeaveBadRequest(String body) {
    final text = body.trim();
    if (text.isEmpty) return _leaveOnlyOwnerMessage;
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final msg = decoded['message']?.toString().trim();
        if (msg != null && msg.isNotEmpty) return msg;
      }
    } catch (_) {
      // Not JSON: the backend returns the 400 as a plain-text body.
    }
    return text;
  }

  static const _leaveOnlyOwnerMessage =
      'Você é o único proprietário desta organização. Transfira a '
      'titularidade ou exclua a organização antes de sair.';

  String _messageForStatus(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return 'Código inválido, expirado ou dados incorretos.';
      case 403:
        return 'Você não tem permissão para executar esta ação.';
      case 404:
        return 'Organization não encontrada.';
      case 409:
        return 'Você já é membro desta organization.';
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
