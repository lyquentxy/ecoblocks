# Architecture

EcoBlocks uses an Android device as the only Hub. The Hub owns the UI, automation decisions, storage, agent runtime, and bus communication.

```text
Flutter App
    |
WebView Blockly UI
    |
Hub / Agent Runtime
    |
Bus Adapter
    |
Dumb Sensor and Actuator Nodes
```

## Boundaries

- `app/` hosts the Flutter shell and WebView bridge.
- `ui/blocks/` owns the Blockly workspace bundle and custom blocks.
- `agent/core/` owns pure Dart runtime models and bridge messages.
- `agent/devices/` documents device-node directions.
- `agent/protocols/` documents bus protocol experiments.

Detailed hardware protocol fields are intentionally not stable yet. Keep mock payloads minimal until real hardware confirms the shape.
