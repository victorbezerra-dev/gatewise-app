import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../../../modules/organizations/presentation/components/status_panels.dart';
import '../../domain/entities/space_entity.dart';
import '../space_providers.dart';
import 'esp32_tutorial_sheet.dart';

class DeviceSection extends StatelessWidget {
  const DeviceSection({
    super.key,
    required this.space,
    required this.notifier,
    required this.onProvision,
    required this.onDownloadKey,
  });

  final Space space;
  final SpaceController notifier;
  final VoidCallback onProvision;
  final VoidCallback onDownloadKey;

  void _openTutorial(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Esp32TutorialSheet(spaceId: space.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(context.l.spaceDeviceSection),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: GateWiseColors.electricBlue.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.memory_rounded,
                      color: GateWiseColors.electricBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l.spaceDeviceHardware,
                          style: const TextStyle(
                            color: GateWiseColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l.spaceDeviceDesc,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.48),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: context.l.spaceEsp32TutorialTitle,
                    onPressed: () => _openTutorial(context),
                    style: IconButton.styleFrom(
                      backgroundColor: GateWiseColors.electricBlue.withValues(
                        alpha: 0.12,
                      ),
                      foregroundColor: GateWiseColors.neonCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.help_outline_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onProvision,
                icon: const Icon(
                  Icons.settings_input_component_rounded,
                  size: 17,
                ),
                label: Text(context.l.spaceDeviceProvisionButton),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onDownloadKey,
                icon: const Icon(Icons.ios_share_rounded, size: 17),
                label: Text(context.l.spaceDeviceBackendKeyButton),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
