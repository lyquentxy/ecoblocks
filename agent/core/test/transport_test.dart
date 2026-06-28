import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:test/test.dart';

void main() {
  test('transport device json stays minimal', () {
    const device = TransportDevice(
      id: 'ble-temp-01',
      name: 'Temp Node',
      transport: TransportKind.ble,
    );

    expect(device.toJson(), {
      'id': 'ble-temp-01',
      'name': 'Temp Node',
      'transport': 'ble',
      'raw': <String, dynamic>{},
    });
  });

  test('transport message wraps mock payload without defining protocol fields',
      () {
    const message = TransportMessage(
      type: 'sensor_update',
      deviceId: 'mock-temp-01',
      transport: TransportKind.mock,
      payload: {'temp': 'mock'},
    );

    expect(message.toJson(), {
      'type': 'sensor_update',
      'device': 'mock-temp-01',
      'transport': 'mock',
      'payload': {'temp': 'mock'},
    });
  });

  test('mock transport scans and emits lifecycle statuses', () async {
    final transport = MockTransport();
    final statuses = <TransportStatusEvent>[];
    final sub = transport.statuses.listen(statuses.add);

    final devices = await transport.scan();
    await transport.connect(devices.first);
    await Future<void>.delayed(Duration.zero);

    expect(devices, hasLength(2));
    expect(statuses.map((item) => item.status), [
      TransportStatus.scanning,
      TransportStatus.found,
      TransportStatus.connecting,
      TransportStatus.ready,
    ]);

    await sub.cancel();
    await transport.dispose();
  });
}
