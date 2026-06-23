# Safety

EcoBlocks controls real ecological environments, so safety rules belong in the Hub rather than in dumb nodes.

Initial safety direction:

- Default to mock values while hardware is unknown.
- Keep actuator commands explicit and observable.
- Prefer simple failure states over hidden retries.
- Add limits only when tied to real device behavior.

Safety implementation work should live in `agent/safety/` once it becomes code rather than documentation.
