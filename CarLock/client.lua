ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

keysoncar = {}

    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()
            Citizen.Wait(100)
            if IsControlPressed(0, 15) and IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                    ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
                        --print(haskey)
                        if haskey then
                            local status = (not GetIsVehicleEngineRunning(vehicle))
                            SetVehicleEngineOn(vehicle, status, false, true)
                            TriggerServerEvent("CarLock:keyoperation", status, plate, vehicle)
                            if status then
                                table.insert( keysoncar, vehicle )
                            else
                                remove(vehicle)
                            end
                        end
                    end, plate, vehicle)
                    Citizen.Wait(1000)

                end
            end
        end
    end)


    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            -- if IsPedInAnyVehicle(ped, false) then
            --     local vehicle = GetVehiclePedIsIn(ped, false)
            --     if not GetIsVehicleEngineRunning(vehicle) then
            --         print('disabling')
            --         DisableControlAction(1, 71, true)
            --     end
            -- end
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)


            for i, k in ipairs(keysoncar) do
                --print( GetPedInVehicleSeat(vehicle, -1))
                if GetPedInVehicleSeat(vehicle, -1) == 0 then
                    SetVehicleEngineOn(k, true, true, true)
                --print(k.."k")
                end
            end

        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsTryingToEnter(ped)
            
            if not checkswitchstatus(vehicle) then
                SetVehicleEngineOn(vehicle, false, true, true)
            end

        end
    end)


if Config.AdvancedMode then
    RegisterCommand('takeswitch', function()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("CarLock:keyoperation", false, plate, vehicle)
        SetVehicleEngineOn(vehicle, false, false, true)
    end)
end


function checkswitchstatus(vehicle)

    for i, k in ipairs(keysoncar) do
        if k == vehicle then return true end
    end

end

function remove(vehicle)

    for i, k in ipairs(keysoncar) do
        if k == vehicle then
            keysoncar[i] = nil
        end
    end


end



-- CarLock
local timer = 0


Citizen.CreateThread(function()
  local dict = "anim@mp_player_intmenu@key_fob@"
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(0)
  end
  while true do
	Citizen.Wait(0)
	if (IsControlJustReleased(1, 246)) then
		if GetGameTimer() - 2000  > timer then
			timer = GetGameTimer()
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local hasAlreadyLocked = false
			cars = ESX.Game.GetVehiclesInArea(coords, 30)
			local carstrie = {}
			local cars_dist = {}		
			notowned = 0
			if #cars == 0 then
				ESX.ShowNotification("it seems there isn't any car to lock")
			else
				for j=1, #cars, 1 do
					local coordscar = GetEntityCoords(cars[j])
					local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
					table.insert(cars_dist, {cars[j], distance})
				end
				for k=1, #cars_dist, 1 do
					local z = -1
					local distance, car = 200
					for l=1, #cars_dist, 1 do
						if cars_dist[l][2] < distance then
							distance = cars_dist[l][2]
							car = cars_dist[l][1]
							z = l
						end
					end
					if z ~= -1 then
						table.remove(cars_dist, z)
						table.insert(carstrie, car)
					end
				end
				for i=1, #carstrie, 1 do
					local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
                    ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
                        if haskey then
                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
                            vehicleLabel = GetLabelText(vehicleLabel)
                            local lock = GetVehicleDoorLockStatus(carstrie[i])
                            if lock == 1 or lock == 0 then
                                SetVehicleDoorShut(carstrie[i], 0, false)
                                SetVehicleDoorShut(carstrie[i], 1, false)
                                SetVehicleDoorShut(carstrie[i], 2, false)
                                SetVehicleDoorShut(carstrie[i], 3, false)
                                SetVehicleDoorShut(carstrie[i], 4, false)
                                SetVehicleDoorShut(carstrie[i], 5, false)
                                SetVehicleDoorsLocked(carstrie[i], 2)
                                PlayVehicleDoorCloseSound(carstrie[i], 1)
                                ESX.ShowNotification('you ~r~Closed ~y~'..vehicleLabel..'~s~ doors~s~.')
                                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
                                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                                    TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                                end
                                SetVehicleLights(carstrie[i], 2)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 0)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 2)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 0)
                                hasAlreadyLocked = true
                            elseif lock == 2 then
                                SetVehicleDoorsLocked(carstrie[i], 1)
                                PlayVehicleDoorOpenSound(carstrie[i], 0)
                                ESX.ShowNotification('you ~g~opened ~y~'..vehicleLabel..'~s~ doors~s~.')
                                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
                                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                                    TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                                end
                                SetVehicleLights(carstrie[i], 2)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 0)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 2)
                                Citizen.Wait(150)
                                SetVehicleLights(carstrie[i], 0)
                                hasAlreadyLocked = true
                            end
                        else
                            ESX.ShowNotification("it seems there isn't any car to lock")
                        end
                    end, plate)
				end			
			end
		else
			ESX.ShowNotification("~r~Don't Spam")
			timer = GetGameTimer()
		end
	end
  end
end)

