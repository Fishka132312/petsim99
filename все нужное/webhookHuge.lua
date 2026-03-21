
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local PetsLib = require(game.ReplicatedStorage.Library.Items)
local RAPCmds = require(game.ReplicatedStorage.Library.Client.RAPCmds)

local lastState = {}
local initialized = false
local iconLinkKomaru = "https://upload.wikimedia.org/wikipedia/commons/f/f9/Komarucat.jpg"

local function getThumbnail(assetId)
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

local function getIconId(pet, dir)
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
    local rapValue = getRap(itemName)
    local iconLink = getThumbnail(pet.iconId) or ""

    local valueText = ">>> **Item:** `" .. itemName .. "`\n**Rap:** `" .. rapValue .. "`"

    local payload = {
        ["username"] = "Komaru Webhook",
        ["embeds"] = {{
            ["title"] = "🎉 New Pet Hatched!!!",
            ["color"] = 16768768,
            ["thumbnail"] = { ["url"] = iconLink },
            ["fields"] = {
                {
                    ["name"] = "🛠️ **Pet Info:**",
                    ["value"] = valueText,
                    ["inline"] = false
                },
                {
                    ["name"] = "👤 **User Info:**",
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

    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        req({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end
end

local function scanPets()
    local pets = PetsLib.Pet:All()
    local current = {}

    for _, pet in pairs(pets) do
        local name = "Unknown"
        local amount = 0

        pcall(function() name = pet:GetId() end)
        pcall(function() amount = pet:GetAmount() end)

        local dir
        pcall(function()
            dir = pet:Directory()
        end)

        local iconId = getIconId(pet, dir)

        if not current[name] then
            current[name] = {
                count = 0,
                iconId = iconId
            }
        end

        current[name].count += amount

        if iconId ~= "0" then
            current[name].iconId = iconId
        end
    end

for name, data in pairs(current) do
    local old = lastState[name]
    local oldCount = old and old.count or 0

    if data.count > oldCount then
        local diff = data.count - oldCount

        local petNameStr = tostring(name)
        local triggerPrefix = "Leprechaun"

        if initialized and string.find(petNameStr, "^" .. triggerPrefix) then
            sendWebhook({
                name = petNameStr,
                amount = diff,
                iconId = data.iconId
            })
        end
    end

    lastState[name] = {
        count = data.count,
        iconId = data.iconId
    }
end
end

scanPets()
initialized = true

while true do
    task.wait(1)
    scanPets()
end
