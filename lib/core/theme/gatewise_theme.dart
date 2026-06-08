import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

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
    this.showTechIcons = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showGrid;
  final bool showTechIcons;

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
          if (showTechIcons) ...[
            const _FloatingTechIcon(
              alignment: Alignment(-0.86, -0.68),
              icon: SimpleIcons.arduino,
              size: 38,
              rotation: -0.14,
              color: GateWiseColors.electricBlue,
              opacity: 0.075,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.78, -0.62),
              icon: SimpleIcons.capacitor,
              size: 36,
              rotation: 0.2,
              opacity: 0.07,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.34, -0.48),
              icon: SimpleIcons.raspberrypi,
              size: 30,
              rotation: 0.1,
              opacity: 0.05,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.04, -0.56),
              icon: SimpleIcons.python,
              size: 31,
              rotation: -0.12,
              color: GateWiseColors.electricBlue,
              opacity: 0.062,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.34, -0.38),
              icon: SimpleIcons.espressif,
              size: 34,
              rotation: -0.2,
              color: GateWiseColors.electricBlue,
              opacity: 0.055,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.9, -0.06),
              icon: SimpleIcons.mqtt,
              size: 34,
              rotation: 0.22,
              opacity: 0.06,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.9, 0.02),
              icon: SimpleIcons.nodered,
              size: 36,
              rotation: -0.16,
              color: GateWiseColors.electricBlue,
              opacity: 0.052,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.26, 0.04),
              icon: SimpleIcons.dart,
              size: 29,
              rotation: 0.18,
              opacity: 0.048,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.28, 0.12),
              icon: SimpleIcons.flutter,
              size: 30,
              rotation: -0.1,
              color: GateWiseColors.electricBlue,
              opacity: 0.052,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.58, 0.26),
              icon: SimpleIcons.platformio,
              size: 38,
              rotation: 0.18,
              opacity: 0.06,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.96, 0.46),
              icon: SimpleIcons.javascript,
              size: 28,
              rotation: -0.24,
              opacity: 0.045,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.62, 0.3),
              icon: SimpleIcons.homeassistant,
              size: 36,
              rotation: -0.22,
              color: GateWiseColors.electricBlue,
              opacity: 0.06,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.96, 0.46),
              icon: SimpleIcons.docker,
              size: 31,
              rotation: 0.18,
              opacity: 0.045,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.18, 0.48),
              icon: Icons.memory_rounded,
              size: 32,
              rotation: -0.18,
              opacity: 0.05,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.22, 0.62),
              icon: Icons.settings_input_component_rounded,
              size: 34,
              rotation: 0.24,
              color: GateWiseColors.electricBlue,
              opacity: 0.05,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.42, 0.72),
              icon: SimpleIcons.typescript,
              size: 29,
              rotation: 0.14,
              color: GateWiseColors.electricBlue,
              opacity: 0.047,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.46, 0.72),
              icon: SimpleIcons.kubernetes,
              size: 30,
              rotation: -0.2,
              opacity: 0.044,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(-0.78, 0.78),
              icon: Icons.sensors_rounded,
              size: 34,
              rotation: -0.22,
              opacity: 0.055,
            ),
            const _FloatingTechIcon(
              alignment: Alignment(0.82, 0.78),
              icon: Icons.usb_rounded,
              size: 30,
              rotation: 0.12,
              color: GateWiseColors.electricBlue,
              opacity: 0.045,
            ),
          ],
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

class _FloatingTechIcon extends StatelessWidget {
  const _FloatingTechIcon({
    required this.alignment,
    required this.icon,
    required this.size,
    this.rotation = 0,
    this.color = GateWiseColors.neonCyan,
    this.opacity = 0.055,
  });

  final Alignment alignment;
  final IconData icon;
  final double size;
  final double rotation;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Transform.rotate(
          angle: rotation,
          child: Opacity(
            opacity: opacity,
            child: Icon(icon, color: color, size: size),
          ),
        ),
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

