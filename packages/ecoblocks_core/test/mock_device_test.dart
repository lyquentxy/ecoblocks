import 'package:ecoblocks_core/ecoblocks_core.dart';

void main() {
  // 只验证最基本的序列化往返。字段细节等硬件协议定了再说。
  final sensor = MockSensor(id: 'test-01', type: 'temp', value: 25.3, unit: '°C');

  final json = sensor.toJson();
  final restored = MockSensor.fromJson(json);

  assert(restored.id == sensor.id);
  assert(restored.type == sensor.type);
  assert(restored.value == sensor.value);
  assert(restored.unit == sensor.unit);

  // Bridge 消息方向测试
  final update = SensorUpdate(sensor);
  final updateJson = update.toJson();
  assert(updateJson['type'] == 'sensor_update');
  assert(updateJson['sensor'] is Map);
}
