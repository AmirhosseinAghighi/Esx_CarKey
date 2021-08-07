# Esx_CarKey
Car Key as item for ESX !

## Support
  Discord : https://discord.gg/DW8r7RmM   
  you can report your problem as message in our discord support channel

## Features
  - Toggle any vehicle engine with specefic key
  - Door lock with specefic key 

## Requirements  
  - [EssentialMode](https://github.com/extendedmode/extendedmode)

## Installation
1.Download File from reposity.  
2. Copy ```esx_carkey``` folder to your resources folder  
3. Copy all files in ```sounds``` folder to interactsound ```sounds``` folder
4. Go to ```\essentialmode\server\common.lua```  
5. add this code after all lines !
```
  RegisterServerEvent('esx:CreateItem')
  AddEventHandler('esx:CreateItem', function(name, label, limit, rare, can_remove)

    if ESX.Items[name] == nil then

      ESX.Items[name] = {
        label     = label,
        limit     = limit,
        rare      = rare,
        canRemove = can_remove,
      }

    end
  end)
```  
5. Enjoy the Script !  

## Notes !
1. for giving any key to player or get any key from player, you need to trigger ```CarLock:keyoperation``` in player client  
  Example :  
  ```
    TriggerServerEvent("CarLock:keyoperation", false, plate, vehicle) -- get key
    TriggerServerEvent("CarLock:keyoperation", true, plate, vehicle) -- give key
  ```
2. to check the player has key or not you need to trigger esx callback named  ```CarLock:haskey```  
  Example : 
  ```
    ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
      if haskey then
        print("The Player Has Key")
      end
    end, plate, vehicle)
  ```  
  3. to create key for vehicle use trigger named ```esx:CreateItem```   
  Example : 
  ```
  TriggerServerEvent('esx:CreateItem', "CarKey|"..plate, "Car Key | "..plate, 1, 0, 1);
  -- Dont change anything except plate
  ```
  

  