    final circuitPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.18)
      ..lineTo(size.width * 0.35, size.height * 0.18)
      ..lineTo(size.width * 0.46, size.height * 0.28)
      ..lineTo(size.width * 0.78, size.height * 0.28)
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..lineTo(size.width * 0.36, size.height * 0.58)
      ..lineTo(size.width * 0.62, size.height * 0.58)
      ..lineTo(size.width * 0.88, size.height * 0.42)
      ..moveTo(size.width * 0.04, size.height * 0.42)
      ..lineTo(size.width * 0.18, size.height * 0.42)
      ..lineTo(size.width * 0.27, size.height * 0.35)
      ..lineTo(size.width * 0.43, size.height * 0.35)
      ..lineTo(size.width * 0.52, size.height * 0.46)
      ..lineTo(size.width * 0.69, size.height * 0.46)
      ..moveTo(size.width * 0.08, size.height * 0.9)
      ..lineTo(size.width * 0.22, size.height * 0.82)
      ..lineTo(size.width * 0.41, size.height * 0.82)
      ..lineTo(size.width * 0.51, size.height * 0.72)
      ..lineTo(size.width * 0.75, size.height * 0.72)
      ..lineTo(size.width * 0.93, size.height * 0.63)
      ..moveTo(size.width * 0.92, size.height * 0.12)
      ..lineTo(size.width * 0.76, size.height * 0.18)
      ..lineTo(size.width * 0.67, size.height * 0.1)
      ..lineTo(size.width * 0.52, size.height * 0.1)
      ..moveTo(size.width * 0.57, size.height * 0.93)
      ..lineTo(size.width * 0.65, size.height * 0.84)
      ..lineTo(size.width * 0.84, size.height * 0.84);

    canvas.drawPath(circuitPath, circuitPaint);

    final accentCircuitPaint = Paint()
      ..color = GateWiseColors.electricBlue.withValues(alpha: 0.075)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final accentPath = Path()
      ..moveTo(size.width * 0.02, size.height * 0.3)
      ..cubicTo(
        size.width * 0.16,
        size.height * 0.22,
        size.width * 0.24,
        size.height * 0.5,
        size.width * 0.38,
        size.height * 0.41,
      )
      ..moveTo(size.width * 0.66, size.height * 0.2)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.36,
        size.width * 0.86,
        size.height * 0.14,
        size.width * 0.98,
        size.height * 0.32,
      )
      ..moveTo(size.width * 0.12, size.height * 0.62)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.68,
        size.width * 0.32,
        size.height * 0.9,
        size.width * 0.48,
        size.height * 0.76,
      )
      ..moveTo(size.width * 0.58, size.height * 0.58)
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.52,
        size.width * 0.8,
        size.height * 0.86,
        size.width * 0.96,
        size.height * 0.74,
      );

    canvas.drawPath(accentPath, accentCircuitPaint);

    final nodePaint = Paint()
      ..color = GateWiseColors.neonCyan.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    for (final offset in [
      Offset(size.width * 0.35, size.height * 0.18),
      Offset(size.width * 0.46, size.height * 0.28),
      Offset(size.width * 0.62, size.height * 0.58),
      Offset(size.width * 0.88, size.height * 0.42),
      Offset(size.width * 0.27, size.height * 0.35),
      Offset(size.width * 0.52, size.height * 0.46),
      Offset(size.width * 0.22, size.height * 0.82),
      Offset(size.width * 0.51, size.height * 0.72),
      Offset(size.width * 0.75, size.height * 0.72),
      Offset(size.width * 0.76, size.height * 0.18),
      Offset(size.width * 0.65, size.height * 0.84),
      Offset(size.width * 0.84, size.height * 0.84),
    ]) {
      canvas.drawCircle(offset, 3.5 + math.sin(offset.dx) * 0.2, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
