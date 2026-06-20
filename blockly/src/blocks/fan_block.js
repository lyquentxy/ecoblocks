import * as Blockly from 'blockly';

/**
 * 风扇执行器积木块。
 * State 字段显示当前开关状态，由 Dart 侧更新。
 */
export const fanBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField('🌀 风扇')
      .appendField(new Blockly.FieldLabel('关'), 'state');
    this.setPreviousStatement(true, null);
    this.setNextStatement(true, null);
    this.setColour(210); // 蓝紫色系
    this.setTooltip('风扇控制');
  },
};
