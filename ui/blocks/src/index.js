import * as Blockly from 'blockly';
import * as EnMessages from 'blockly/msg/en';
import * as ZhHansMessages from 'blockly/msg/zh-hans';
import './bridge';
import './agent_overlay';
import './renderers/ink/renderer';
import { tempBlock } from './blocks/temp_block';
import { fanBlock } from './blocks/fan_block';
import { settingsBlock } from './blocks/settings_block';
import { getBlocklyLocale, setBlocklyLocale, t } from './i18n';

Blockly.Blocks['sensor_temp'] = tempBlock;
Blockly.Blocks['actuator_fan'] = fanBlock;
Blockly.Blocks['system_settings'] = settingsBlock;

applyBlocklyLocale(getBlocklyLocale());

const workspace = Blockly.inject('blocklyDiv', {
  renderer: 'ink',
  media: './media/',
  toolbox: buildToolbox(),
  scrollbars: true,
  trashcan: true,
  zoom: { controls: true, wheel: true, startScale: 1.0 },
  grid: { spacing: 20, length: 3, colour: '#e0e0e0' },
});

workspace.addChangeListener((event) => {
  if (
    event.type === Blockly.Events.BLOCK_CREATE ||
    event.type === Blockly.Events.BLOCK_DELETE ||
    event.type === Blockly.Events.BLOCK_CHANGE ||
    event.type === Blockly.Events.BLOCK_MOVE
  ) {
    window.EcoBridge.send({
      type: 'blockly_event',
      eventType: event.type,
      blockCount: workspace.getAllBlocks(false).length,
    });
  }
});

window.addEventListener('ecoblocks-message', (e) => {
  const msg = e.detail;
  if (!msg || !msg.type) return;
  switch (msg.type) {
    case 'sensor_update':
      updateSensorBlock(msg.sensor);
      break;
    case 'actuator_state':
      updateActuatorBlock(msg.actuator);
      break;
    case 'locale_changed':
      applyBlocklyLocale(msg.locale);
      applyLocaleToWorkspace();
      break;
  }
});

let lastSettingsClickAt = 0;

workspace.addChangeListener((event) => {
  if (event.type !== Blockly.Events.CLICK) return;
  const blockId = event.blockId;
  const block = blockId ? workspace.getBlockById(blockId) : null;
  if (!block || block.type !== 'system_settings') return;
  const now = Date.now();
  if (now - lastSettingsClickAt <= 450) {
    window.EcoBridge.send({ type: 'settings_open_requested' });
  }
  lastSettingsClickAt = now;
});

function buildToolbox() {
  return Blockly.utils.xml.textToDom(`
    <xml>
      <category name="${escapeXml(t('sensors'))}" colour="#486b58">
        <block type="sensor_temp"></block>
      </category>
      <category name="${escapeXml(t('actuators'))}" colour="#5d5d67">
        <block type="actuator_fan"></block>
      </category>
      <category name="${escapeXml(t('logic'))}" colour="#596b7a">
        <block type="logic_compare"></block>
        <block type="controls_if"></block>
      </category>
    </xml>
  `);
}

function applyBlocklyLocale(locale) {
  const normalized = setBlocklyLocale(locale);
  Blockly.setLocale(normalized === 'en' ? EnMessages : ZhHansMessages);
}

function escapeXml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function applyLocaleToWorkspace() {
  workspace.updateToolbox(buildToolbox());
  workspace.getAllBlocks(false).forEach((block) => {
    if (block.type === 'sensor_temp') {
      setField(block, 'label', t('temperature'));
      block.setTooltip(t('tempTooltip'));
    }
    if (block.type === 'actuator_fan') {
      setField(block, 'label', t('fan'));
      const stateField = block.getField('state');
      const current = stateField?.getValue();
      if (current === 'on' || current === '\u5f00') {
        setField(block, 'state', t('on'));
      } else {
        setField(block, 'state', t('off'));
      }
      block.setTooltip(t('fanTooltip'));
    }
    if (block.type === 'system_settings') {
      setField(block, 'label', t('settings'));
      block.setTooltip(t('settings'));
      pinSettingsBlock(block);
    }
    block.render();
  });
}

function setField(block, name, value) {
  const field = block.getField(name);
  if (field) field.setValue(value);
}

function updateSensorBlock(sensor) {
  workspace
    .getAllBlocks(false)
    .filter((b) => b.type === 'sensor_temp')
    .forEach((b) => {
      const valueField = b.getField('value');
      if (valueField) valueField.setValue(String(sensor.value));
    });
}

function updateActuatorBlock(actuator) {
  workspace
    .getAllBlocks(false)
    .filter((b) => b.type === 'actuator_fan')
    .forEach((b) => {
      const stateField = b.getField('state');
      if (stateField) stateField.setValue(actuator.state === 'on' ? t('on') : t('off'));
    });
}

function seedMockBlocks() {
  const temp = workspace.newBlock('sensor_temp');
  temp.initSvg();
  temp.render();
  temp.moveBy(50, 50);

  const fan = workspace.newBlock('actuator_fan');
  fan.initSvg();
  fan.render();
  fan.moveBy(50, 150);

  const settings = workspace.newBlock('system_settings');
  settings.initSvg();
  settings.render();
  pinSettingsBlock(settings);
}

setTimeout(seedMockBlocks, 500);

function pinSettingsBlock(block) {
  const metrics = workspace.getMetrics();
  if (!metrics) return;
  const size = block.getHeightWidth();
  const current = block.getRelativeToSurfaceXY();
  const targetX = metrics.viewLeft + metrics.viewWidth / 2 - size.width / 2;
  const targetY = metrics.viewTop + metrics.viewHeight / 2 - size.height / 2;
  block.moveBy(targetX - current.x, targetY - current.y);
}

window.addEventListener('resize', () => {
  const settings = workspace
    .getAllBlocks(false)
    .find((block) => block.type === 'system_settings');
  if (settings) pinSettingsBlock(settings);
});

window.addEventListener('load', () => {
  applyBlocklyLocale(getBlocklyLocale());
  window.EcoBridge.send({ type: 'blockly_ready' });
});
