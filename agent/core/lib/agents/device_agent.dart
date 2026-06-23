import 'agent_event.dart';
import 'scanned_device.dart';

abstract class DeviceAgent {
  Stream<AgentEvent> profile(List<ScannedDevice> devices);
}
