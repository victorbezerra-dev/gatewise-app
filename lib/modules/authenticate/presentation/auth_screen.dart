import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_notifier.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/providers/user_profile_provider.dart';
import 'auth_flow_notifier.dart';

class AuthLoginScreen extends ConsumerWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(authFlowNotifierProvider);
    final loginNotifier = ref.read(authFlowNotifierProvider.notifier);
    final logoWidth = MediaQuery.of(context).size.width * 0.6;

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
      backgroundColor: const Color(0xFF0B1C2C),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Image.asset(
                      'assets/images/gatewise-logo.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -80),
                    child: Column(
                      children: [
                        const Text(
                          'Acesse sua conta com segurança.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4D9EF6),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () => loginNotifier.loginFlow(),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Entrar com GateWise',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Ainda não tem cadastro?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => loginNotifier.registerFlow(),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4D9EF6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
