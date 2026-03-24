local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "pet sim99", HidePremium = false, SaveConfig = true, ConfigFolder = "pet sim99"})

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
    Name = "Lucky Raid Auto-Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmRaid = Value
        
        if _G.AutoFarmRaid then
            if not AutoFarmRaidLoaded then
                AutoFarmRaidLoaded = true
                loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Raidfarm.lua'))()
            end
        end
    end 
})


local Section = Tab:AddSection({
	Name = "Auto Upgrade"
})

loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/autoraidupgrades.lua'))()

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

Tab:AddToggle({
    Name = "Raid Pets Slots",
    Default = false,
    Callback = function(Value)
        _G.AutoUpgradeConfig.LuckyRaidPets = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Pets",
    Default = false,
    Callback = function(Value)
    _G.AutoUpgradeConfig.LuckyRaidDamage = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Attack Speed",
    Default = false,
    Callback = function(Value)
     _G.AutoUpgradeConfig.LuckyRaidAttackSpeed = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Pet Speed",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidPetSpeed = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky RaidEgg Cost",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidEggCost = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid More Currency",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidMoreCurrency = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid XP",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidXP = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Better Loots",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidBetterLoot = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Huge Chest",
    Default = false,
    Callback = function(Value)
        _G.AutoUpgradeConfig.LuckyRaidHugeChest = Value
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Titanic Chest",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidTitanicChest = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Key Drops",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidKeyDrops = Value
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Boss Huge Chances",
    Default = false,
    Callback = function(Value)
       _G.AutoUpgradeConfig.LuckyRaidBossHugeChances = Value
    end    
})

Tab:AddToggle({
    Name = "Lucky Raid Boss Titanic Chances",
    Default = false,
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


loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/autotap.lua'))()
_G.AutoTap = false
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/megaspeedpets.lua'))()
_G.AutoSpeedPets = false
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/automagnet.lua'))()
_G.AutoMagnet = false
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoBuyNewZone.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/TeleportToBestZone.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoCollectRanks.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoCollectFreeGifts.lua'))()


 

Tab:AddToggle({
    Name = "Auto Tap",
    Default = false,
    Callback = function(Value)
       _G.AutoTap = Value
    end
})


Tab:AddToggle({
	Name = "SpeedPets",
	Default = false,
	Callback = function(Value)
		_G.AutoSpeedPets = Value
	end    
})


Tab:AddToggle({
    Name = "Auto Magnet",
    Default = false,
    Callback = function(Value)
        _G.AutoMagnet = Value
    end    
})


Tab:AddToggle({
    Name = "Auto Buy New Zones",
    Default = false,
    Callback = function(Value)
      _G.AutoBuyEnabled = Value
    end    
})

Tab:AddToggle({
    Name = "Auto-Teleport to Best Zone",
    Default = false,
    Callback = function(Value)
       _G.AutoTeleportbestlocation = Value
    end    
})



Tab:AddToggle({
    Name = "Auto Claim Ranks",
    Default = false,
    Callback = function(Value)
        _G.AutoCollectRANK = Value
    end    
})

Tab:AddToggle({
    Name = "Auto Collect Free Gifts",
    Default = false,
    Callback = function(Value)
       _G.AutoCollectGifts = Value
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


loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoHatchBestEgg.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/things/AutoCollectFreeGifts.lua'))()


Tab:AddToggle({
    Name = "Auto Hatch Best Egg",
    Default = false,
    Callback = function(Value)
        _G.AutoHatchBestEgg = Value
    end    
})


Tab:AddToggle({
    Name = "Auto Hatch Near Egg",
    Default = false,
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
    Callback = function(Value)
        if Value then
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end    
})

Tab:AddButton({
	Name = "Total Gvno-Graphix💀",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/Antilag/PetsOptimizer.lua'))()
    end    
})
