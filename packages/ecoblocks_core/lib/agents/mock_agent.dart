import 'agent_event.dart';
import 'device_agent.dart';
import 'device_profile.dart';
import 'scanned_device.dart';

class MockAgent implements DeviceAgent {
  const MockAgent();

  @override
  Stream<AgentEvent> profile(List<ScannedDevice> devices) async* {
    yield const AgentStatusEvent('profiling', 'Mock agent profiling devices');
    for (final device in devices) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      yield AgentProfileEvent(_profile(device));
    }
    yield const AgentStatusEvent('done', 'Mock profiling done');
  }

  DeviceProfile _profile(ScannedDevice device) {
    final text = '${device.name} ${device.raw}'.toLowerCase();
    if (text.contains('fan') || text.contains('风扇')) {
      return DeviceProfile(
        deviceId: device.id,
        type: 'fan',
        capability: 'airflow',
        task: 'adjust air movement',
      );
    }
    if (text.contains('light') || text.contains('灯')) {
      return DeviceProfile(
        deviceId: device.id,
        type: 'light',
        capability: 'lighting',
        task: 'adjust illumination',
      );
    }
    if (text.contains('temp') || text.contains('温度')) {
      return DeviceProfile(
        deviceId: device.id,
        type: 'temperature',
        capability: 'temperature.read',
        task: 'observe environment temperature',
      );
    }
    return DeviceProfile(
      deviceId: device.id,
      type: 'unknown',
      capability: 'observe',
      task: 'wait for user assignment',
    );
  }
}
