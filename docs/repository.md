# Repository

The repository is organized around product layers rather than the first aquarium scenario.

```text
ecoblocks/
├── app/
│   └── README.md
├── ui/
│   ├── blocks/
│   ├── dashboard/
│   ├── components/
│   └── README.md
├── agent/
│   ├── core/
│   ├── runtime/
│   ├── capabilities/
│   ├── devices/
│   ├── protocols/
│   ├── embedded/
│   ├── firmware/
│   ├── safety/
│   ├── memory/
│   └── README.md
├── examples/
│   ├── aquarium/
│   ├── terrarium/
│   └── hydroponics/
├── docs/
├── tools/
├── README.md
├── AGENTS.md
└── CLAUDE.md
```

## Mapping From The Old Layout

- `blockly/` moved to `ui/blocks/`.
- `packages/ecoblocks_core/` moved to `agent/core/`.
- `hardware/` moved to `agent/devices/`.
- `protocol/` moved to `agent/protocols/`.
- `legacy_android/` moved to `agent/embedded/`.

## Current Implementation Status

- `app/` is the modern Flutter host.
- `ui/blocks/` builds the Blockly workspace bundle consumed by the app.
- `agent/core/` is a pure Dart package used by the Flutter app.
- Empty module folders are intentional placeholders for the next slices.
