import 'dart:convert';

import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BlocklyBridge {
  final InAppWebViewController controller;
  final void Function(FromBlockly msg) onMessage;

  BlocklyBridge({required this.controller, required this.onMessage}) {
    _setupJsHandler();
  }

  void _setupJsHandler() {
    controller.addJavaScriptHandler(
      handlerName: 'flutterPostMessage',
      callback: (args) {
        if (args.isEmpty) return;
        try {
          final json = jsonDecode(args.first as String) as Map<String, dynamic>;
          onMessage(FromBlockly.fromJson(json));
        } catch (_) {
          // Ignore malformed messages from the WebView.
        }
      },
    );
  }

  void sendSensorUpdate(MockSensor sensor) {
    _eval(SensorUpdate(sensor).toJson());
  }

  void sendActuatorState(MockActuator actuator) {
    _eval(ActuatorState(actuator).toJson());
  }

  void sendDeviceProfile(DeviceProfile profile) {
    _eval(DeviceProfileMessage(profile).toJson());
  }

  void sendAgentStatus(String status, String message) {
    _eval(AgentStatusMessage(status, message).toJson());
  }

  void _eval(Map<String, dynamic> msg) {
    final json = jsonEncode(msg);
    controller.evaluateJavascript(
      source:
          "window.EcoBridge && window.EcoBridge.receive(${jsonEncode(json)})",
    );
  }
}
