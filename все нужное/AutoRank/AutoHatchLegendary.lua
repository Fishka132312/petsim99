task.wait(1.5)
_G.AutoHatchLegendary = false
_G.ReturnToPosLegendary = true 

local Library = game.ReplicatedStorage:WaitForChild("Library", 15)
local function GetLib(path)
    local s, res = pcall(function() return require(path) end)
    return s and res or nil
end

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Network = require(Library.Client.Network)
local EggCmds = require(Library.Client.EggCmds)
local Directory = require(Library.Directory)
local Variables = require(Library.Variables)
local WorldsUtil = require(Library.Util.WorldsUtil)
local PetsDir = require(Library.Directory.Pets)

if not Network or not EggCmds then return end

local function IsHatching()
    if Variables.OpeningEgg and Variables.OpeningEgg > 0 then return true end
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and (playerGui:FindFirstChild("EggOpen") or playerGui:FindFirstChild("EggSkip")) then return true end
    return false
end

local function GetTargetEgg()
    local myWorld = WorldsUtil.GetWorldNumber()
    local eggList = {}
    local HighRarityNames = {["Legendary"]=true,["Mythical"]=true,["Exotic"]=true,["Celestial"]=true,["Superior"]=true,["Divine"]=true}

    for eggId, eggInfo in pairs(Directory.Eggs) do
        local eggWorld = eggInfo.worldNumber or eggInfo.WorldNumber or 1
        if eggWorld == myWorld and not EggCmds.IsEggLocked(eggId) then
            local petsInEgg = eggInfo.pets or (eggInfo.loot and eggInfo.loot.pets)
            if petsInEgg then
                table.insert(eggList, {id = eggId, eggNumber = eggInfo.eggNumber or 0})
            end
        end
    end

    table.sort(eggList, function(a, b) return a.eggNumber < b.eggNumber end)
    return eggList[#eggList]
end

local function FindEggModel(eggNum)
    local eggsFolder = game.Workspace:FindFirstChild("__THINGS") and game.Workspace.__THINGS:FindFirstChild("Eggs")
    if not eggsFolder then return nil end

    for _, zoneFolder in pairs(eggsFolder:GetChildren()) do
        for _, model in pairs(zoneFolder:GetChildren()) do
            if model:IsA("Model") and model:GetPivot().Position.Y > -500 then
                local foundNum = tonumber(model.Name:match("%d+"))
                if foundNum == eggNum then
                    return model
                end
            end
        end
    end
    return nil
end

local function MainLoop()
    if not _G.AutoHatchLegendary or IsHatching() then return end

    local targetEgg = GetTargetEgg()
    if not targetEgg then 
        return 
    end

    local model = FindEggModel(targetEgg.eggNumber)
    if not model then
        return
    end

    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local oldPos = root.CFrame
    root.CFrame = model:GetPivot() * CFrame.new(0, 3, 5)
    task.wait(0.4)

    local success, err = pcall(function()
    return Network.Invoke("Eggs_RequestPurchase", targetEgg.id, EggCmds.GetMaxHatch())
end)

    if _G.ReturnToPosLegendary then
        task.wait(0.1)
        root.CFrame = oldPos
    end
end

task.spawn(function()
    while true do
        local ok, err = pcall(MainLoop)
        if not ok then warn("Ошибка цикла: " .. tostring(err)) end
        task.wait(1)
    end
end)
