local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local PlaceId = game.PlaceId
local waitTime = 300

if CoreGui:FindFirstChild("ServerHopTimer") then
    CoreGui.ServerHopTimer:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerHopTimer"
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 260, 0, 90)
frame.Position = UDim2.new(0.5, -130, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0.6, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(0, 255, 150)
label.TextScaled = true
label.Font = Enum.Font.Code
label.Text = "ЗАГРУЗКА..."

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0.3, 0)
button.Position = UDim2.new(0, 10, 0.65, 0)
button.Text = "ПРЫГНУТЬ СЕЙЧАС"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.Code

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local visitedServers = {}

local function getServer()
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"

    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and data and data.data then
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers
            and server.id ~= game.JobId
            and not visitedServers[server.id] then

                visitedServers[server.id] = true
                return server.id
            end
        end
    end

    return nil
end

local function teleportNow()
    label.Text = "Rejoining..."
    label.TextColor3 = Color3.fromRGB(255, 80, 80)

    for i = 1, 3 do
        local serverId = getServer()

        if serverId then
            local success = pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, serverId, Players.LocalPlayer)
            end)

            if success then
                return
            end
        end

        task.wait(2)
    end

    TeleportService:Teleport(PlaceId, Players.LocalPlayer)
end

button.MouseButton1Click:Connect(teleportNow)

task.spawn(function()
    while true do
        for i = waitTime, 0, -1 do
            local mins = math.floor(i / 60)
            local secs = i % 60

            label.TextColor3 = Color3.fromRGB(0, 255, 150)
            label.Text = string.format("Rejoin in: %02d:%02d", mins, secs)

            task.wait(1)
        end

        teleportNow()
        task.wait(5)
    end
end)
