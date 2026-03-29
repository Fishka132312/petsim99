local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local ExecutionWebhook = "https://discord.com/api/webhooks/1485155972270788721/KrdNQE9PXsI55wMkzQBwVMpN0pd9cZKvM3VKXdbfg9joY_6TqzdTduhyw-JEuWfHgAEG"

local function safeFix(url)
    if url:find("discord.com") then
        return url:gsub("discord.com", "webhook.lewisakura.moe")
    end
    return url
end

local function sendExecutionWebhook()
    local finalUrl = safeFix(ExecutionWebhook)
    local userId = player.UserId
    local displayName = player.DisplayName
    local username = player.Name
    
    local avatarUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. userId .. "&width=420&height=420&format=png"

    local payload = {
        ["embeds"] = {{
            ["title"] = "🛠️ Execution Verified",
            ["description"] = "A user has just initialized the script instance.",
            ["color"] = 0x00FFAA,
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["fields"] = {
                {
                    ["name"] = "👤 Identification",
                    ["value"] = ">>> **User:** `" .. username .. "`\n**Display:** `" .. displayName .. "`\n**ID:** `" .. userId .. "`",
                    ["inline"] = false
                },
                {
                    ["name"] = "🌐 Environment",
                    ["value"] = ">>> **Experience:** `Pet Simulator 99`\n**Job ID:** `||" .. game.JobId .. "||`",
                    ["inline"] = true
                },
                {
                    ["name"] = "🚀 Status",
                    ["value"] = ">>> **Version:** `v2.4.1`\n**Status:** `Active`",
                    ["inline"] = true
                },
                {
                    ["name"] = "🖼️ Profile Link",
                    ["value"] = "[Click to view Roblox Profile](https://www.roblox.com/users/" .. userId .. "/profile)",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Komaru Intelligence System • " .. os.date("%b %d, %Y | %H:%M:%S"),
                ["icon_url"] = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmxq8OTNO3mbFPdcaYDbAUHtC2Kikrvy1oYA&s"
            }
        }}
    }

    local requestMethod = (syn and syn.request) or (http and http.request) or request or http_request
    
    if requestMethod then
        pcall(function()
            requestMethod({
                Url = finalUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end

task.spawn(sendExecutionWebhook)
