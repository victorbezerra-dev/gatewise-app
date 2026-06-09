import 'package:flutter/material.dart';

import '../../../../core/theme/gatewise_theme.dart';
import 'status_panels.dart';

class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.showGradientBackground = true,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final bool showGradientBackground;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: GateWiseColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.36),
              blurRadius: 28,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: showGradientBackground
            ? TechBackground(
                showTechIcons: false,
                child: SafeArea(
                  top: false,
                  child: _SheetContent(
                    title: title,
                    subtitle: subtitle,
                    child: child,
                  ),
                ),
              )
            : SafeArea(
                top: false,
                child: _SheetContent(
                  title: title,
                  subtitle: subtitle,
                  child: child,
                ),
              ),
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SheetBackButton(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageTitle(title),
                    if (subtitle?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 7),
                      Text(
                        subtitle!.trim(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.58),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GlassPanel(
            padding: const EdgeInsets.all(16),
            borderRadius: 26,
            opacity: 0.76,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SheetBackButton extends StatelessWidget {
  const _SheetBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GateWiseColors.surfaceLight.withValues(alpha: 0.92),
            GateWiseColors.surface.withValues(alpha: 0.86),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: GateWiseColors.electricBlue.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: GateWiseColors.textPrimary,
            size: 19,
          ),
        ),
      ),
    );
  }
}
