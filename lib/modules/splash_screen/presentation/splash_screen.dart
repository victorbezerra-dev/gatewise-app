import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/gatewise_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _mainLottieController;
  late final AnimationController _dotsController;
  late final AnimationController _loadingLottieController;

  late final Animation<int> _dotAnimation;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    _mainLottieController = AnimationController(vsync: this);
    _loadingLottieController = AnimationController(vsync: this);

    _dotsController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _dotAnimation = IntTween(begin: 0, end: 3).animate(_dotsController);

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      context.go('/auth-login');
    });
  }

  @override
  void dispose() {
    _mainLottieController.dispose();
    _loadingLottieController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GateWiseColors.background,
      body: TechBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: GlassPanel(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 190,
                          child: Lottie.asset(
                            'assets/animations/profile-password-unlock.json',
                            controller: _mainLottieController,
                            onLoaded: (composition) {
                              _mainLottieController
                                ..duration = composition.duration
                                ..repeat();
                            },
                          ),
                        ),
                        Image.asset(
                          'assets/images/gatewise-logo.png',
                          width: 210,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        const Text.rich(
                          TextSpan(
                            text: 'Conectar, automatizar e proteger. ',
                            style: TextStyle(
                              fontSize: 18,
                              color: GateWiseColors.textPrimary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Em qualquer escala',
                                style: TextStyle(
                                  color: GateWiseColors.neonCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        const TechStatusPill(
                          label: 'Conectando com segurança',
                          icon: Icons.lock_outline_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    controller: _loadingLottieController,
                    onLoaded: (composition) {
                      _loadingLottieController
                        ..duration = composition.duration
                        ..repeat();
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: _dotAnimation,
                  builder: (context, child) {
                    final dots = '.' * _dotAnimation.value;
                    return Text(
                      'loading$dots',
                      style: const TextStyle(
                        color: GateWiseColors.textSecondary,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
