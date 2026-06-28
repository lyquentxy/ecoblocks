import 'transport_status.dart';

class TransportMessage {
  final String type;
  final String deviceId;
  final TransportKind transport;
  final Map<String, dynamic> payload;

  const TransportMessage({
    required this.type,
    required this.deviceId,
    required this.transport,
    this.payload = const {},
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'device': deviceId,
        'transport': transport.name,
        'payload': payload,
      };
}
