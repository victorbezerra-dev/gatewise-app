import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/gatewise_theme.dart';
import 'modules/host/presentation/widgets/custom_dialog.dart';

class GateWiseApp extends ConsumerWidget {
  const GateWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'GateWise',
      debugShowCheckedModeBanner: false,
      theme: GateWiseTheme.dark(),
      builder: (context, child) => Stack(
        children: [
          child!,
          const DialogHost(),
        ],
      ),
    );
  }
}
