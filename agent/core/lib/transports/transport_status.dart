enum TransportKind {
  ble,
  wifi,
  adapter,
  mock,
}

enum TransportStatus {
  unknown,
  scanning,
  found,
  connecting,
  connected,
  ready,
  disconnected,
  error,
}

class TransportStatusEvent {
  final TransportStatus status;
  final String message;
  final String? deviceId;

  const TransportStatusEvent({
    required this.status,
    this.message = '',
    this.deviceId,
  });
}
