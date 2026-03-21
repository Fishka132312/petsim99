_G.AutoTap = true
local RADIUS = 150
local MAX_TARGETS = 100

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")
local breakablesPath = workspace:WaitForChild("__THINGS"):WaitForChild("Breakables")

task.spawn(function()
    while _G.AutoTap do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root then
            local rootPos = root.Position
            local targets = {}

            local allBreakables = breakablesPath:GetChildren()
            for i = 1, #allBreakables do
                local obj = allBreakables[i]
                local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                
                if part then
                    local dist = (rootPos - part.Position).Magnitude
                    if dist <= RADIUS then
                        table.insert(targets, {instance = obj, distance = dist})
                    end
                end
            end

            table.sort(targets, function(a, b)
                return a.distance < b.distance
            end)

            for i = 1, math.min(#targets, MAX_TARGETS) do
                if not _G.AutoTap then break end
                network:FireServer(targets[i].instance.Name)
            end
        end
        
        task.wait(0.05) 
    end
end)