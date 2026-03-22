_G.AutoTap = true

local RADIUS = 150
local MAX_TARGETS = 100

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")

local function getBreakables()
    local things = workspace:FindFirstChild("__THINGS")
    if not things then return nil end
    return things:FindFirstChild("Breakables")
end

task.spawn(function()
        print(">>> Поток AutoTap запущен! Статус:", _G.AutoTap)
    while true do
    if not _G.AutoTap then break end
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root then
            local breakablesPath = getBreakables()
            
            if breakablesPath then
                local rootPos = root.Position
                local targets = {}

                local allBreakables = breakablesPath:GetChildren()

                for i = 1, #allBreakables do
                    local obj = allBreakables[i]
                    local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                    
                    if part then
                        local dist = (rootPos - part.Position).Magnitude
                        if dist <= RADIUS then
                            targets[#targets + 1] = {instance = obj, distance = dist}
                        end
                    end
                end

                table.sort(targets, function(a, b)
                    return a.distance < b.distance
                end)

                local limit = math.min(#targets, MAX_TARGETS)

                for i = 1, limit do
                    if not _G.AutoTap then break end
                    network:FireServer(targets[i].instance.Name)
                end
            end
        end
        
        task.wait(0.05)
    end
end)
