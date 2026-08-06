import '../../domain/entities/join_organization_result_entity.dart';
import '../../domain/value_objects/join_organization_status_vo.dart';
import 'organization_dto.dart';

class JoinOrganizationResponseDto {
  static JoinOrganizationResult fromJson(Map<String, dynamic> json) =>
      JoinOrganizationResult(
        status: JoinOrganizationStatus.fromJson(json['status']),
        organization: OrganizationDto.fromJson(
          (json['organization'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
        addedSpaceIds: (json['addedSpaceIds'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [],
        alreadyGrantedSpaceIds: (json['alreadyGrantedSpaceIds'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [],
      );
}
