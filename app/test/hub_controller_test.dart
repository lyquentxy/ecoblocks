import 'package:ecoblocks_app/controllers/hub_controller.dart';
import 'package:ecoblocks_app/settings/app_settings.dart';
import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySettingsStore extends AppSettingsStore {
  AppSettings value;

  _MemorySettingsStore(this.value);

  @override
  Future<AppSettings> load() async => value;

  @override
  Future<void> save(AppSettings settings) async {
    value = settings;
  }
}

void main() {
  test('HubController loads and saves shared settings', () async {
    final store = _MemorySettingsStore(const AppSettings(localeCode: 'zh'));
    final controller = HubController(settingsStore: store);

    await controller.loadSettings();
    await controller.saveSettings(
      controller.settings.copyWith(localeCode: 'en'),
    );

    expect(controller.settings.localeCode, 'en');
    expect(store.value.localeCode, 'en');
  });

  test('HubController keeps mock scan state', () {
    final controller = HubController(settingsStore: _MemorySettingsStore(
      const AppSettings(),
    ));

    controller.setBlocklyReady(true);
    controller.addProfile(const DeviceProfile(
      deviceId: 'mock-temp-01',
      type: 'temperature',
      capability: 'temperature.read',
      task: 'observe environment temperature',
    ));
    controller.setMockSensor(const MockSensor(
      id: 'mock-temp-01',
      type: 'temp',
      value: 'mock',
      unit: 'C',
    ));

    expect(controller.blocklyReady, isTrue);
    expect(controller.profiles.single.deviceId, 'mock-temp-01');
    expect(controller.mockSensors.single.value, 'mock');
  });
}
