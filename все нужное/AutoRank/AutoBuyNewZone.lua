_G.AutoBuyEnabledForRank = false

task.spawn(function()
    local ZoneCmds = require(game.ReplicatedStorage.Library.Client.ZoneCmds)
    local ZonesUtil = require(game.ReplicatedStorage.Library.Util.ZonesUtil)
    local Network = require(game.ReplicatedStorage.Library.Client.Network)

    while true do
        if _G.AutoBuyEnabledForRank == true then
            local _, maxZoneData = ZoneCmds.GetMaxOwnedZone()
            
            if maxZoneData and maxZoneData.ZoneNumber then
                local nextZoneName, nextZoneData = ZonesUtil.GetZoneFromNumber(maxZoneData.ZoneNumber + 1)
                
                if nextZoneData and nextZoneData.ZoneName then
                    local success = Network.Invoke("Zones_RequestPurchase", nextZoneData.ZoneName)
                    if success then
                        print("Успешно куплена зона: " .. nextZoneData.ZoneName)
                    end
                end
            end
        end
        
        task.wait(2)
    end
end)
