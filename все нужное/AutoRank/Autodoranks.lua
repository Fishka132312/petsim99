_G.Autorank = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet, needsHatch)
    -- Фарм и передвижение
    _G.AutoSpeedPetsForRank = needsFarm
    _G.AutoMagnetForRank = needsFarm
    _G.AutoTeleportbestlocationForRank = needsFarm
    _G.AutoTapForRank = needsFarm
    
    -- Использование предметов
    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
    
    -- Открытие яиц
    _G.AutoHatchBestEggForRank = needsHatch
end

task.spawn(function()
    print("Авто-ранг менеджер (Light) запущен!")
    
    while true do
        local needsFarm = false
        local needsJar = false
        local needsComet = false
        local needsHatch = false

        if _G.Autorank then
            local data = Save.Get()
            
            if data and data.Goals then
                for _, goal in pairs(data.Goals) do
                    local title = string.lower(QuestCmds.MakeTitle(goal))
                    
                    -- Проверка на прогресс
                    local current = goal.Progress or 0
                    local target = goal.Amount or 1
                    if current >= target then continue end

                    -- 1. Квесты на фарм (зона / алмазы)
                    if string.find(title, "best area") or string.find(title, "Diamonds") then
                        needsFarm = true
                    end
                    
                    -- 2. Квесты на Coin Jar
                    if string.find(title, "coin jar") then
                        needsJar = true
                        needsFarm = true
                    end

                    -- 3. Квесты на Кометы
                    if string.find(title, "comet") then
                        needsComet = true
                        needsFarm = true
                    end

                    -- 4. Квесты на открытие лучших яиц
                    if string.find(title, "hatch") and string.find(title, "best egg") then
                        needsHatch = true
                    end
                end
            end
        end

        updateStates(needsFarm, needsJar, needsComet, needsHatch)
        
        task.wait(2)
    end
end)
