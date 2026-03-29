-- Настройки
getgenv().LuckyRaidSettings = {
    TargetRaidLevel = "Max",
    TweenSpeed = 90,
    RoomRadius = 75 
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local Net = ReplicatedStorage:WaitForChild("Network")
local Library = ReplicatedStorage:WaitForChild("Library")
local RaidCmds = require(Library.Client.RaidCmds)
local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")

_G.AutoFarmRaidLegit = false
local activatedBosses = {}

-- === УМНАЯ СИСТЕМА ПЕРЕДВИЖЕНИЯ (PATHFINDING) ===

local function getPathPoints(targetPos)
    local path = PathfindingService:CreatePath({
        AgentRadius = 3,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointsSpacing = 4
    })
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(hrp.Position, targetPos)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    else
        -- Если путь не найден (например, цель внутри стены), просто идем напрямую
        return nil
    end
end

local function tweenTo(targetCFrame)
    if not targetCFrame then return end
    local targetPos = targetCFrame.Position
    
    -- Пробуем построить маршрут
    local waypoints = getPathPoints(targetPos)
    
    if waypoints then
        -- Идем по точкам маршрута
        for i, waypoint in ipairs(waypoints) do
            if not _G.AutoFarmRaidLegit then break end
            
            -- Пропускаем первую точку (она обычно под нами)
            if i == 1 then continue end 
            
            local pointPos = waypoint.Position
            -- Поднимаем точку, чтобы не цепляться за пол при твине
            local finalPointPos = Vector3.new(pointPos.X, hrp.Position.Y, pointPos.Z)
            
            -- Если это последняя точка, плавно переходим на высоту цели
            if i == #waypoints then
                finalPointPos = targetPos
            end

            local dist = (hrp.Position - finalPointPos).Magnitude
            local duration = dist / getgenv().LuckyRaidSettings.TweenSpeed
            
            local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(finalPointPos)})
            tween:Play()
            tween.Completed:Wait()
        end
    else
        -- Резервный вариант: прямой полет, если Pathfinding не сработал
        local dist = (hrp.Position - targetPos).Magnitude
        local duration = dist / getgenv().LuckyRaidSettings.TweenSpeed
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- === ФУНКЦИЯ ПОИСКА БРЕЙКАБЛОВ ===

