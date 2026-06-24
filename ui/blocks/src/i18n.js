const messages = {
  zh: {
    sensors: '\u4f20\u611f\u5668',
    actuators: '\u6267\u884c\u5668',
    logic: '\u903b\u8f91',
    settings: '\u8bbe\u7f6e',
    language: '\u8bed\u8a00',
    temperature: '\u6e29\u5ea6',
    fan: '\u98ce\u6247',
    tempTooltip: '\u5f53\u524d\u6e29\u5ea6',
    fanTooltip: '\u98ce\u6247\u63a7\u5236',
    agentTitle: 'AI Agent',
    waiting: '\u7b49\u5f85\u4e2d',
    status: '\u72b6\u6001',
    type: '\u7c7b\u578b',
    capability: '\u80fd\u529b',
    task: '\u4efb\u52a1',
    device: '\u8bbe\u5907',
    unknown: '\u672a\u77e5',
    observe: '\u89c2\u5bdf',
    on: '\u5f00',
    off: '\u5173',
  },
  en: {
    sensors: 'Sensors',
    actuators: 'Actuators',
    logic: 'Logic',
    settings: 'Settings',
    language: 'Language',
    temperature: 'Temperature',
    fan: 'Fan',
    tempTooltip: 'Current temperature',
    fanTooltip: 'Fan control',
    agentTitle: 'AI Agent',
    waiting: 'waiting',
    status: 'status',
    type: 'type',
    capability: 'capability',
    task: 'task',
    device: 'device',
    unknown: 'unknown',
    observe: 'observe',
    on: 'on',
    off: 'off',
  },
};

let currentLocale = normalizeLocale(
  window.ECOBLOCKS_LOCALE ||
    new URLSearchParams(window.location.search).get('locale') ||
    document.documentElement.lang,
);

export function normalizeLocale(locale) {
  const language = String(locale || '').toLowerCase().split('-')[0];
  return language === 'en' ? 'en' : 'zh';
}

export function setBlocklyLocale(locale) {
  currentLocale = normalizeLocale(locale);
  document.documentElement.lang = currentLocale === 'en' ? 'en' : 'zh-CN';
  return currentLocale;
}

export function getBlocklyLocale() {
  return currentLocale;
}

export function t(key) {
  return messages[currentLocale][key] || messages.zh[key] || key;
}
