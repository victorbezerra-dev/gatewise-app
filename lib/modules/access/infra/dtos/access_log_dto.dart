import '../../domain/entities/access_log_entity.dart';
import '../../domain/value_objects/access_log_status_vo.dart';

class AccessLogDto {
  static AccessLog fromJson(Map<String, dynamic> json) {
    return AccessLog(
      id: json['id']?.toString() ?? '',
      commandId: json['commandId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      spaceId: (json['spaceId'] as num?)?.toInt() ?? 0,
      spaceName: json['spaceName']?.toString() ?? '',
      issuedAt: DateTime.parse(json['issuedAt'].toString()),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.tryParse(json['confirmedAt'].toString())
          : null,
      status: AccessLogStatus.fromJson(json['status']),
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
