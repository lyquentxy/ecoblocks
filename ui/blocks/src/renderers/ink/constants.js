import {utils, zelos} from 'blockly';

export class InkConstantProvider extends zelos.ConstantProvider {
  constructor() {
    super(4.5);
    this.CORNER_RADIUS = 16;
    this.NOTCH_WIDTH = 34;
    this.NOTCH_HEIGHT = 8;
    this.NOTCH_OFFSET_LEFT = 18;
    this.STATEMENT_INPUT_NOTCH_OFFSET = this.NOTCH_OFFSET_LEFT;
    this.MIN_BLOCK_HEIGHT = 46;
    this.DUMMY_INPUT_MIN_HEIGHT = 34;
    this.FIELD_TEXT_FONTSIZE = 12.5;
    this.FIELD_TEXT_FONTWEIGHT = '600';
    this.FIELD_TEXT_FONTFAMILY =
      '"LXGW WenKai", "STKaiti", "KaiTi", "Songti SC", system-ui, sans-serif';
    this.FIELD_BORDER_RECT_RADIUS = 10;
    this.START_HAT_HEIGHT = 18;
    this.START_HAT_WIDTH = 92;
    this.SELECTED_GLOW_COLOUR = '#687b70';
    this.SELECTED_GLOW_SIZE = 1.2;
    this.REPLACEMENT_GLOW_COLOUR = '#879b8e';
  }

  generateSecondaryColour_(colour) {
    return utils.colour.blend('#101814', colour, 0.16) || colour;
  }

  generateTertiaryColour_(colour) {
    return utils.colour.blend('#050706', colour, 0.30) || colour;
  }
}
