import 'dart:convert';
import '../../../core/domain/entities/user_entity.dart';
import '../../../core/domain/interfaces/custom_http_client.dart';
import '../../../core/infra/secure_storage.dart';
import '../domain/entities/access_grant.dart';
import '../domain/entities/open_lab_request.dart';

class LabRepository {
  final CustomHttpClient httpClient;

  LabRepository(this.httpClient);

  Future<void> openLab({required OpenLabRequest request}) async {
    final response = await httpClient.post(
      '/api/Spaces/1/open',
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to open lab: ${response.data}');
    }
  }

  Future<List<AccessGrant>> getAccessGrants() async {
    final userJson = await SecureStore.getUserJson();

    if (userJson == null) {
      throw Exception('An error occurred while retrieving access permissions');
    }

    final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);

    final response = await httpClient.get('/api/AccessGrants/user/${user.id}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList.map((json) => AccessGrant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch access grants: ${response.data}');
    }
  }

  Future<void> requestAccess() async {
    final body = jsonEncode({
      'labId': 1,
      'reason': 'Student needs access to the laboratory',
    });

    final response = await httpClient.post(
      '/api/AccessGrants/request-access',
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to request access: ${response.data}');
    }
  }
}
