import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../../organizations/domain/value_objects/organization_member_role_vo.dart';
import '../../organizations/presentation/organization_providers.dart';
import '../../spaces/domain/entities/space_entity.dart';
import 'access_log_providers.dart';
import 'components/history_tab_bar.dart';
import 'components/space_picker_sheet.dart';
import 'grants_tab.dart';
import 'logs_tab.dart';

class AccessScreen extends ConsumerStatefulWidget {
  const AccessScreen({super.key});

  @override
  ConsumerState<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends ConsumerState<AccessScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _canViewSpaceLogs {
    final role = ref
        .read(organizationControllerProvider)
        .viewerMembership
        ?.role;
    return role == null ||
        role == OrganizationMemberRole.owner ||
        role == OrganizationMemberRole.manager;
  }

  Future<void> _openSpacePicker(AccessLogController controller) async {
    final space = await showModalBottomSheet<Space>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SpacePickerSheet(),
    );
    if (space != null) {
      controller.setSpaceMode(space.id, space.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.accessTitle,
                style: const TextStyle(
                  color: GateWiseColors.textPrimary,
                  fontSize: 25,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 14),
              HistoryTabBar(controller: _tabController),
              const SizedBox(height: 2),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LogsTab(
                canViewSpaceLogs: _canViewSpaceLogs,
                onOpenSpacePicker: _openSpacePicker,
              ),
              const GrantsTab(),
            ],
          ),
        ),
      ],
    );
  }
}
