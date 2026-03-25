_G.Autorank = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet, needsHatch, potionTier, needsLegendary)
    _G.AutoSpeedPetsForRank = needsFarm
    _G.AutoMagnetForRank = needsFarm
    _G.AutoTeleportbestlocation = needsFarm
    _G.AutoTapForRank = needsFarm
	_G.AutoHatchForLegendaryRank = needsLegendary

    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
    _G.AutoHatchBestEggForRank = needsHatch
    
    -- ПРОВЕРКА: Если нашли тир, отправляем в _G.PotionToUse
    if potionTier and potionTier > 0 then
        if _G.PotionToUse == nil then
            _G.PotionToUse = tonumber(potionTier)
            print("!!! [SUCCESS] Отправил в скрипт зелий Тир: " .. potionTier)
        end
    end
end

task.spawn(function()
    print("Авто-ранг менеджер v12 запущен!")
    
    while true do
        local needsFarm = false
        local needsJar = false
        local needsComet = false
        local needsHatch = false
		local needsLegendary = false
        local potionTier = 0 

        if _G.Autorank then
            local data = Save.Get()
            if data and data.Goals then
                for _, goal in pairs(data.Goals) do
                    local title = string.lower(QuestCmds.MakeTitle(goal))
                    
                    -- ДЕБАГ: Раскомментируй строку ниже, если хочешь видеть все квесты в консоли
                    -- print("Проверяю квест: " .. title)

                    -- 1. Фарм / Алмазы
                    if string.find(title, "best area") or string.find(title, "diamonds") then
                        needsFarm = true
                    end
                    
                    -- 2. Jar / Comet
                    if string.find(title, "coin jar") then
                        needsJar = true; needsFarm = true
                    elseif string.find(title, "comet") then
                        needsComet = true; needsFarm = true
                    end

                    -- 3. Яйца
                    if string.find(title, "hatch") and string.find(title, "best egg") then
                        needsHatch = true
                    end

                    --Лега петы
					if string.find(title, "hatch") and string.find(title, "legendary") then
                    needsLegendary = true
                end

                    -- 4. УЛЬТРА-ПОИСК ЗЕЛИЙ
                    if string.find(title, "potion") then
                        -- Сначала ищем классику: "tier 3"
                        local tierNumber = string.match(title, "tier%s+(%d+)")
                        
                        -- Если не нашел, ищем просто любую цифру в конце или середине
                        if not tierNumber then
                            tierNumber = string.match(title, "(%d+)%s+potion") or string.match(title, "potion%s+(%d+)")
                        end
                        
                        -- Если всё еще не нашел, берем ПОСЛЕДНЮЮ цифру в названии (обычно это тир)
                        if not tierNumber then
                            tierNumber = string.match(title, ".*(%d+)")
                        end

                        if tierNumber then
                            potionTier = tonumber(tierNumber)
                        end
                    end
                end
            end
        end

        updateStates(needsFarm, needsJar, needsComet, needsHatch, potionTier, needsLegendary)
        task.wait(2)
    end
end)
