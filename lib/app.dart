import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/gatewise_theme.dart';

class GateWiseApp extends StatelessWidget {
  const GateWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'GateWise',
      debugShowCheckedModeBanner: false,
      theme: GateWiseTheme.dark(),
    );
  }
}
