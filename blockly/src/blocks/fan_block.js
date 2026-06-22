import * as Blockly from 'blockly';

export const fanBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField('Fan')
      .appendField(new Blockly.FieldLabel('off'), 'state');
    this.setPreviousStatement(true, null);
    this.setNextStatement(true, null);
    this.setColour(210);
    this.setTooltip('Fan control');
  },
};
