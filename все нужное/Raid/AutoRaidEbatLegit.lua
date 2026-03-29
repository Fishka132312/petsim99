if not getgenv().LuckyRaidSettings then
    getgenv().LuckyRaidSettings = {
        TargetRaidLevel = "Max",
        BossChest1 = true,
        BossChest2 = true,
        BossChest3 = true,
        OpenChests = {
            TitanicChest = true,
            HugeChest = true,
            LootChest = true,
            LeprechaunChest = true,
            Tier1000Chest = true
        },
		WalkSpeed = 100,
		LegitMode = true,
        Noclip = true
    }
end

_G.AutoFarmRaidNormal = true 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")
local Active = things:WaitForChild("__INSTANCE_CONTAINER"):WaitForChild("Active")
local Net = ReplicatedStorage:WaitForChild("Network")
local PathfindingService = game:GetService("PathfindingService")

local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local Network = require(Library.Client.Network)

local lastBossRoom = 0
local boss2Purchased = false 
local teleportedThisRaid = false
local lastLeave = 0
local currentTween = nil

local function moveTo(targetPosition)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not hrp then return end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45,
    })

    path:ComputeAsync(hrp.Position, targetPosition)

    if path.Status ~= Enum.PathStatus.Success then
        return
    end

    for _, waypoint in ipairs(path:GetWaypoints()) do
        if not _G.AutoFarmRaidNormal then break end

        humanoid:MoveTo(waypoint.Position)

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        humanoid.MoveToFinished:Wait()
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P then
        _G.AutoFarmRaidNormal = not _G.AutoFarmRaidNormal
        if not _G.AutoFarmRaidNormal then end
        warn(" LuckyRaid Status: " .. (_G.AutoFarmRaidNormal and "RUNNING" or "STOPPED"))
    end
end)

local function getBreakable()
    for _, v in pairs(breakables:GetChildren()) do
        local id = v:GetAttribute("BreakableID")
        if id and string.find(tostring(id), "LuckyRaid") then return v end
    end
    return nil
end

local function forceBuy(bossId, roomNum)
    print("🛒 Покупка/Рычаг: Босс #" .. bossId .. " (Комната " .. roomNum .. ")")
    for i = 1, 3 do
        pcall(function()
            Net.LuckyRaid_PullLever:InvokeServer(bossId)
            task.wait(0.1)
            Net.Raids_StartBoss:InvokeServer(bossId)
        end)
        task.wait(0.3)
    end
    if bossId == 2 then boss2Purchased = true end
end

task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarmRaidNormal then
            local target = getBreakable()
            if target and target.Parent then
                local targetPos = target:GetPivot()
                moveTo((targetPos * CFrame.new(0, 3, 0)).Position)
            end
        end
    end
end)

task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if getgenv().LuckyRaidSettings.Noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarmRaidNormal and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = getgenv().LuckyRaidSettings.WalkSpeed
                end
            end
        end)
    end
end)


while task.wait(0.5) do
    if _G.AutoFarmRaidNormal then
        local raid = RaidInstance.GetCurrent()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        if not raid then
            teleportedThisRaid = false
            lastBossRoom = 0
            boss2Purchased = false
            if tick() - lastLeave > 3 then
                local myRaid = RaidInstance.GetByOwner(player)
                if myRaid and not myRaid:IsComplete() then
                    Network.Invoke("Raids_Join", myRaid:GetId())
                else
                    local portal
                    for i = 1, 10 do if not RaidInstance.GetByPortal(i) then portal = i break end end
                    if portal then
                        local settings = getgenv().LuckyRaidSettings
                        local lvl = (settings and settings.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or 1
                        RaidCmds.Create({Difficulty = lvl, Portal = portal, PartyMode = 1})
                    end
                end
                lastLeave = tick()
            end
        elseif hrp then
            local room = raid:GetRoomNumber()
            local raidFolder = Active:FindFirstChild("LuckyRaid")

            if raidFolder and raidFolder:FindFirstChild("INTERACT") then
                for _, obj in ipairs(raidFolder.INTERACT:GetChildren()) do
                    if getgenv().LuckyRaidSettings.OpenChests[obj.Name] then
                        pcall(function() Net.Raids_OpenChest:InvokeServer(obj.Name) end)
                    end
                end
            end

            if lastBossRoom ~= room then
                if room == 3 then forceBuy(1, 3) lastBossRoom = room
                elseif room == 6 then forceBuy(2, 6) lastBossRoom = room
                end
            end

            if not getBreakable() then
                if boss2Purchased and lastBossRoom < 9 then
                    task.wait(2)
                    if not getBreakable() then
                        warn("🎯 ТП в FinalArea!")
                        local finalAreaPath = Active:FindFirstChild("LuckyRaid")
                        if finalAreaPath and finalAreaPath:FindFirstChild("FinalArea") then
                            moveTo(finalAreaPath.FinalArea:GetPivot().Position)
                            task.wait(1)
                            for i = 1, 3 do
                                pcall(function()
                                    Net.LuckyRaid_PullLever:InvokeServer(3)
                                    task.wait(0.2)
                                    Net.Raids_StartBoss:InvokeServer(3)
                                end)
                            end
                            lastBossRoom = 9 
                        end
                    end
                end

                if room >= 10 then
                    task.wait(5)
                    if not getBreakable() then
                        warn("🏁 Ресет рейда...")
                        lastLeave = tick()
                        pcall(function()
                            Net.Instancing_PlayerLeaveInstance:FireServer("LuckyRaid")
                            task.wait(0.5)
                            Net.Instancing_PlayerEnterInstance:InvokeServer("LuckyEventWorld")
                        end)
                    end
                end
            end
        end
    end
end
