import {blockRendering, zelos} from 'blockly';
import {InkConstantProvider} from './constants';

export class InkRenderer extends zelos.Renderer {
  makeConstants_() {
    return new InkConstantProvider();
  }
}

blockRendering.register('ink', InkRenderer);
