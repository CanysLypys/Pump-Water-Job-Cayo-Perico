ESX = nil

Citizen.CreateThread(function()
TriggerServerEvent("cl_water:getpassword")
while ESX == nil do
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
   Citizen.Wait(0)
end
while ESX.GetPlayerData().job == nil do
   Citizen.Wait(10)
end

PlayerData = ESX.GetPlayerData()

end)

local eventpassword = ""

RegisterNetEvent("cl_water:clientpassword")
AddEventHandler("cl_water:clientpassword", function(pass)
if eventpassword == "" then
   eventpassword = pass
end
end)

Citizen.CreateThread(function()
while true do
   Wait(0)

   local coords =GetEntityCoords(PlayerPedId())

   for k,v in pairs(Config.Wassersilos) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
         DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
   end
   for k,v in pairs(Config.Repairlocations) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
         DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
      end
   end
end
end)


--[[ Animationen:

-- Shoplift: anim@am_hold_up@makle shoplift_mid / shoplift_high /shoplift_low

-- Wasserpumpen: amb@prop_human_bum_bin@idle_a idle_c

]]


local pumptwasser = false
local pumperepariert = true
local nearMarker = false
local isplayingpumpanim = false

Citizen.CreateThread(function()
while true do
   Wait(0)
   if #(GetEntityCoords(PlayerPedId()) - vector3(5347.46, -5508.84, 52.95)) < 1.5 then
      nearMarker = true
      if pumperepariert == false then
         ESX.ShowHelpNotification("~r~Das Wasserrohr ist beschädigt")

      elseif pumperepariert and nearMarker then
         ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um Wasser zu pumpen")
         if IsControlJustPressed(0, 38) then
            isOnVehicle()
            Wait(0.1 * 1000) -- Preventing to play the animation on the vehicle. Fastest workaround I could make.
            loadAnimDict("amb@prop_human_bum_bin@idle_a")

            playPumpAnim()
         end
      end
   else
      nearMarker = false
   end
end
end)

Citizen.CreateThread(function()
while true do
   Wait(0)

   if #(GetEntityCoords(PlayerPedId()) - vector3(4896.88, -5344.99, 10.2)) < 1.5 then
      nearMarker = true
      if pumperepariert == false then
         ESX.ShowHelpNotification("~r~Das Wasserrohr ist beschädigt")
      elseif pumperepariert and nearMarker then
         ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um Wasser zu pumpen")
         if IsControlJustPressed(0, 38) then
            isOnVehicle()
            Wait(0.1 * 1000) -- Preventing to play the animation on the vehicle. Fastest workaround I could make.


            playPumpAnim()
         end
      end
   else
      nearMarker = false
   end
end
end)

Citizen.CreateThread(function()
while true do
   Wait(0)

   if #(GetEntityCoords(PlayerPedId()) - vector3(5207.41, -5005.0, 13.66)) < 1.5 then
      nearMarker = true
      if pumperepariert == false then
         ESX.ShowHelpNotification("~r~Das Wasserrohr ist beschädigt")
      elseif pumperepariert and nearMarker then
         ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um Wasser zu pumpen")
         if IsControlJustPressed(0, 38) then
            isOnVehicle()
            Wait(0.1 * 1000) -- Preventing to play the animation on the vehicle. Fastest workaround I could make.


            playPumpAnim()
         end
      end
   else
      nearMarker = false
   end
end
end)

-- Wasserrohr reparieren

Citizen.CreateThread(function()
while true do
   Wait(0)
   if #(GetEntityCoords(PlayerPedId()) - vector3(5125.96, -5202.74, 2.84)) < 1.5 then
      if pumperepariert then
         ESX.ShowHelpNotification("~g~Das Wasserrohr funktioniert")
      elseif pumperepariert == false then
         ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um das Wasserrohr zu reparieren")

         if IsControlJustPressed(0, 38) then
            playRepairAnim()
         end
      end
   end
end
end)


function isOnVehicle()
   local me = PlayerPedId()
   local vehicle = GetVehiclePedIsIn(me, false)

   if IsPedInAnyVehicle(me, false) then
      TaskLeaveVehicle(me, vehicle, 0)
      ESX.ShowNotification("Im Fahrzeug kannst du kein Wasser pumpen")
   else
   end
end

function loadAnimDict(dict)
   while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Wait(5)
   end
end

function playPumpAnim()
   local me = PlayerPedId()
   loadAnimDict("amb@prop_human_bum_bin@idle_a")
   Wait(0.1 * 1000)

   isplayingpumpanim = true
   TaskPlayAnim(me, 'amb@prop_human_bum_bin@idle_a', 'idle_c', 8.0, -8.0, -1, 1, 1, false, false, false )
   TriggerServerEvent("cl_water:sammleWasser", eventpassword)
   Wait(4 * 1000)
   clearAnim()
   isplayingpumpanim = false
