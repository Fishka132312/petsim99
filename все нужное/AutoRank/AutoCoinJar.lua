_G.CoinJarUse = false
local SPAWN_DELAY = 10

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local SaveModule = require(Library.Client.Save)
local Network = require(Library.Client.Network)

local function getAvailableJarUID()
    local playerData = SaveModule.Get()
    if playerData and playerData.Inventory and playerData.Inventory.Misc then
        for uid, item in pairs(playerData.Inventory.Misc) do
            if string.find(item.id, "Coin Jar") and not string.find(item.id, "Giant") then
                return uid
            end
        end
    end
    return nil
end

task.spawn(function()
    
    while true do
        if _G.CoinJarUse then
            local jarUID = getAvailableJarUID()
            
            if jarUID then
                local success, ray = Network.Invoke("CoinJar_Spawn", jarUID)
                
                if success then
                    print("Успешно заспавнили банку! UID: " .. jarUID)
                else
                end
            else
            end
        end
        
        task.wait(SPAWN_DELAY)
    end
end)
