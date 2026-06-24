// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EcoBlocks';

  @override
  String get workspaceTitle => 'Workspace';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get deepSeekKey => 'DeepSeek SK';

  @override
  String get apiKeyHint => 'sk-...';

  @override
  String get save => 'Save';

  @override
  String get hubStatus => 'Hub Status';

  @override
  String get blocklyReady => 'Blockly ready';

  @override
  String get blocklyWaiting => 'Waiting for Blockly';

  @override
  String get aiEnabled => 'AI enabled';

  @override
  String get aiDisabled => 'Mock Agent';

  @override
  String get agentStatusLabel => 'Agent';

  @override
  String get deviceProfilesLabel => 'Device profiles';

  @override
  String get mockSensorsLabel => 'Mock data';

  @override
  String get llmSettingsTitle => 'LLM Settings';

  @override
  String get llmSettingsSubtitle => 'DeepSeek API key';

  @override
  String get testLayerTitle => 'Test Layer';

  @override
  String get testLayerSubtitle => 'Connectivity checks';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get clear => 'Clear';

  @override
  String get showSecret => 'Show secret';

  @override
  String get hideSecret => 'Hide secret';

  @override
  String get deepSeekFixedProvider =>
      'Provider: DeepSeek, model: deepseek-v4-flash';

  @override
  String get envLocalHint =>
      '.env.local can provide DEEPSEEK_API_KEY for local development.';

  @override
  String get deepSeekConnectionTestDescription =>
      'Run a minimal DeepSeek request to verify the API key and network connection. This does not scan or update devices.';

  @override
  String get testing => 'Testing...';

  @override
  String get testConnection => 'Test connection';

  @override
  String get missingApiKey => 'Missing DeepSeek API key';
}
