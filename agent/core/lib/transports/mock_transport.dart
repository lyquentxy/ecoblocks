import 'dart:async';

import 'transport.dart';
import 'transport_device.dart';
import 'transport_message.dart';
import 'transport_status.dart';

class MockTransport implements EcoTransport {
  final List<TransportDevice> devices;
  final StreamController<TransportStatusEvent> _statuses =
      StreamController<TransportStatusEvent>.broadcast();
  final StreamController<TransportMessage> _messages =
      StreamController<TransportMessage>.broadcast();

  MockTransport({
    this.devices = const [
      TransportDevice(
        id: 'mock-temp-01',
        name: 'Mock Temp Node',
        transport: TransportKind.mock,
      ),
      TransportDevice(
        id: 'mock-fan-01',
        name: 'Mock Fan Node',
        transport: TransportKind.mock,
      ),
    ],
  });

  @override
  String get id => 'mock';

  @override
  TransportKind get kind => TransportKind.mock;

  @override
  Stream<TransportStatusEvent> get statuses => _statuses.stream;

  @override
  Stream<TransportMessage> get messages => _messages.stream;

  @override
  Future<List<TransportDevice>> scan() async {
    _emitStatus(TransportStatus.scanning, 'mock scan started');
    _emitStatus(TransportStatus.found, 'mock devices found');
    return devices;
  }

  @override
  Future<void> connect(TransportDevice device) async {
    _emitStatus(
      TransportStatus.connecting,
      'mock connecting',
      deviceId: device.id,
    );
    _emitStatus(
      TransportStatus.ready,
      'mock ready',
      deviceId: device.id,
    );
  }

  @override
  Future<void> disconnect(String deviceId) async {
    _emitStatus(
      TransportStatus.disconnected,
      'mock disconnected',
      deviceId: deviceId,
    );
  }

  @override
  Future<void> send(TransportMessage message) async {
    _messages.add(message);
  }

  @override
  Future<void> dispose() async {
    await _statuses.close();
    await _messages.close();
  }

  void _emitStatus(
    TransportStatus status,
    String message, {
    String? deviceId,
  }) {
    _statuses.add(
      TransportStatusEvent(
        status: status,
        message: message,
        deviceId: deviceId,
      ),
    );
  }
}
