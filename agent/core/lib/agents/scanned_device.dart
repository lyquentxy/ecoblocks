class ScannedDevice {
  final String id;
  final String name;
  final String source;
  final String? serial;
  final Map<String, dynamic> raw;

  const ScannedDevice({
    required this.id,
    required this.name,
    required this.source,
    this.serial,
    this.raw = const {},
  });

  bool get hasSerial => serial != null && serial!.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'source': source,
        if (hasSerial) 'serial': serial!.trim(),
        'raw': raw,
      };
}
