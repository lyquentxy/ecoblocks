import 'transport_status.dart';

class TransportDevice {
  final String id;
  final String name;
  final TransportKind transport;
  final Map<String, dynamic> raw;

  const TransportDevice({
    required this.id,
    required this.name,
    required this.transport,
    this.raw = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'transport': transport.name,
        'raw': raw,
      };
}
