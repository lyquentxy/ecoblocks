import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:test/test.dart';

void main() {
  test('MockSensor serializes round trip', () {
    const sensor =
        MockSensor(id: 'test-01', type: 'temp', value: 25.3, unit: 'C');

    final restored = MockSensor.fromJson(sensor.toJson());

    expect(restored.id, sensor.id);
    expect(restored.type, sensor.type);
    expect(restored.value, sensor.value);
    expect(restored.unit, sensor.unit);
  });

  test('Bridge sensor update keeps message minimal', () {
    const sensor =
        MockSensor(id: 'test-01', type: 'temp', value: 'mock', unit: 'C');

    final updateJson = SensorUpdate(sensor).toJson();

    expect(updateJson['type'], 'sensor_update');
    expect(updateJson['sensor'], isA<Map<String, dynamic>>());
  });
}
