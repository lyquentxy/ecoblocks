# Agent Runtime

The agent runtime belongs under `agent/`.

Current runtime code lives in `agent/core/lib/agents/` because it is still small and pure Dart. If runtime concerns grow beyond the shared package, move orchestration-specific code into `agent/runtime/` while keeping common models in `agent/core/`.

The runtime should work from minimal mock inputs first:

```json
{"temp": "mock"}
{"fan": "mock"}
```

Do not introduce stable hardware protocol fields before the device protocol is confirmed.
