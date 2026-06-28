# Architecture

EcoBlocks uses an Android device as the only Hub. The Hub owns the UI, automation decisions, storage, agent runtime, and bus communication.

```text
Flutter App
    |
WebView Blockly UI
    |
Hub / Agent Runtime
    |
Transport Layer
    |
Dumb Sensor and Actuator Nodes
```

## Boundaries

- `app/` hosts the Flutter shell and WebView bridge.
- `ui/blocks/` owns the Blockly workspace bundle and custom blocks.
- `agent/core/` owns pure Dart runtime models and bridge messages.
- `agent/core/lib/transports/` owns transport contracts shared by BLE, Wi-Fi,
  mock, and future adapter implementations.
- `agent/devices/` documents device-node directions.
- `agent/protocols/` documents bus protocol experiments.

Detailed hardware protocol fields are intentionally not stable yet. Keep mock payloads minimal until real hardware confirms the shape.

## Transport Direction

- BLE is the first low-power node base.
- Wi-Fi is the high-bandwidth and developer-friendly base.
- CAN and RS-485 remain future external industrial adapter routes.

The Flutter app owns platform plugins and permissions. The pure Dart core only
knows the transport interface, device discovery envelope, lifecycle status, and
outer message envelope.
