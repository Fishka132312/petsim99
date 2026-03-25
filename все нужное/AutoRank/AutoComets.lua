_G.CometUse = false
local SPAWN_DELAY = 3

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local SaveModule = require(Library.Client.Save)
local Network = require(Library.Client.Network)

local function getCometUID()
    local playerData = SaveModule.Get()
    if playerData and playerData.Inventory and playerData.Inventory.Misc then
        for uid, item in pairs(playerData.Inventory.Misc) do
            if item.id == "Comet" then 
                return uid
            end
        end
    end
    return nil
end

task.spawn(function()
    print("Авто-спавн комет запущен!")
    
    while true do
        if _G.CometUse then
            local cometUID = getCometUID()
            
            if cometUID then
                local success = Network.Invoke("Comet_Spawn", cometUID)
                
                if success then
                    print("Комета вызвана! UID: " .. cometUID)
                else
                    print("Сервер отклонил вызов (возможно, лимит на локации)")
                end
            else
                warn("Кометы закончились!")
            end
        end
        
        task.wait(SPAWN_DELAY)
    end
end)
