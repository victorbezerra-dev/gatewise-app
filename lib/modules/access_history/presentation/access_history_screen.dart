import 'package:flutter/material.dart';

import '../../../core/theme/gatewise_theme.dart';

class AccessHistoryScreen extends StatelessWidget {
  const AccessHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 122),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const Text(
            'Histórico',
            style: TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 25,
              height: 1.05,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 18),
          GlassPanel(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: GateWiseColors.electricBlue.withValues(alpha: 0.14),
                    border: Border.all(
                      color: GateWiseColors.electricBlue.withValues(
                        alpha: 0.24,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: GateWiseColors.electricBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nenhum acesso registrado',
                        style: TextStyle(
                          color: GateWiseColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Quando você acessar um ambiente, o registro aparecerá aqui.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.58),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
