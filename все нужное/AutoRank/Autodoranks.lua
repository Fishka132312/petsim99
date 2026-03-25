_G.Autorank = true

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet)
    _G.AutoSpeedPets = needsFarm
    _G.AutoMagnet = needsFarm
    _G.AutoTeleportbestlocation = needsFarm
    _G.AutoTap = needsFarm
    
    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
end

task.spawn(function()
    print("Авто-ранг менеджер (v2) запущен!")
    
    while true do
        local needsFarm = false
        local needsJar = false
        local needsComet = false

        if _G.Autorank then
            local data = Save.Get()
            
            if data and data.Goals then
                for _, goal in pairs(data.Goals) do
                    local title = string.lower(QuestCmds.MakeTitle(goal))
                    
                    if string.find(title, "best area") then
                        needsFarm = true
                    end
                    
                    if string.find(title, "coin jar") then
                        needsJar = true
                        needsFarm = true
                    end

                    if string.find(title, "comet") then
                        needsComet = true
                        needsFarm = true
                    end
                end
            end
        end

        updateStates(needsFarm, needsJar, needsComet)
        
        task.wait(2)
    end
end)
