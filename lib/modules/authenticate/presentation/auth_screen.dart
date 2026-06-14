import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_notifier.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/gatewise_theme.dart';
import 'auth_flow_notifier.dart';

class AuthLoginScreen extends ConsumerWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(authFlowNotifierProvider);
    final loginNotifier = ref.read(authFlowNotifierProvider.notifier);
    final screenSize = MediaQuery.sizeOf(context);
    final logoWidth = screenSize.width * 0.6;
    final housesTop = (screenSize.height * 0.075).clamp(52.0, 72.0).toDouble();

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        log("User authenticated.");
      } else if (next is AuthUnauthenticated && next.error != null) {
        log("Authentication error: ${next.error}");
      }
    });

    ref.listen<AsyncValue<void>>(authFlowNotifierProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          final authState = ref.read(authProvider);
          if (authState is! AuthAuthenticated) {
            log(
              "Login flow finished without authenticated user. Staying on login screen.",
            );
            return;
          }

          log("Login flow completed successfully.");
          ref.invalidate(userProfileProvider);
          context.go('/main');
        },
        error: (err, _) {
          log("Login flow failed: $err");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login failed: $err")));
        },
      );
    });

    final isLoading = loginState is AsyncLoading;

    return Scaffold(
      backgroundColor: GateWiseColors.background,
      body: TechBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                left: -screenSize.width * 0.16,
                right: -screenSize.width * 0.16,
                top: housesTop,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.46,
                    child: Image.asset(
                      'assets/images/houses-background.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: const TechStatusPill(
                    label: 'Plataforma de automação IoT',
                    icon: Icons.lock_outline_rounded,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 410),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                GateWiseColors.neonCyan.withValues(alpha: 0.2),
                                GateWiseColors.electricBlue.withValues(
                                  alpha: 0.08,
                                ),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/gatewise-transparent-icon.png',
                            width: logoWidth.clamp(70, 80).toDouble(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text(
                          'GateWise',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 60),
                        GlassPanel(
                          child: Column(
                            children: [
                              const Text(
                                'A porta de entrada para ambientes inteligentes.',
                                style: TextStyle(
                                  color: GateWiseColors.textPrimary,
                                  fontSize: 22,
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Conecte, automatize e proteja qualquer ambiente, em qualquer escala, de forma inteligente.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.62),
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 26),
                              NeonGradientButton(
                                label: 'Entrar com GateWise',
                                icon: Icons.login_rounded,
                                isLoading: isLoading,
                                gradient: const [
                                  GateWiseColors.electricBlue,
                                  GateWiseColors.electricBlue,
                                ],
                                onPressed: isLoading
                                    ? null
                                    : () => loginNotifier.loginFlow(),
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Ainda não tem cadastro?',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.62,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => loginNotifier.registerFlow(),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                    ),
                                    child: const Text(
                                      'Cadastre-se',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
