import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/custom_http_client_provider.dart';
import '../domain/entities/organization_entity.dart';
import '../domain/entities/organization_invite_entity.dart';
import '../domain/entities/organization_member_entity.dart';
import '../domain/value_objects/organization_member_role_vo.dart';
import '../infra/dtos/create_invite_dto.dart';
import '../infra/dtos/organization_payload_dto.dart';
import '../infra/organization_repository.dart';

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository(ref.watch(customHttpClientProvider));
});

final organizationControllerProvider =
    StateNotifierProvider<OrganizationController, OrganizationState>((ref) {
      return OrganizationController(ref.watch(organizationRepositoryProvider));
    });

class OrganizationState {
  const OrganizationState({
    this.memberships = const AsyncLoading(),
    this.ownedOrganizations = const AsyncData([]),
    this.selectedOrganization = const AsyncData(null),
    this.viewerMembership,
    this.members = const AsyncData([]),
    this.invites = const AsyncData([]),
    this.action = const AsyncData(null),
    this.actionErrorMessage,
  });

  final AsyncValue<List<OrganizationMembership>> memberships;
  final AsyncValue<List<Organization>> ownedOrganizations;
  final AsyncValue<Organization?> selectedOrganization;
  final OrganizationMembership? viewerMembership;
  final AsyncValue<List<OrganizationMember>> members;
  final AsyncValue<List<OrganizationInvite>> invites;
  final AsyncValue<void> action;
  final String? actionErrorMessage;

  OrganizationState copyWith({
    AsyncValue<List<OrganizationMembership>>? memberships,
    AsyncValue<List<Organization>>? ownedOrganizations,
    AsyncValue<Organization?>? selectedOrganization,
    OrganizationMembership? viewerMembership,
    bool clearViewerMembership = false,
    AsyncValue<List<OrganizationMember>>? members,
    AsyncValue<List<OrganizationInvite>>? invites,
    AsyncValue<void>? action,
    String? actionErrorMessage,
    bool clearActionErrorMessage = false,
  }) {
    return OrganizationState(
      memberships: memberships ?? this.memberships,
      ownedOrganizations: ownedOrganizations ?? this.ownedOrganizations,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      viewerMembership: clearViewerMembership
          ? null
          : viewerMembership ?? this.viewerMembership,
      members: members ?? this.members,
      invites: invites ?? this.invites,
      action: action ?? this.action,
      actionErrorMessage: clearActionErrorMessage
          ? null
          : actionErrorMessage ?? this.actionErrorMessage,
    );
  }
}

class OrganizationController extends StateNotifier<OrganizationState> {
  OrganizationController(this._repository) : super(const OrganizationState());

  final OrganizationRepository _repository;

  Future<void> loadInitial() async {
    await Future.wait([
      loadMemberships(),
      loadAdminOrganizations(silent: true),
    ]);
  }

