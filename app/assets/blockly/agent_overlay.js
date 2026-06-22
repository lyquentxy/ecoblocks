(function () {
  var panel;
  var list;
  var statusLine;

  function ensurePanel() {
    if (panel) return;
    panel = document.createElement('div');
    panel.id = 'agentPanel';
    panel.innerHTML =
      '<div class="agent-title">AI Agent</div>' +
      '<div id="agentStatus">waiting</div>' +
      '<div id="agentProfiles"></div>';
    document.body.appendChild(panel);
    statusLine = document.getElementById('agentStatus');
    list = document.getElementById('agentProfiles');
  }

  function showStatus(status, message) {
    ensurePanel();
    statusLine.textContent = status + ': ' + message;
  }

  function showProfile(profile) {
    ensurePanel();
    var item = document.createElement('div');
    item.className = 'agent-profile';
    item.innerHTML =
      '<div><strong>' + escapeHtml(profile.device_id || profile.deviceId || 'device') + '</strong></div>' +
      '<div>type: ' + escapeHtml(profile.type || 'unknown') + '</div>' +
      '<div>capability: ' + escapeHtml(profile.capability || 'unknown') + '</div>' +
      '<div>task: ' + escapeHtml(profile.task || 'observe') + '</div>';
    list.appendChild(item);
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  window.addEventListener('ecoblocks-message', function (event) {
    var msg = event.detail;
    if (!msg || !msg.type) return;
    if (msg.type === 'agent_status') {
      showStatus(msg.status || 'status', msg.message || '');
    }
    if (msg.type === 'device_profile') {
      showProfile(msg.profile || {});
    }
  });
})();
