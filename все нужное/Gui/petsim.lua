local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "pet sim99", HidePremium = false, SaveConfig = true, ConfigFolder = "petsim99"})

local scripts = {
    'things/autotap.lua',
    'things/megaspeedpets.lua',
    'things/automagnet.lua',
    'things/TeleportToBestZone.lua',
    'things/AutoBuyNewZone.lua',
    'things/AutoCollectRanks.lua',
    'things/AutoCollectFreeGifts.lua',
    'things/AutoHatchBestEgg.lua',
    'things/AutoOpenNearEgg.lua',
    'AutoRank/autotap.lua',
    'AutoRank/megaspeedpets.lua',
    'AutoRank/automagnet.lua',
    'AutoRank/TeleportToBestZone.lua',
    'AutoRank/dorankstest.lua',
    'AutoRank/AutoCoinJar.lua',
    'AutoRank/AutoComets.lua',
    'AutoRank/AutoHatchBestEgg.lua',
    'AutoRank/AutoPotions.lua',
    'AutoRank/AutoLegendaryHatch.lua',
    'AutoRank/UnlockEggs.lua',
    'AutoRank/AutoFlag.lua',
    'AutoRank/AutoCraftPets.lua',
    'autoraidupgrades.lua',
    'AutoHatchLegendary.lua',
	'Raid/AutoRaidEbatLegit.lua',
	'Raid/Raidfarm.lua',
	
}

local baseUrl = 'https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/'

_G.AutoUpgradeConfig = _G.AutoUpgradeConfig or {} 

_G.AutoUpgradeConfig.Enabled = true
_G.AutoUpgradeConfig.Interval = 1
_G.AutoUpgradeConfig.LuckyRaidPets = false
_G.AutoUpgradeConfig.LuckyRaidDamage = false
_G.AutoUpgradeConfig.LuckyRaidAttackSpeed = false
_G.AutoUpgradeConfig.LuckyRaidPetSpeed = false
_G.AutoUpgradeConfig.LuckyRaidEggCost = false
_G.AutoUpgradeConfig.LuckyRaidMoreCurrency = false
_G.AutoUpgradeConfig.LuckyRaidXP = false
_G.AutoUpgradeConfig.LuckyRaidBetterLoot = false
_G.AutoUpgradeConfig.LuckyRaidHugeChest = false
_G.AutoUpgradeConfig.LuckyRaidTitanicChest = false
_G.AutoUpgradeConfig.LuckyRaidKeyDrops = false
_G.AutoUpgradeConfig.LuckyRaidBossHugeChances = false
_G.AutoUpgradeConfig.LuckyRaidBossTitanicChances = false

local Tab = Window:MakeTab({
	Name = "Event farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Raid Farm"
})

local AutoFarmRaidLoaded = false

Tab:AddToggle({
    Name = "Lucky Raid Auto-Farm Legit",
    Default = false,
    Save = true,
    Flag = "LuckyRaidAutoFarmLegit",
    Callback = function(Value)
        _G.AutoFarmRaidLegit = Value
    end
})

Tab:AddToggle({
    Name = "Lucky Raid Auto-Farm",
    Default = false,
    Save = true,
    Flag = "LuckyRaidAutoFarm",
    Callback = function(Value)
        _G.AutoFarmRaid = Value
    end
})



local Section = Tab:AddSection({
	Name = "Auto Upgrade"
})

Tab:AddToggle({
    Name = "Raid Pets Slots",
    Default = false,
	Save = true,
    Flag = "RaidPetsSlotsUpgrage",
    Callback = function(Value)
        _G.AutoUpgradeConfig.LuckyRaidPets = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Pets",
    Default = false,
	Save = true,
    Flag = "LuckyRaidPetsUpgrage",
    Callback = function(Value)
    _G.AutoUpgradeConfig.LuckyRaidDamage = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Attack Speed",
    Default = false,
	Save = true,
    Flag = "LuckyRaidAttackSpeedUpgrage",
    Callback = function(Value)
     _G.AutoUpgradeConfig.LuckyRaidAttackSpeed = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Pet Speed",
    Default = false,
	Save = true,
    Flag = "LuckyRaidPetSpeedUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidPetSpeed = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky RaidEgg Cost",
    Default = false,
	Save = true,
    Flag = "LuckyRaidEggCostUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidEggCost = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid More Currency",
    Default = false,
	Save = true,
    Flag = "LuckyRaidMoreCurrencyUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidMoreCurrency = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid XP",
    Default = false,
	Save = true,
    Flag = "LuckyRaidXPUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidXP = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Better Loots",
    Default = false,
	Save = true,
    Flag = "LuckyRaidBetterLootsUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidBetterLoot = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Huge Chest",
    Default = false,
	Save = true,
    Flag = "LuckyRaidHugeChestUpgrage",
    Callback = function(Value)
        _G.AutoUpgradeConfig.LuckyRaidHugeChest = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Titanic Chest",
    Default = false,
	Save = true,
    Flag = "LuckyRaidTitanicChestUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidTitanicChest = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Key Drops",
    Default = false,
	Save = true,
    Flag = "LuckyRaidKeyDropsUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidKeyDrops = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Boss Huge Chances",
    Default = false,
	Save = true,
    Flag = "LuckyRaidBossHugeChancesUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidBossHugeChances = Value
    end    
})

