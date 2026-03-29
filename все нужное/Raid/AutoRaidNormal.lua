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
        TweenSpeed = 50,
		LegitMode = true,
        Noclip = true
    }
end

_G.AutoFarmRaid = false

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

local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local Network = require(Library.Client.Network)

local lastBossRoom = 0
local boss2Purchased = false 
local teleportedThisRaid = false
local lastLeave = 0
local currentTween = nil

-- Функция плавного перемещения
local function tweenTo(targetCFrame)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 4 then return end -- Ужe на месте

    local duration = distance / getgenv().LuckyRaidSettings.TweenSpeed
    
    if currentTween then currentTween:Cancel() end

    currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P then
        _G.AutoFarmRaid = not _G.AutoFarmRaid
        if not _G.AutoFarmRaid and currentTween then currentTween:Cancel() end
        warn(" LuckyRaid Status: " .. (_G.AutoFarmRaid and "RUNNING" or "STOPPED"))
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

-- Основной цикл перемещения (теперь Твином)
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarmRaid then
            local target = getBreakable()
            if target and target.Parent then
                local targetPos = target:GetPivot()
                -- Смещение чуть выше объекта, чтобы не застревать в текстурах
                tweenTo(targetPos * CFrame.new(0, 3, 0))
            end
        end
    end
end)

-- Функция для работы Ноуклипа
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

print("🚀 Скрипт запущен. Твин-телепорт активирован.")

-- Логика рейда (оставлена без изменений, исправлены только вызовы)
while task.wait(0.5) do
    if _G.AutoFarmRaid then
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
                            tweenTo(finalAreaPath.FinalArea:GetPivot())
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
