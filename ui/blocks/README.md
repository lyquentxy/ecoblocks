# Blocks

Blockly workspace bundle used by the Flutter app.

Responsibilities:

- Custom EcoBlocks blocks.
- Blockly toolbox and built-in Blockly i18n.
- Ink-style workspace theme and background.
- WebView bridge messages.

Build from this directory:

```bash
npm run build
```

Then copy `dist/ecoblocks.js` and `dist/index.html` into `app/assets/blockly/`.
