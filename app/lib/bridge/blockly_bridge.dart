import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ecoblocks_core/ecoblocks_core.dart';

/// Blockly ↔ Dart 桥接器。
///
/// 负责：
///   1. 往 Blockly JS 发送传感器/执行器数据
///   2. 接收 Blockly 用户操作事件
class BlocklyBridge {
  final InAppWebViewController controller;
  final void Function(FromBlockly msg) onMessage;

  BlocklyBridge({required this.controller, required this.onMessage}) {
    _setupJsHandler();
  }

  /// 注册 JavaScriptChannel，接收 JS 发来的消息。
  void _setupJsHandler() {
    controller.addJavaScriptHandler(
      handlerName: 'flutterPostMessage',
      callback: (args) {
        if (args.isNotEmpty) {
          try {
            final json = jsonDecode(args.first as String) as Map<String, dynamic>;
            onMessage(FromBlockly.fromJson(json));
          } catch (_) {
            // 解析失败，忽略
          }
        }
      },
    );
  }

  /// 发送传感器更新到 Blockly。
  void sendSensorUpdate(MockSensor sensor) {
    _eval(SensorUpdate(sensor).toJson());
  }

  /// 发送执行器状态到 Blockly。
  void sendActuatorState(MockActuator actuator) {
    _eval(ActuatorState(actuator).toJson());
  }

  /// 执行 JS: EcoBridge.receive(json)
  void _eval(Map<String, dynamic> msg) {
    final json = jsonEncode(msg);
    controller.evaluateJavascript(
      source: "window.EcoBridge && window.EcoBridge.receive('$json')",
    );
  }
}
