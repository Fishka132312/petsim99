_G.Autorank = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet, needsHatch, needsGold, needsRainbow)
    -- Фарм и передвижение
    _G.AutoSpeedPetsForRank = needsFarm
    _G.AutoMagnetForRank = needsFarm
    _G.AutoTeleportbestlocationForRank = needsFarm
    _G.AutoTapForRank = needsFarm
    
    -- Использование предметов
    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
    
    -- Открытие яиц и Крафт
    _G.AutoHatchBestEggForRank = needsHatch
    _G.CraftPetsGold = needsGold
    _G.CraftPetsRainbow = needsRainbow
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
                        if string.find(title, "use a") or string.find(title, "use %d+") then
                            print("--- [RANK] Активен квест на Coin Jar: " .. title)
                        end
                    end

                    -- 3. Квесты на Кометы
                    if string.find(title, "comet") then
                        needsComet = true
                        needsFarm = true
                        if string.find(title, "use a") or string.find(title, "use %d+") then
                            print("--- [RANK] Активен квест на Кометы: " .. title)
                        end
                    end

                    -- 4. Квесты на открытие лучших яиц
                    if string.find(title, "hatch") and string.find(title, "best egg") then
                        needsHatch = true
                    end

-- 5. Квесты на зелья (Понимает цифры 1-9, римские i-vi и артикль "a")
if string.find(title, "use") and string.find(title, "potion") and string.find(title, "tier") then
    -- 1. Пытаемся вытащить римские цифры или обычные (ищем всё, что после слова tier)
    local rawTier = title:match("tier%s+([%w%.]+)")
    
    -- 2. Таблица для перевода римских в обычные
    local romanMap = {i = 1, ii = 2, iii = 3, iv = 4, v = 5, vi = 6}
    
    -- 3. Определяем итоговое число тира
    local tierNumber = tonumber(rawTier) or romanMap[rawTier]

    if tierNumber then
        _G.PotionToUse = tierNumber
        _G.AutoUsePotionsForRank = true
        print("--- [RANK] Нашел квест на зелья! Тир: " .. tostring(tierNumber))
    else
        print("--- [RANK] Вижу квест, но не понял Тир из текста: " .. title)
    end
end

						-- 6. Квесты на флаги (Use X Flags)
if string.find(title, "use") and string.find(title, "flag") then
    -- Ищем число в тексте квеста (например, "10" из "use 10 flags")
    local amount = title:match("(%d+)")
    
    if amount then
        _G.UseFlag = tonumber(amount)
        needsFarm = true -- Это включит телепорт и фарм через updateStates
        print("--- [RANK] Квест на флаги! Нужно использовать: " .. amount)
    else
        -- Если число не найдено (например, "use a flag"), ставим 1 по умолчанию
        _G.UseFlag = 1
        needsFarm = true
        print("--- [RANK] Квест на флаг (единичный)")
    end
end

-- 7. КРАФТ (Золотые и Радужные)
                    local isMakeQuest = string.find(title, "make")
                    if isMakeQuest then
                        if string.find(title, "rainbow") then
                            needsRainbow = true
                            needsGold = true -- Включаем и голд, чтобы было из чего делать радужных
                            needsHatch = true -- Идем к яйцам за материалом
                            print("--- [RANK] Квест на Rainbow петов!")
                        elseif string.find(title, "gold") or string.find(title, "golden") then
                            needsGold = true
                            needsHatch = true -- Идем к яйцам
                            print("--- [RANK] Квест на Golden петов!")
                        end
                    end
                end
            end
        end

        updateStates(needsFarm, needsJar, needsComet, needsHatch)
        
        task.wait(2)
    end
end)
