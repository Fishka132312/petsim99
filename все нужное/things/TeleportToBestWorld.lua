_G.Teleprttobestworld = false

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local v_u_30 = require(game.ReplicatedStorage.Library.Modules.PlaceFile)
local v_u_25 = require(game.ReplicatedStorage.Library.Client.ZoneCmds)
local v_u_27 = require(game.ReplicatedStorage.Library.Client.RebirthCmds)

local function GetBestPlaceID()
    local rb = v_u_27.Get()
    
    if v_u_25.Owns("Doodle Oasis") and rb >= 8 then
        return v_u_30.LocalPlaces.World4
    end
    if v_u_25.Owns("Void Spiral") and rb >= 8 then
        return v_u_30.LocalPlaces.World3
    end
    if v_u_25.Owns("Rainbow Road") and rb >= 4 then
        return v_u_30.LocalPlaces.World2
    end
    
    return v_u_30.LocalPlaces.World1
end

task.spawn(function()
    while task.wait(5) do
        if _G.Teleprttobestworld then
            local currentPlaceID = game.PlaceId
            local bestPlaceID = GetBestPlaceID()
            
            if currentPlaceID ~= bestPlaceID and bestPlaceID ~= nil then
                
                local success, err = pcall(function()
                    TeleportService:Teleport(bestPlaceID, Players.LocalPlayer)
                end)
                
                if not success then
                end
            end
        end
    end
end)
