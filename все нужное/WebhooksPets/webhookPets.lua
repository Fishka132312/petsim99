_G.KomaruScriptID = tick()
local currentScriptID = _G.KomaruScriptID

local config = _G.WebhooksPetsConfig or {}
local WebhookURL = config.HugeWebhook or ""

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local PetsLib = require(game.ReplicatedStorage.Library.Items)
local RAPCmds = require(game.ReplicatedStorage.Library.Client.RAPCmds)
local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)

local lastState = {}
local initialized = false
local iconLinkKomaru = "https://upload.wikimedia.org/wikipedia/commons/f/f9/Komarucat.jpg"

local function getThumbnail(assetId)
    if not assetId or assetId == "" then return nil end
    
    if tostring(assetId):find("http") then
        return assetId
    end

    local success, response = pcall(function()
        return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. assetId .. "&size=420x420&format=Png")
    end)

    if success and response then
        local data = HttpService:JSONDecode(response)
        if data.data and data.data[1] then
            return data.data[1].imageUrl
        end
    end

    return nil
end

local function getIconId(pet, dir, variant)
    local iconId = nil
    
    pcall(function()
        local icon = pet:GetIcon() 
        iconId = string.match(tostring(icon), "%d+")
    end)

    if not iconId and dir then
        local raw = dir.Icon or dir.Image or dir.Thumbnail
        if raw then
            iconId = string.match(tostring(raw), "%d+")
        end
    end

    return iconId or "0"
end

local function getRap(name)
    local rapValue = "N/A"

    pcall(function()
        local rap = RAPCmds.Get({id = name})
        if rap then
            if rap >= 1000000 then
                rapValue = string.format("%.2fM", rap / 1000000)
            elseif rap >= 1000 then
                rapValue = string.format("%.1fK", rap / 1000)
            else
                rapValue = tostring(rap)
            end
        end
    end)

    return rapValue
end

