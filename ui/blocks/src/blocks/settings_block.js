import { t } from '../i18n';

export const settingsBlock = {
  init: function () {
    this.appendDummyInput().appendField(t('settings'), 'label');
    this.setColour(32);
    this.setTooltip(t('settings'));
    this.setMovable(false);
    this.setDeletable(false);
    this.setEditable(true);
  },
};
