import * as Blockly from 'blockly';

/**
 * 温度传感器积木块。
 * 显示实时温度值。Value 字段由 Dart 侧通过 bridge 更新。
 */
export const tempBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField('🌡 温度')
      .appendField(new Blockly.FieldLabel('--'), 'value')
      .appendField('°C');
    this.setOutput(true, null);
    this.setColour(90); // 绿色系
    this.setTooltip('当前温度');
  },
};
