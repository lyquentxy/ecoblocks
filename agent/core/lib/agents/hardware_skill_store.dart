import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'scanned_device.dart';

typedef HardwareSkillDraftBuilder = FutureOr<Map<String, dynamic>> Function(
  ScannedDevice device,
);

class HardwareSkillArchiveResult {
  final String kind;
  final bool created;
  final String path;
  final String? serial;

  const HardwareSkillArchiveResult({
    required this.kind,
    required this.created,
    required this.path,
    this.serial,
  });
}

class HardwareSkillStore {
  final Directory root;

  HardwareSkillStore(this.root);

  Future<HardwareSkillArchiveResult> archive(
    ScannedDevice device, {
    HardwareSkillDraftBuilder? buildDraft,
  }) async {
    await _devicesDir.create(recursive: true);
    if (!device.hasSerial) {
      return _archiveNonSerial(device);
    }

    final serial = device.serial!.trim();
    final index = await _readMap(_indexFile);
    final serials = _asStringMap(index['serials']);
    final relativePath = 'devices/${_safeFileName(serial)}.json';
    final skillFile = File('${root.path}${Platform.pathSeparator}$relativePath');

    if (serials.containsKey(serial) && await skillFile.exists()) {
      return HardwareSkillArchiveResult(
        kind: 'serial',
        created: false,
        path: skillFile.path,
        serial: serial,
      );
    }

    final skill = await Future.value(
      buildDraft?.call(device) ?? const {'mock': 'hardware_skill'},
    );
    await skillFile.writeAsString(jsonEncode(skill));
    serials[serial] = relativePath;
    await _indexFile.writeAsString(jsonEncode({'serials': serials}));

    return HardwareSkillArchiveResult(
      kind: 'serial',
      created: true,
      path: skillFile.path,
      serial: serial,
    );
  }

  Future<HardwareSkillArchiveResult> _archiveNonSerial(
    ScannedDevice device,
  ) async {
    final json = await _readMap(_nonSerialFile);
    final items = _asList(json['mock']);
    items.add(device.toJson());
    await _nonSerialFile.writeAsString(jsonEncode({'mock': items}));
    return HardwareSkillArchiveResult(
      kind: 'non_serial',
      created: true,
      path: _nonSerialFile.path,
    );
  }

  Directory get _devicesDir =>
      Directory('${root.path}${Platform.pathSeparator}devices');

  File get _indexFile => File(
        '${_devicesDir.path}${Platform.pathSeparator}index.json',
      );

  File get _nonSerialFile => File(
        '${_devicesDir.path}${Platform.pathSeparator}non_serial.json',
      );

  Future<Map<String, dynamic>> _readMap(File file) async {
    if (!await file.exists()) return {};
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      return {};
    }
    return {};
  }

  Map<String, String> _asStringMap(Object? value) {
    if (value is! Map) return {};
    return value.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }

  List<dynamic> _asList(Object? value) {
    if (value is List) return List<dynamic>.from(value);
    return <dynamic>[];
  }

  String _safeFileName(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');
  }
}
