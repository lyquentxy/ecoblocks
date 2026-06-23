window.EcoBridge = {
  send: function (msg) {
    try {
      const payload = JSON.stringify(msg);
      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
        window.flutter_inappwebview.callHandler('flutterPostMessage', payload);
        return;
      }
      if (window.flutterPostMessage) {
        window.flutterPostMessage(payload);
      }
    } catch (e) {
      console.log('[EcoBridge] send error:', e);
    }
  },

  receive: function (jsonStr) {
    try {
      const msg = typeof jsonStr === 'string' ? JSON.parse(jsonStr) : jsonStr;
      window.dispatchEvent(new CustomEvent('ecoblocks-message', { detail: msg }));
    } catch (e) {
      console.log('[EcoBridge] receive error:', e);
    }
  },
};
