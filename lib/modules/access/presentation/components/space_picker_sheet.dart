import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../../organizations/presentation/organization_providers.dart';
import '../../../spaces/domain/entities/space_entity.dart';
import '../../../spaces/presentation/space_providers.dart';

class SpacePickerSheet extends ConsumerStatefulWidget {
  const SpacePickerSheet({super.key});

  @override
  ConsumerState<SpacePickerSheet> createState() => _SpacePickerSheetState();
}

class _SpacePickerSheetState extends ConsumerState<SpacePickerSheet> {
  bool _loadRequested = false;
  bool _missingOrganization = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_ensureSpacesLoaded);
  }

  void _ensureSpacesLoaded() {
    if (_loadRequested) return;

    final orgId = ref
        .read(organizationControllerProvider)
        .selectedOrganization
        .valueOrNull
        ?.id;
    if (orgId == null) {
      if (mounted) {
        setState(() {
          _loadRequested = true;
          _missingOrganization = true;
        });
      }
      return;
    }

    _loadRequested = true;
    final current = ref.read(spaceControllerProvider).spaces;
    final spaces = current.valueOrNull;
    if (spaces == null) {
      ref.read(spaceControllerProvider.notifier).loadSpaces(orgId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spaceControllerProvider).spaces;
    final content = _missingOrganization
        ? const _SpacePickerMessage(message: 'Nenhuma organização disponível')
        : spacesAsync.when(
            loading: () => _loadRequested
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: CircularProgressIndicator(
                        color: GateWiseColors.neonCyan,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : const _SpacePickerMessage(
                    message: 'Nenhum espaço disponível.',
                  ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                e.toString(),
                style: const TextStyle(
                  color: GateWiseColors.danger,
                  fontSize: 13,
                ),
              ),
            ),
            data: (spaces) {
              if (spaces.isEmpty) {
                return const _SpacePickerMessage(
                  message: 'Nenhum espaço disponível.',
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: spaces.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _SpaceRow(
                  space: spaces[i],
                  onTap: () => Navigator.of(context).pop(spaces[i]),
                ),
              );
            },
          );

    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        18 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: GateWiseColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Selecionar Espaço',
            style: TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Escolha o espaço cujos acessos deseja monitorar.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SpacePickerMessage extends StatelessWidget {
  const _SpacePickerMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SpaceRow extends StatelessWidget {
  const _SpaceRow({required this.space, required this.onTap});

  final Space space;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: 16,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
                border: Border.all(
                  color: GateWiseColors.electricBlue.withValues(alpha: 0.28),
                ),
              ),
              child: const Icon(
                Icons.sensor_door_rounded,
                color: GateWiseColors.electricBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                space.name,
                style: const TextStyle(
                  color: GateWiseColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: GateWiseColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
