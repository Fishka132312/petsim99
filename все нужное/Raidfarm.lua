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
        }
    }
end

_G.AutoFarmRaid = true 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")
local Active = things:WaitForChild("__INSTANCE_CONTAINER"):WaitForChild("Active")
local Net = ReplicatedStorage:WaitForChild("Network")

local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local Network = require(Library.Client.Network)

local hrp = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

local lastBossRoom = 0
local boss2Purchased = false 
local teleportedThisRaid = false
local lastLeave = 0

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P then
        _G.AutoFarmRaid = not _G.ScriptEnabled
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
    pcall(function()
        Net.LuckyRaid_PullLever:InvokeServer(bossId)
        task.wait(0.1)
        Net.Raids_StartBoss:InvokeServer(bossId)
    end)
    if bossId == 2 then boss2Purchased = true end
end

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarmRaid then
            local target = getBreakable()
            if target and target.Parent then
                local targetPos = target:GetPivot()
                if (hrp.Position - targetPos.Position).Magnitude > 15 then
                    hrp.CFrame = targetPos * CFrame.new(0, 4, 0)
                end
            end
        end
    end
end)

print("🚀 Скрипт запущен. Фикс рычага в FinalArea добавлен.")

while task.wait(0.5) do
    if _G.AutoFarmRaid then
        local raid = RaidInstance.GetCurrent()

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
        else
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
                    print("⏳ Пусто после 2-го босса. Проверка финала...")
                    task.wait(3)
                    
                    if not getBreakable() then
                        warn("🎯 ТП в FinalArea!")
                        
                        local finalAreaPath = workspace.__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("LuckyRaid")
                        if finalAreaPath and finalAreaPath:FindFirstChild("FinalArea") then
                            hrp.CFrame = finalAreaPath.FinalArea:GetPivot()
                            task.wait(0.5)
                            
                            for i = 1, 3 do
                                pcall(function()
                                    local args = { 3 }
                                    Net.LuckyRaid_PullLever:InvokeServer(unpack(args))
                                    task.wait(0.2)
                                    Net.Raids_StartBoss:InvokeServer(unpack(args))
                                end)
                                task.wait(0.3)
                            end
                            
                            print("✅ Рычаг №3 и активация выполнены!")
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

            if not teleportedThisRaid and room == 1 then
                teleportedThisRaid = true
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -10)
            end
        end
    end
end
