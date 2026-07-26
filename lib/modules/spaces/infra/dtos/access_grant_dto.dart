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
      authorizedUserAvatarUrl:
          userJson?['userAvatarUrl']?.toString() ??
          json['authorizedUserAvatarUrl']?.toString(),
      grantedByUserId: json['grantedByUserId']?.toString(),
      grantedByUserAvatarUrl: json['grantedByUserAvatarUrl']?.toString(),
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

enum AccessGrantReviewStatus {
  approved(1),
  rejected(2);

  const AccessGrantReviewStatus(this.value);
  final int value;
}

class AccessGrantReviewPayload {
  const AccessGrantReviewPayload({required this.status, this.reason});

  final AccessGrantReviewStatus status;
  final String? reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'status': status.value};
    if (reason != null && reason!.isNotEmpty) map['reason'] = reason;
    return map;
  }
}
