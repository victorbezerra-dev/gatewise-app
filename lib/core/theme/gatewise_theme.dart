import 'dart:math' as math;

import 'package:flutter/material.dart';

class GateWiseColors {
  const GateWiseColors._();

  static const background = Color(0xFF050B22);
  static const surface = Color(0xFF0D1936);
  static const surfaceLight = Color(0xFF142650);
  static const surfaceGlass = Color(0xB30E1B3A);

  static const neonCyan = Color(0xFF86B9FF);
  static const electricBlue = Color(0xFF3F5BFF);
  static const violet = Color(0xFF2F48D8);
  static const mint = Color(0xFF23F7A5);
  static const amber = Color(0xFFFFC857);
  static const danger = Color(0xFFFF5C7A);

  static const textPrimary = Color(0xFFF4F8FF);
  static const textSecondary = Color(0xB8FFFFFF);
  static const textMuted = Color(0x7AFFFFFF);

  static const primaryGradient = [electricBlue, Color(0xFF4C6DFF), neonCyan];
  static const successGradient = [mint, Color(0xFF10B981)];
}

class GateWiseTheme {
  const GateWiseTheme._();

  static ThemeData dark() {
    final baseTheme = ThemeData.dark(useMaterial3: true);

    return baseTheme.copyWith(
      scaffoldBackgroundColor: GateWiseColors.background,
      colorScheme: const ColorScheme.dark(
        primary: GateWiseColors.electricBlue,
        secondary: GateWiseColors.violet,
        surface: GateWiseColors.surface,
        error: GateWiseColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GateWiseColors.surfaceGlass,
        hoverColor: GateWiseColors.surfaceLight,
        focusColor: GateWiseColors.surfaceLight,
        labelStyle: const TextStyle(color: GateWiseColors.textSecondary),
        hintStyle: const TextStyle(color: GateWiseColors.textMuted),
        helperStyle: const TextStyle(color: GateWiseColors.textMuted),
        errorStyle: const TextStyle(color: GateWiseColors.danger),
        prefixIconColor: GateWiseColors.electricBlue,
        suffixIconColor: GateWiseColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: GateWiseColors.electricBlue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: GateWiseColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: GateWiseColors.danger,
            width: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          backgroundColor: GateWiseColors.electricBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          backgroundColor: GateWiseColors.electricBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GateWiseColors.electricBlue,
          side: BorderSide(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.35),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GateWiseColors.electricBlue,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: GateWiseColors.surfaceLight,
        contentTextStyle: const TextStyle(color: GateWiseColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class TechBackground extends StatelessWidget {
  const TechBackground({
    super.key,
    required this.child,
    this.padding,
    this.showGrid = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showGrid;

  @override
  Widget build(BuildContext context) {
    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    return DecoratedBox(
      decoration: const BoxDecoration(color: GateWiseColors.background),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    GateWiseColors.background,
                    Color(0xFF071437),
                    GateWiseColors.background,
                  ],
                ),
              ),
            ),
          ),
          if (showGrid)
            Positioned.fill(child: CustomPaint(painter: _CircuitGridPainter())),
          Positioned.fill(child: content),
        ],
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 28,
    this.opacity = 0.72,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: GateWiseColors.surfaceGlass.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class NeonGradientButton extends StatelessWidget {
  const NeonGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 58,
    this.gradient = GateWiseColors.primaryGradient,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled || isLoading ? 1 : 0.48,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: enabled ? 0.22 : 0.12),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 19),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class TechStatusPill extends StatelessWidget {
  const TechStatusPill({
    super.key,
    required this.label,
    this.icon = Icons.lock_outline_rounded,
    this.color = GateWiseColors.neonCyan,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircuitGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = GateWiseColors.neonCyan.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    const gridSpacing = 34.0;

    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final circuitPaint = Paint()
      ..color = GateWiseColors.violet.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Nine well-separated L-shaped traces, one per cell of a loose 3x3
    // grid, so the circuit reads as a calm, evenly spaced pattern instead
    // of a dense tangle in one corner.
    final circuitPath = Path()
      ..moveTo(size.width * 0.06, size.height * 0.14)
      ..lineTo(size.width * 0.22, size.height * 0.14)
      ..lineTo(size.width * 0.32, size.height * 0.24)
      ..moveTo(size.width * 0.42, size.height * 0.12)
      ..lineTo(size.width * 0.58, size.height * 0.12)
      ..lineTo(size.width * 0.66, size.height * 0.22)
      ..moveTo(size.width * 0.76, size.height * 0.14)
      ..lineTo(size.width * 0.92, size.height * 0.14)
      ..lineTo(size.width * 0.96, size.height * 0.24)
      ..moveTo(size.width * 0.08, size.height * 0.48)
      ..lineTo(size.width * 0.24, size.height * 0.48)
      ..lineTo(size.width * 0.34, size.height * 0.58)
      ..moveTo(size.width * 0.44, size.height * 0.46)
      ..lineTo(size.width * 0.60, size.height * 0.46)
      ..lineTo(size.width * 0.60, size.height * 0.58)
      ..moveTo(size.width * 0.74, size.height * 0.44)
      ..lineTo(size.width * 0.90, size.height * 0.44)
      ..lineTo(size.width * 0.90, size.height * 0.58)
      ..moveTo(size.width * 0.08, size.height * 0.82)
      ..lineTo(size.width * 0.24, size.height * 0.82)
      ..lineTo(size.width * 0.34, size.height * 0.72)
      ..moveTo(size.width * 0.42, size.height * 0.84)
      ..lineTo(size.width * 0.58, size.height * 0.84)
      ..lineTo(size.width * 0.66, size.height * 0.74)
      ..moveTo(size.width * 0.76, size.height * 0.80)
      ..lineTo(size.width * 0.92, size.height * 0.80)
      ..lineTo(size.width * 0.92, size.height * 0.92);

    canvas.drawPath(circuitPath, circuitPaint);

    final accentCircuitPaint = Paint()
      ..color = GateWiseColors.electricBlue.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // A few soft curves tucked into the gaps between traces, kept short so
    // they add texture without crowding the pattern above.
    final accentPath = Path()
      ..moveTo(size.width * 0.34, size.height * 0.08)
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.02,
        size.width * 0.44,
        size.height * 0.02,
        size.width * 0.48,
        size.height * 0.08,
      )
      ..moveTo(size.width * 0.02, size.height * 0.30)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.35,
        size.width * 0.10,
        size.height * 0.42,
        size.width * 0.02,
        size.height * 0.46,
      )
      ..moveTo(size.width * 0.98, size.height * 0.30)
      ..cubicTo(
        size.width * 0.90,
        size.height * 0.35,
        size.width * 0.90,
        size.height * 0.42,
        size.width * 0.98,
        size.height * 0.46,
      )
      ..moveTo(size.width * 0.34, size.height * 0.94)
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.98,
        size.width * 0.44,
        size.height * 0.98,
        size.width * 0.48,
        size.height * 0.94,
      );

    canvas.drawPath(accentPath, accentCircuitPaint);

    final nodePaint = Paint()
      ..color = GateWiseColors.neonCyan.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (final offset in [
      Offset(size.width * 0.22, size.height * 0.14),
      Offset(size.width * 0.32, size.height * 0.24),
      Offset(size.width * 0.58, size.height * 0.12),
      Offset(size.width * 0.66, size.height * 0.22),
      Offset(size.width * 0.92, size.height * 0.14),
      Offset(size.width * 0.24, size.height * 0.48),
      Offset(size.width * 0.34, size.height * 0.58),
      Offset(size.width * 0.60, size.height * 0.46),
      Offset(size.width * 0.90, size.height * 0.44),
      Offset(size.width * 0.24, size.height * 0.82),
      Offset(size.width * 0.34, size.height * 0.72),
      Offset(size.width * 0.58, size.height * 0.84),
      Offset(size.width * 0.66, size.height * 0.74),
      Offset(size.width * 0.92, size.height * 0.80),
    ]) {
      canvas.drawCircle(offset, 4.2 + math.sin(offset.dx) * 0.3, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
