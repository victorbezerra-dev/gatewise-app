import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/organization_invite_entity.dart';
import '../../domain/value_objects/organization_member_role_vo.dart';
import 'org_ui_helpers.dart';
import 'role_badge.dart';

const _kMaxVisibleSpaces = 3;

class InviteCard extends StatefulWidget {
  const InviteCard({
    super.key,
    required this.invite,
    this.onRevoke,
    this.onRemoveSpace,
  });

  final OrganizationInvite invite;
  final VoidCallback? onRevoke;
  final void Function(int spaceId)? onRemoveSpace;

  @override
  State<InviteCard> createState() => _InviteCardState();
}

class _InviteCardState extends State<InviteCard> {
  bool _spacesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final invite = widget.invite;
    final hasSpaces = invite.spaces.isNotEmpty;
    final hasMemberWindow = invite.role == OrganizationMemberRole.member &&
        (invite.memberStartsAt != null || invite.memberExpiresAt != null);
    final hasMore = invite.spaces.length > _kMaxVisibleSpaces;
    final visibleSpaces = _spacesExpanded
        ? invite.spaces
        : invite.spaces.take(_kMaxVisibleSpaces).toList();

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
                if (widget.onRevoke != null && invite.isActive)
                  IconButton(
                    tooltip: 'Revogar convite',
                    onPressed: widget.onRevoke,
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
                  label: invite.isActive
                      ? context.l.statusActive
                      : context.l.statusInactive,
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
            if (hasMemberWindow) ...[
              const SizedBox(height: 4),
              Text(
                'Acesso do membro: ${formatDate(invite.memberStartsAt)} → ${formatDate(invite.memberExpiresAt)}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.54),
                  fontSize: 12,
                ),
              ),
            ],
            if (hasSpaces) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.sensor_door_rounded,
                    size: 15,
                    color: GateWiseColors.electricBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Espaços',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final space in visibleSpaces)
                    _SpaceChip(
                      name: space.name,
                      onRemove: widget.onRemoveSpace != null && invite.isActive
                          ? () => widget.onRemoveSpace!(space.spaceId)
                          : null,
                    ),
                  if (hasMore)
                    _ToggleChip(
                      label: _spacesExpanded
                          ? 'ver menos'
                          : '+${invite.spaces.length - _kMaxVisibleSpaces} mais',
                      onTap: () =>
                          setState(() => _spacesExpanded = !_spacesExpanded),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpaceChip extends StatelessWidget {
  const _SpaceChip({required this.name, this.onRemove});

  final String name;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 9,
        right: onRemove != null ? 4 : 9,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: GateWiseColors.electricBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: GateWiseColors.electricBlue.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sensor_door_rounded,
            size: 12,
            color: GateWiseColors.electricBlue.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              color: GateWiseColors.electricBlue.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
