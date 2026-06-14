import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gatewise_app/l10n/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/gatewise_theme.dart';
import 'modules/host/presentation/widgets/custom_dialog.dart';

class GateWiseApp extends ConsumerWidget {
  const GateWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'GateWise',
      debugShowCheckedModeBanner: false,
      theme: GateWiseTheme.dark(),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Stack(
        children: [
          child!,
          const DialogHost(),
        ],
      ),
    );
  }
}
