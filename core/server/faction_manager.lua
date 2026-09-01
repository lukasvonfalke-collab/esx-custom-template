-- Faction Manager (ESX style)
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local DB = require('server.db')
local Perms = require('server.permissions')

ESX.RegisterServerCallback('core:getFactions', function(source, cb)
  DB.fetch("SELECT id, name, tag, meta, head_identifier FROM factions", {}, function(rows)
    cb(rows)
  end)
end)

-- Create faction (admin only)
RegisterNetEvent('core:createFaction')
AddEventHandler('core:createFaction', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer or (xPlayer.getGroup and xPlayer.getGroup() ~= 'admin') then
    print(('core:createFaction denied for %s'):format(src))
    return
  end
  if not data or not data.name or not data.tag then return end
  DB.insert("INSERT INTO factions (name, tag, is_public, meta) VALUES (?, ?, ?, ?)", {data.name, data.tag, data.is_public and 1 or 0, json.encode(data.meta or {})}, function()
    TriggerClientEvent('esx:showNotification', src, "Fraktion erstellt: "..data.name)
  end)
end)

-- Create Rank
RegisterNetEvent('core:createRank')
AddEventHandler('core:createRank', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  if not factionId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'manageRanks', function(has)
        if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end
      end)
    end
  end)

  function proceed()
    local name = data.name or 'New Rank'
    local order = tonumber(data.order) or 0
    local pay = tonumber(data.pay) or 0
    DB.insert("INSERT INTO faction_ranks (faction_id, name, rank_order, pay, priority) VALUES (?, ?, ?, ?, ?)", {factionId, name, order, pay, order}, function()
      TriggerClientEvent('esx:showNotification', src, 'Rang erstellt: '..name)
    end)
  end
end)

-- Update Rank
RegisterNetEvent('core:updateRank')
AddEventHandler('core:updateRank', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local rankId = tonumber(data.rankId)
  if not factionId or not rankId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'manageRanks', function(has)
        if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end
      end)
    end
  end)

  function proceed()
    DB.execute("UPDATE faction_ranks SET name = ?, rank_order = ?, pay = ? WHERE id = ? AND faction_id = ?", {data.name, data.order, data.pay, rankId, factionId}, function()
      TriggerClientEvent('esx:showNotification', src, 'Rang aktualisiert')
    end)
  end
end)

-- Delete Rank
RegisterNetEvent('core:deleteRank')
AddEventHandler('core:deleteRank', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local rankId = tonumber(data.rankId)
  if not factionId or not rankId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'manageRanks', function(has)
        if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end
      end)
    end
  end)

  function proceed()
    DB.execute("UPDATE faction_members SET rank_id = NULL WHERE faction_id = ? AND rank_id = ?", {factionId, rankId}, function()
      DB.execute("DELETE FROM faction_ranks WHERE id = ? AND faction_id = ?", {rankId, factionId}, function()
        TriggerClientEvent('esx:showNotification', src, 'Rang gelöscht')
      end)
    end)
  end
end)

-- Set Rank Permission
RegisterNetEvent('core:setRankPermission')
AddEventHandler('core:setRankPermission', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local rankId = tonumber(data.rankId)
  local permission = tostring(data.permission)
  local allowed = data.allowed and 1 or 0
  if not factionId or not rankId or not permission then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'manageRanks', function(has)
        if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end
      end)
    end
  end)

  function proceed()
    DB.execute("DELETE FROM faction_permissions WHERE faction_id = ? AND rank_id = ? AND permission_key = ?", {factionId, rankId, permission}, function()
      DB.insert("INSERT INTO faction_permissions (faction_id, rank_id, permission_key, allowed) VALUES (?, ?, ?, ?)", {factionId, rankId, permission, allowed}, function()
        TriggerClientEvent('esx:showNotification', src, 'Permission gesetzt')
      end)
    end)
  end
end)

-- Hire Member
RegisterNetEvent('core:hireMember')
AddEventHandler('core:hireMember', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local targetIdentifier = data.identifier
  local targetCharacterId = tonumber(data.characterId)
  local rankId = tonumber(data.rankId) or nil
  if not factionId or not targetIdentifier or not targetCharacterId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'hireMember', function(has) if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end end)
    end
  end)

  function proceed()
    DB.insert("INSERT INTO faction_members (faction_id, character_id, identifier, rank_id) VALUES (?, ?, ?, ?)", {factionId, targetCharacterId, targetIdentifier, rankId}, function()
      TriggerClientEvent('esx:showNotification', src, 'Mitarbeiter eingestellt')
    end)
  end
end)

-- Fire Member
RegisterNetEvent('core:fireMember')
AddEventHandler('core:fireMember', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local memberId = tonumber(data.memberId)
  if not factionId or not memberId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'fireMember', function(has) if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end end)
    end
  end)

  function proceed()
    DB.execute("DELETE FROM faction_members WHERE id = ? AND faction_id = ?", {memberId, factionId}, function()
      TriggerClientEvent('esx:showNotification', src, 'Mitarbeiter entlassen')
    end)
  end
end)

-- Promote / Demote
RegisterNetEvent('core:promoteMember')
AddEventHandler('core:promoteMember', function(data)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then return end
  local factionId = tonumber(data.factionId)
  local memberId = tonumber(data.memberId)
  local newRankId = tonumber(data.newRankId)
  if not factionId or not memberId or not newRankId then return end

  Perms.isLeader(factionId, xPlayer.identifier, function(isLeader)
    if isLeader then proceed() else
      Perms.hasPermission(factionId, xPlayer.identifier, 'promoteMember', function(has) if has then proceed() else TriggerClientEvent('esx:showNotification', src, 'Keine Berechtigung') end end)
    end
  end)

  function proceed()
    DB.execute("UPDATE faction_members SET rank_id = ? WHERE id = ? AND faction_id = ?", {newRankId, memberId, factionId}, function()
      TriggerClientEvent('esx:showNotification', src, 'Mitarbeiter befördert')
    end)
  end
end)
