_G.AutoTeleportbestlocationForRank = false
_G.TeleportInitialized = false
_G.Teleportbestlocationaccept = 0

local function startAutoTeleport()
    if _G.TeleportInitialized then return end
    _G.TeleportInitialized = true

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    
    local ZoneCmds = require(ReplicatedStorage.Library.Client.ZoneCmds)
    local currentBestNum = -1
    local stayConnection = nil
    local FREE_DISTANCE = 30

    local function findZoneFolder(targetNum)
        local containers = {"Map", "Map2", "Map3", "Map4", "Map5"}
        for _, name in ipairs(containers) do
            local c = workspace:FindFirstChild(name)
            if c then
                for _, folder in ipairs(c:GetChildren()) do
                    local n = tonumber(folder.Name:match("^(%d+)"))
                    if n == targetNum then return folder end
                end
            end
        end
        return nil
    end

    local function doTeleport()
        if not _G.AutoTeleportbestlocationForRank or tick() < _G.Teleportbestlocationaccept then return end
        
        local _, zoneData = ZoneCmds.GetMaxOwnedZone()
        if not zoneData or not zoneData.ZoneNumber then return end
        
        local bestNum = zoneData.ZoneNumber
        local folder = findZoneFolder(bestNum)
        if not folder then return end
        
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local mainPart = nil
        local interact = folder:FindFirstChild("INTERACT")
        if interact then
            for _, v in ipairs(interact:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:match("^Main") then
                    mainPart = v
                    break
                end
            end
        end

        if not mainPart then
            local persistent = folder:FindFirstChild("PERSISTENT")
            local zoneTP = persistent and persistent:FindFirstChild("Teleport")
            if zoneTP then
                local distToTP = (root.Position - zoneTP.Position).Magnitude
                if distToTP > 20 then
                    root.CFrame = zoneTP.CFrame * CFrame.new(0, 3, 0)
                    print("Прыжок на тех. точку Teleport для прогрузки...")
                end
            end
            return
        end

        local distance = (root.Position - mainPart.Position).Magnitude
        
        if distance > FREE_DISTANCE then
            root.CFrame = mainPart.CFrame * CFrame.new(0, 3, 0)
            print("Успешный ТП на Main зоны " .. bestNum)
        end

        if not stayConnection or currentBestNum ~= bestNum then
            if stayConnection then stayConnection:Disconnect() end
            currentBestNum = bestNum
            
            stayConnection = RunService.Heartbeat:Connect(function()
                if not _G.AutoTeleportbestlocationForRank or tick() < _G.Teleportbestlocationaccept then
                    if stayConnection then stayConnection:Disconnect(); stayConnection = nil end
                    return
                end
                if root and mainPart and mainPart.Parent then
                    if (root.Position - mainPart.Position).Magnitude > FREE_DISTANCE then
                        root.CFrame = mainPart.CFrame * CFrame.new(0, 3, 0)
                    end
                end
            end)
        end
    end

    task.spawn(function()
        while true do
            pcall(doTeleport)
            task.wait(1)
        end
    end)
end

startAutoTeleport()
