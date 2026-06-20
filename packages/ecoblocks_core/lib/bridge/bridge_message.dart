/// Dart ↔ Blockly JS 桥接消息协议。
///
/// 方向：
///   Dart → JS: "sensor_update", "actuator_state"
///   JS → Dart: "block_clicked", "rule_changed"

import '../models/mock_device.dart';

/// Dart 发给 Blockly 的消息。
sealed class ToBlockly {
  Map<String, dynamic> toJson();
}

class SensorUpdate implements ToBlockly {
  final MockSensor sensor;
  const SensorUpdate(this.sensor);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'sensor_update',
        'sensor': sensor.toJson(),
      };
}

class ActuatorState implements ToBlockly {
  final MockActuator actuator;
  const ActuatorState(this.actuator);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'actuator_state',
        'actuator': actuator.toJson(),
      };
}

/// Blockly 发给 Dart 的消息。
sealed class FromBlockly {
  const FromBlockly();

  factory FromBlockly.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String) {
      'block_clicked' => BlockClicked(json['block_id'] as String, json['block_type'] as String),
      'rule_changed' => RuleChanged(json['rule_count'] as int),
      _ => UnknownMessage(json),
    };
  }
}

class BlockClicked extends FromBlockly {
  final String blockId;
  final String blockType;
  const BlockClicked(this.blockId, this.blockType) : super();
}

class RuleChanged extends FromBlockly {
  final int ruleCount;
  const RuleChanged(this.ruleCount) : super();
}

class UnknownMessage extends FromBlockly {
  final Map<String, dynamic> raw;
  const UnknownMessage(this.raw) : super();
}
