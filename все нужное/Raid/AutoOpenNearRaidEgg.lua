local EggCmds = require(game.ReplicatedStorage.Library.Client.EggCmds)

_G.AutoHatchRaidEgg = false
local SEARCH_RADIUS = 200

local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local HatchRemote = Network:WaitForChild("CustomEggs_Hatch")
local Players = game:GetService("Players")

local function getMaxHatch()
    local max = 1
    local success, result = pcall(function() return EggCmds.GetMaxHatch() end)
    if success and result then
        max = result
    end
    return max
end

local function getNearestRaidEgg()
    local player = Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPos = char.HumanoidRootPart.Position
    local things = game.Workspace:WaitForChild("__THINGS")
    local eggsFolder = things:FindFirstChild("CustomEggs") or things:FindFirstChild("Eggs")
    
    if not eggsFolder then return nil end

    local nearestEggId = nil
    local minDist = SEARCH_RADIUS

    for _, v in pairs(eggsFolder:GetChildren()) do
        local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
        if part then
            local dist = (rootPos - part.Position).Magnitude
            if dist < minDist then
                local eggId = v:GetAttribute("EggID") or v.Name 
                minDist = dist
                nearestEggId = eggId
            end
        end
    end
    return nearestEggId
end

task.spawn(function()
    
    while true do
        if _G.AutoHatchRaidEgg then
            local eggId = getNearestRaidEgg()
            
            if eggId then
                local amount = getMaxHatch()
                
                local success, err = pcall(function()
                    return HatchRemote:InvokeServer(eggId, amount)
                end)
                
                if not success then
                end
            end
            task.wait(0.5)
        else
            task.wait(1)
        end
    end
end)
