const messages = {
  zh: {
    sensors: '传感器',
    actuators: '执行器',
    logic: '逻辑',
    settings: '设置',
    language: '语言',
    temperature: '温度',
    fan: '风扇',
    tempTooltip: '当前温度',
    fanTooltip: '风扇控制',
    agentTitle: 'AI Agent',
    waiting: '等待中',
    status: '状态',
    type: '类型',
    capability: '能力',
    task: '任务',
    device: '设备',
    unknown: '未知',
    observe: '观察',
    on: '开',
    off: '关',
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
