/**
 * EcoBlocks Bridge — JS ↔ Dart 通信层
 *
 * 方向：
 *   Dart → JS:  Flutter 通过 evaluateJavascript 调用 window.EcoBridge.receive(json)
 *   JS   → Dart: Blockly 事件通过 window.EcoBridge.send(json) 回传
 *
 *   底层使用 Flutter 的 JavaScriptChannel (window.flutterPostMessage)
 */

window.EcoBridge = {
  /**
   * 发送消息给 Dart 侧。
   * Flutter WebView 会拦截 postMessage 调用。
   */
  send: function (msg) {
    try {
      // Flutter JavaScriptChannel 注入的方法名
      if (window.flutterPostMessage) {
        window.flutterPostMessage(JSON.stringify(msg));
      }
    } catch (e) {
      console.log('[EcoBridge] send error:', e);
    }
  },

  /**
   * 接收来自 Dart 侧的消息。
   * Flutter 侧调用 evaluateJavascript('EcoBridge.receive(...)')
   */
  receive: function (jsonStr) {
    try {
      const msg = JSON.parse(jsonStr);
      console.log('[EcoBridge] received:', msg);
      window.dispatchEvent(
        new CustomEvent('ecoblocks-message', { detail: msg })
      );
    } catch (e) {
      console.log('[EcoBridge] receive error:', e);
    }
  },
};
