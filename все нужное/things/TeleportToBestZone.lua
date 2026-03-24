_G.AutoTeleportbestlocation = false
_G.TeleportInitialized = false

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
    local CHECK_DELAY = 1
    local FREE_DISTANCE = 20

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
        if not _G.AutoTeleportbestlocation then 
            currentBestNum = -1 
            if stayConnection then 
                stayConnection:Disconnect() 
                stayConnection = nil
            end
            return 
        end
        
        local _, zoneData = ZoneCmds.GetMaxOwnedZone()
        if not zoneData or not zoneData.ZoneNumber then return end
        
        local bestNum = zoneData.ZoneNumber
        
        if bestNum > currentBestNum then
            local folder = findZoneFolder(bestNum)
            if not folder then return end
            
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local p = folder:FindFirstChild("PERSISTENT")
            if p and p:FindFirstChild("Teleport") then
                root.CFrame = p.Teleport.CFrame
                task.wait(0.5)
            end

            local interact = folder:FindFirstChild("INTERACT")
            local spawns = interact and interact:FindFirstChild("BREAKABLE_SPAWNS")
            local mainPart = spawns and spawns:FindFirstChild("Main")
            
            if mainPart then
                currentBestNum = bestNum
                if stayConnection then stayConnection:Disconnect() end
                
                stayConnection = RunService.Heartbeat:Connect(function()
                    if not _G.AutoTeleportbestlocation or currentBestNum ~= bestNum then 
                        if stayConnection then 
                            stayConnection:Disconnect() 
                            stayConnection = nil
                        end
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
    end

    task.spawn(function()
        print("Система телепортации готова. Статус: " .. tostring(_G.AutoTeleportbestlocation))
        while true do
            pcall(doTeleport)
            task.wait(CHECK_DELAY)
        end
    end)
end

startAutoTeleport()
