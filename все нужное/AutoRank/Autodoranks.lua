_G.Autorank = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet, needsHatch)
    -- Фарм и передвижение
    _G.AutoSpeedPetsForRank = needsFarm
    _G.AutoMagnetForRank = needsFarm
    _G.AutoTeleportbestlocation = needsFarm
    _G.AutoTapForRank = needsFarm
    
    -- Использование предметов
    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
    
    -- Открытие яиц
    _G.AutoHatchBestEggForRank = needsHatch
end

task.spawn(function()
    print("Авто-ранг менеджер (v4) запущен!")
    
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
                    
                    -- 1. Квесты в лучшей зоне (Best Area или Алмазы)
                    -- Алмазы почти всегда эффективнее бить в лучшей зоне
                    if string.find(title, "best area") or string.find(title, "diamonds") then
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

                    -- 4. Квесты на открытие ЛУЧШИХ яиц
                    if string.find(title, "hatch") and string.find(title, "best egg") then
                        needsHatch = true
                    end
                end
            end
        end

        -- Обновляем все переменные
        updateStates(needsFarm, needsJar, needsComet, needsHatch)
        
        task.wait(2)
    end
end)
