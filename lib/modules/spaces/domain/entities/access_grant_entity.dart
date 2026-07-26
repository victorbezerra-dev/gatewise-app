import '../value_objects/access_grant_status_vo.dart';

class AccessGrant {
  const AccessGrant({
    required this.id,
    required this.authorizedUserId,
    required this.authorizedUserName,
    required this.authorizedUserEmail,
    this.authorizedUserAvatarUrl,
    this.grantedByUserId,
    this.grantedByUserAvatarUrl,
    required this.spaceId,
    this.spaceName,
    required this.reason,
    required this.status,
    this.grantedAt,
    this.revokedAt,
    this.createdAt,
  });

  final int id;
  final String authorizedUserId;
  final String authorizedUserName;
  final String authorizedUserEmail;
  final String? authorizedUserAvatarUrl;
  final String? grantedByUserId;
  final String? grantedByUserAvatarUrl;
  final int spaceId;
  final String? spaceName;
  final String reason;
  final AccessGrantStatus status;
  final DateTime? grantedAt;
  final DateTime? revokedAt;
  final DateTime? createdAt;
}
