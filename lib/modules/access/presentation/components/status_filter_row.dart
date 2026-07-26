import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/gatewise_theme.dart';
import '../../domain/value_objects/access_log_status_vo.dart';

class StatusFilterRow extends StatelessWidget {
  const StatusFilterRow({
    super.key,
    required this.selected,
    required this.fromDate,
    required this.toDate,
    required this.hasActiveFilters,
    required this.onStatusSelected,
    required this.onDateRangeSelected,
    required this.onClearFilters,
  });

  final AccessLogStatus? selected;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool hasActiveFilters;
  final void Function(AccessLogStatus?) onStatusSelected;
  final void Function(DateTimeRange?) onDateRangeSelected;
  final VoidCallback onClearFilters;

  static const _filters = [
    null,
    AccessLogStatus.granted,
    AccessLogStatus.pendingConfirmation,
    AccessLogStatus.noConfirmation,
    AccessLogStatus.deniedByPolicy,
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filters.map((filter) {
              final isSelected = selected == filter;
              final label = filter == null ? 'Todos' : filter.label;
              final chipColor = _chipColor(filter);

              return _FilterChipButton(
                label: label,
                color: chipColor,
                isSelected: isSelected,
                onTap: () => onStatusSelected(filter),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DateFilterButton(
                  label: _dateLabel,
                  isSelected: fromDate != null && toDate != null,
                  onTap: () => _pickDateRange(context),
                ),
              ),
              if (fromDate != null && toDate != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Remover data',
                  onPressed: () => onDateRangeSelected(null),
                  style: IconButton.styleFrom(
                    backgroundColor: GateWiseColors.surfaceGlass.withValues(
                      alpha: 0.72,
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: GateWiseColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String get _dateLabel {
    if (fromDate == null || toDate == null) return 'Filtrar por data';
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(fromDate!.toLocal())} - ${formatter.format(toDate!.toLocal())}';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final initialRange = fromDate != null && toDate != null
        ? DateTimeRange(start: fromDate!, end: toDate!)
        : DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initialRange,
      helpText: 'Filtrar histórico por data',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      saveText: 'Aplicar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: GateWiseColors.neonCyan,
              onPrimary: GateWiseColors.background,
              surface: GateWiseColors.surface,
              onSurface: GateWiseColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: GateWiseColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) onDateRangeSelected(picked);
  }

  static Color _chipColor(AccessLogStatus? status) {
    if (status == null) return GateWiseColors.neonCyan;
    if (status.isSuccess) return GateWiseColors.mint;
    if (status.isFailure) return GateWiseColors.danger;
    return GateWiseColors.amber;
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
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

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? GateWiseColors.neonCyan
        : GateWiseColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? GateWiseColors.neonCyan.withValues(alpha: 0.16)
              : GateWiseColors.surfaceGlass.withValues(alpha: 0.72),
          border: Border.all(
            color: isSelected
                ? GateWiseColors.neonCyan.withValues(alpha: 0.58)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.expand_more_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
