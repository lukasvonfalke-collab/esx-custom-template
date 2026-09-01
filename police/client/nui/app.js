window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action === 'open') {
    const records = data.records || [];
    const container = document.getElementById('records');
    container.innerHTML = '';
    records.forEach(r => {
      const el = document.createElement('div');
      el.className = 'record';
      el.textContent = `${r.type} - ${r.author_identifier} - ${r.created_at} - ${JSON.stringify(JSON.parse(r.data || '{}'))}`;
      container.appendChild(el);
    });
  }
});

document.getElementById('createBtn').addEventListener('click', () => {
  const type = document.getElementById('type').value;
  const data = document.getElementById('data').value;
  let parsed = {};
  try { parsed = JSON.parse(data) } catch(e) { alert('Invalid JSON'); return }
  fetch(`https://${GetParentResourceName()}/createRecord`, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify({ type, data: parsed }) }).then(() => {});
});

document.getElementById('closeBtn').addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: JSON.stringify({}) }).then(() => {});
});
