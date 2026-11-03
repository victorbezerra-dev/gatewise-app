import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import '../domain/entities/equipment_entity.dart';
import 'components/equipment_form_sheet.dart';
import 'components/equipment_list.dart';
import 'equipment_providers.dart';

class SpaceEquipmentsScreen extends ConsumerWidget {
  const SpaceEquipmentsScreen({
    super.key,
    required this.spaceId,
    required this.canManage,
  });

  final int spaceId;
  final bool canManage;

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final created = await showModalBottomSheet<Equipment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EquipmentFormSheet(spaceId: spaceId),
    );
    ref.invalidate(spaceEquipmentsProvider(spaceId));
    if (created == null || !context.mounted) return;
    await context.push('/spaces/$spaceId/equipments/${created.id}');
    ref.invalidate(spaceEquipmentsProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: Text(context.l.equipmentsSection),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              backgroundColor: GateWiseColors.electricBlue,
              foregroundColor: Colors.white,
              onPressed: () => _create(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l.equipmentsAddButton),
            )
          : null,
      body: TechBackground(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            color: GateWiseColors.electricBlue,
            backgroundColor: GateWiseColors.surface,
            onRefresh: () async =>
                ref.invalidate(spaceEquipmentsProvider(spaceId)),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Bottom padding keeps the last card clear of the FAB.
              padding: EdgeInsets.fromLTRB(18, 8, 18, canManage ? 96 : 24),
              children: [EquipmentList(spaceId: spaceId, canManage: canManage)],
            ),
          ),
        ),
      ),
    );
  }
}
