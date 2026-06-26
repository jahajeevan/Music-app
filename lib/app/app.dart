import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

// Theme mode preference
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class WavelengthApp extends ConsumerWidget {
  const WavelengthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Wavelength',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('pt'),
        Locale('ja'),
        Locale('ko'),
        Locale('zh'),
        Locale('ar'),
        Locale('hi'),
        Locale('ru'),
        Locale('it'),
        Locale('nl'),
        Locale('pl'),
        Locale('tr'),
        Locale('sv'),
        Locale('da'),
        Locale('fi'),
        Locale('no'),
        Locale('id'),
      ],
    );
  }
}
