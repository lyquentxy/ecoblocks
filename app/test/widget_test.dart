import 'package:ecoblocks_app/settings/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppSettings serializes DeepSeek key', () {
    const settings = AppSettings(
      deepSeekApiKey: 'sk-test',
      localeCode: 'en',
    );

    final restored = AppSettings.fromJson(settings.toJson());

    expect(restored.deepSeekApiKey, 'sk-test');
    expect(restored.localeCode, 'en');
    expect(restored.hasDeepSeekKey, isTrue);
  });

  test('AppSettings defaults to system locale', () {
    const settings = AppSettings();

    expect(settings.localeCode, isEmpty);
  });
}
