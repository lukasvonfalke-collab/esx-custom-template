ESX = nil
local isHandcuffed = false
local isInJail = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('police:handcuff')
AddEventHandler('police:handcuff', function()
  local playerPed = PlayerPedId()
  isHandcuffed = not isHandcuffed
  if isHandcuffed then
    FreezeEntityPosition(playerPed, true)
    -- play an animation (optional)
  else
    FreezeEntityPosition(playerPed, false)
  end
end)

RegisterNetEvent('police:sendToJailClient')
AddEventHandler('police:sendToJailClient', function(minutes)
  local playerPed = PlayerPedId()
  isInJail = true
  local duration = tonumber(minutes) or 1
  -- teleport to jail
  local jail = vector3(1850.0, 2600.0, 45.0)
  SetEntityCoords(playerPed, jail.x, jail.y, jail.z, false, false, false, true)
  ESX.ShowNotification('Du wurdest inhaftiert für '..duration..' Minuten')
  -- simple timer
  Citizen.CreateThread(function()
    local remaining = duration * 60
    while remaining > 0 and isInJail do
      Citizen.Wait(1000)
      remaining = remaining - 1
    end
    if isInJail then
      isInJail = false
      TriggerEvent('police:releaseFromJail')
    end
  end)
end)

RegisterNetEvent('police:releaseFromJail')
AddEventHandler('police:releaseFromJail', function()
  isInJail = false
  local playerPed = PlayerPedId()
  local releasePos = vector3(1850.0, 2600.0, 45.0)
  -- teleport to release point (outside jail)
  SetEntityCoords(playerPed, releasePos.x + 5.0, releasePos.y, releasePos.z, false, false, false, true)
  ESX.ShowNotification('Du wurdest entlassen')
end)

-- Open MDT command
RegisterCommand('mdt', function()
  ESX.TriggerServerCallback('police:getRecords', function(records)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', records = records })
  end, 100)
end, false)

-- NUI Callbacks
RegisterNUICallback('createRecord', function(data, cb)
  TriggerServerEvent('police:createRecord', data)
  cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
  SetNuiFocus(false, false)
  cb('ok')
end)
