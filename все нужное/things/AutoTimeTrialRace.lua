-- === Настройки ===
getgenv().TimeTrialSettings = {
    TweenSpeed = 110,
    DetectionRadius = 120
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Библиотеки игры
local Library = ReplicatedStorage:WaitForChild("Library")
local InstancingCmds = require(Library.Client.InstancingCmds)
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")

_G.TimeTrialFarm = true -- Поставил true, чтобы сразу работал

-- === ФУНКЦИЯ ПРОВЕРКИ ГУИ ===
local function isRoundFinished()
    local pg = player:FindFirstChild("PlayerGui")
    local summary = pg and pg:FindFirstChild("TimeTrialSummary")
    if summary and summary.Enabled then
        local mainFrame = summary:FindFirstChild("Frame") or summary:FindFirstChildOfClass("Frame")
        return mainFrame and mainFrame.Visible
    end
    return false
end

-- === СИСТЕМА ПЕРЕДВИЖЕНИЯ ===
local function tweenTo(targetCFrame)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not _G.TimeTrialFarm or isRoundFinished() then return end

    local targetPos = targetCFrame.Position
    local dist = (hrp.Position - targetPos).Magnitude
    local duration = dist / getgenv().TimeTrialSettings.TweenSpeed
    
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    
    local completed = false
    local connection
    
    -- Мониторинг во время полета (без утечек памяти)
    connection = RunService.Heartbeat:Connect(function()
        if not _G.TimeTrialFarm or isRoundFinished() then
            tween:Cancel()
            completed = true
            if connection then connection:Disconnect() connection = nil end
        end
    end)

    tween:Play()

    -- Ждем завершения
    tween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() connection = nil end
    end)

    -- Ждем физического окончания процесса
    repeat task.wait() until completed or not _G.TimeTrialFarm
    if connection then connection:Disconnect() connection = nil end
end

-- === ПОИСК БЛИЖАЙШЕЙ ЦЕЛИ ===
local function getClosestBreakable()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest = nil
    local dist = math.huge
    local children = breakables:GetChildren()

    for i = 1, #children do
        local v = children[i]
        if v:IsA("Model") or v:IsA("BasePart") then
            local pos = v:GetPivot().Position
            local d = (hrp.Position - pos).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

-- === ОСНОВНОЙ ЦИКЛ ===
task.spawn(function()
    print("--- Time Trial Farm v8.0 FIXED ---")
    
    while task.wait(0.3) do
        if not _G.TimeTrialFarm then continue end

        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if not hrp then continue end -- Ждем прогрузки персонажа

        local instanceID = InstancingCmds.GetInstanceID()

        if instanceID ~= "TimeTrial" then
            -- Вход в игру
            print("Входим в Time Trial...")
            pcall(function() InstancingCmds.Enter("TimeTrial") end)
            task.wait(6) -- Увеличил задержку прогрузки, чтобы не крашило при входе
        else
            -- Проверка на финиш
            if isRoundFinished() then
                print("Раунд окончен, выходим...")
                pcall(function() InstancingCmds.Leave() end)
                task.wait(4)
                continue
            end

            -- Логика фарма
            local target = getClosestBreakable()
            if target then
                local targetPivot = target:GetPivot()
                local targetPos = (targetPivot * CFrame.new(0, 6, 0)).Position
                
                if (hrp.Position - targetPos).Magnitude > 8 then
                    tweenTo(CFrame.new(targetPos))
                end
            end
        end
    end
end)
