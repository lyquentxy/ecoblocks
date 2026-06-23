# App

Flutter host application for EcoBlocks.

Responsibilities:

- Runs on the Android Hub device.
- Hosts the Blockly workspace inside WebView.
- Owns app-level localization and settings persistence.
- Bridges Hub state between Flutter and Blockly.

The app depends on the pure Dart package at `../agent/core`.
