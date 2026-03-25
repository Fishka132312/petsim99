local Library = game.ReplicatedStorage:WaitForChild("Library")
local Directory = require(Library.Directory)
local EggCmds = require(Library.Client.EggCmds)
local Save = require(Library.Client.Save)
local Network = require(Library.Client.Network)
local MasteryConfigs = require(Library.Client.MasteryCmds)
local MachineCmds = require(Library.Client:WaitForChild("MachineCmds"))
local Signal = require(Library:WaitForChild("Signal"))

_G.CraftPetsGold = false

local function GetBestEgg()
    local bestId = nil
    local maxNum = -1
    for id, info in pairs(Directory.Eggs) do
        if info and info.eggNumber and type(info.eggNumber) == "number" then
            if not EggCmds.IsEggLocked(id) then
                if info.eggNumber > maxNum then
                    maxNum = info.eggNumber
                    bestId = id
                end
            end
        end
    end
    return bestId
end

local function getRequiredAmount()
    local reduction = 0
    if MasteryConfigs.HasPerk("Pets", "GoldReduction") then
        reduction = MasteryConfigs.GetPerkPower("Pets", "GoldReduction")
    end
    return math.max(1, 10 - reduction)
end

local function CraftCycle()
    local eggId = GetBestEgg()
    if not eggId then return end

    local eggData = Directory.Eggs[eggId]
    local inventory = Save.Get().Inventory.Pet
    local needed = getRequiredAmount()
    
    local bestPets = {}
    if eggData and eggData.pets then
        for _, petInfo in pairs(eggData.pets) do
            bestPets[petInfo[1]] = true
        end
    end

    for uid, petData in pairs(inventory) do
        if not _G.CraftPetsGold then break end

        if bestPets[petData.id] and not petData.g and not petData.nk and petData._am and petData._am >= needed then
            
            MachineCmds.AllowOpen("GoldMachine")
            Signal.Fire("SuperMachine: Open", "GoldMachine")
            
            local amountToCraft = math.floor(petData._am / needed)
            if amountToCraft > 0 then
                print("[Auto-Gold] Крафчу: " .. tostring(petData.id) .. " x" .. amountToCraft)
                Network.Invoke("GoldMachine_Activate", uid, amountToCraft)
                task.wait(0.5)
            end
        end
    end
end

task.spawn(function()
    print("--- АВТО-КРАФТ ЗАПУЩЕН ---")
    while true do
        if _G.CraftPetsGold then
            local status, err = pcall(function()
                CraftCycle()
            end)
            if not status then warn("Ошибка авто-крафта: " .. tostring(err)) end
        end
        
        task.wait(5) 
        
        if not _G.CraftPetsGold then
            print("--- АВТО-КРАФТ ОСТАНОВЛЕН (_G.CraftPetsGold = false) ---")
            repeat task.wait(1) until _G.CraftPetsGold
            print("--- АВТО-КРАФТ СНОВА ВКЛЮЧЕН ---")
        end
    end
end)
