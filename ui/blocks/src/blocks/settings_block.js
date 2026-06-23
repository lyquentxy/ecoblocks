import * as Blockly from 'blockly';
import { getBlocklyLocale, t } from '../i18n';

export const settingsBlock = {
  init: function () {
    this.appendDummyInput()
      .appendField(t('settings'), 'label')
      .appendField(t('language'))
      .appendField(
        new Blockly.FieldDropdown(
          [
            ['中文', 'zh'],
            ['English', 'en'],
          ],
          (value) => {
            window.EcoBridge?.send({
              type: 'settings_changed',
              locale: value,
            });
          },
        ),
        'language',
      );
    this.setColour(32);
    this.setTooltip(t('settings'));
    this.setMovable(false);
    this.setDeletable(false);
    this.setEditable(true);
  },
};
