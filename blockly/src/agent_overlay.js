import { setBlocklyLocale, t } from './i18n';

function ensureAgentPanel() {
  let panel = document.getElementById('agentPanel');
  if (panel) return panel;
  panel = document.createElement('div');
  panel.id = 'agentPanel';
  panel.innerHTML =
    `<div class="agent-title">${escapeHtml(t('agentTitle'))}</div>` +
    `<div id="agentStatus">${escapeHtml(t('waiting'))}</div>` +
    '<div id="agentProfiles"></div>';
  document.body.appendChild(panel);
  return panel;
}

function refreshAgentPanelLabels() {
  const panel = ensureAgentPanel();
  const title = panel.querySelector('.agent-title');
  if (title) title.textContent = t('agentTitle');
  const status = document.getElementById('agentStatus');
  if (status && status.dataset.lastStatus) {
    status.textContent = `${status.dataset.lastStatus}: ${status.dataset.lastMessage || ''}`;
  } else if (status) {
    status.textContent = t('waiting');
  }
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

window.addEventListener('ecoblocks-message', (event) => {
  const msg = event.detail;
  if (!msg || !msg.type) return;
  if (msg.type === 'locale_changed') {
    setBlocklyLocale(msg.locale);
    refreshAgentPanelLabels();
    return;
  }
  ensureAgentPanel();
  if (msg.type === 'agent_status') {
    const status = document.getElementById('agentStatus');
    status.dataset.lastStatus = msg.status || t('status');
    status.dataset.lastMessage = msg.message || '';
    status.textContent = `${status.dataset.lastStatus}: ${status.dataset.lastMessage}`;
  }
  if (msg.type === 'device_profile') {
    const profile = msg.profile || {};
    const list = document.getElementById('agentProfiles');
    const item = document.createElement('div');
    item.className = 'agent-profile';
    item.innerHTML =
      `<div><strong>${escapeHtml(profile.device_id || profile.deviceId || t('device'))}</strong></div>` +
      `<div>${escapeHtml(t('type'))}: ${escapeHtml(profile.type || t('unknown'))}</div>` +
      `<div>${escapeHtml(t('capability'))}: ${escapeHtml(profile.capability || t('unknown'))}</div>` +
      `<div>${escapeHtml(t('task'))}: ${escapeHtml(profile.task || t('observe'))}</div>`;
    list.appendChild(item);
  }
});
