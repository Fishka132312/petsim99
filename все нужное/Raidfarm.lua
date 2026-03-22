getgenv().LuckyRaidEnabled = true
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
    }
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")
local Net = ReplicatedStorage:WaitForChild("Network")

local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local Network = require(Library.Client.Network)

UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.K then
        getgenv().LuckyRaidEnabled = not getgenv().LuckyRaidEnabled
        print("LuckyRaid Status:", getgenv().LuckyRaidEnabled and "ACTIVE" or "PAUSED")
    end
end)

local function getHRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getFinalAreaWaypoint()
    local container = things:FindFirstChild("__INSTANCE_CONTAINER")
    local active = container and container:FindFirstChild("Active")
    local luckyRaid = active and active:FindFirstChild("LuckyRaid")
    if luckyRaid then
        local finalArea = luckyRaid:FindFirstChild("FinalArea")
        return finalArea and finalArea:FindFirstChild("Waypoint")
    end
    return nil
end

local function getBreakable()
    local hrp = getHRP()
    if not hrp then return nil end
    local target, dist = nil, math.huge
    for _, v in ipairs(breakables:GetChildren()) do
        local id = v:GetAttribute("BreakableID")
        if id and string.find(id, "LuckyRaid") then
            local p = v:GetPivot().Position
            local d = (hrp.Position - p).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

local function hasBreakables()
    for _, v in ipairs(breakables:GetChildren()) do
        if v:GetAttribute("BreakableID") and string.find(v:GetAttribute("BreakableID"), "LuckyRaid") then
            return true
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().LuckyRaidEnabled then
            local target = getBreakable()
            local hrp = getHRP()
            if target and target.Parent and hrp then
                hrp.CFrame = target:GetPivot() * CFrame.new(0, 4, 0)
            end
        end
    end
end)

task.spawn(function()
    local lastBossRoom = 0
    local secretOpened = false
    local isFinishing = false

    while true do
        task.wait(0.5)
        if not getgenv().LuckyRaidEnabled then continue end

        local raid = RaidInstance.GetCurrent()
        local hrp = getHRP()
        
        if not raid then
            secretOpened = false
            isFinishing = false
            lastBossRoom = 0
            
            local myRaid = RaidInstance.GetByOwner(player)
            if myRaid and not myRaid:IsComplete() then
                Network.Invoke("Raids_Join", myRaid:GetId())
            else
                local lvl = (getgenv().LuckyRaidSettings.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or 1
                for i = 1, 10 do
                    if not RaidInstance.GetByPortal(i) then
                        RaidCmds.Create({Difficulty = lvl, Portal = i, PartyMode = 1})
                        break
                    end
                end
            end
        elseif hrp then
            local room = raid:GetRoomNumber()
            
            if room % 3 == 0 and lastBossRoom ~= room then
                lastBossRoom = room
                for i = 1, 3 do
                    pcall(function() 
                        Net.LuckyRaid_PullLever:InvokeServer(i)
                        Net.Raids_StartBoss:InvokeServer(i)
                    end)
                end
            end

            if room >= 10 and not hasBreakables() and not isFinishing then
                local waypoint = getFinalAreaWaypoint()
                
                if waypoint then
                    if not secretOpened then
                        local attempts = 0
                        repeat
                            hrp.CFrame = waypoint.CFrame
                            task.wait(0.3)
                            pcall(function()
                                Net.Raids_StartBoss:InvokeServer(3)
                            end)
                            attempts = attempts + 1
                            task.wait(0.7)
                        until hasBreakables() or attempts > 5
                        
                        secretOpened = true
                        if hasBreakables() then continue end
                    end

                    isFinishing = true
                    hrp.CFrame = waypoint.CFrame
                    task.wait(0.5)
                    
                    local chestOrder = {"TitanicChest", "HugeChest", "LootChest", "Tier1000Chest"}
                    for _, chestName in ipairs(chestOrder) do
                        if getgenv().LuckyRaidSettings.OpenChests[chestName] then
                            pcall(function()
                                Net.Raids_OpenChest:InvokeServer(chestName)
                            end)
                            task.wait(0.6)
                        end
                    end
                    
                    task.wait(1)
                    Net.Instancing_PlayerLeaveInstance:FireServer("LuckyRaid")
                    task.wait(2)
                    Net.Instancing_PlayerEnterInstance:InvokeServer("LuckyEventWorld")
                end
            end
        end
    end
end)
