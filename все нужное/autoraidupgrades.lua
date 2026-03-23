_G.AutoUpgradeConfig = {
    Enabled = true,
    Interval = 1,
    
    LuckyRaidPets = false,
    LuckyRaidDamage = false,
    LuckyRaidAttackSpeed = false,
    LuckyRaidPetSpeed = false,
    LuckyRaidEggCost = false,
    LuckyRaidMoreCurrency = true,
    LuckyRaidXP = false,
    LuckyRaidBetterLoot = false,
    LuckyRaidHugeChest = false,
    LuckyRaidTitanicChest = false,
    LuckyRaidKeyDrops = true,
    LuckyRaidBossHugeChances = false,
    LuckyRaidBossTitanicChances = false
}

local Config = _G.AutoUpgradeConfig

local v_u_2 = require(game.ReplicatedStorage.Library.Directory.EventUpgrades)
local v_u_3 = require(game.ReplicatedStorage.Library.Client.EventUpgradeCmds)
local v_u_12 = require(game.ReplicatedStorage.Library.Client.FFlags)

function getCost(p25, p26)
    local v27 = v_u_12.Get(v_u_12.Keys.MapleLeafCost) or 1
    local v28 = p25.TierCosts[p26]:Clone()
    local v29 = v28:GetAmount() * v27
    return v28:SetAmount((math.ceil(v29)))
end

function canUpgrade(upgradeData)
    local currentTier = v_u_3.GetTier(upgradeData)
    if not currentTier or currentTier >= #upgradeData.TierPowers then return false end
    
    local costItem = getCost(upgradeData, currentTier + 1)
    return costItem:CountAny() >= costItem:GetAmount()
end

task.spawn(function()
    
    while true do
        if Config.Enabled then
            for name, shouldUpgrade in pairs(Config) do
                if name ~= "Enabled" and name ~= "Interval" and shouldUpgrade == true and v_u_2[name] then
                    local upgradeData = v_u_2[name]
                    if canUpgrade(upgradeData) then
                        print("Upgrading: " .. name)
                        v_u_3.Purchase(upgradeData) 
                    end
                end
            end
        end
        task.wait(Config.Interval)
    end
end)
