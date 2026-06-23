import * as Blockly from 'blockly';

/**
 * 水墨主题 — 中国水墨画风格 Blockly 主题。
 * 第一版只做基本配色，后续迭代完善。
 */
export const InkTheme = Blockly.Theme.defineTheme('ink', {
  name: 'Ink',
  base: Blockly.Themes.Classic,
  componentStyles: {
    workspaceBackgroundColour: '#f5f0e8', // 宣纸色
    toolboxBackgroundColour: '#e8e0d0',
    toolboxForegroundColour: '#3a3028',
    flyoutBackgroundColour: '#ede5d8',
    flyoutForegroundColour: '#3a3028',
    flyoutOpacity: 0.95,
    scrollbarColour: '#8c8278',
    scrollbarOpacity: 0.4,
  },
});
