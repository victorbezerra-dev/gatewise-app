import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/entities/equipment_entity.dart';
import 'button_form_sheet.dart';
import 'control_buttons.dart';

/// Lays out an equipment's buttons as a remote control, in the style of the
/// air conditioner panel. Buttons are placed by their icon (power, volume,
/// channel, arrows, digits...); the rest are listed under "other buttons".
class RemoteControlPanel extends StatefulWidget {
  const RemoteControlPanel({
    super.key,
    required this.buttons,
    required this.enabled,
    required this.sending,
    required this.onPressed,
    this.onLongPress,
  });

  final List<EquipmentButton> buttons;
  final bool enabled;
  final bool sending;
  final ValueChanged<EquipmentButton> onPressed;
  final ValueChanged<EquipmentButton>? onLongPress;

  @override
  State<RemoteControlPanel> createState() => _RemoteControlPanelState();
}

class _RemoteControlPanelState extends State<RemoteControlPanel> {
  bool _showDigits = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final slots = _RemoteSlots(widget.buttons);

    VoidCallback? tap(EquipmentButton? button) =>
        button == null || !widget.enabled
        ? null
        : () => widget.onPressed(button);
    VoidCallback? hold(EquipmentButton? button) =>
        button == null || widget.onLongPress == null
        ? null
        : () => widget.onLongPress!(button);

    Widget round(String icon, {double size = 48}) {
      final button = slots.take(icon);
      if (button == null) return SizedBox(width: size, height: size);
      return RoundIconButton(
        icon: buttonIconFor(icon),
        size: size,
        tooltip: button.name,
        onPressed: tap(button),
        onLongPress: hold(button),
      );
    }

