import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';

class HistoryTabBar extends StatelessWidget {
  const HistoryTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceGlass.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: GateWiseColors.electricBlue.withValues(alpha: 0.22),
          border: Border.all(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.5),
          ),
        ),
        dividerColor: Colors.transparent,
        labelColor: GateWiseColors.electricBlue,
        unselectedLabelColor: GateWiseColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Logs de Acesso'),
          Tab(text: 'Solicitações'),
        ],
      ),
    );
  }
}
