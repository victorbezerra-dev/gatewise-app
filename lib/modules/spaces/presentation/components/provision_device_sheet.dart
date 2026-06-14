import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../space_providers.dart';

class ProvisionDeviceSheet extends StatelessWidget {
  const ProvisionDeviceSheet({super.key, required this.result});

  final DeviceProvisionResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GateWiseColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: GateWiseColors.mint.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.memory_rounded,
                    color: GateWiseColors.mint,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispositivo provisionado',
                        style: TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Copie e grave as chaves no ESP32.',
                        style: TextStyle(
                          color: GateWiseColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _WarningBanner(),
            const SizedBox(height: 18),
            _PemKeyCard(
              label: 'Chave Pública do Backend',
              subtitle: 'Para verificar comandos MQTT no ESP32.',
              icon: Icons.vpn_key_rounded,
              color: GateWiseColors.electricBlue,
              pem: result.backendPublicKeyPem,
            ),
            const SizedBox(height: 12),
            _PemKeyCard(
              label: 'Chave Privada do Dispositivo',
              subtitle: 'Flashe esta chave no hardware. Não será exibida novamente.',
              icon: Icons.lock_rounded,
              color: GateWiseColors.amber,
              pem: result.devicePrivateKeyPem,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: GateWiseColors.surfaceLight,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GateWiseColors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GateWiseColors.amber.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: GateWiseColors.amber,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'A chave privada do dispositivo não fica armazenada no servidor. '
              'Guarde-a com segurança antes de fechar esta tela.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PemKeyCard extends StatelessWidget {
  const _PemKeyCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.pem,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String pem;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: GateWiseColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _CopyButton(text: pem, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.48),
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GateWiseColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.18)),
            ),
            child: Text(
              pem,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: GateWiseColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _copied
            ? Icon(Icons.check_rounded, key: const ValueKey('check'), color: GateWiseColors.mint, size: 18)
            : Icon(Icons.copy_rounded, key: const ValueKey('copy'), color: widget.color, size: 18),
      ),
    );
  }
}
