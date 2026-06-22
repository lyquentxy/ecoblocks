import * as Blockly from 'blockly';

export const tempBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField('Temp')
      .appendField(new Blockly.FieldLabel('--'), 'value')
      .appendField('C');
    this.setOutput(true, null);
    this.setColour(90);
    this.setTooltip('Current temperature');
  },
};
