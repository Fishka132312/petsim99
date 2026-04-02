_G.AutoTap = false

local RADIUS = 150
local MAX_TARGETS = 1
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")

local function getBreakables()
    local things = workspace:FindFirstChild("__THINGS")
    return things and things:FindFirstChild("Breakables")
end

task.spawn(function()
    
    game:GetService("RunService").Stepped:Connect(function()
        if not _G.AutoTap then return end
        
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root then
            local breakablesPath = getBreakables()
            if breakablesPath then
                local rootPos = root.Position
                local allBreakables = breakablesPath:GetChildren()
                local count = 0

                for i = 1, #allBreakables do
                    local obj = allBreakables[i]
                    local part = obj.PrimaryPart or obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                    
                    if part then
                        if (rootPos - part.Position).Magnitude <= RADIUS then
                            network:FireServer(obj.Name)
                            
                            count = count + 1
                            if count >= MAX_TARGETS then break end
                        end
                    end
                end
            end
        end
    end)
end)
