_G.Autorank = false
_G.IsDoingJarQuest = false

local Save = require(game.ReplicatedStorage.Library.Client.Save)
local QuestCmds = require(game.ReplicatedStorage.Library.Client.QuestCmds)

local function updateStates(needsFarm, needsJar, needsComet, needsHatch, needsGold, needsRainbow, needsLegendary)
    -- Фарм и передвижение
    _G.AutoSpeedPetsForRank = _G.Autorank
    _G.AutoMagnetForRank = _G.Autorank
    _G.AutoTeleportbestlocationForRank = needsFarm
    _G.AutoTapForRank = _G.Autorank
    
    -- Использование предметов
    _G.CoinJarUse = needsJar
    _G.CometUse = needsComet
    
    -- Открытие яиц и Крафт
    if needsLegendary then
        _G.AutoHatchBestEggForRank = false
        _G.AutoHatchLegendary = true
    else
        _G.AutoHatchBestEggForRank = needsHatch
        _G.AutoHatchLegendary = false
    end

    _G.CraftPetsGold = needsGold
    _G.CraftPetsRainbow = needsRainbow
end

task.spawn(function()
    
    while true do
        local needsFarm = false
        local needsJar = false
        local needsComet = false
        local needsHatch = false
        local needsGold = false
        local needsRainbow = false
        local needsLegendary = false
        _G.IsDoingJarQuest = false
        _G.AutoUsePotionsForRank = false

        if _G.Autorank then
            local data = Save.Get()
            
            if data and data.Goals then
                for _, goal in pairs(data.Goals) do
                    local title = string.lower(QuestCmds.MakeTitle(goal))
                    
                    -- Проверка на прогресс
                    local current = goal.Progress or 0
                    local target = goal.Amount or 1
                    if current >= target then continue end

                    -- 1. Квесты на фарм (зона / алмазы / ломание объектов)
local isDiamondQuest = string.find(title, "diamond") -- Убрал "s", теперь ловит и diamond, и diamonds
local isBreakQuest = string.find(title, "break")
local isEarnQuest = string.find(title, "earn") or string.find(title, "collect")

-- Проверяем: если в названии есть "diamond" ИЛИ "best area"
if isDiamondQuest or string.find(title, "best area") then
    needsFarm = true -- Это заставит скрипт телепортироваться в лучшую локацию
    
    if isDiamondQuest then
        if isBreakQuest then
        elseif isEarnQuest then
        end
    end
end

                    -- 2. Квесты на Coin Jar
if string.find(title, "coin jar") then
    needsJar = true
    _G.IsDoingJarQuest = true
    -- Добавляем проверку: если в квесте про джары просят "best area", включаем фарм/тп
    if string.find(title, "best area") then
        needsFarm = true
    end
    
    if string.find(title, "use a") or string.find(title, "use %d+") or string.find(title, "break") then
        print("--- [RANK] The active quest is Coin Jar: " .. title)
    end
end

                    -- 3. Квесты на Кометы
                    if string.find(title, "comet") then
                        needsComet = true
                        needsFarm = true
                        if string.find(title, "use a") or string.find(title, "use %d+") then
                            print("--- [RANK] The active quest is Comets: " .. title)
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
        print("--- [RANK] Potion quest! Tier: " .. tostring(tierNumber))
    end
end

						-- 6. Квесты на флаги (Use X Flags)
if string.find(title, "use") and string.find(title, "flag") then
    -- Ищем число в тексте квеста (например, "10" из "use 10 flags")
    local amount = title:match("(%d+)")
    
    if amount then
        _G.UseFlag = tonumber(amount)
        needsFarm = true -- Это включит телепорт и фарм через updateStates
        print("--- [RANK] Flags quest! Need to use: " .. amount)
    else
        -- Если число не найдено (например, "use a flag"), ставим 1 по умолчанию
        _G.UseFlag = 1
        needsFarm = true
        print("--- [RANK] Flag Quest (single)")
    end
end

-- 7. КРАФТ (Золотые и Радужные)
local isMakeQuest = string.find(title, "make")
if isMakeQuest then
    -- Проверяем на Радужных (Rainbow)
    if string.find(title, "rainbow") then
        needsRainbow = true
        needsGold = true   -- Обязательно для материала
        needsHatch = true  -- Бежим к яйцам
        
        if string.find(title, "make a ") then
            print("--- [RANK] Final push: Crafting the latest Rainbow Pet!")
        else
            print("--- [RANK] The active quest is Rainbow Pets!")
        end

    -- Проверяем на Золотых (Gold/Golden)
    elseif string.find(title, "gold") or string.find(title, "golden") then
        needsGold = true
        needsHatch = true  -- Бежим к яйцам
        
        if string.find(title, "make a ") then
            print("--- [RANK] Final push: Crafting the latest Gold Pet!")
        else
            print("--- [RANK] Active quest is Gold pets!")
        end
    end
end

-- 8. Квест на Легендарных питомцев (Hatch a Legendary)
-- 8. Квест на Легендарных питомцев (Hatch a Legendary)
if string.find(title, "hatch") and (string.find(title, "legendary") or string.find(title, "above")) then
    needsLegendary = true
    needsHatch = false -- Выключаем обычный хатч
    needsFarm = false  -- Выключаем ТП на фарм, чтобы стоять у яйца
    print("--- [RANK] A quest for a legendary!")
end
                end
            end
        end

        updateStates(needsFarm, needsJar, needsComet, needsHatch, needsGold, needsRainbow, needsLegendary)
        
        task.wait(5)
    end
end)