    final power = slots.take('power');
    final topRow = [
      for (final icon in ['input', 'mute', 'home', 'back']) icon,
    ].where(slots.has).toList();
    final volumeUp = slots.take('volume_up');
    final volumeDown = slots.take('volume_down');
    final channelUp = slots.take('channel_up');
    final channelDown = slots.take('channel_down');
    final hasPad = ['up', 'down', 'left', 'right', 'ok'].any(slots.has);
    final hasRockers =
        volumeUp != null ||
        volumeDown != null ||
        channelUp != null ||
        channelDown != null;
    final topButtons = [for (final icon in topRow) round(icon)];
    final pad = hasPad
        ? _DirectionalPad(
            up: round('up', size: 44),
            down: round('down', size: 44),
            left: round('left', size: 44),
            right: round('right', size: 44),
            ok: round('ok', size: 54),
          )
        : null;
    final bottomRow = [
      for (final icon in ['menu', 'info', 'exit', 'play'])
        if (slots.has(icon)) round(icon),
    ];
    final digits = slots.takeDigits();
    final others = slots.rest();

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.remoteTitle,
                  style: const TextStyle(
                    color: GateWiseColors.neonCyan,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (widget.sending)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: GateWiseColors.neonCyan,
                    ),
                  ),
                ),
              if (power != null)
                PowerButton(
                  color: GateWiseColors.danger,
                  enabled: widget.enabled,
                  tooltip: power.name,
                  onPressed: () => widget.onPressed(power),
                  onLongPress: hold(power),
                ),
            ],
          ),
          if (topButtons.isNotEmpty) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: topButtons,
            ),
          ],
          if (hasPad || hasRockers) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Rocker(
                  label: l.remoteVolumeLabel,
                  up: volumeUp,
                  down: volumeDown,
                  onTap: tap,
                  onHold: hold,
                ),
                pad ?? const SizedBox.shrink(),
                _Rocker(
                  label: l.remoteChannelLabel,
                  up: channelUp,
                  down: channelDown,
                  onTap: tap,
                  onHold: hold,
                ),
              ],
            ),
          ],
          if (bottomRow.isNotEmpty) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: bottomRow,
            ),
          ],
          if (digits.isNotEmpty) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => setState(() => _showDigits = !_showDigits),
              icon: Icon(
                _showDigits ? Icons.expand_less_rounded : Icons.dialpad_rounded,
                size: 18,
              ),
              label: Text(l.remoteNumbersToggle),
            ),
            if (_showDigits)
              _DigitPad(digits: digits, onTap: tap, onHold: hold),
          ],
          if (others.isNotEmpty) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l.remoteOtherButtons,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final button in others)
                  GestureDetector(
                    onLongPress: hold(button),
                    child: ActionChip(
                      avatar: Icon(buttonIconFor(button.icon), size: 16),
                      label: Text(button.name),
                      backgroundColor: GateWiseColors.surfaceLight.withValues(
                        alpha: 0.4,
                      ),
                      labelStyle: const TextStyle(
                        color: GateWiseColors.textPrimary,
                        fontSize: 12,
                      ),
                      onPressed: tap(button),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Buttons grouped by icon. Each slot takes the first button with that icon;
/// duplicates and unknown icons end up in [rest].
class _RemoteSlots {
  _RemoteSlots(List<EquipmentButton> buttons)
    : _remaining = [...buttons]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final List<EquipmentButton> _remaining;

  bool has(String icon) => _remaining.any((b) => b.icon == icon);

  EquipmentButton? take(String icon) {
    final index = _remaining.indexWhere((b) => b.icon == icon);
    return index < 0 ? null : _remaining.removeAt(index);
  }

  /// Digit buttons ordered 1–9 then 0, as on a remote.
  List<EquipmentButton> takeDigits() {
    final digits = _remaining.where((b) => b.icon == 'digit').toList();
    _remaining.removeWhere((b) => b.icon == 'digit');
    int order(EquipmentButton b) {
      final value = int.tryParse(b.name.trim());
      return value == null ? 99 : (value == 0 ? 10 : value);
    }

    return digits..sort((a, b) => order(a).compareTo(order(b)));
  }

  List<EquipmentButton> rest() => List.unmodifiable(_remaining);
}

class _Rocker extends StatelessWidget {
  const _Rocker({
    required this.label,
    required this.up,
    required this.down,
    required this.onTap,
    required this.onHold,
  });

  final String label;
  final EquipmentButton? up;
  final EquipmentButton? down;
  final VoidCallback? Function(EquipmentButton?) onTap;
  final VoidCallback? Function(EquipmentButton?) onHold;

  @override
  Widget build(BuildContext context) {
    if (up == null && down == null) return const SizedBox(width: 60);
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: GateWiseColors.electricBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          IconButton(
            onPressed: onTap(up),
            onLongPress: onHold(up),
            tooltip: up?.name,
            color: GateWiseColors.neonCyan,
            icon: const Icon(Icons.add_rounded),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          IconButton(
            onPressed: onTap(down),
            onLongPress: onHold(down),
            tooltip: down?.name,
            color: GateWiseColors.neonCyan,
            icon: const Icon(Icons.remove_rounded),
          ),
        ],
      ),
    );
  }
}

class _DirectionalPad extends StatelessWidget {
  const _DirectionalPad({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
    required this.ok,
  });

  final Widget up;
  final Widget down;
  final Widget left;
  final Widget right;
  final Widget ok;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 156,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GateWiseColors.electricBlue.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(alignment: Alignment.topCenter, child: up),
          Align(alignment: Alignment.bottomCenter, child: down),
          Align(alignment: Alignment.centerLeft, child: left),
          Align(alignment: Alignment.centerRight, child: right),
          ok,
        ],
      ),
    );
  }
}

class _DigitPad extends StatelessWidget {
  const _DigitPad({
    required this.digits,
    required this.onTap,
    required this.onHold,
  });

  final List<EquipmentButton> digits;
  final VoidCallback? Function(EquipmentButton?) onTap;
  final VoidCallback? Function(EquipmentButton?) onHold;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: [
        for (final (index, button) in digits.indexed) ...[
          // 0 sits under 8, like on a remote.
          if (index == 9 && digits.length == 10) const SizedBox.shrink(),
          _digit(button),
        ],
      ],
    );
  }

  Widget _digit(EquipmentButton button) {
    return Material(
      color: GateWiseColors.surfaceLight.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap(button),
        onLongPress: onHold(button),
        child: Center(
          child: Text(
            button.name,
            style: const TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
