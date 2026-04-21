_G.AutoTap = false

local RADIUS = 15-
local MAX_TARGETS = 10

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")

local function getBreakables()
    local things = workspace:FindFirstChild("__THINGS")
    if not things then return nil end
    return things:FindFirstChild("Breakables")
end

runService.Heartbeat:Connect(function()
    if not _G.AutoTap then return end
    
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local breakablesPath = getBreakables()
    if not breakablesPath then return end
    
    local rootPos = root.Position
    local count = 0
    local objects = breakablesPath:GetChildren()

    for i = 1, #objects do
        if count >= MAX_TARGETS then break end
        
        local obj = objects[i]
        local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
        
        if part then
            local distanceSquared = (rootPos - part.Position).Magnitude
            if distanceSquared <= RADIUS then
                network:FireServer(obj.Name)
                count = count + 1
            end
        end
    end
end)
