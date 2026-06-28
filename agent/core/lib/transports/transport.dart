import 'transport_device.dart';
import 'transport_message.dart';
import 'transport_status.dart';

abstract interface class EcoTransport {
  String get id;
  TransportKind get kind;
  Stream<TransportStatusEvent> get statuses;
  Stream<TransportMessage> get messages;

  Future<List<TransportDevice>> scan();
  Future<void> connect(TransportDevice device);
  Future<void> disconnect(String deviceId);
  Future<void> send(TransportMessage message);
  Future<void> dispose();
}
