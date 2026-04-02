local Library = game.ReplicatedStorage:WaitForChild("Library")
local Directory = require(Library.Directory)
local EggCmds = require(Library.Client.EggCmds)
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local MasteryConfigs = require(Library.Client.MasteryCmds)
local MachineCmds = require(Library.Client:WaitForChild("MachineCmds"))
local Signal = require(Library:WaitForChild("Signal"))

_G.CraftPetsGold = false
_G.CraftPetsRainbow = false

local function GetBestEgg()
    local bestId = nil
    local maxNum = -1
    for id, info in pairs(Directory.Eggs) do
        if info and info.eggNumber and not EggCmds.IsEggLocked(id) then
            if info.eggNumber > maxNum then
                maxNum = info.eggNumber
                bestId = id
            end
        end
    end
    return bestId
end

local function getRequired(mode)
    local perk = (mode == "Rainbow") and "RainbowReduction" or "GoldReduction"
    local base = 10
    if MasteryConfigs.HasPerk("Pets", perk) then
        base = base - MasteryConfigs.GetPerkPower("Pets", perk)
    end
    return math.max(1, base)
end

local function CraftCycle()
    local eggId = GetBestEgg()
    if not eggId then return end

    local eggData = Directory.Eggs[eggId]
    local inventory = Save.Get().Inventory.Pet
    local goldNeeded = getRequired("Gold")
    local rainbowNeeded = getRequired("Rainbow")
    
    local bestPets = {}
    for _, petInfo in pairs(eggData.pets) do
        bestPets[petInfo[1]] = true
    end

    for uid, petData in pairs(inventory) do
        if not _G.CraftPetsGold then break end
        if not bestPets[petData.id] then continue end

        local isNormal = not petData.pt or petData.pt == 0
        if isNormal and not petData.r and petData._am and petData._am >= goldNeeded then
            local amountToCraft = math.floor(petData._am / goldNeeded)
            if amountToCraft > 0 then
                print("[Auto-Gold] Crafting: " .. petData.id .. " x" .. amountToCraft)
                MachineCmds.AllowOpen("GoldMachine")
                Network.Invoke("GoldMachine_Activate", uid, amountToCraft)
                task.wait(0.3)
            end
        end

        local isGold = petData.pt == 1 
        if _G.CraftPetsRainbow and isGold and not petData.r and petData._am and petData._am >= rainbowNeeded then
            local amountToCraft = math.floor(petData._am / rainbowNeeded)
            if amountToCraft > 0 then
                print("[Auto-Rainbow] Crafting: " .. petData.id .. " x" .. amountToCraft)
                MachineCmds.AllowOpen("SuperMachine")
                MachineCmds.AllowOpen("RainbowMachine")
                
                local success = Network.Invoke("RainbowMachine_Activate", uid, amountToCraft)
                if success then
                    task.wait(0.3)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if _G.CraftPetsGold then
            pcall(CraftCycle)
        end
        task.wait(5)
    end
end)
