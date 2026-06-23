import 'dart:async';
import 'dart:convert';

import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../bridge/blockly_bridge.dart';
import '../controllers/hub_controller.dart';
import '../l10n/app_localizations.dart';
import '../settings/app_settings.dart';

class WorkspacePage extends StatefulWidget {
  final HubController controller;

  const WorkspacePage({required this.controller, super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  BlocklyBridge? _bridge;
  StreamSubscription<AgentEvent>? _agentSub;
  String? _htmlWithJs;
  String? _lastSentLocale;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onHubChanged);
    _boot();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sendCurrentLocaleToBlockly();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onHubChanged);
    _agentSub?.cancel();
    super.dispose();
  }

  Future<void> _boot() async {
    final html = await rootBundle.loadString('assets/blockly/index.html');
    final inkCss = await rootBundle.loadString('assets/blockly/ink_style.css');
    final inkBackground =
        await rootBundle.load('assets/blockly/ink_background.png');
    final bridgeJs =
        await rootBundle.loadString('assets/blockly/bridge_runtime.js');
    final blocklyJs =
        await rootBundle.loadString('assets/blockly/ecoblocks.js');
    final htmlWithoutScripts = html.replaceAll(
      RegExp(r'<script[^>]*src="ecoblocks\.js"[^>]*></script>'),
      '',
    );
    final htmlWithStyle = htmlWithoutScripts.replaceFirst(
      '</head>',
      '<style>:root{--ecoblocks-ink-bg:url("data:image/png;base64,${base64Encode(inkBackground.buffer.asUint8List())}");}</style><style>$inkCss</style></head>',
    );
    final htmlWithJs = htmlWithStyle.replaceFirst(
      '</body>',
      '<script>$bridgeJs</script><script>$blocklyJs</script></body>',
    );
    if (!mounted) return;
    setState(() => _htmlWithJs = htmlWithJs);
  }

  void _onHubChanged() {
    _sendCurrentLocaleToBlockly();
    if (mounted) setState(() {});
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _bridge = BlocklyBridge(
      controller: controller,
      onMessage: (msg) {
        if (msg is RuleChanged) {
          debugPrint('[Blockly] rule count: ${msg.ruleCount}');
        }
        if (msg is SettingsChanged &&
            (msg.localeCode == 'zh' || msg.localeCode == 'en')) {
          _saveSettings(
            widget.controller.settings.copyWith(localeCode: msg.localeCode),
          );
        }
        if (msg is UnknownMessage && msg.raw['type'] == 'blockly_ready') {
          widget.controller.setBlocklyReady(true);
          _sendCurrentLocaleToBlockly();
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

  void _sendCurrentLocaleToBlockly() {
    final bridge = _bridge;
    if (bridge == null || !widget.controller.blocklyReady || !mounted) return;
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_lastSentLocale == localeCode) return;
    _lastSentLocale = localeCode;
    bridge.sendLocaleChanged(localeCode);
  }

  Future<void> _runAgentScan() async {
    await _agentSub?.cancel();
    final runtime = AgentRuntime(agent: _createAgent());
    final devices = _mockScan();
    widget.controller.startScan('Found ${devices.length} mock devices');

    _agentSub = runtime.runScan(devices).listen((event) {
      switch (event) {
        case AgentStatusEvent(:final status, :final message):
          widget.controller.setAgentStatus(status, message);
          _bridge?.sendAgentStatus(status, message);
        case AgentProfileEvent(:final profile):
          widget.controller.addProfile(profile);
          _bridge?.sendDeviceProfile(profile);
          _applyProfileToMockBlocks(profile);
        case AgentErrorEvent(:final message):
          widget.controller.setAgentStatus('error', message);
          _bridge?.sendAgentStatus('error', message);
      }
    });
  }

  DeviceAgent _createAgent() {
    final settings = widget.controller.settings;
    if (settings.hasDeepSeekKey) {
      return DeepSeekAgent(
        config: DeepSeekConfig(apiKey: settings.deepSeekApiKey.trim()),
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
      final sensor = MockSensor(
        id: profile.deviceId,
        type: 'temp',
        value: 'mock',
        unit: 'C',
      );
      widget.controller.setMockSensor(sensor);
      _bridge?.sendSensorUpdate(sensor);
    }
    if (profile.deviceId.contains('fan') || profile.type.contains('fan')) {
      final actuator = MockActuator(
        id: profile.deviceId,
        type: 'fan',
        state: 'off',
      );
      widget.controller.setMockActuator(actuator);
      _bridge?.sendActuatorState(actuator);
    }
  }

  Future<void> _saveSettings(AppSettings settings) async {
    final current = widget.controller.settings;
    if (current.deepSeekApiKey == settings.deepSeekApiKey &&
        current.localeCode == settings.localeCode) {
      return;
    }
    final previousKey = widget.controller.settings.deepSeekApiKey;
    await widget.controller.saveSettings(settings);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lastSentLocale = null;
      _sendCurrentLocaleToBlockly();
    });
    if (previousKey != settings.deepSeekApiKey &&
        widget.controller.blocklyReady) {
      await _runAgentScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hub = widget.controller;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (hub.settings.hasDeepSeekKey)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.auto_awesome, size: 20),
            ),
          if (hub.blocklyReady)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _BlocklyPane(
            webView: _htmlWithJs == null
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
        },
      ),
    );
  }
}

class _BlocklyPane extends StatelessWidget {
  final Widget webView;

  const _BlocklyPane({
    required this.webView,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: webView,
    );
  }
}
