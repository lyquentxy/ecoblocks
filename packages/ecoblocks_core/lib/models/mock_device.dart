/// Mock 设备模型。
///
/// 不提前设计详细字段。等硬件协议确定后再补。
/// 现在只要能表示 "这是一个温度传感器，值是 25.3" 就够了。

class MockSensor {
  final String id;
  final String type; // "temp" | "humidity" | "light" | "water_level" | "leak"
  final dynamic value;
  final String unit;

  const MockSensor({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'value': value,
        'unit': unit,
      };

  factory MockSensor.fromJson(Map<String, dynamic> json) => MockSensor(
        id: json['id'] as String,
        type: json['type'] as String,
        value: json['value'],
        unit: json['unit'] as String,
      );
}

class MockActuator {
  final String id;
  final String type; // "light" | "pump" | "fan" | "heater"
  final String state; // "on" | "off"
  final int? level; // 0-255, nullable

  const MockActuator({
    required this.id,
    required this.type,
    required this.state,
    this.level,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'state': state,
        'level': level,
      };

  factory MockActuator.fromJson(Map<String, dynamic> json) => MockActuator(
        id: json['id'] as String,
        type: json['type'] as String,
        state: json['state'] as String,
        level: json['level'] as int?,
      );
}

/// 给 Mock 用的默认数据源。
class MockDataSources {
  static final sensors = [
    const MockSensor(id: 'mock-temp-01', type: 'temp', value: 25.3, unit: '°C'),
    const MockSensor(id: 'mock-humi-01', type: 'humidity', value: 68, unit: '%'),
  ];

  static final actuators = [
    const MockActuator(id: 'mock-fan-01', type: 'fan', state: 'off'),
    const MockActuator(id: 'mock-light-01', type: 'light', state: 'on', level: 180),
  ];
}
