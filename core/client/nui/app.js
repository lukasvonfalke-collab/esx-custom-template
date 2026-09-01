window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action === 'open') {
    const factions = data.factions;
    const list = document.getElementById('faction-list');
    list.innerHTML = '';
    factions.forEach(f => {
      const el = document.createElement('div');
      el.className = 'faction';
      el.textContent = `${f.name} [${f.tag}]`;
      el.onclick = () => { fetchRanks(f.id); };
      list.appendChild(el);
    });
  }
});

document.getElementById('closeBtn').addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: JSON.stringify({}) }).then(() => {});
});

function fetchRanks(factionId) {
  fetch(`https://${GetParentResourceName()}/fetchRanks`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({ factionId })
  }).then(resp => resp.json()).then(data => {
    renderRanks(data || []);
  });
}

function renderRanks(ranks) {
  const container = document.getElementById('ranks');
  container.innerHTML = '';
  ranks.forEach(r => {
    const el = document.createElement('div');
    el.className = 'rank';
    el.textContent = `${r.name} (Order: ${r.rank_order}, Pay: ${r.pay || 0})`;
    container.appendChild(el);
  });
}
