import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/hub_controller.dart';
import 'l10n/app_localizations.dart';
import 'pages/workspace_page.dart';

void main() {
  runApp(const EcoBlocksApp());
}

class EcoBlocksApp extends StatefulWidget {
  const EcoBlocksApp({super.key});

  @override
  State<EcoBlocksApp> createState() => _EcoBlocksAppState();
}

class _EcoBlocksAppState extends State<EcoBlocksApp> {
  late final HubController _hubController;

  @override
  void initState() {
    super.initState();
    _hubController = HubController()..loadSettings();
  }

  @override
  void dispose() {
    _hubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hubController,
      builder: (context, _) {
        final localeCode = _hubController.settings.localeCode;
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          locale: localeCode.isEmpty ? null : Locale(localeCode),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh'),
            Locale('en'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale?.languageCode == 'en') return const Locale('en');
            return const Locale('zh');
          },
          home: WorkspacePage(controller: _hubController),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF1a1815) : const Color(0xFFf5f0e8),
    );
  }
}
