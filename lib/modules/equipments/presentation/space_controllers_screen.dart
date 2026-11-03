import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/gatewise_theme.dart';
import 'components/controllers_section.dart';
import 'equipment_providers.dart';

class SpaceControllersScreen extends ConsumerWidget {
  const SpaceControllersScreen({super.key, required this.spaceId});

  final int spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: GateWiseColors.background,
      appBar: AppBar(
        title: Text(context.l.controllersScreenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: TechBackground(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            color: GateWiseColors.electricBlue,
            backgroundColor: GateWiseColors.surface,
            onRefresh: () async =>
                ref.invalidate(spaceControllersProvider(spaceId)),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [ControllersSection(spaceId: spaceId)],
            ),
          ),
        ),
      ),
    );
  }
}
