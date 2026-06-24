package com.ecoblocks

import android.os.Build
import android.os.Bundle
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.io.File

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        prepareWebViewStorage()
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // flutter_inappwebview handles the WebView and JavaScript bridge.
    }

    private fun prepareWebViewStorage() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            WebView.setDataDirectorySuffix("ecoblocks")
        }

        listOf(
            File(cacheDir, "WebView/Default/HTTP Cache/Code Cache/webui_js"),
            File(cacheDir, "WebView/Default/HTTP Cache/Code Cache/js"),
            File(cacheDir, "WebView/Default/HTTP Cache/Code Cache/wasm"),
        ).forEach { it.mkdirs() }
    }
}
