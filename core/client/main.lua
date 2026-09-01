ESX = nil
local isMenuOpen = false
local currentFactions = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterCommand('factionmenu', function()
  ESX.TriggerServerCallback('core:getFactions', function(factions)
    currentFactions = factions or {}
    SetNuiFocus(true, true)
    isMenuOpen = true
    SendNUIMessage({ action = 'open', factions = currentFactions })
  end)
end, false)

RegisterNUICallback('close', function(_, cb)
  SetNuiFocus(false, false)
  isMenuOpen = false
  cb('ok')
end)

RegisterNUICallback('createRank', function(data, cb)
  TriggerServerEvent('core:createRank', data)
  cb('ok')
end)

RegisterNUICallback('updateRank', function(data, cb)
  TriggerServerEvent('core:updateRank', data)
  cb('ok')
end)

RegisterNUICallback('deleteRank', function(data, cb)
  TriggerServerEvent('core:deleteRank', data)
  cb('ok')
end)

RegisterNUICallback('setRankPermission', function(data, cb)
  TriggerServerEvent('core:setRankPermission', data)
  cb('ok')
end)

RegisterNUICallback('hireMember', function(data, cb)
  TriggerServerEvent('core:hireMember', data)
  cb('ok')
end)

RegisterNUICallback('promoteMember', function(data, cb)
  TriggerServerEvent('core:promoteMember', data)
  cb('ok')
end)

CreateThread(function()
  while true do
    Wait(0)
    if isMenuOpen then
      if IsControlJustReleased(0, 200) then
        SetNuiFocus(false, false)
        isMenuOpen = false
        SendNUIMessage({ action = 'close' })
      end
    end
  end
end)
