_G.AutoSpeedPets = false

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Network = RS:WaitForChild("Network"):WaitForChild("Breakables_JoinPetBulk")
local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")
local breakables = things.Breakables
local petsFolder = things.Pets

local t_insert = table.insert
local t_clear = table.clear
local task_wait = task.wait

local petIds = {}

local function updatePetList()
    t_clear(petIds)
    for _, pet in ipairs(petsFolder:GetChildren()) do
        local name = pet.Name
        if name:match("^%d+$") then
            t_insert(petIds, name)
        end
    end
end

updatePetList()
petsFolder.ChildAdded:Connect(updatePetList)
petsFolder.ChildRemoved:Connect(updatePetList)

task.spawn(function()
    while true do
        if _G.AutoSpeedPets then 
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and #petIds > 0 then
                local myPos = root.Position
                local targets = {}
                local radiusSq = 60^2
                
                local allBreakables = breakables:GetChildren()
                for i = 1, #allBreakables do
                    local obj = allBreakables[i]
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    
                    if part then
                        local pPos = part.Position
                        local dx = pPos.X - myPos.X
                        local dy = pPos.Y - myPos.Y
                        local dz = pPos.Z - myPos.Z
                        if (dx*dx + dy*dy + dz*dz) <= radiusSq then
                            t_insert(targets, obj.Name)
                        end
                    end
                    if #targets >= 40 then break end 
                end

                if #targets > 0 then
                    local attackData = {}
                    local targetCount = #targets
                    
                    for i = 1, #petIds do
                        attackData[petIds[i]] = targets[((i - 1) % targetCount) + 1]
                    end

                    Network:FireServer(attackData)
                end
            end
        end
        
        task_wait() 
    end
end)
