import 'organization_entity.dart';
import '../value_objects/join_organization_status_vo.dart';

class JoinOrganizationResult {
  const JoinOrganizationResult({
    required this.status,
    required this.organization,
    this.addedSpaceIds = const [],
    this.alreadyGrantedSpaceIds = const [],
  });

  final JoinOrganizationStatus status;
  final Organization organization;
  final List<int> addedSpaceIds;
  final List<int> alreadyGrantedSpaceIds;
}
