# EcoBlocks

EcoBlocks is a programmable automation platform for ecological systems running on low-power Android devices.

It is not a smart aquarium project. Aquarium is the first scenario; the platform should also fit terrariums, hydroponics, incubation boxes, classroom experiments, and other small ecosystems.

## Core Direction

- Android is the Hub. There is no separate Hub hardware.
- Hardware nodes are dumb. They collect data or execute actions; they do not decide.
- Blockly is the expression layer for user rules and controls.
- Android connects to one Bus Adapter, and all nodes hang from that bus.
- Mock data stays minimal until the hardware protocol is real.

```json
{"temp": "mock"}
{"fan": "mock"}
```

## Repository Layout

```text
ecoblocks/
├── app/          # Flutter Android host app
├── ui/           # User-facing UI surfaces
├── agent/        # Runtime, device, protocol, firmware, and safety modules
├── examples/     # Scenario examples
├── docs/         # Architecture and repository docs
├── tools/        # Local developer tools
├── README.md
├── AGENTS.md
└── CLAUDE.md
```

See [docs/repository.md](docs/repository.md) for the full directory map.

## Build Notes

All tool caches must stay inside project `.cache/`.

```bash
source setenv.sh
```

Current runnable pieces:

- Flutter app: `app/`
- Blockly workspace bundle: `ui/blocks/`
- Pure Dart core package: `agent/core/`

## License

MIT License
