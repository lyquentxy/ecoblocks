# EcoBlocks Bus Protocol Notes

This directory records bus protocol exploration.

Current direction:

- BLE is the first low-power node base.
- Wi-Fi is the high-bandwidth and developer-friendly base.
- CAN 2.0B and RS-485 Modbus remain future external industrial adapter routes.
- Android owns the Hub role.
- Sensor and actuator nodes stay dumb.

Do not freeze frame layouts or detailed payload fields yet. The active data rule is still mock-first:

```json
{"temp": "mock"}
{"fan": "mock"}
```

When real adapter and node firmware tests exist, promote confirmed fields into this document.
