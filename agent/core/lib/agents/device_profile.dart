class DeviceProfile {
  final String deviceId;
  final String type;
  final String capability;
  final String task;

  const DeviceProfile({
    required this.deviceId,
    required this.type,
    required this.capability,
    required this.task,
  });

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'type': type,
        'capability': capability,
        'task': task,
      };

  factory DeviceProfile.fromJson(Map<String, dynamic> json) => DeviceProfile(
        deviceId: (json['device_id'] ?? json['deviceId'] ?? '') as String,
        type: (json['type'] ?? 'unknown') as String,
        capability: (json['capability'] ?? 'unknown') as String,
        task: (json['task'] ?? 'observe') as String,
      );
}
