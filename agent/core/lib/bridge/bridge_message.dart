import '../agents/device_profile.dart';
import '../models/mock_device.dart';

/// Dart -> Blockly JS messages.
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

class DeviceProfileMessage implements ToBlockly {
  final DeviceProfile profile;
  const DeviceProfileMessage(this.profile);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'device_profile',
        'profile': profile.toJson(),
      };
}

class AgentStatusMessage implements ToBlockly {
  final String status;
  final String message;
  const AgentStatusMessage(this.status, this.message);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'agent_status',
        'status': status,
        'message': message,
      };
}

class LocaleChanged implements ToBlockly {
  final String localeCode;
  const LocaleChanged(this.localeCode);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'locale_changed',
        'locale': localeCode,
      };
}

/// Blockly JS -> Dart messages.
sealed class FromBlockly {
  const FromBlockly();

  factory FromBlockly.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String) {
      'block_clicked' => BlockClicked(
          json['block_id'] as String,
          json['block_type'] as String,
        ),
      'rule_changed' => RuleChanged(json['rule_count'] as int),
      'settings_open_requested' => const SettingsOpenRequested(),
      'settings_changed' => SettingsChanged(
          (json['locale'] ?? '') as String,
        ),
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

class SettingsChanged extends FromBlockly {
  final String localeCode;
  const SettingsChanged(this.localeCode) : super();
}

class SettingsOpenRequested extends FromBlockly {
  const SettingsOpenRequested() : super();
}

class UnknownMessage extends FromBlockly {
  final Map<String, dynamic> raw;
  const UnknownMessage(this.raw) : super();
}
