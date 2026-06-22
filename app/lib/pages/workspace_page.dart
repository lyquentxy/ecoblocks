import 'dart:async';

import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../bridge/blockly_bridge.dart';
import '../settings/app_settings.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final _settingsStore = AppSettingsStore();

  InAppWebViewController? _webViewController;
  BlocklyBridge? _bridge;
  StreamSubscription<AgentEvent>? _agentSub;
  AppSettings _settings = const AppSettings();
  bool _blocklyReady = false;
  String? _htmlWithJs;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _agentSub?.cancel();
    super.dispose();
  }

  Future<void> _boot() async {
    final settings = await _settingsStore.load();
    final html = await rootBundle.loadString('assets/blockly/index.html');
    final inkCss = await rootBundle.loadString('assets/blockly/ink_style.css');
    final bridgeJs =
        await rootBundle.loadString('assets/blockly/bridge_runtime.js');
    final blocklyJs =
        await rootBundle.loadString('assets/blockly/ecoblocks.js');
    final overlayJs =
        await rootBundle.loadString('assets/blockly/agent_overlay.js');
    final htmlWithStyle = html.replaceFirst(
      '</head>',
      '<style>$inkCss</style></head>',
    );
    final htmlWithJs = htmlWithStyle.replaceFirst(
      RegExp(r'<script[^>]*src="ecoblocks\.js"[^>]*></script>'),
      '<script>$bridgeJs</script><script>$blocklyJs</script><script>$overlayJs</script>',
    );
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _htmlWithJs = htmlWithJs;
    });
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _webViewController = controller;
    _bridge = BlocklyBridge(
      controller: controller,
      onMessage: (msg) {
        if (msg is RuleChanged) {
          debugPrint('[Blockly] rule count: ${msg.ruleCount}');
        }
        if (msg is UnknownMessage && msg.raw['type'] == 'blockly_ready') {
          setState(() => _blocklyReady = true);
          _runAgentScan();
        }
      },
    );

    final html = _htmlWithJs;
    if (html != null) {
      controller.loadData(
        data: html,
        mimeType: 'text/html',
        encoding: 'utf-8',
      );
    }
  }

  Future<void> _runAgentScan() async {
    await _agentSub?.cancel();
    final runtime = AgentRuntime(agent: _createAgent());
    final devices = _mockScan();

    _agentSub = runtime.runScan(devices).listen((event) {
      switch (event) {
        case AgentStatusEvent(:final status, :final message):
          _bridge?.sendAgentStatus(status, message);
        case AgentProfileEvent(:final profile):
          _bridge?.sendDeviceProfile(profile);
          _applyProfileToMockBlocks(profile);
        case AgentErrorEvent(:final message):
          _bridge?.sendAgentStatus('error', message);
      }
    });
  }

  DeviceAgent _createAgent() {
    if (_settings.hasDeepSeekKey) {
      return DeepSeekAgent(
        config: DeepSeekConfig(apiKey: _settings.deepSeekApiKey.trim()),
      );
    }
    return const MockAgent();
  }

  List<ScannedDevice> _mockScan() => const [
        ScannedDevice(
          id: 'mock-temp-01',
          name: 'EB-Temp-01',
          source: 'mock',
          raw: {'hint': 'temperature sensor'},
        ),
        ScannedDevice(
          id: 'mock-fan-01',
          name: 'EB-Fan-01',
          source: 'mock',
          raw: {'hint': 'fan actuator'},
        ),
      ];

  void _applyProfileToMockBlocks(DeviceProfile profile) {
    if (profile.deviceId.contains('temp') || profile.type.contains('temp')) {
      _bridge?.sendSensorUpdate(
        MockSensor(
          id: profile.deviceId,
          type: 'temp',
          value: 'mock',
          unit: 'C',
        ),
      );
    }
    if (profile.deviceId.contains('fan') || profile.type.contains('fan')) {
      _bridge?.sendActuatorState(
        MockActuator(
          id: profile.deviceId,
          type: 'fan',
          state: 'off',
        ),
      );
    }
  }

  Future<void> _showSettingsDialog() async {
    final controller = TextEditingController(text: _settings.deepSeekApiKey);
    final saved = await showDialog<AppSettings>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DeepSeek Settings'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'DeepSeek SK',
            hintText: 'sk-...',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              AppSettings(deepSeekApiKey: controller.text.trim()),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (saved == null) return;
    await _settingsStore.save(saved);
    if (!mounted) return;
    setState(() => _settings = saved);
    if (_blocklyReady) {
      await _runAgentScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoBlocks'),
        actions: [
          if (_settings.hasDeepSeekKey)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.auto_awesome, size: 20),
            ),
          if (_blocklyReady)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
          IconButton(
            onPressed: _showSettingsDialog,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _htmlWithJs == null
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  transparentBackground: true,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onWebViewCreated: _onWebViewCreated,
              onConsoleMessage: (_, msg) {
                debugPrint('[Blockly JS] ${msg.message}');
              },
            ),
    );
  }
}
