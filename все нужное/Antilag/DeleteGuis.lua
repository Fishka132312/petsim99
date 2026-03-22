local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local mainGuiList = {
    "Achievements", "Admin Inventory", "ArrowHolder", "BenchLeft", "BlockPartyMain",
    "BlockPartyRebirth", "BoostsPage", "BoothHistory", "BoothOtherPlayer", "BoothPrompt",
    "Box", "Changelog", "DiscoverMessage", "EdgeGlow", "EggDeal", "EventFishTop",
    "ExclusiveMerchShop", "ExclusiveRaffle", "ExclusiveShop", "FantasypackDeal",
    "FarmInventory", "FarmMessage", "FarmingGoalsSide", "FreePet", "FrozenEffect",
    "GenerateRewards", "GlobalEvents", "Goal", "GrinchRaidSummary", "Guilds",
    "HalloweenInventory", "HalloweenMessage", "HalloweenQuests", "HypeTickets",
    "InviteFriends", "IslandChanged", "LockpickGame", "Leagues", "NewGift",
    "OrnamentMsgCommon", "OrnamentMsgRare", "PaidPowerup", "PlayerProfile",
    "ShinyBonus", "Starter", "StarterpackDeal", "TimeTrialSummary", "TowerAutoFuse",
    "TowerDeal", "TowerDefenseHotbarInfo", "TowerDefenseMain", "TowerInventory",
    "TowerMapEnd", "TowerPetFuse", "TowerPetInfo", "TowerSettings", "Tutorial", "YeetMain"
}

local machinesList = {
    "Auction", "BasketballCalendar", "BasketballUpgradeMachine", "BoostExchangeMachine",
    "CardCombinationMachine", "ChristmasPetCraftingMachine", "ChristmasTreeMachine",
    "ConveyorHugeChanceMachine", "ConveyorUpgradeMachine", "CraftingMachine",
    "DailyQuestMachine", "DaycareMachine", "DoodleUpgradeMachine", "EventBoatMerchant",
    "EventFishingMerchant", "EventRodMerchant", "FantasyShardMachine", "FarmSlotsMachine",
    "FarmStorageSlotsMachine", "FarmUpgradeMachine", "FarmUpgradesSelectorMachine",
    "FarmingEggMerchant", "FarmingPetInfo", "FarmingPetMerchant", "FarmingSupplyMerchant",
    "FarmingTravelingMerchant", "ForgeMachineSelect", "HalloweenPetCraftingMachine",
    "HalloweenSellMerchant", "HalloweenUpgradeMachine", "MagicMachine", "MegaPresentAdd",
    "MegaPresentChoice", "MegaPresentOpen", "MegaPresentUpgradeMachine", "PetCraftingMachine",
    "PetIndexMachine", "PetUpgradeUI", "PetUpgradeUI_OLD", "RainbowTowerMachine",
    "SantaMachine", "SantasSleigh", "SecretSanta", "SlimeMachine", "SummerGiftMachine",
    "SummerGiftbagMachine", "TowerFuseMachine", "TowerIndexMachine", "TowerMaps", "WingsUpgradesMachine"
}

local miscList = {
    "BoxCustomize", "ChatFilters", "DebugStats", "EdgeGlow2", "FarmFlash", 
    "FarmStorage", "GlobalMessage", "Ornament", "PackAutoOpen", 
    "RaffleSelector", "RaffleSelectorExclusive", "Testing", "TycoonTeleport"
}

local function wipe(target)
    if target then target:Destroy() end
end

local function purge()
    for _, name in ipairs(mainGuiList) do wipe(playerGui:FindFirstChild(name)) end
    
    wipe(playerGui:FindFirstChild("_INSTANCES"))
    
    local machines = playerGui:FindFirstChild("_MACHINES")
    if machines then
        for _, name in ipairs(machinesList) do wipe(machines:FindFirstChild(name)) end
    end
    
    local misc = playerGui:FindFirstChild("_MISC")
    if misc then
        for _, name in ipairs(miscList) do wipe(misc:FindFirstChild(name)) end
    end
end

playerGui.DescendantAdded:Connect(function(desc)
    task.defer(function()
        for _, name in ipairs(mainGuiList) do if desc.Name == name and desc.Parent == playerGui then desc:Destroy() return end end
        
        if desc.Name == "_INSTANCES" and desc.Parent == playerGui then desc:Destroy() return end
        
        if desc.Parent and (desc.Parent.Name == "_MACHINES" or desc.Parent.Name == "_MISC") then
            local list = desc.Parent.Name == "_MACHINES" and machinesList or miscList
            for _, name in ipairs(list) do
                if desc.Name == name then desc:Destroy() break end
            end
        end
    end)
end)

purge()