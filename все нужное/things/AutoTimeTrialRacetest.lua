-- === Настройки ===
getgenv().TimeTrialSettings = {
    TweenSpeed = 85, -- Чуть снизил для стабильности, 95 иногда кикает
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

_G.TimeTrialFarm = false -- Сразу включено

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

-- === БЕЗОПАСНАЯ СИСТЕМА ПЕРЕДВИЖЕНИЯ ===
local currentTween = nil
local function tweenTo(targetCFrame)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not _G.TimeTrialFarm or isRoundFinished() then return end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = dist / getgenv().TimeTrialSettings.TweenSpeed
    
    -- Если уже летим, отменяем старый твин
    if currentTween then currentTween:Cancel() end

    currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    
    local completed = false
    local connection
    
    connection = RunService.Stepped:Connect(function()
        -- Если условия изменились или персонаж пропал — мгновенный стоп
        if not _G.TimeTrialFarm or isRoundFinished() or not hrp.Parent then
            if currentTween then currentTween:Cancel() end
            completed = true
            connection:Disconnect()
        end
    end)

    currentTween:Play()
    currentTween.Completed:Wait()
    
    if connection.Connected then connection:Disconnect() end
    completed = true
end

-- === ПОИСК БЛИЖАЙШЕЙ ЦЕЛИ ===
local function getClosestBreakable()
    local things = workspace:FindFirstChild("__THINGS")
    local breakables = things and things:FindFirstChild("Breakables")
    if not breakables then return nil end

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
    print("--- Time Trial Farm FIXED v9.0 ---")
    
    while task.wait(0.5) do -- Увеличена задержка цикла для разгрузки CPU
        if not _G.TimeTrialFarm then continue end

        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        -- Если персонажа нет, ждем и не выполняем код дальше
        if not hrp then 
            task.wait(1)
            continue 
        end

        local instanceID = InstancingCmds.GetInstanceID()

        if instanceID ~= "TimeTrial" then
            print("Входим в Time Trial...")
            pcall(function() InstancingCmds.Enter("TimeTrial") end)
            task.wait(7) -- Даем время на полную прогрузку мира
        else
            if isRoundFinished() then
                print("Раунд окончен, выходим...")
                if currentTween then currentTween:Cancel() end
                pcall(function() InstancingCmds.Leave() end)
                task.wait(5) -- Пауза перед следующим циклом
                continue
            end

            local target = getClosestBreakable()
            if target and target.Parent then
                local targetPivot = target:GetPivot()
                -- Смещение вверх, чтобы не застревать в текстурах
                local targetPos = (targetPivot * CFrame.new(0, 5, 0)).Position
                
                if (hrp.Position - targetPos).Magnitude > 7 then
                    tweenTo(CFrame.new(targetPos))
                end
            end
        end
    end
end)