  Future<void> loadMemberships() async {
    state = state.copyWith(memberships: const AsyncLoading());
    try {
      final data = await _repository.listMemberships();
      state = state.copyWith(memberships: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(memberships: AsyncError(e, st));
    }
  }

  Future<void> loadAdminOrganizations({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(ownedOrganizations: const AsyncLoading());
    }

    try {
      final data = await _repository.listOrganizations();
      state = state.copyWith(ownedOrganizations: AsyncData(data));
    } on OrganizationApiException catch (e, st) {
      if (e.statusCode == 403) {
        state = state.copyWith(ownedOrganizations: const AsyncData([]));
        return;
      }
      state = state.copyWith(ownedOrganizations: AsyncError(e, st));
    } catch (e, st) {
      state = state.copyWith(ownedOrganizations: AsyncError(e, st));
    }
  }

  Future<void> loadOrganizationDetails(int id) async {
    state = state.copyWith(
      selectedOrganization: const AsyncLoading(),
      members: const AsyncLoading(),
      invites: const AsyncLoading(),
      clearViewerMembership: true,
    );

    await Future.wait([loadOrganization(id), loadMembers(id), loadInvites(id)]);
  }

  Future<void> loadOrganization(int id) async {
    try {
      final membership = await _repository.getById(id);
      state = state.copyWith(
        selectedOrganization: AsyncData(membership.organization),
        viewerMembership: membership,
      );
    } catch (e, st) {
      state = state.copyWith(selectedOrganization: AsyncError(e, st));
    }
  }

  Future<void> loadMembers(int organizationId) async {
    state = state.copyWith(members: const AsyncLoading());
    try {
      final members = await _repository.listMembers(organizationId);
      state = state.copyWith(members: AsyncData(members));
    } on OrganizationApiException catch (e, st) {
      if (e.statusCode == 403) {
        state = state.copyWith(members: const AsyncData([]));
        return;
      }
      state = state.copyWith(members: AsyncError(e, st));
    } catch (e, st) {
      state = state.copyWith(members: AsyncError(e, st));
    }
  }

  Future<void> loadInvites(int organizationId) async {
    state = state.copyWith(invites: const AsyncLoading());
    try {
      final invites = await _repository.listInvites(organizationId);
      state = state.copyWith(invites: AsyncData(invites));
    } on OrganizationApiException catch (e, st) {
      if (e.statusCode == 403) {
        state = state.copyWith(invites: const AsyncData([]));
        return;
      }
      state = state.copyWith(invites: AsyncError(e, st));
    } catch (e, st) {
      state = state.copyWith(invites: AsyncError(e, st));
    }
  }

  Future<Organization?> createOrganization(OrganizationPayload payload) async {
    return _runAction(() async {
      final organization = await _repository.create(payload);
      await loadInitial();
      return organization;
    });
  }

  Future<bool> updateOrganization(int id, OrganizationPayload payload) async {
    final result = await _runAction(() async {
      await _repository.update(id, payload);
      await loadOrganizationDetails(id);
      await loadInitial();
      return true;
    });
    return result ?? false;
  }

  Future<bool> deleteOrganization(int id) async {
    final result = await _runAction(() async {
      await _repository.deleteOrganization(id);
      await loadInitial();
      return true;
    });
    return result ?? false;
  }

  Future<OrganizationInvite?> createInvite(
    int organizationId,
    CreateInvitePayload payload,
  ) async {
    return _runAction(() async {
      final invite = await _repository.createInvite(organizationId, payload);
      await loadInvites(organizationId);
      return invite;
    });
  }

  Future<Organization?> joinByCode(String code) async {
    return _runAction(() async {
      final organization = await _repository.joinByCode(code);
      await loadInitial();
      return organization;
    });
  }

  Future<bool> removeMember(int organizationId, int memberId) async {
    final result = await _runAction(() async {
      await _repository.removeMember(organizationId, memberId);
      await loadMembers(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> revokeInvite(int organizationId, int inviteId) async {
    final result = await _runAction(() async {
      await _repository.revokeInvite(organizationId, inviteId);
      await loadInvites(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> removeSpaceFromInvite(
    int organizationId,
    int inviteId,
    int spaceId,
  ) async {
    final result = await _runAction(() async {
      await _repository.removeSpaceFromInvite(organizationId, inviteId, spaceId);
      await loadInvites(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> updateMemberRole(
    int organizationId,
    int memberId,
    OrganizationMemberRole role,
  ) async {
    final result = await _runAction(() async {
      await _repository.updateMemberRole(organizationId, memberId, role);
      await loadMembers(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<bool> removeSpaceManager(
    int organizationId,
    int spaceId,
    int spaceManagerId,
  ) async {
    final result = await _runAction(() async {
      await _repository.removeSpaceManager(organizationId, spaceId, spaceManagerId);
      await loadMembers(organizationId);
      return true;
    });
    return result ?? false;
  }

  Future<T?> _runAction<T>(Future<T> Function() action) async {
    state = state.copyWith(
      action: const AsyncLoading(),
      clearActionErrorMessage: true,
    );
    try {
      final result = await action();
      state = state.copyWith(
        action: const AsyncData(null),
        clearActionErrorMessage: true,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        action: const AsyncData(null),
        actionErrorMessage: e.toString(),
      );
      return null;
    }
  }
}
