import '../value_objects/access_log_status_vo.dart';

class AccessLog {
  const AccessLog({
    required this.id,
    required this.commandId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.spaceId,
    required this.spaceName,
    required this.issuedAt,
    this.confirmedAt,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String commandId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final int spaceId;
  final String spaceName;
  final DateTime issuedAt;
  final DateTime? confirmedAt;
  final AccessLogStatus status;
  final DateTime createdAt;
}
