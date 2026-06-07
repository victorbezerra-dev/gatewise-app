import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

class GateWiseApp extends StatelessWidget {
  const GateWiseApp({super.key});

  static const _backgroundColor = Color(0xFF101C2B);
  static const _surfaceColor = Color(0xFF17283D);
  static const _surfaceColorLight = Color(0xFF1D314A);
  static const _primaryColor = Color(0xFF4D9EF6);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'GateWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _backgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: _primaryColor,
          surface: _surfaceColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surfaceColor,
          hoverColor: _surfaceColorLight,
          focusColor: _surfaceColorLight,
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
          helperStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
          errorStyle: const TextStyle(color: Color(0xFFFF7A8A)),
          prefixIconColor: Colors.white70,
          suffixIconColor: Colors.white70,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primaryColor, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7A8A)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7A8A), width: 1.4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
