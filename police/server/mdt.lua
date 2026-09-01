-- MDT server handlers: create/view reports, warrants, evidence
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('police:getRecords', function(source, cb, limit)
  limit = tonumber(limit) or 50
  exports.oxmysql:execute('SELECT * FROM records ORDER BY created_at DESC LIMIT ?', {limit}, function(rows)
    cb(rows)
  end)
end)

RegisterNetEvent('police:createRecord')
AddEventHandler('police:createRecord', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  if not data or not data.type then return end
  exports.oxmysql:execute('INSERT INTO records (type, author_identifier, faction_id, data, created_at) VALUES (?, ?, ?, ?, NOW())', {data.type, xPlayer.identifier, data.factionId or nil, json.encode(data.data or {})}, function()
    TriggerClientEvent('esx:showNotification', src, 'Eintrag erstellt')
    exports.oxmysql:execute("INSERT INTO logs (category, actor_identifier, action, data) VALUES (?, ?, ?, ?)", {'mdt', xPlayer.identifier, 'createRecord', json.encode(data)}, function() end)
  end)
end)
