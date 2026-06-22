import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:test/test.dart';

void main() {
  test('MockAgent profiles scanned devices asynchronously', () async {
    const agent = MockAgent();
    final events = await agent.profile([
      const ScannedDevice(
          id: 'mock-temp-01', name: 'EB-Temp-01', source: 'mock'),
    ]).toList();

    expect(events.whereType<AgentStatusEvent>().first.status, 'profiling');
    final profile = events.whereType<AgentProfileEvent>().single.profile;
    expect(profile.deviceId, 'mock-temp-01');
    expect(profile.type, 'temperature');
  });

  test('AgentRuntime emits scanning then profile events', () async {
    final runtime = AgentRuntime(agent: const MockAgent());
    final events = await runtime.runScan([
      const ScannedDevice(id: 'mock-fan-01', name: 'EB-Fan-01', source: 'mock'),
    ]).toList();

    expect(events.first, isA<AgentStatusEvent>());
    expect((events.first as AgentStatusEvent).status, 'scanning');
    expect(events.whereType<AgentProfileEvent>().single.profile.type, 'fan');
  });
}
