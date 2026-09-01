TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local DB = require('server.db')

RegisterServerEvent('core:logAction')
AddEventHandler('core:logAction', function(category, actor, action, data)
  DB.insert("INSERT INTO logs (category, actor_identifier, action, data) VALUES (?, ?, ?, ?)", {category, actor, action, json.encode(data or {})}, function() end)

  if Config.Discord.enabled and Config.Discord.webhook and Config.Discord.webhook ~= '' then
    -- Simple webhook send (non-blocking)
    PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) end, 'POST', json.encode({username = 'RP-Logs', content = string.format("[%s] %s: %s -- %s", category, actor, action, json.encode(data or {}))}), {['Content-Type'] = 'application/json'})
  end
end)
