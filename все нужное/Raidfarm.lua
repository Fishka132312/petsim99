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
local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")
local Active = things:WaitForChild("__INSTANCE_CONTAINER"):WaitForChild("Active")
local Net = ReplicatedStorage:WaitForChild("Network")

local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local Network = require(Library.Client.Network)

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    hrp = c:WaitForChild("HumanoidRootPart")
end)

local function getBreakable()
    local target = nil
    local dist = math.huge
    local all = breakables:GetChildren()
    local playerPos = hrp.Position
    
    for i = 1, #all do
        local v = all[i]
        local id = v:GetAttribute("BreakableID")
        if id and string.find(id, "LuckyRaid") then
            local p = v:GetPivot().Position
            local d = (playerPos - p).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

local function hasBreakables()
    local all = breakables:GetChildren()
    for i = 1, #all do
        local id = all[i]:GetAttribute("BreakableID")
        if id and string.find(id, "LuckyRaid") then
            return true
        end
    end
    return false
end

local function openChests(openedThisRoom)
    local raidFolder = Active:FindFirstChild("LuckyRaid")
    local interact = raidFolder and raidFolder:FindFirstChild("INTERACT")
    if not interact then return end

    for _, obj in ipairs(interact:GetChildren()) do
        if getgenv().LuckyRaidSettings.OpenChests[obj.Name] and not openedThisRoom[obj] then
            openedThisRoom[obj] = true
            task.spawn(function()
                pcall(function() Net.Raids_OpenChest:InvokeServer(obj.Name) end)
            end)
        end
    end
end

task.spawn(function()
    while getgenv().LuckyRaidEnabled do
        local target = getBreakable()
        if target and target.Parent then
            local targetPos = target:GetPivot() * CFrame.new(0, 4, 0)
            if (hrp.Position - targetPos.Position).Magnitude > 5 then
                hrp.CFrame = targetPos
            end
        end
        task.wait(0.1) 
    end
end)

local function pullLeverMultiple(id)
    for i = 1, 3 do
        pcall(function()
            Net.LuckyRaid_PullLever:InvokeServer(id)
            Net.Raids_StartBoss:InvokeServer(id)
        end)
        task.wait(0.2)
    end
end

task.spawn(function()
    local teleportedThisRaid = false
    local lastBossRoom = 0
    local openedThisRoom = {}
    local leaving = false
    local lastLeave = 0

    while getgenv().LuckyRaidEnabled do
        local raid = RaidInstance.GetCurrent()
        local Config = getgenv().LuckyRaidSettings
        
        if not raid then
            teleportedThisRaid = false
            openedThisRoom = {}
            lastBossRoom = 0

            if tick() - lastLeave > 2 then
                local myRaid = RaidInstance.GetByOwner(player)
                if myRaid and not myRaid:IsComplete() then
                    Network.Invoke("Raids_Join", myRaid:GetId())
                else
                    local portal = nil
                    for i = 1, 10 do
                        if not RaidInstance.GetByPortal(i) then portal = i break end
                    end
                    
                    if portal then
                        local lvl = (Config.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or tonumber(Config.TargetRaidLevel)
                        RaidCmds.Create({Difficulty = lvl or 1, Portal = portal, PartyMode = 1})
                    end
                end
                lastLeave = tick()
            end
        else
            openChests(openedThisRoom)
            local room = raid:GetRoomNumber()

            if not teleportedThisRaid and room == 1 then
                teleportedThisRaid = true
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -10)
            end

            if room % 3 == 0 and lastBossRoom ~= room then
                lastBossRoom = room
                task.spawn(function()
                    if Config.BossChest1 then pullLeverMultiple(1) end
                    if Config.BossChest2 then pullLeverMultiple(2) end
                    if Config.BossChest3 then pullLeverMultiple(3) end
                end)
            end

            if room >= 10 and not leaving and not hasBreakables() then
                leaving = true
                task.spawn(function()
                    pcall(function()
                        Net.Instancing_PlayerLeaveInstance:FireServer("LuckyRaid")
                        task.wait(0.3)
                        Net.Instancing_PlayerEnterInstance:InvokeServer("LuckyEventWorld")
                    end)
                    lastLeave = tick()
                    task.wait(2)
                    leaving = false
                end)
            end
        end
        task.wait(0.1)
    end
end)
