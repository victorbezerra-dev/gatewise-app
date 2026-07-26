import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../../spaces/domain/value_objects/access_grant_status_vo.dart';
import '../grant_request_providers.dart';

class GrantFilterRow extends StatelessWidget {
  const GrantFilterRow({
    super.key,
    required this.viewType,
    required this.statusFilter,
    required this.canReview,
    required this.hasActiveFilters,
    required this.onViewTypeChanged,
    required this.onStatusChanged,
    required this.onClearFilters,
  });

  final GrantViewType viewType;
  final AccessGrantStatus? statusFilter;
  final bool canReview;
  final bool hasActiveFilters;
  final void Function(GrantViewType) onViewTypeChanged;
  final void Function(AccessGrantStatus?) onStatusChanged;
  final VoidCallback onClearFilters;

  static const _statuses = [
    null,
    AccessGrantStatus.pending,
    AccessGrantStatus.granted,
    AccessGrantStatus.rejected,
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                color: GateWiseColors.neonCyan,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Filtros',
                  style: TextStyle(
                    color: GateWiseColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (hasActiveFilters)
                TextButton.icon(
                  onPressed: onClearFilters,
                  style: TextButton.styleFrom(
                    foregroundColor: GateWiseColors.neonCyan,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Limpar'),
                ),
            ],
          ),
          if (canReview) ...[
            const SizedBox(height: 12),
            GlassPanel(
              padding: const EdgeInsets.all(4),
              borderRadius: 16,
              child: Row(
                children: [
                  Expanded(
                    child: _TypeChip(
                      label: 'Minhas',
                      icon: Icons.person_rounded,
                      isSelected: viewType == GrantViewType.mine,
                      color: GateWiseColors.neonCyan,
                      onTap: () => onViewTypeChanged(GrantViewType.mine),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _TypeChip(
                      label: 'Para revisar',
                      icon: Icons.rate_review_rounded,
                      isSelected: viewType == GrantViewType.toReview,
                      color: GateWiseColors.electricBlue,
                      onTap: () => onViewTypeChanged(GrantViewType.toReview),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((s) {
              final isSelected = statusFilter == s;
              final label = s == null ? 'Todos' : s.label(context);
              final color = _chipColor(s);
              return _FilterChip(
                label: label,
                color: color,
                isSelected: isSelected,
                onTap: () => onStatusChanged(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static Color _chipColor(AccessGrantStatus? s) {
    if (s == null) return GateWiseColors.neonCyan;
    return switch (s) {
      AccessGrantStatus.pending => GateWiseColors.amber,
      AccessGrantStatus.granted => GateWiseColors.mint,
      AccessGrantStatus.rejected => GateWiseColors.danger,
    };
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? color : GateWiseColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : GateWiseColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? color.withValues(alpha: 0.22)
              : GateWiseColors.surfaceGlass.withValues(alpha: 0.72),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : GateWiseColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