end

function playRepairAnim()
   local me = PlayerPedId()
   TaskStartScenarioInPlace(me, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 51, true)
   Wait(10 * 1000)
   TaskStartScenarioInPlace(me, "WORLD_HUMAN_HAMMERING", 51, true)
   Wait(20 * 1000)
   TaskStartScenarioInPlace(me, "WORLD_HUMAN_WELDING", 51, true)
   Wait(20 * 1000)
   pumperepariert = true
   clearAnim()
end

function clearAnim()
   local me = PlayerPedId()
   ClearPedTasks(me)
end



Citizen.CreateThread(function()
for k,v in pairs(Config.Wassersilos) do
   local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))

   SetBlipSprite(blip, 770)
   SetBlipScale(blip, 0.7)
   SetBlipColour(blip, 3)
   SetBlipDisplay(blip, 4)
   SetBlipAsShortRange(blip, true)

   BeginTextCommandSetBlipName("STRING")
   AddTextComponentString("Wassersilo")
   EndTextCommandSetBlipName(blip)
end
end)


Citizen.CreateThread(function()
for k,v in pairs(Config.Repairlocations) do
   local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))

   SetBlipSprite(blip, 761)
   SetBlipScale(blip, 0.7)
   SetBlipColour(blip, 46)
   SetBlipDisplay(blip, 4)
   SetBlipAsShortRange(blip, true)

   BeginTextCommandSetBlipName("STRING")
   AddTextComponentString("Wasserrohr")
   EndTextCommandSetBlipName(blip)
end
end)

Citizen.CreateThread(function()
for k,v in pairs(Config.BlipPoint) do
   local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))

   SetBlipSprite(blip, 750)
   SetBlipScale(blip, 0.7)
   SetBlipColour(blip, 52)
   SetBlipDisplay(blip, 4)
   SetBlipAsShortRange(blip, true)

   BeginTextCommandSetBlipName("STRING")
   AddTextComponentString("Wasserverkauf")
   EndTextCommandSetBlipName(blip)
end
end)

RegisterNetEvent("cl_water:voll")
AddEventHandler("cl_water:voll", function()
local me = PlayerPedId()
ESX.ShowNotification("Du kannst kein weiteres Wasser mehr tragen")
clearAnim()
loadAnimDict("anim@heists@ornate_bank@chat_manager")
TaskPlayAnim(me, 'anim@heists@ornate_bank@chat_manager', 'fail', 8.0, -8.0, -1, 51, 0, false, false, false )
end)


RegisterNetEvent("cl_water:success")
AddEventHandler("cl_water:success", function(amount)
ESX.ShowNotification("Du pumpst nun " ..amount.. "x Wasser")
end)

RegisterNetEvent("cl_water:sellSuccess")
AddEventHandler("cl_water:sellSuccess", function(wasserflaschenpreis)
ESX.ShowNotification("Du verkaufst Wasserflaschen für ".. wasserflaschenpreis.. "$")
end)

RegisterNetEvent("cl_water:keinWasserMehr")
AddEventHandler("cl_water:keinWasserMehr", function()
local me = PlayerPedId()
ESX.ShowNotification("Du hast nicht genug Wasser")
clearAnim()
loadAnimDict("anim@heists@ornate_bank@chat_manager")
TaskPlayAnim(me, 'anim@heists@ornate_bank@chat_manager', 'fail', 8.0, -8.0, -1, 51, 0, false, false, false )
Wait(3 * 1000)
clearAnim()
end)


-- NPC's
Citizen.CreateThread(function()

for _,v in pairs(Config.WaterSeller) do
   RequestModel(GetHashKey(v[7]))
   while not HasModelLoaded(GetHashKey(v[7])) do
      Wait(1)
   end

   RequestAnimDict("mini@strip_club@idles@bouncer@base")
   while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
      Wait(1)
   end
   ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
   SetEntityHeading(ped, v[5])
   FreezeEntityPosition(ped, true)
   SetEntityInvincible(ped, true)
   SetBlockingOfNonTemporaryEvents(ped, true)
   TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end
end)

Citizen.CreateThread(function()
while true do
   Wait(0)
   if #(GetEntityCoords(PlayerPedId()) - vector3(945.45, -3104.38, 5.9)) < 1.5 then
      ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um die Wasserflaschen zu verkaufen")
      if IsControlJustPressed(0, 38) then
         local amount = 10
         TriggerServerEvent("cl_water:sellWater", eventpassword, amount)
      end
   end
end
end)
