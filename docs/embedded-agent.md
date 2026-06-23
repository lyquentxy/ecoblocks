# Embedded Agent

`agent/embedded/` tracks low-memory and legacy Android routes.

The current product direction is Android API 21+ for the main Flutter app. Android 4.4/API 19 is not part of the modern Flutter APK. If it returns as a product target, treat it as a separate lightweight control endpoint with a smaller UI surface.

The embedded route may read saved rules or simple form rules, but the full Blockly editing experience belongs to the modern app and web-facing UI.