local function sendWebhook(pet)
    local itemName = pet.name or "Unknown"
    local variant = pet.variant or "Normal"
    local rapValue = getRap(itemName)
    
    local rawIcon = getThumbnail(pet.iconId) or ""
    local iconLink = rawIcon

    if rawIcon ~= "" then
        if variant:find("Golden") then
            iconLink = "https://wsrv.nl/?url=" .. rawIcon .. "&tint=ffd700&bright=10"
        elseif variant:find("Shiny") then
            local separator = iconLink:find("?") and "&" or "?"
            iconLink = iconLink .. separator .. "bright=30&con=50"
        end
    end

    local lowName = itemName:lower()

    local category = "Pet" -- По умолчанию
    if lowName:find("titanic") then
        category = "Titanic"
    elseif lowName:find("huge") then
        category = "Huge"
    elseif lowName:find("leprechaun") then
        category = "Leprechaun"
    end

    local embedColor = 16777215
    local titleEmoji = "🎉 "

    if variant:find("Rainbow") then
        embedColor = 16711935 
        titleEmoji = "🌈 "
    elseif variant:find("Golden") then
        embedColor = 16761095 
        titleEmoji = "✨ "
    end
    
    if variant:find("Shiny") then
        titleEmoji = titleEmoji .. " ⭐ "
    end

    local valueText = ">>> **Item:** `" .. itemName .. "`\n" ..
                      "**Type:** `" .. variant .. "`\n" ..
                      "**Amount:** `x" .. tostring(pet.amount or 1) .. "`\n" ..
                      "**Rap:** `" .. rapValue .. "`"

    local payload = {
        ["username"] = "Komaru Webhook",
        ["embeds"] = {{
            ["title"] = titleEmoji .. " New " .. category .. " Pet Hatched!!!",
            ["color"] = embedColor,
            ["thumbnail"] = { ["url"] = iconLink },
            ["fields"] = {
                {
                    ["name"] = "🛠️  **Pet Info:**",
                    ["value"] = valueText,
                    ["inline"] = false
                },
                {
                    ["name"] = "👤  **User Info:**",
                    ["value"] = ">>> **In Account:** ||" .. player.Name .. "||\nИдешь нахуй лаки чмо",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "KomaruWebhook • Today at " .. os.date("%H:%M"),
                ["icon_url"] = iconLinkKomaru
            }
        }}
    }

    local targetUrl = WebhookURL
    if lowName:find("titanic") then
        targetUrl = config.TitanicWebhook or WebhookURL
    end

    local req = (syn and syn.request) or (http and http.request) or request
    if req and targetUrl ~= "" then
        req({
            Url = targetUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end
end

local function runTest()
    -- ЗАМЕНА ТУТ: Берем имя и ID из конфига
    local testName = config.TestName or "" 
    local testId = config.TestId or "" 

    if testName == "" or testId == "" then
        print("⚠️ [Komaru Test]: Данные для теста не указаны в конфиге.")
        return 
    end

    print("--- ЗАПУСК ТЕСТА ВЕБХУКА ДЛЯ: " .. testName .. " ---")
    local variants = {"Normal", "Normal Shiny", "Golden", "Golden Shiny", "Rainbow", "Rainbow Shiny"}

    for _, v in ipairs(variants) do
        if _G.KomaruScriptID ~= currentScriptID then break end
        
        sendWebhook({
            name = testName,
            variant = v,
            amount = 1,
            iconId = testId
        })
        
        task.wait(1.5)
    end
    print("--- ТЕСТ ЗАВЕРШЕН ---")
end


local function scanPets()
    local Save = SaveModule.Get()
    if not Save or not Save.Inventory or not Save.Inventory.Pet then return end
    
    local current = {}
    local allPetsData = PetsLib.Pet:All()

    for uid, data in pairs(Save.Inventory.Pet) do
        local name = data.id or "Unknown"
        local amount = data._am or 1
        local pt = data.pt or 0 
        local sh = data.sh or false 

        local variant = "Normal"
        if pt == 1 then variant = "Golden"
        elseif pt == 2 then variant = "Rainbow" end
        if sh then variant = variant .. " Shiny" end

        local stateKey = name .. "_" .. variant

        if not current[stateKey] then
            local foundIconId = "0"
            
            for _, petObj in pairs(allPetsData) do
if petObj:GetId() == name then
                    pcall(function() 
                        petObj:SetType(0) 
                        petObj:SetShiny(false) 
                    end)

                    -- УСТАНАВЛИВАЕМ НУЖНЫЙ ТИП
                    if pt == 1 then 
                        pcall(function() petObj:SetType(1) end) -- Golden
                    elseif pt == 2 then 
                        pcall(function() petObj:SetType(2) end) -- Rainbow
                    end
                    
                    if sh then 
                        pcall(function() petObj:SetShiny(true) end) -- Shiny
                    end

                    local dir = petObj:Directory()
                    foundIconId = getIconId(petObj, dir, variant)
                    
                    pcall(function() 
                        petObj:SetType(0) 
                        petObj:SetShiny(false) 
                    end)

                    if foundIconId ~= "0" then break end
                end
            end

            current[stateKey] = {
                name = name,
                count = 0,
                variant = variant,
                iconId = foundIconId 
            }
        end

        current[stateKey].count = current[stateKey].count + amount
    end

    for key, data in pairs(current) do
        local old = lastState[key]
        local oldCount = (old and old.count) or 0

        if initialized and data.count > oldCount then
            local diff = data.count - oldCount
            local lowName = data.name:lower()

            if lowName:find("huge") or lowName:find("titanic") or lowName:find("leprechaun") then
                sendWebhook({
                    name = data.name,
                    variant = data.variant,
                    amount = diff,
                    iconId = data.iconId
                })
            end
        end
        
        lastState[key] = { count = data.count }
    end
end

print("--- Komaru Webhook: Инициализация инвентаря ---")
scanPets() 
task.wait(2)
initialized = true
task.spawn(runTest)
print("--- Komaru Webhook: Работает! Жду дропа ---")

while true do
    if _G.KomaruScriptID ~= currentScriptID then 
        print("--- Старый скрипт обнаружен и остановлен! ---")
        break 
    end
    
    scanPets()
    task.wait(1)
end