import 'dart:async';

import 'hardware_skill_store.dart';
import 'scanned_device.dart';

abstract class HardwareScanner {
  Future<List<ScannedDevice>> scan();
}

class HardwareDiscoveryRuntime {
  final HardwareScanner scanner;
  final HardwareSkillStore store;
  final HardwareSkillDraftBuilder? buildDraft;

  const HardwareDiscoveryRuntime({
    required this.scanner,
    required this.store,
    this.buildDraft,
  });

  Future<List<HardwareSkillArchiveResult>> scanOnce() async {
    final devices = await scanner.scan();
    final results = <HardwareSkillArchiveResult>[];
    for (final device in devices) {
      results.add(await store.archive(device, buildDraft: buildDraft));
    }
    return results;
  }

  Stream<List<HardwareSkillArchiveResult>> poll({
    Duration interval = const Duration(seconds: 5),
    int? maxTicks,
  }) async* {
    var ticks = 0;
    while (maxTicks == null || ticks < maxTicks) {
      yield await scanOnce();
      ticks += 1;
      if (maxTicks == null || ticks < maxTicks) {
        await Future<void>.delayed(interval);
      }
    }
  }
}
