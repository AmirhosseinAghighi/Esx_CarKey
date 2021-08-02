ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local createdcars = {}
local keysoncar = {}


ESX.RegisterServerCallback('CarLock:haskey', function(source, cb, plate, vehicle)
    local item = "CarKey|"..plate
    print(item)
    local xPlayer = ESX.getPlayerFromId(source)
    cb(xPlayer.getInventoryItem(item).count >= 1 or keysoncar[vehicle] == true)
    --cb(xPlayer.getInventoryItem(name.." | "..plate).count >= 1)
end)

RegisterNetEvent("CarLock:keyoperation")
AddEventHandler("CarLock:keyoperation", function(op, plate, vehicle)
    local item = "CarKey|"..plate
    local xPlayer = ESX.getPlayerFromId(source)

    if keysoncar[vehicle] ~= op then
        if op then
            if Config.AdvancedMode then
                xPlayer.removeInventoryItem(item, 1)
            end
            keysoncar[vehicle] = true
        else
            if xPlayer.getInventoryItem(item).count == 0 then
                xPlayer.addInventoryItem(item, 1)
                keysoncar[vehicle] = false
            end
        end
    end

end)


