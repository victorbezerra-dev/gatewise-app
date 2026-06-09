import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_invite_entity.dart';
import 'org_ui_helpers.dart';
import 'role_badge.dart';

class InviteCard extends StatelessWidget {
  const InviteCard({super.key, required this.invite, required this.onRevoke});

  final OrganizationInvite invite;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        borderRadius: 18,
        opacity: 0.56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    invite.code,
                    style: const TextStyle(
                      color: GateWiseColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copiar código',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: invite.code));
                    if (context.mounted) showSnack(context, 'Código copiado.');
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: GateWiseColors.electricBlue,
                  ),
                ),
                IconButton(
                  tooltip: 'Revogar convite',
                  onPressed: onRevoke,
                  icon: const Icon(
                    Icons.link_off_rounded,
                    color: GateWiseColors.danger,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                RoleBadge(role: invite.role),
                TechStatusPill(
                  label: invite.isActive ? 'ATIVO' : 'INATIVO',
                  icon: invite.isActive
                      ? Icons.check_rounded
                      : Icons.block_rounded,
                  color: invite.isActive
                      ? GateWiseColors.mint
                      : GateWiseColors.danger,
                ),
                TechStatusPill(
                  label:
                      '${invite.usesCount}/${invite.maxUses?.toString() ?? '∞'} USOS',
                  icon: Icons.group_add_rounded,
                  color: GateWiseColors.amber,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Expira em: ${formatDate(invite.expiresAt)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.54),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
