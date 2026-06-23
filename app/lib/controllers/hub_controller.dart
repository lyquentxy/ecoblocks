import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter/foundation.dart';

import '../settings/app_settings.dart';

class HubController extends ChangeNotifier {
  final AppSettingsStore settingsStore;

  AppSettings _settings = const AppSettings();
  bool _loaded = false;
  bool _blocklyReady = false;
  String _agentStatus = 'waiting';
  String _agentMessage = '';
  final List<DeviceProfile> _profiles = [];
  final Map<String, MockSensor> _mockSensors = {};
  final Map<String, MockActuator> _mockActuators = {};

  HubController({AppSettingsStore? settingsStore})
      : settingsStore = settingsStore ?? AppSettingsStore();

  AppSettings get settings => _settings;
  bool get loaded => _loaded;
  bool get blocklyReady => _blocklyReady;
  String get agentStatus => _agentStatus;
  String get agentMessage => _agentMessage;
  List<DeviceProfile> get profiles => List.unmodifiable(_profiles);
  List<MockSensor> get mockSensors => List.unmodifiable(_mockSensors.values);
  List<MockActuator> get mockActuators =>
      List.unmodifiable(_mockActuators.values);

  Future<void> loadSettings() async {
    _settings = await settingsStore.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    notifyListeners();
    await settingsStore.save(settings);
  }

  void setBlocklyReady(bool ready) {
    if (_blocklyReady == ready) return;
    _blocklyReady = ready;
    notifyListeners();
  }

  void startScan(String message) {
    _profiles.clear();
    _mockSensors.clear();
    _mockActuators.clear();
    setAgentStatus('scanning', message);
  }

  void setAgentStatus(String status, String message) {
    _agentStatus = status;
    _agentMessage = message;
    notifyListeners();
  }

  void addProfile(DeviceProfile profile) {
    _profiles.removeWhere((item) => item.deviceId == profile.deviceId);
    _profiles.add(profile);
    notifyListeners();
  }

  void setMockSensor(MockSensor sensor) {
    _mockSensors[sensor.id] = sensor;
    notifyListeners();
  }

  void setMockActuator(MockActuator actuator) {
    _mockActuators[actuator.id] = actuator;
    notifyListeners();
  }
}
