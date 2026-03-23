-- Raid Upgrade
_G.AutoUpgradeConfig = _G.AutoUpgradeConfig or {} 

_G.AutoUpgradeConfig.Enabled = true
_G.AutoUpgradeConfig.Interval = 1
_G.AutoUpgradeConfig.LuckyRaidPets = false
_G.AutoUpgradeConfig.LuckyRaidDamage = false
_G.AutoUpgradeConfig.LuckyRaidAttackSpeed = false
_G.AutoUpgradeConfig.LuckyRaidPetSpeed = false
_G.AutoUpgradeConfig.LuckyRaidEggCost = false
_G.AutoUpgradeConfig.LuckyRaidMoreCurrency = false
_G.AutoUpgradeConfig.LuckyRaidXP = true
_G.AutoUpgradeConfig.LuckyRaidBetterLoot = false
_G.AutoUpgradeConfig.LuckyRaidHugeChest = false
_G.AutoUpgradeConfig.LuckyRaidTitanicChest = false
_G.AutoUpgradeConfig.LuckyRaidKeyDrops = false
_G.AutoUpgradeConfig.LuckyRaidBossHugeChances = false
_G.AutoUpgradeConfig.LuckyRaidBossTitanicChances = false

-- Webhook Settings
_G.WebhooksPetsConfig = {
    -- Huge pets webhook
    HugeWebhook = "",
    
    -- Titanic pets webhook
    TitanicWebhook = "",

    -- Fake webhook (leave empty if no)
    TestName = "", 
    TestId = "", 
}

-- Turn off 3D graphic?
_G.VisualConfig = {
    -- false  = Default (Game is visible)
    -- true = FPS Boost (White screen, 3D off)
    Disable3D = true,
}

-- Anti Admin
_G.AntiAdminEnabled = true

loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/shortlink/AutoFarmRaid.lua'))()
