import * as Blockly from 'blockly';
import { tempBlock } from './blocks/temp_block';
import { fanBlock } from './blocks/fan_block';

// 注册自定义积木块
Blockly.Blocks['sensor_temp'] = tempBlock;
Blockly.Blocks['actuator_fan'] = fanBlock;

// 读取 toolbox XML
const toolboxXml = document.getElementById('toolbox');
const toolbox = toolboxXml
  ? Blockly.utils.xml.textToDom(toolboxXml.outerHTML)
  : null;
toolboxXml?.remove();

// 创建工作区
const workspace = Blockly.inject('blocklyDiv', {
  toolbox: toolbox,
  scrollbars: true,
  trashcan: true,
  zoom: { controls: true, wheel: true, startScale: 1.0 },
  grid: { spacing: 20, length: 3, colour: '#e0e0e0' },
});

// ---------- 监听 Blockly 事件 → 发给 Dart ----------
workspace.addChangeListener((event) => {
  // 只关心有意义的用户操作
  if (event.type === Blockly.Events.BLOCK_CREATE ||
      event.type === Blockly.Events.BLOCK_DELETE ||
      event.type === Blockly.Events.BLOCK_CHANGE ||
      event.type === Blockly.Events.BLOCK_MOVE) {
    window.EcoBridge.send({
      type: 'blockly_event',
      eventType: event.type,
      blockCount: workspace.getAllBlocks(false).length,
    });
  }
});

// ---------- 接收来自 Dart 的消息 ----------
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

// ---------- 更新积木块显示 ----------
function updateSensorBlock(sensor) {
  const blocks = workspace
    .getAllBlocks(false)
    .filter((b) => b.type === 'sensor_temp');
  blocks.forEach((b) => {
    const valueField = b.getField('value');
    if (valueField) {
      valueField.setValue(String(sensor.value));
    }
  });
}

function updateActuatorBlock(actuator) {
  const blocks = workspace
    .getAllBlocks(false)
    .filter((b) => b.type === 'actuator_fan');
  blocks.forEach((b) => {
    const stateField = b.getField('state');
    if (stateField) {
      stateField.setValue(actuator.state === 'on' ? '开' : '关');
    }
  });
}

// 初始：放一些 mock 积木块在画布上
function seedMockBlocks() {
  const tempBlock = workspace.newBlock('sensor_temp');
  tempBlock.initSvg();
  tempBlock.render();
  tempBlock.moveBy(50, 50);

  const fanBlock = workspace.newBlock('actuator_fan');
  fanBlock.initSvg();
  fanBlock.render();
  fanBlock.moveBy(50, 150);
}

// Blockly 渲染完成后放置 mock 积木块
setTimeout(seedMockBlocks, 500);

// 通知 Dart 侧 Blockly 已就绪
window.addEventListener('load', () => {
  window.EcoBridge.send({ type: 'blockly_ready' });
});
