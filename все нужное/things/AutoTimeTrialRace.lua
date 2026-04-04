getgenv().TimeTrialSettings = {
    TweenSpeed = 110,
    DetectionRadius = 120
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local Library = ReplicatedStorage:WaitForChild("Library")
local InstancingCmds = require(Library.Client.InstancingCmds)
local things = workspace:WaitForChild("__THINGS")
local breakables = things:WaitForChild("Breakables")

_G.TimeTrialFarm = false

local function isRoundFinished()
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        local summary = pg:FindFirstChild("TimeTrialSummary")
        if summary and summary.Enabled then
            local mainFrame = summary:FindFirstChild("Frame") or summary:FindFirstChildOfClass("Frame")
            if mainFrame and mainFrame.Visible then
                return true
            end
        end
    end
    return false
end

local function getPathPoints(targetPos)
    local path = PathfindingService:CreatePath({AgentRadius = 3, AgentHeight = 5})
    local success, _ = pcall(function() path:ComputeAsync(hrp.Position, targetPos) end)
    if success and path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    end
    return nil
end

local function tweenTo(targetCFrame)
    if not _G.TimeTrialFarm or isRoundFinished() then return end

    local targetPos = targetCFrame.Position
    local dist = (hrp.Position - targetPos).Magnitude
    local duration = dist / getgenv().TimeTrialSettings.TweenSpeed
    
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()

    local completed = false
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not _G.TimeTrialFarm or isRoundFinished() then
            tween:Cancel()
            completed = true
            connection:Disconnect()
        end
    end)

    tween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)

    repeat task.wait() until completed or not _G.TimeTrialFarm
end

local function getClosestBreakable()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(breakables:GetChildren()) do
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

task.spawn(function()
    
    while task.wait(0.3) do
        if not _G.TimeTrialFarm then 
            continue 
        end

        local instanceID = InstancingCmds.GetInstanceID()

        if instanceID ~= "TimeTrial" then
            pcall(function() InstancingCmds.Enter("TimeTrial") end)
            task.wait(5)
        else
            if isRoundFinished() then
                pcall(function() InstancingCmds.Leave() end)
                task.wait(3)
                continue
            end

            local target = getClosestBreakable()
            if target then
                local targetPivot = target:GetPivot()
                local targetPos = (targetPivot * CFrame.new(0, 6, 0)).Position
                
                if (hrp.Position - targetPos).Magnitude > 7 then
                    tweenTo(CFrame.new(targetPos))
                end
            end
        end
    end
end)
