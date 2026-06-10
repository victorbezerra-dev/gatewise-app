import '../../domain/entities/access_grant_entity.dart';
import '../../domain/value_objects/access_grant_status_vo.dart';

class AccessGrantDto {
  static AccessGrant fromJson(Map<String, dynamic> json) {
    final userJson = json['authorizedUser'] as Map?;
    final spaceJson = json['space'] as Map?;

    return AccessGrant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      authorizedUserId:
          json['authorizedUserId']?.toString() ??
          userJson?['id']?.toString() ??
          '',
      authorizedUserName:
          userJson?['name']?.toString() ??
          json['authorizedUserName']?.toString() ??
          '',
      authorizedUserEmail:
          userJson?['email']?.toString() ??
          json['authorizedUserEmail']?.toString() ??
          '',
      grantedByUserId: json['grantedByUserId']?.toString(),
      spaceId:
          (json['spaceId'] as num?)?.toInt() ??
          (json['labId'] as num?)?.toInt() ??
          (spaceJson?['id'] as num?)?.toInt() ??
          0,
      spaceName:
          spaceJson?['name']?.toString() ?? json['spaceName']?.toString(),
      reason: json['reason']?.toString() ?? '',
      status: AccessGrantStatus.fromJson(json['status']),
      grantedAt: DateTime.tryParse(json['grantedAt']?.toString() ?? ''),
      revokedAt: DateTime.tryParse(json['revokedAt']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

class RequestAccessPayload {
  const RequestAccessPayload({required this.spaceId, required this.reason});

  final int spaceId;
  final String reason;

  Map<String, dynamic> toJson() => {'spaceId': spaceId, 'reason': reason};
}

class AccessGrantReviewPayload {
  const AccessGrantReviewPayload({required this.approved});

  final bool approved;

  Map<String, dynamic> toJson() => {'approved': approved};
}
