-- Police server main: arrests, jail, basic queries (uses oxmysql directly)
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local JailPosition = { x = 1850.0, y = 2600.0, z = 45.0 } -- example jail coords (adjust)

-- Helper: check permission via DB: faction tag, identifier, permissionKey
local function hasFactionPermission(factionTag, identifier, permissionKey, cb)
  exports.oxmysql:execute([[ 
    SELECT fp.allowed FROM faction_permissions fp
    JOIN faction_ranks fr ON fp.rank_id = fr.id
    JOIN factions f ON fr.faction_id = f.id
    JOIN faction_members fm ON fm.rank_id = fr.id AND fm.faction_id = f.id
    WHERE f.tag = ? AND fm.identifier = ? AND fp.permission_key = ? AND fp.allowed = 1
  ]], {factionTag, identifier, permissionKey}, function(result)
    if result and #result > 0 then cb(true) else cb(false) end
  end)
end

-- Get person by identifier or name
ESX.RegisterServerCallback('police:getPerson', function(source, cb, query)
  if not query then cb({}) return end
  local like = '%'..query..'%'
  exports.oxmysql:execute("SELECT id, char_name, data FROM characters WHERE char_name LIKE ? LIMIT 50", {like}, function(rows)
    cb(rows)
  end)
end)

-- Plate search
ESX.RegisterServerCallback('police:getVehicleByPlate', function(source, cb, plate)
  exports.oxmysql:execute("SELECT * FROM vehicles WHERE plate = ? LIMIT 1", {plate}, function(rows)
    cb(rows[1])
  end)
end)

-- Arrest player: record and send to jail
RegisterNetEvent('police:arrestPlayer')
AddEventHandler('police:arrestPlayer', function(targetServerId, minutes, reason)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local target = ESX.GetPlayerFromId(targetServerId)
  if not target then
    TriggerClientEvent('esx:showNotification', src, 'Spieler nicht gefunden')
    return
  end

  -- Ensure caller has arrest permission in their faction (police)
  local identifier = xPlayer.identifier
  hasFactionPermission('LSPD', identifier, 'arrest', function(allowed)
    if not allowed then
      TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung zu verhaften')
      return
    end

    -- Insert arrest record
    exports.oxmysql:execute("INSERT INTO arrests (target_identifier, officer_identifier, minutes, reason, created_at) VALUES (?, ?, ?, ?, NOW())", {target.identifier, xPlayer.identifier, minutes, reason}, function()
      -- send target to jail
      TriggerClientEvent('police:sendToJailClient', targetServerId, minutes)
      TriggerClientEvent('esx:showNotification', src, 'Spieler inhaftiert')
      exports.oxmysql:execute("INSERT INTO logs (category, actor_identifier, action, data) VALUES (?, ?, ?, ?)", {'police', xPlayer.identifier, 'arrest', json.encode({target = target.identifier, minutes = minutes, reason = reason})}, function() end)
    end)
  end)
end)

-- Release player early (by officer)
RegisterNetEvent('police:releasePlayer')
AddEventHandler('police:releasePlayer', function(targetServerId)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local target = ESX.GetPlayerFromId(targetServerId)
  if not target then return end

  hasFactionPermission('LSPD', xPlayer.identifier, 'release', function(allowed)
    if not allowed then
      TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung')
      return
    end

    exports.oxmysql:execute('UPDATE arrests SET released = 1, released_at = NOW() WHERE target_identifier = ?', {target.identifier}, function() end)
    TriggerClientEvent('police:releaseFromJail', targetServerId)
    TriggerClientEvent('esx:showNotification', src, 'Spieler freigelassen')
  end)
end)
