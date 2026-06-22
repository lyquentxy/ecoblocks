import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppSettings {
  final String deepSeekApiKey;

  const AppSettings({this.deepSeekApiKey = ''});

  bool get hasDeepSeekKey => deepSeekApiKey.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'deepseek_sk': deepSeekApiKey,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        deepSeekApiKey: (json['deepseek_sk'] ?? '') as String,
      );
}

class AppSettingsStore {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/ecoblocks_settings.json');
  }

  Future<AppSettings> load() async {
    final file = await _file();
    if (!await file.exists()) {
      return const AppSettings();
    }
    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(settings.toJson()));
  }
}
