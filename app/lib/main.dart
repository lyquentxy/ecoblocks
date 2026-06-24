import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/hub_controller.dart';
import 'l10n/app_localizations.dart';
import 'pages/settings_routes.dart';
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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
          navigatorKey: _navigatorKey,
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
          onGenerateRoute: _onGenerateRoute,
          home: WorkspacePage(
            controller: _hubController,
            onOpenSettings: _openSettings,
          ),
        );
      },
    );
  }

  void _openSettings() {
    _navigatorKey.currentState?.pushNamed('/settings');
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/settings' ||
        settings.name == '/settings/llm' ||
        settings.name == '/settings/test') {
      return PageRouteBuilder<void>(
        settings: settings,
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SettingsShellPage(
            controller: _hubController,
            routeName: settings.name ?? '/settings',
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.12, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
    }
    return null;
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
