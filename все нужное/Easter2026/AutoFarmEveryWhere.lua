_G.AutoSpeedPets2 = true

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Network = RS:WaitForChild("Network"):WaitForChild("Breakables_JoinPetBulk")

local player = Players.LocalPlayer
local things = workspace:WaitForChild("__THINGS")

local breakables = things.Breakables
local petsFolder = things.Pets

local ignoredZones = {}

local petIds = {}

-- обновление петов
local function updatePetList()
    table.clear(petIds)
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if pet.Name:match("^%d+$") then
            table.insert(petIds, pet.Name)
        end
    end
end

updatePetList()
petsFolder.ChildAdded:Connect(updatePetList)
petsFolder.ChildRemoved:Connect(updatePetList)

-- зоны
local ZonesFolder = things:WaitForChild("__INSTANCE_CONTAINER")
    :WaitForChild("Active")
    :WaitForChild("EasterHatchEvent")
    :WaitForChild("BREAK_ZONES")

local function getZoneOfPart(part)
    for _, zone in pairs(ZonesFolder:GetChildren()) do
        local size = zone.Size
        local pos = zone.Position
        local pPos = part.Position

        if pPos.X >= pos.X - size.X/2 and pPos.X <= pos.X + size.X/2 and
           pPos.Z >= pos.Z - size.Z/2 and pPos.Z <= pos.Z + size.Z/2 then
            return zone.Name
        end
    end
    return nil
end

task.spawn(function()
    while true do
        if _G.AutoSpeedPets2 and #petIds > 0 then

            local targets = {}

            for _, obj in ipairs(breakables:GetChildren()) do
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")

                if part then
                    local zoneName = getZoneOfPart(part)

                    -- проверка зоны
                    if zoneName and ignoredZones[zoneName] == nil then
                        ignoredZones[zoneName] = "checking"

                        task.delay(2, function()
                            if obj and obj.Parent == breakables then
                                ignoredZones[zoneName] = true
                                print("❌ зона в блэклист:", zoneName)
                            else
                                ignoredZones[zoneName] = false
                                print("✅ зона фармится:", zoneName)
                            end
                        end)
                    end

                    -- фильтр
                    if not zoneName 
                    or ignoredZones[zoneName] == false 
                    or ignoredZones[zoneName] == "checking" then
                        table.insert(targets, obj.Name)
                    end
                end
            end

            if #targets > 0 then
                local attackData = {}
                local count = #targets

                for i = 1, #petIds do
                    attackData[petIds[i]] = targets[((i - 1) % count) + 1]
                end

                Network:FireServer(attackData)
            end
        end

        task.wait(0.15)
    end
end)
