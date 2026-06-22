import 'agent_event.dart';
import 'device_agent.dart';
import 'mock_agent.dart';
import 'scanned_device.dart';

class AgentRuntime {
  final DeviceAgent agent;
  final DeviceAgent fallbackAgent;

  const AgentRuntime({
    required this.agent,
    this.fallbackAgent = const MockAgent(),
  });

  Stream<AgentEvent> runScan(List<ScannedDevice> devices) async* {
    yield AgentStatusEvent('scanning', 'Found ${devices.length} mock devices');
    try {
      await for (final event in agent.profile(devices)) {
        yield event;
      }
    } catch (error) {
      yield AgentErrorEvent(error.toString());
      await for (final event in fallbackAgent.profile(devices)) {
        yield event;
      }
    }
  }
}