Tab:AddToggle({
    Name = "Lucky Raid Boss Titanic Chances",
    Default = false,
	Save = true,
    Flag = "LuckyRaidBossTitanicChancesUpgrage",
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidBossTitanicChances = Value
    end    
})
 
 

--------------------------------Autofarm-----------------------------

local Tab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Auto Farm"
})

Tab:AddToggle({
    Name = "Auto Tap",
    Default = false,
	Save = true,
    Flag = "AutoTap",
    Callback = function(Value)
       _G.AutoTap = Value
    end
})


Tab:AddToggle({
	Name = "SpeedPets",
	Default = false,
	Save = true,
    Flag = "SpeedPets",
	Callback = function(Value)
		_G.AutoSpeedPets = Value
	end    
})


Tab:AddToggle({
    Name = "Auto Magnet",
    Default = false,
	Save = true,
    Flag = "AutoMagnet",
    Callback = function(Value)
        _G.AutoMagnet = Value
    end    
})

Tab:AddToggle({
    Name = "Auto Buy New Zones",
    Default = false,
	Save = true,
    Flag = "AutoBuyNewZones",
    Callback = function(Value)
        _G.AutoBuyNewZone = Value
        
        if Value then
            task.spawn(function()
                while _G.AutoBuyNewZone do
                    if not _G.AutoBuyNewZone then break end

                    if not _G.IsDoingJarQuest then
                        local success = game:GetService("ReplicatedStorage").Network.Zone_RequestPurchase:InvokeServer() 
                        
                        if success then
                            print("--- [AUTO-BUY] Попытка покупки зоны успешна!")
                        end
                    else
                        print("--- [PAUSE] Покупка зон приостановлена: активен квест на Coin Jar")
                    end
                    
                    task.wait(5)
                end
            end)
        end
    end    
})

Tab:AddToggle({
    Name = "Auto-Teleport to Best Zone",
    Default = false,
	Save = true,
    Flag = "AutoTeleporttoBestZone",
    Callback = function(Value)
       _G.AutoTeleportbestlocation = Value
    end    
})


for _, scriptPath in ipairs(scripts) do
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(baseUrl .. scriptPath))()
        end)
        if not success then
            warn("Ошибка загрузки скрипта " .. scriptPath .. ": " .. err)
        end
    end)
end


--------------------------------Main-----------------------------

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Auto Rank"
})

local Toggle = Tab:AddToggle({
    Name = "Auto Rank (BETA)",
    Default = false,
    Callback = function(Value)
        _G.Autorank = Value
        print("Auto Rank статус:", Value)
    end
})

local Section = Tab:AddSection({
	Name = "Auto Collect"
})

Tab:AddToggle({
    Name = "Auto Claim Mail",
    Default = false,
	Save = true,
    Flag = "AutoClaimMail",
    Callback = function(Value)
       _G.ClaimMail = Value
    end    
})

Tab:AddToggle({
    Name = "Auto Claim Ranks",
    Default = false,
	Save = true,
    Flag = "AutoClaimRanks",
    Callback = function(Value)
        _G.AutoCollectRANK = Value
    end    
})

Tab:AddToggle({
    Name = "Auto Collect Free Gifts",
    Default = false,
	Save = true,
    Flag = "AutoCollectFreeGifts",
    Callback = function(Value)
       _G.AutoCollectGifts = Value
    end    
})

Tab:AddButton({
	Name = "Collect all Relics",
	Callback = function()
      	loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoCollectRelic.lua'))()
  	end    
})


--------------------------------Eggs-----------------------------


local Tab = Window:MakeTab({
	Name = "Eggs",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Eggs"
})

