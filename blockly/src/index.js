import * as Blockly from 'blockly';
import './bridge';
import './agent_overlay';
import './renderers/ink/renderer';
import { tempBlock } from './blocks/temp_block';
import { fanBlock } from './blocks/fan_block';

Blockly.Blocks['sensor_temp'] = tempBlock;
Blockly.Blocks['actuator_fan'] = fanBlock;

const toolboxXml = document.getElementById('toolbox');
const toolbox = toolboxXml ? Blockly.utils.xml.textToDom(toolboxXml.outerHTML) : null;
toolboxXml?.remove();

const workspace = Blockly.inject('blocklyDiv', {
  renderer: 'ink',
  toolbox,
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
  }
});

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
      if (stateField) stateField.setValue(actuator.state === 'on' ? 'on' : 'off');
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
}

setTimeout(seedMockBlocks, 500);

window.addEventListener('load', () => {
  window.EcoBridge.send({ type: 'blockly_ready' });
});
