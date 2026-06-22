class ScannedDevice {
  final String id;
  final String name;
  final String source;
  final Map<String, dynamic> raw;

  const ScannedDevice({
    required this.id,
    required this.name,
    required this.source,
    this.raw = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'source': source,
        'raw': raw,
      };
}