Tab:AddToggle({
    Name = "Auto Hatch Best Egg",
    Default = false,
	Save = true,
    Flag = "AutoHatchBestEgg",
    Callback = function(Value)
        _G.AutoHatchBestEgg = Value
    end    
})


Tab:AddToggle({
    Name = "Auto Hatch Near Egg",
    Default = false,
	Save = true,
    Flag = "AutoHatchNearEgg",
    Callback = function(Value)
        _G.AutoHatchNearEgg = Value
    end    
})



Tab:AddButton({
    Name = "Remove Egg Animation",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):FindFirstChild("Eggs_PlayOpenAnimation")
        if remote then
            remote:Destroy()
        end
    end    
})

--------------------------------FUN-----------------------------

local Tab = Window:MakeTab({
	Name = "FUN",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "FUN"
})

local SelectedHoverboard = "Original"
local lp = game:GetService("Players").LocalPlayer
local HoverboardCmds = require(game:GetService("ReplicatedStorage").Library.Client.HoverboardCmds)

task.spawn(function()
    while task.wait(0.1) do
        if SelectedHoverboard ~= "Original" then
            if lp:GetAttribute("Hoverboard") ~= SelectedHoverboard then
                lp:SetAttribute("Hoverboard", SelectedHoverboard)
            end
        end
    end
end)

Tab:AddDropdown({
    Name = "Select & Equip Hoverboard",
    Default = "Original",
    Options = (function()
        local list = {}
        local success, Directory = pcall(function() 
            return require(game:GetService("ReplicatedStorage").Library.Directory) 
        end)
        if success and Directory.Hoverboards then
            for name, _ in pairs(Directory.Hoverboards) do
                table.insert(list, name)
            end
        end
        table.sort(list)
        return list
    end)(), 
    Callback = function(Value)
        SelectedHoverboard = Value
        
        lp:SetAttribute("Hoverboard", Value)
        
        if lp:GetAttribute("UsingHoverboard") then
            lp:SetAttribute("Hoverboard", "")
            task.wait()
            lp:SetAttribute("Hoverboard", Value)
        else
            pcall(function()
                HoverboardCmds.RequestEquip() 
            end)
        end
    end    
})

--------------------------------Webhook-----------------------------

local Tab = Window:MakeTab({
	Name = "Webhook",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Webhook"
})

Tab:AddTextbox({
    Name = "Huge/Titanic Webhook",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        if not _G.WebhooksPetsConfig then
            _G.WebhooksPetsConfig = {}
        end

        _G.WebhooksPetsConfig.HugeWebhook = Value
        _G.WebhooksPetsConfig.TitanicWebhook = Value 
                
        if not _G.KomaruScriptRunning then
            _G.KomaruScriptRunning = true
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/WebhooksPets/webhookPets.lua'))()
        end
    end    
})
 
--------------------------------MISC-----------------------------

local Tab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Tools"
})

Tab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/ignore-it/refs/heads/main/infiniteyield'))()
  	end    
})


Tab:AddButton({
	Name = "Zap Hub",
	Callback = function()
    loadstring(game:HttpGet('https://zaphub.xyz/Exec'))()
  	end    
})

local Section = Tab:AddSection({
	Name = "Fps Boost"
})

loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/FpsCap.lua'))()

Tab:AddButton({
	Name = "Antilag",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/AntiLag.lua'))()
    end    
})

Tab:AddButton({
	Name = "Delete guis(Only if autofarm)",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/DeleteGuis.lua'))()
    end    
})

Tab:AddButton({
	Name = "FpsBoost2",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/FpsBoost2.lua'))()
    end    
})

Tab:AddButton({
	Name = "PetsOptimizer",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/PetsOptimizer.lua'))()
    end    
})

Tab:AddToggle({
    Name = "Disable 3D Rendering",
    Default = false,
	Save = true,
    Flag = "Disable3DRendering",
    Callback = function(Value)
        if Value then
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end    
})

Tab:AddTextbox({
	Name = "Set FPS Cap",
	Default = "60",
	TextDisappear = false,
	Callback = function(Value)
		local num = tonumber(Value)
		
		if num and num > 0 then
			_G.FPS_Value = num
			_G.FPS_Enabled = true
		else
			_G.FPS_Enabled = false
		end
	end	  
})

Tab:AddButton({
	Name = "Total Gvno-Graphix💀",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/PetsOptimizer.lua'))()
    end    
})

Tab:AddButton({
	Name = "Destroy Gui",
	Callback = function()
    OrionLib:Destroy()
    end    
})

OrionLib:Init()
