import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'EcoBlocks'**
  String get appTitle;

  /// No description provided for @workspaceTitle.
  ///
  /// In zh, this message translates to:
  /// **'工作区'**
  String get workspaceTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get languageSystem;

  /// No description provided for @languageChinese.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @deepSeekKey.
  ///
  /// In zh, this message translates to:
  /// **'DeepSeek SK'**
  String get deepSeekKey;

  /// No description provided for @apiKeyHint.
  ///
  /// In zh, this message translates to:
  /// **'sk-...'**
  String get apiKeyHint;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @hubStatus.
  ///
  /// In zh, this message translates to:
  /// **'Hub 状态'**
  String get hubStatus;

  /// No description provided for @blocklyReady.
  ///
  /// In zh, this message translates to:
  /// **'Blockly 已就绪'**
  String get blocklyReady;

  /// No description provided for @blocklyWaiting.
  ///
  /// In zh, this message translates to:
  /// **'等待 Blockly'**
  String get blocklyWaiting;

  /// No description provided for @aiEnabled.
  ///
  /// In zh, this message translates to:
  /// **'AI 已启用'**
  String get aiEnabled;

  /// No description provided for @aiDisabled.
  ///
  /// In zh, this message translates to:
  /// **'Mock Agent'**
  String get aiDisabled;

  /// No description provided for @agentStatusLabel.
  ///
  /// In zh, this message translates to:
  /// **'Agent'**
  String get agentStatusLabel;

  /// No description provided for @deviceProfilesLabel.
  ///
  /// In zh, this message translates to:
  /// **'设备画像'**
  String get deviceProfilesLabel;

  /// No description provided for @mockSensorsLabel.
  ///
  /// In zh, this message translates to:
  /// **'Mock 数据'**
  String get mockSensorsLabel;

  /// No description provided for @llmSettingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'LLM 设置'**
  String get llmSettingsTitle;

  /// No description provided for @llmSettingsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'DeepSeek API Key'**
  String get llmSettingsSubtitle;

  /// No description provided for @testLayerTitle.
  ///
  /// In zh, this message translates to:
  /// **'测试层'**
  String get testLayerTitle;

  /// No description provided for @testLayerSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'联网检查'**
  String get testLayerSubtitle;

  /// No description provided for @settingsSaved.
  ///
  /// In zh, this message translates to:
  /// **'设置已保存'**
  String get settingsSaved;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clear;

  /// No description provided for @showSecret.
  ///
  /// In zh, this message translates to:
  /// **'显示密钥'**
  String get showSecret;

  /// No description provided for @hideSecret.
  ///
  /// In zh, this message translates to:
  /// **'隐藏密钥'**
  String get hideSecret;

  /// No description provided for @deepSeekFixedProvider.
  ///
  /// In zh, this message translates to:
  /// **'服务：DeepSeek，模型：deepseek-v4-flash'**
  String get deepSeekFixedProvider;

  /// No description provided for @envLocalHint.
  ///
  /// In zh, this message translates to:
  /// **'.env.local 可提供 DEEPSEEK_API_KEY 作为本地开发默认值。'**
  String get envLocalHint;

  /// No description provided for @deepSeekConnectionTestDescription.
  ///
  /// In zh, this message translates to:
  /// **'发送一个最小 DeepSeek 请求，用于验证 API Key 和网络连接。此操作不会扫描或更新设备。'**
  String get deepSeekConnectionTestDescription;

  /// No description provided for @testing.
  ///
  /// In zh, this message translates to:
  /// **'测试中...'**
  String get testing;

  /// No description provided for @testConnection.
  ///
  /// In zh, this message translates to:
  /// **'测试联网'**
  String get testConnection;

  /// No description provided for @missingApiKey.
  ///
  /// In zh, this message translates to:
  /// **'缺少 DeepSeek API Key'**
  String get missingApiKey;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
