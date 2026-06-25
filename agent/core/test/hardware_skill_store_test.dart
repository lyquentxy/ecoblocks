import 'dart:convert';
import 'dart:io';

import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late HardwareSkillStore store;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ecoblocks_skill_store_');
    store = HardwareSkillStore(Directory('${tempDir.path}/ecoblocks_agent'));
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('new serial device creates index entry and mock skill', () async {
    final result = await store.archive(
      const ScannedDevice(
        id: 'temp-01',
        name: 'Temp Node',
        source: 'mock',
        serial: 'serial-temp-01',
      ),
    );

    expect(result.kind, 'serial');
    expect(result.created, isTrue);

    final index = await _readJson(
      File('${tempDir.path}/ecoblocks_agent/devices/index.json'),
    );
    expect(index['serials']['serial-temp-01'], 'devices/serial-temp-01.json');

    final skill = await _readJson(File(result.path));
    expect(skill, {'mock': 'hardware_skill'});
  });

  test('known serial reuses existing skill', () async {
    const device = ScannedDevice(
      id: 'fan-01',
      name: 'Fan Node',
      source: 'mock',
      serial: 'serial-fan-01',
    );

    final first = await store.archive(device);
    final second = await store.archive(device);

    expect(first.created, isTrue);
    expect(second.created, isFalse);
    expect(second.path, first.path);
  });

  test('device without serial is recorded in non serial json', () async {
    final result = await store.archive(
      const ScannedDevice(
        id: 'unknown-01',
        name: 'Unknown Node',
        source: 'mock',
      ),
    );

    expect(result.kind, 'non_serial');

    final json = await _readJson(
      File('${tempDir.path}/ecoblocks_agent/devices/non_serial.json'),
    );
    expect(json['mock'], isA<List<dynamic>>());
    expect(json['mock'].single['id'], 'unknown-01');
  });

  test('discovery runtime can poll scanner without duplicating serial skills',
      () async {
    final runtime = HardwareDiscoveryRuntime(
      scanner: const MockHardwareScanner(),
      store: store,
    );

    final ticks = await runtime
        .poll(interval: Duration.zero, maxTicks: 2)
        .toList();

    expect(ticks, hasLength(2));
    expect(
      ticks.first.where((result) => result.kind == 'serial' && result.created),
      hasLength(2),
    );
    expect(
      ticks.last.where((result) => result.kind == 'serial' && !result.created),
      hasLength(2),
    );
  });
}

Future<Map<String, dynamic>> _readJson(File file) async {
  return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
}
