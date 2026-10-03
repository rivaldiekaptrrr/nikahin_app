import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

class NikahinApp extends ConsumerWidget {
  const NikahinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Nikahin',
      debugShowCheckedModeBanner: false,
      theme: NikahinTheme.lightTheme(isWeddingMode: true),
      darkTheme: NikahinTheme.darkTheme(isWeddingMode: true),
      themeMode: currentThemeMode,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
    );
  }
}
