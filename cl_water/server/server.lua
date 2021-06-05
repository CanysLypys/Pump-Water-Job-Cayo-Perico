ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
   math.randomseed(os.time())

   if length > 0 then
      return string.random(length - 1) .. charset[math.random(1, #charset)]
   else
      return ""
   end
end

local eventpassword = string.random(12)


RegisterServerEvent("cl_water:getpassword")
AddEventHandler("cl_water:getpassword", function()
TriggerClientEvent("cl_water:clientpassword", source, eventpassword)
end)

RegisterServerEvent("cl_water:sammleWasser")
AddEventHandler("cl_water:sammleWasser", function(pass)
if pass == eventpassword then
   local xPlayer = ESX.GetPlayerFromId(source)
   local xItem = xPlayer.getInventoryItem("wasserflasche")
   local amount = math.random(1, 4)
   if xItem.weight ~= -1 and (xItem.count + 1) > xItem.weight then
      TriggerClientEvent("cl_water:voll", source)
   else
      xPlayer.addInventoryItem(xItem.name, amount)
      TriggerClientEvent("cl_water:success", source, amount)
   end
else
   DropPlayer(source, "Nope.")
end
end)

RegisterServerEvent("cl_water:sellWater")
AddEventHandler("cl_water:sellWater", function(pass)
if pass == eventpassword then
   local xPlayer = ESX.GetPlayerFromId(source)
   if xPlayer.getInventoryItem("wasserflasche").count > 4 then
      local price = 500
      Config.PricePerBottle = price
      xPlayer.removeInventoryItem("wasserflasche", 5)
      xPlayer.addMoney(price)
      TriggerClientEvent("cl_water:sellSuccess", source, price)
   elseif xPlayer.getInventoryItem("wasserflasche").count < 5 then
      TriggerClientEvent("cl_water:keinWasserMehr", source)
   end
end
end)