# Agent Runtime

The agent runtime belongs under `agent/`.

Current runtime code lives in `agent/core/lib/agents/` because it is still small and pure Dart. If runtime concerns grow beyond the shared package, move orchestration-specific code into `agent/runtime/` while keeping common models in `agent/core/`.

The runtime should work from minimal mock inputs first:

```json
{"temp": "mock"}
{"fan": "mock"}
```

Do not introduce stable hardware protocol fields before the device protocol is confirmed.

## Agent v1 Hardware Skill Archive

The first hardware skill archive is intentionally minimal:

- Scanned devices with a serial number are recorded in an index JSON that points
  to one skill JSON per serial.
- Each per-device skill JSON starts as a mock placeholder. Do not predefine
  protocol, API, or capability fields here.
- Scanned devices without a serial number are kept in a separate non-serial JSON
  so they are visible but do not enter the serial index.
- The archive lives in the app documents directory at runtime, not in repository
  source files.

DeepSeek may be used later to draft candidate skill contents, but those contents
remain mock/candidate data until real hardware behavior is confirmed.
