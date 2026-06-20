import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ecoblocks_core/ecoblocks_core.dart';
import '../bridge/blockly_bridge.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  InAppWebViewController? _webViewController;
  BlocklyBridge? _bridge;
  Timer? _mockTimer;
  bool _blocklyReady = false;
  String? _htmlWithJs;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
    super.dispose();
  }

  /// 从 assets 读 HTML 和 JS，把 JS 内嵌到 HTML 里。
  /// 不依赖本地 HTTP 服务器，兼容 Android 4.4。
  Future<void> _loadHtml() async {
    final html = await rootBundle.loadString('assets/blockly/index.html');
    final js = await rootBundle.loadString('assets/blockly/ecoblocks.js');

    // 把 <script src="ecoblocks.js"> 替换为内联 <script>
    _htmlWithJs = html.replaceFirst(
      RegExp(r'<script[^>]*src="ecoblocks\.js"[^>]*></script>'),
      '<script>$js</script>',
    );
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _webViewController = controller;

    _bridge = BlocklyBridge(
      controller: controller,
      onMessage: (msg) {
        if (msg is RuleChanged) {
          debugPrint('[Blockly] 规则数: ${msg.ruleCount}');
        }
        if (msg is UnknownMessage && msg.raw['type'] == 'blockly_ready') {
          setState(() => _blocklyReady = true);
          _startMockData();
        }
      },
    );

    // 直接加载 HTML 字符串，不走网络
    if (_htmlWithJs != null) {
      controller.loadData(
        data: _htmlWithJs!,
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: null,
      );
    }
  }

  void _startMockData() {
    double temp = 25.0;
    _mockTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      temp += (DateTime.now().millisecond % 100) / 1000.0 - 0.05;
      temp = double.parse(temp.toStringAsFixed(1));
      _bridge?.sendSensorUpdate(
        MockSensor(id: 'mock-temp-01', type: 'temp', value: temp, unit: '°C'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoBlocks'),
        actions: [
          if (_blocklyReady)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
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