local function getTargetBreakable(currentRoomNumber)
    local raidPath = things.__INSTANCE_CONTAINER.Active:FindFirstChild("LuckyRaid")
    if not raidPath then return nil end

    local searchPoints = {}
    local roomModel = raidPath.Rooms:FindFirstChild("Room" .. currentRoomNumber)
    if roomModel then table.insert(searchPoints, roomModel:GetPivot().Position) end
    
    if activatedBosses[1] then table.insert(searchPoints, raidPath.Rooms.Boss1.BREAK_ZONES.Boss1.Position) end
    if activatedBosses[2] then table.insert(searchPoints, raidPath.Rooms.Boss2.BREAK_ZONES.Boss2.Position) end
    
    if activatedBosses["Chests"] and raidPath:FindFirstChild("FinalArea") then 
        table.insert(searchPoints, raidPath.FinalArea:GetPivot().Position) 
    end

    local closest = nil
    local dist = math.huge
    local foundInRange = false

    for _, v in pairs(breakables:GetChildren()) do
        if v:GetAttribute("BreakableID") and string.find(tostring(v:GetAttribute("BreakableID")), "LuckyRaid") then
            local pos = v:GetPivot().Position
            for _, point in ipairs(searchPoints) do
                if (pos - point).Magnitude < getgenv().LuckyRaidSettings.RoomRadius then
                    local d = (hrp.Position - pos).Magnitude
                    if d < dist then
                        dist = d
                        closest = v
                        foundInRange = true
                    end
                end
            end
        end
    end

    if not foundInRange then
        dist = math.huge
        for _, v in pairs(breakables:GetChildren()) do
            if v:GetAttribute("BreakableID") and string.find(tostring(v:GetAttribute("BreakableID")), "LuckyRaid") then
                local d = (hrp.Position - v:GetPivot().Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
    end
    return closest
end

-- === ОБРАБОТКА БОССОВ ===

-- === ОБРАБОТКА БОССОВ С ПРОВЕРКОЙ ОЧИСТКИ ЗОНЫ ===

local function handleBoss(bossNum)
    if activatedBosses[bossNum] then return end
    local raidPath = things.__INSTANCE_CONTAINER.Active:FindFirstChild("LuckyRaid")
    local bossModel = raidPath and raidPath.Rooms:FindFirstChild("Boss" .. bossNum)
    
    if bossModel then
        local leverPos = bossModel.Lever:GetPivot()
        local doorPos = bossModel.Door.Interact:GetPivot()
        
        -- 1. Жмем рычаг
        tweenTo(leverPos)
        for i = 1, 5 do
            Net.LuckyRaid_PullLever:InvokeServer(bossNum)
            task.wait(0.1)
        end
        
        -- 2. Идем к двери и заходим
        tweenTo(doorPos)
        Net.Raids_BossChallenge:InvokeServer(bossNum)
        
        local breakZone = bossModel:FindFirstChild("BREAK_ZONES") and bossModel.BREAK_ZONES:FindFirstChild("Boss" .. bossNum)
        if breakZone then
            local zonePos = breakZone.Position
            -- Подлетаем к зоне
            tweenTo(breakZone.CFrame * CFrame.new(0, 5, 0))
            
            -- === НОВАЯ ПРОВЕРКА ===
            -- Ждем, пока в радиусе зоны есть хоть один LuckyRaid объект            
            local zoneCleared = false
            while not zoneCleared do
                zoneCleared = true -- Допускаем, что чисто
                for _, v in pairs(breakables:GetChildren()) do
                    if v:GetAttribute("BreakableID") and string.find(tostring(v:GetAttribute("BreakableID")), "LuckyRaid") then
                        -- Если объект близко к центру зоны (в пределах радиуса настроек)
                        if (v:GetPivot().Position - zonePos).Magnitude < getgenv().LuckyRaidSettings.RoomRadius then
                            zoneCleared = false -- Нашли объект, значит еще не закончили
                            break
                        end
                    end
                end
                if not _G.AutoFarmRaidLegit then return end -- Выход, если стопнули чит
                task.wait(1) -- Проверяем раз в секунду, чтобы не лагало
            end
        end
        
        -- 3. Только теперь помечаем как выполненное и идем назад к двери
        activatedBosses[bossNum] = true
        task.wait(0.5)
        tweenTo(doorPos)
    end
end

-- === ОСНОВНОЙ ЦИКЛ ===

-- === ОСНОВНОЙ ЦИКЛ (С ПРОВЕРКОЙ ДИСТАНЦИИ) ===

task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoFarmRaidLegit then continue end
        local raid = RaidInstance.GetCurrent()

        if not raid then
            activatedBosses = {} 
            local myRaid = RaidInstance.GetByOwner(player)
            if myRaid and not myRaid:IsComplete() then
                Net.Raids_Join:InvokeServer(myRaid:GetId())
            else
                local portal = nil
                for i = 1, 10 do if not RaidInstance.GetByPortal(i) then portal = i break end end
                if portal then
                    local lvl = (getgenv().LuckyRaidSettings.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or 1
                    RaidCmds.Create({Difficulty = lvl, Portal = portal, PartyMode = 1})
                end
            end
            task.wait(2)
        else
            local room = raid:GetRoomNumber()
            local raidPath = things.__INSTANCE_CONTAINER.Active:FindFirstChild("LuckyRaid")
            
            if room == 3 and not activatedBosses[1] then
                handleBoss(1)
            elseif room == 9 and not activatedBosses[2] then
                handleBoss(2)
            elseif room == 10 then
                local target = getTargetBreakable(10)
                if target then
                    -- НОВАЯ ПРОВЕРКА: Твиним только если мы дальше 7 единиц от цели
                    if (hrp.Position - target:GetPivot().Position).Magnitude > 7 then
                        tweenTo(target:GetPivot() * CFrame.new(0, 5, 0))
                    end
                else
                    local final = raidPath:FindFirstChild("FinalArea")
                    if final then
                        if not activatedBosses["Chests"] then
                            tweenTo(final.Waypoint.CFrame)
                            local chestNames = {"TitanicChest", "LootChest", "HugeChest", "Tier1000Chest"}
                            for _, name in ipairs(chestNames) do
                                pcall(function() Net.Raids_CollectReward:InvokeServer(name, "330689e3c5014071a396b93495ab5f2f") end)
                            end
                            activatedBosses["Chests"] = true
                            task.wait(1)
                        end
                        if not activatedBosses[3] then handleBoss(3) 
                        else 
                            Net.Instancing_PlayerLeaveInstance:FireServer("LuckyRaid")
                            task.wait(2)
                        end
                    end
                end
            else
                local target = getTargetBreakable(room)
                if target then
                    -- НОВАЯ ПРОВЕРКА: Не дергаем твин, если уже прилетели к объекту
                    local targetPos = (target:GetPivot() * CFrame.new(0, 5, 0)).Position
                    if (hrp.Position - targetPos).Magnitude > 7 then
                        tweenTo(target:GetPivot() * CFrame.new(0, 5, 0))
                    end
                end
            end
        end
    end
end)
