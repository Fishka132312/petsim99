_G.AutoBuyEnabled = true 

task.spawn(function()
    local ZoneCmds = require(game.ReplicatedStorage.Library.Client.ZoneCmds)
    local ZonesUtil = require(game.ReplicatedStorage.Library.Util.ZonesUtil)
    local Network = require(game.ReplicatedStorage.Library.Client.Network)

    print("Авто-покупка запущена. Статус: " .. tostring(_G.AutoBuyEnabled))

    while true do
        if _G.AutoBuyEnabled then
            local _, maxZoneData = ZoneCmds.GetMaxOwnedZone()
            
            if maxZoneData and maxZoneData.ZoneNumber then
                local nextZoneName, nextZoneData = ZonesUtil.GetZoneFromNumber(maxZoneData.ZoneNumber + 1)
                
                if nextZoneData and nextZoneData.ZoneName then
                    local success, result = Network.Invoke("Zones_RequestPurchase", nextZoneData.ZoneName)
                    if success then
                        print("Куплена зона: " .. nextZoneData.ZoneName)
                    end
                end
            end
        end
        
        task.wait(2)
    end
end)
