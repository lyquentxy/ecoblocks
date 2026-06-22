function ensureAgentPanel() {
  let panel = document.getElementById('agentPanel');
  if (panel) return panel;
  panel = document.createElement('div');
  panel.id = 'agentPanel';
  panel.innerHTML =
    '<div class="agent-title">AI Agent</div>' +
    '<div id="agentStatus">waiting</div>' +
    '<div id="agentProfiles"></div>';
  document.body.appendChild(panel);
  return panel;
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
  ensureAgentPanel();
  if (msg.type === 'agent_status') {
    const status = document.getElementById('agentStatus');
    status.textContent = `${msg.status || 'status'}: ${msg.message || ''}`;
  }
  if (msg.type === 'device_profile') {
    const profile = msg.profile || {};
    const list = document.getElementById('agentProfiles');
    const item = document.createElement('div');
    item.className = 'agent-profile';
    item.innerHTML =
      `<div><strong>${escapeHtml(profile.device_id || profile.deviceId || 'device')}</strong></div>` +
      `<div>type: ${escapeHtml(profile.type || 'unknown')}</div>` +
      `<div>capability: ${escapeHtml(profile.capability || 'unknown')}</div>` +
      `<div>task: ${escapeHtml(profile.task || 'observe')}</div>`;
    list.appendChild(item);
  }
});
