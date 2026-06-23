import * as Blockly from 'blockly';
import { t } from '../i18n';

export const fanBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField(t('fan'), 'label')
      .appendField(new Blockly.FieldLabel(t('off')), 'state');
    this.setPreviousStatement(true, null);
    this.setNextStatement(true, null);
    this.setColour(210);
    this.setTooltip(t('fanTooltip'));
  },
};
