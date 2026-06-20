import 'package:flutter/material.dart';
import 'pages/workspace_page.dart';

void main() {
  runApp(const EcoBlocksApp());
}

class EcoBlocksApp extends StatelessWidget {
  const EcoBlocksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoBlocks',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const WorkspacePage(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF1a1815)
          : const Color(0xFFf5f0e8), // 宣纸色
    );
  }
}
