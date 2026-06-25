import 'scanned_device.dart';
import 'hardware_discovery_runtime.dart';

class MockHardwareScanner implements HardwareScanner {
  const MockHardwareScanner();

  Future<List<ScannedDevice>> scan() async => const [
        ScannedDevice(
          id: 'mock-temp-01',
          name: 'EB-Temp-01',
          source: 'mock',
          serial: 'mock-temp-serial-01',
          raw: {'mock': 'temp'},
        ),
        ScannedDevice(
          id: 'mock-fan-01',
          name: 'EB-Fan-01',
          source: 'mock',
          serial: 'mock-fan-serial-01',
          raw: {'mock': 'fan'},
        ),
        ScannedDevice(
          id: 'mock-unknown-01',
          name: 'EB-Unknown-01',
          source: 'mock',
          raw: {'mock': 'non_serial'},
        ),
      ];
}
