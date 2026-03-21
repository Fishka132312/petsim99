local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local waitTime = 300

-- Удаляем старое табло
if CoreGui:FindFirstChild("ServerHopTimer") then CoreGui.ServerHopTimer:Destroy() end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ServerHopTimer"
local label = Instance.new("TextLabel", screenGui)
label.Size = UDim2.new(0, 300, 0, 45)
label.Position = UDim2.new(0.5, -150, 0.85, 0)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.fromRGB(0, 255, 150)
label.TextScaled = true
label.Font = Enum.Font.Code
label.Text = "ЗАГРУЗКА..."

local function teleportNow()
    label.Text = "ПРЫГАЮ..."
    label.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                    return true
                end
            end
        end
        return false
    end)

    if not success or result == false then
        warn("API не ответил, использую обычный телепорт")
        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
    end
end

task.spawn(function()
    for i = waitTime, 0, -1 do
        local mins = math.floor(i / 60)
        local secs = i % 60
        label.Text = string.format("ДО ПРЫЖКА: %02d:%02d", mins, secs)
        task.wait(1)
    end
    teleportNow()
end)