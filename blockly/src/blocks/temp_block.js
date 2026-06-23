import * as Blockly from 'blockly';
import { t } from '../i18n';

export const tempBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField(t('temperature'), 'label')
      .appendField(new Blockly.FieldLabel('--'), 'value')
      .appendField('C');
    this.setOutput(true, null);
    this.setColour(90);
    this.setTooltip(t('tempTooltip'));
  },
};
