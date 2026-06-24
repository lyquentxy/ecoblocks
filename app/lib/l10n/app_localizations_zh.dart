// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'EcoBlocks';

  @override
  String get workspaceTitle => '工作区';

  @override
  String get settingsTitle => '设置';

  @override
  String get languageLabel => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get deepSeekKey => 'DeepSeek SK';

  @override
  String get apiKeyHint => 'sk-...';

  @override
  String get save => '保存';

  @override
  String get hubStatus => 'Hub 状态';

  @override
  String get blocklyReady => 'Blockly 已就绪';

  @override
  String get blocklyWaiting => '等待 Blockly';

  @override
  String get aiEnabled => 'AI 已启用';

  @override
  String get aiDisabled => 'Mock Agent';

  @override
  String get agentStatusLabel => 'Agent';

  @override
  String get deviceProfilesLabel => '设备画像';

  @override
  String get mockSensorsLabel => 'Mock 数据';

  @override
  String get llmSettingsTitle => 'LLM 设置';

  @override
  String get llmSettingsSubtitle => 'DeepSeek API Key';

  @override
  String get testLayerTitle => '测试层';

  @override
  String get testLayerSubtitle => '联网检查';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get clear => '清空';

  @override
  String get showSecret => '显示密钥';

  @override
  String get hideSecret => '隐藏密钥';

  @override
  String get deepSeekFixedProvider => '服务：DeepSeek，模型：deepseek-v4-flash';

  @override
  String get envLocalHint => '.env.local 可提供 DEEPSEEK_API_KEY 作为本地开发默认值。';

  @override
  String get deepSeekConnectionTestDescription =>
      '发送一个最小 DeepSeek 请求，用于验证 API Key 和网络连接。此操作不会扫描或更新设备。';

  @override
  String get testing => '测试中...';

  @override
  String get testConnection => '测试联网';

  @override
  String get missingApiKey => '缺少 DeepSeek API Key';
}
