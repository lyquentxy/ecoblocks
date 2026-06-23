# EcoBlocks Bus Protocol Notes

This directory records bus protocol exploration.

Current direction:

- CAN 2.0B is the primary candidate.
- RS-485 Modbus remains a fallback.
- Android connects to one Bus Adapter.
- Sensor and actuator nodes stay dumb.

Do not freeze frame layouts or detailed payload fields yet. The active data rule is still mock-first:

```json
{"temp": "mock"}
{"fan": "mock"}
```

When real adapter and node firmware tests exist, promote confirmed fields into this document.
