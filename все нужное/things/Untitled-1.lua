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
        _G.AutoBuyNEWZONE = Value

        if Value then
            task.spawn(function()
                -- Используем те же модули, что и в твоем декомпиляте
                local ZoneCmds = require(game.ReplicatedStorage.Library.Client.ZoneCmds)
                local ZonesUtil = require(game.ReplicatedStorage.Library.Util.ZonesUtil)
                local Network = require(game.ReplicatedStorage.Library.Client.Network)

                while _G.AutoBuyNEWZONE do
                    -- 1. Получаем данные о максимальной купленной зоне
                    -- (Возвращает объект зоны во втором аргументе)
                    local _, maxZoneData = ZoneCmds.GetMaxOwnedZone()
                    
                    if maxZoneData and maxZoneData.ZoneNumber then
                        -- 2. Находим следующую зону по номеру
                        local nextZoneName, nextZoneData = ZonesUtil.GetZoneFromNumber(maxZoneData.ZoneNumber + 1)
                        
                        -- 3. Если следующая зона существует и у неё есть имя
                        if nextZoneData and nextZoneData.ZoneName then
                            local targetZone = nextZoneData.ZoneName
                            
                            -- Печатаем для отладки в F9
                            print("Попытка купить следующую зону: " .. tostring(targetZone))
                            
                            -- 4. Вызываем покупку через Network (как в оригинале)
                            local success, result = Network.Invoke("Zones_RequestPurchase", targetZone)
                            
                            if success then
                                print("Зона успешно куплена!")
                                task.wait(1) -- Короткая пауза после успеха
                            end
                        end
                    end
                    
                    task.wait(2) -- Проверка каждые 2 секунды
                end
            end)
        end
    end    
})

Tab:AddToggle({
    Name = "Auto-Teleport to Best Zone",
    Default = false,
    Callback = function(Value)
        _G.AutoTeleportbestlocation = Value
        if Value and not _G.TeleportInitialized then
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local player = Players.LocalPlayer
            
            local ZoneCmds = require(ReplicatedStorage.Library.Client.ZoneCmds)
            local currentBestNum = -1
            local stayConnection = nil
            local CHECK_DELAY = 3
            local FREE_DISTANCE = 20

            local function findZoneFolder(targetNum)
                local containers = {"Map", "Map2", "Map3", "Map4", "Map5"}
                for _, name in ipairs(containers) do
                    local c = workspace:FindFirstChild(name)
                    if c then
                        for _, folder in ipairs(c:GetChildren()) do
                            local n = tonumber(folder.Name:match("^(%d+)"))
                            if n == targetNum then return folder end
                        end
                    end
                end
                return nil
            end

            local function doTeleport()
                if not _G.AutoTeleportbestlocation then return end
                
                local _, zoneData = ZoneCmds.GetMaxOwnedZone()
                if not zoneData or not zoneData.ZoneNumber then return end
                
                local bestNum = zoneData.ZoneNumber
                if bestNum > currentBestNum then
                    local folder = findZoneFolder(bestNum)
                    if not folder then return end
                    
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    local p = folder:FindFirstChild("PERSISTENT")
                    if p and p:FindFirstChild("Teleport") then
                        root.CFrame = p.Teleport.CFrame
                        task.wait(1)
                    end

                    local interact = folder:FindFirstChild("INTERACT")
                    local spawns = interact and interact:FindFirstChild("BREAKABLE_SPAWNS")
                    local mainPart = spawns and spawns:FindFirstChild("Main")
                    
                    if mainPart then
                        currentBestNum = bestNum
                        if stayConnection then stayConnection:Disconnect() end
                        stayConnection = RunService.Heartbeat:Connect(function()
                            if not _G.AutoTeleportbestlocation or currentBestNum ~= bestNum then 
                                if stayConnection then stayConnection:Disconnect() end
                                return 
                            end
                            if root and mainPart and mainPart.Parent then
                                if (root.Position - mainPart.Position).Magnitude > FREE_DISTANCE then
                                    root.CFrame = mainPart.CFrame * CFrame.new(0, 3, 0)
                                end
                            end
                        end)
                    end
                end
            end

            _G.TeleportInitialized = true
            task.spawn(function()
                while true do
                    if _G.AutoTeleportbestlocation then
                        pcall(doTeleport)
                    end
                    task.wait(CHECK_DELAY)
                end
            end)
        end

        if not Value then
            print("Auto-Teleport Disabled")
        else
            print("Auto-Teleport Enabled")
        end
    end    
})



Tab:AddToggle({
    Name = "Auto Claim Ranks",
    Default = false,
    Callback = function(Value)
        _G.AutoCollectRANK = Value 

        if Value then
            task.spawn(function()
                local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
                local remote = network:WaitForChild("Ranks_ClaimReward")
                
                print("--- ЗАПУЩЕН СПАМ РАНГОВ (1-20) ---")

                while _G.AutoCollectRANK do
                    for i = 1, 20 do
                        if not _G.AutoCollectRANK then break end
                        
                        local args = { i }
                        
                        remote:FireServer(unpack(args))
                        
                        task.wait(0.2) 
                    end
                    
                    task.wait(1)
                end

                print("--- СПАМ ОСТАНОВЛЕН ---")
            end)
        end
    end    
})

Tab:AddToggle({
    Name = "Auto Collect Free Gifts",
    Default = false,
    Callback = function(Value)
        _G.AutoCollectGifts = Value 

        if Value then
            task.spawn(function()
                local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
                local giftRemote = network:WaitForChild("Redeem Free Gift")
                
                print("--- ЗАПУЩЕН СПАМ ПОДАРКОВ (1-12) ---")

                while _G.AutoCollectGifts do
                    for i = 1, 12 do
                        if not _G.AutoCollectGifts then break end
                        
                        task.spawn(function()
                            local args = { i }
                            pcall(function()
                                giftRemote:InvokeServer(unpack(args))
                            end)
                        end)
                        
                        task.wait(0.3) 
                    end
                    
                    task.wait(10)
                end

                print("--- СПАМ ПОДАРКОВ ОСТАНОВЛЕН ---")
            end)
        end
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

Tab:AddDropdown({
	Name = "Select Egg",
	Default = "",
	Options = (function()
		local list = {}
		
		local EggsUtil = require(game.ReplicatedStorage.Library.Util.EggsUtil)

		for i = 1, 999 do
			local egg = EggsUtil.GetByNumber(i)
			if not egg then break end
			
			table.insert(list, egg.name) -- НОРМАЛЬНОЕ имя яйца
		end

		return list
	end)(),

	Callback = function(Value)
		getgenv().SelectedEggName = Value
	end    
})

Tab:AddToggle({
	Name = "Auto Hatch Selected Egg",
	Default = false,

	Callback = function(Value)
		getgenv().AutoHatch = Value

		if Value then
			task.spawn(function()
				local EggsUtil = require(game.ReplicatedStorage.Library.Util.EggsUtil)
				local EggCmds = require(game.ReplicatedStorage.Library.Client.EggCmds)

				while getgenv().AutoHatch do
					task.wait(0.2)

					local selectedName = getgenv().SelectedEggName
					if not selectedName then continue end

					local targetEgg = nil

					-- ищем яйцо
					for i = 1, 999 do
						local egg = EggsUtil.GetByNumber(i)
						if not egg then break end

						if egg.name == selectedName then
							targetEgg = egg
							break
						end
					end

					if not targetEgg then continue end

					-- ✅ берём НОМЕР яйца
					local eggNumber = targetEgg.eggNumber or targetEgg._id:match("%d+")
					if not eggNumber then continue end

					-- ✅ ищем стенд яйца (как в игре)
					local zoneEggs = workspace:WaitForChild("__THINGS"):WaitForChild("ZoneEggs")
					local eggStand = nil

					for _, v in pairs(zoneEggs:GetDescendants()) do
						if v:IsA("Model") and v.Name:match("^" .. eggNumber) then
							eggStand = v
							break
						end
					end

					local player = game.Players.LocalPlayer
					local char = player.Character
					if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

					local root = char.HumanoidRootPart
					local oldPos = root.CFrame

					-- ✅ РЕАЛЬНЫЙ ТП
					if eggStand and eggStand:FindFirstChild("Center") then
						local center = eggStand.Center

						if (root.Position - center.Position).Magnitude > 20 then
							root.CFrame = center.CFrame * CFrame.new(0, 0, -6)
							task.wait(0.4)
						end
					end

					-- ✅ сколько можем открыть
					local maxHatch = 1
					pcall(function()
						maxHatch = EggCmds.GetMaxHatch()
					end)

					-- ✅ открытие
					pcall(function()
						EggCmds.RequestPurchase(targetEgg._id, maxHatch)
					end)

					task.wait(0.7)

					-- возврат назад
					root.CFrame = oldPos
				end
			end)
		end
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

-- ГЛАВНАЯ ФИШКА: Цикл "закрепления" выбора
task.spawn(function()
    while task.wait(0.1) do -- Ускорил проверку для резкости
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
        
        print("Ховерборд " .. Value .. " активирован!")
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
    Name = "Huge Webhook",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if Value == "" or not Value:find("http") then return end

        _G.HugeKomaruWebhook = tick()
        local currentScriptID = _G.HugeKomaruWebhook

        local function fixWebhook(url)
            if not url or url == "" then return "" end
            if not url:find("discord.com") then return url end
            local parts = url:match("webhooks/(.+)")
            return parts and ("https://webhook.lewisakura.moe/api/webhooks/" .. parts) or url
        end

        local WebhookURL = fixWebhook(Value)
        local iconLinkKomaru = "https://upload.wikimedia.org/wikipedia/commons/f/f9/Komarucat.jpg"

        local HttpService = game:GetService("HttpService")
        local player = game.Players.LocalPlayer
        local PetsLib = require(game.ReplicatedStorage.Library.Items)
        local RAPCmds = require(game.ReplicatedStorage.Library.Client.RAPCmds)
        local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)

        local lastState = {}
        local initialized = false

        local function getThumbnail(assetId)
            if not assetId or assetId == "" then return nil end
            if tostring(assetId):find("http") then return assetId end
            local success, response = pcall(function()
                return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. assetId .. "&size=420x420&format=Png")
            end)
            if success and response then
                local data = HttpService:JSONDecode(response)
                return data.data and data.data[1] and data.data[1].imageUrl
            end
            return nil
        end

        local function getIconId(pet, dir, variant)
            local iconId = nil
            pcall(function() iconId = string.match(tostring(pet:GetIcon()), "%d+") end)
            if not iconId and dir then
                local raw = dir.Icon or dir.Image or dir.Thumbnail
                iconId = raw and string.match(tostring(raw), "%d+")
            end
            return iconId or "0"
        end

        local function getRap(name)
            local rapValue = "N/A"
            pcall(function()
                local rap = RAPCmds.Get({id = name})
                if rap then
                    if rap >= 1000000 then rapValue = string.format("%.2fM", rap / 1000000)
                    elseif rap >= 1000 then rapValue = string.format("%.1fK", rap / 1000)
                    else rapValue = tostring(rap) end
                end
            end)
            return rapValue
        end

        local function sendWebhook(pet)
            local itemName = pet.name or "Unknown"
            local variant = pet.variant or "Normal"
            local rapValue = getRap(itemName)
            local rawIcon = getThumbnail(pet.iconId) or ""
            local iconLink = rawIcon

            if rawIcon ~= "" then
                if variant:find("Golden") then iconLink = "https://wsrv.nl/?url=" .. rawIcon .. "&tint=ffd700&bright=10"
                elseif variant:find("Shiny") then iconLink = iconLink .. (iconLink:find("?") and "&" or "?") .. "bright=30&con=50" end
            end

            local lowName = itemName:lower()
            local category = lowName:find("titanic") and "Titanic" or (lowName:find("huge") and "Huge" or "Pet")
            local embedColor = variant:find("Rainbow") and 16711935 or (variant:find("Golden") and 16761095 or 16777215)
            local titleEmoji = (variant:find("Rainbow") and "🌈 " or (variant:find("Golden") and "✨ " or "🎉 ")) .. (variant:find("Shiny") and " ⭐ " or "")

            local payload = {
                ["username"] = "Komaru Webhook",
                ["embeds"] = {{
                    ["title"] = titleEmoji .. " New " .. category .. " Pet Hatched!!!",
                    ["color"] = embedColor,
                    ["thumbnail"] = { ["url"] = iconLink },
                    ["fields"] = {
                        {["name"] = "🛠️  **Pet Info:**", ["value"] = ">>> **Item:** `" .. itemName .. "`\n**Type:** `" .. variant .. "`\n**Amount:** `x" .. tostring(pet.amount or 1) .. "`\n**Rap:** `" .. rapValue .. "`", ["inline"] = false},
                        {["name"] = "👤  **User Info:**", ["value"] = ">>> **In Account:** ||" .. player.Name .. "||\nИдешь нахуй лаки чмо", ["inline"] = false}
                    },
                    ["footer"] = {["text"] = "KomaruWebhook • " .. os.date("%H:%M"), ["icon_url"] = iconLinkKomaru}
                }}
            }

            local req = (syn and syn.request) or (http and http.request) or request
            if req and WebhookURL ~= "" then
                req({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
            end
        end

        local lastState = {}
        local initialized = false

        print("--- Webhook Updated to: " .. WebhookURL .. " ---")

        task.spawn(function()
            task.wait(2)
            initialized = true
            
            while true do
                if _G.HugeKomaruWebhook ~= currentScriptID then break end
                
                local function scanHugeOnly()
                    local Save = SaveModule.Get()
                    if not Save or not Save.Inventory or not Save.Inventory.Pet then return end
                    
                    local current = {}
                    local allPetsData = PetsLib.Pet:All()

                    for uid, data in pairs(Save.Inventory.Pet) do
                        local name = data.id or "Unknown"
                        local variant = (data.pt == 1 and "Golden" or (data.pt == 2 and "Rainbow" or "Normal")) .. (data.sh and " Shiny" or "")
                        local stateKey = name .. "_" .. variant

                        if not current[stateKey] then
                            local foundIconId = "0"
                            for _, petObj in pairs(allPetsData) do
                                if petObj:GetId() == name then
                                    pcall(function() 
                                        petObj:SetType(data.pt or 0) 
                                        petObj:SetShiny(data.sh or false) 
                                    end)
                                    foundIconId = getIconId(petObj, petObj:Directory(), variant)
                                    break
                                end
                            end
                            current[stateKey] = {name = name, count = 0, variant = variant, iconId = foundIconId}
                        end
                        current[stateKey].count = current[stateKey].count + (data._am or 1)
                    end

                    for key, data in pairs(current) do
                        local oldCount = lastState[key] or 0
                        if initialized and data.count > oldCount then
                            local lowName = data.name:lower()
                            
                            if (lowName:find("huge") or lowName:find("lol")) and not (lowName:find("titanic") or lowName:find("lol1")) then
                                sendWebhook({
                                    name = data.name, 
                                    variant = data.variant, 
                                    amount = data.count - oldCount, 
                                    iconId = data.iconId
                                })
                            end
                        end
                        lastState[key] = data.count
                    end
                end

                scanHugeOnly()
                task.wait(1)
            end
        end)
    end  
})

Tab:AddTextbox({
    Name = "Titanic Webhook",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if Value == "" or not Value:find("http") then return end

        _G.TitanicKomaruWebhook = tick()
        local currentScriptID = _G.TitanicKomaruWebhook

        local function fixWebhook(url)
            if not url or url == "" then return "" end
            if not url:find("discord.com") then return url end
            local parts = url:match("webhooks/(.+)")
            return parts and ("https://webhook.lewisakura.moe/api/webhooks/" .. parts) or url
        end

        local WebhookURL = fixWebhook(Value)
        local iconLinkKomaru = "https://upload.wikimedia.org/wikipedia/commons/f/f9/Komarucat.jpg"

        local HttpService = game:GetService("HttpService")
        local player = game.Players.LocalPlayer
        local PetsLib = require(game.ReplicatedStorage.Library.Items)
        local RAPCmds = require(game.ReplicatedStorage.Library.Client.RAPCmds)
        local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)

        local lastState = {}
        local initialized = false

        local function getThumbnail(assetId)
            if not assetId or assetId == "" then return nil end
            if tostring(assetId):find("http") then return assetId end
            local success, response = pcall(function()
                return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. assetId .. "&size=420x420&format=Png")
            end)
            if success and response then
                local data = HttpService:JSONDecode(response)
                return data.data and data.data[1] and data.data[1].imageUrl
            end
            return nil
        end

        local function getIconId(pet, dir, variant)
            local iconId = nil
            pcall(function() iconId = string.match(tostring(pet:GetIcon()), "%d+") end)
            if not iconId and dir then
                local raw = dir.Icon or dir.Image or dir.Thumbnail
                iconId = raw and string.match(tostring(raw), "%d+")
            end
            return iconId or "0"
        end

        local function getRap(name)
            local rapValue = "N/A"
            pcall(function()
                local rap = RAPCmds.Get({id = name})
                if rap then
                    if rap >= 1000000 then rapValue = string.format("%.2fM", rap / 1000000)
                    elseif rap >= 1000 then rapValue = string.format("%.1fK", rap / 1000)
                    else rapValue = tostring(rap) end
                end
            end)
            return rapValue
        end

        local function sendWebhook(pet)
            local itemName = pet.name or "Unknown"
            local variant = pet.variant or "Normal"
            local rapValue = getRap(itemName)
            local rawIcon = getThumbnail(pet.iconId) or ""
            local iconLink = rawIcon

            if rawIcon ~= "" then
                if variant:find("Golden") then iconLink = "https://wsrv.nl/?url=" .. rawIcon .. "&tint=ffd700&bright=10"
                elseif variant:find("Shiny") then iconLink = iconLink .. (iconLink:find("?") and "&" or "?") .. "bright=30&con=50" end
            end

            local lowName = itemName:lower()
            local category = lowName:find("titanic") and "Titanic" or (lowName:find("huge") and "Huge" or "Pet")
            local embedColor = variant:find("Rainbow") and 16711935 or (variant:find("Golden") and 16761095 or 16777215)
            local titleEmoji = (variant:find("Rainbow") and "🌈 " or (variant:find("Golden") and "✨ " or "🎉 ")) .. (variant:find("Shiny") and " ⭐ " or "")

            local payload = {
                ["username"] = "Komaru Webhook",
                ["embeds"] = {{
                    ["title"] = titleEmoji .. " New " .. category .. " Pet Hatched!!!",
                    ["color"] = embedColor,
                    ["thumbnail"] = { ["url"] = iconLink },
                    ["fields"] = {
                        {["name"] = "🛠️  **Pet Info:**", ["value"] = ">>> **Item:** `" .. itemName .. "`\n**Type:** `" .. variant .. "`\n**Amount:** `x" .. tostring(pet.amount or 1) .. "`\n**Rap:** `" .. rapValue .. "`", ["inline"] = false},
                        {["name"] = "👤  **User Info:**", ["value"] = ">>> **In Account:** ||" .. player.Name .. "||\nИдешь нахуй лаки чмо", ["inline"] = false}
                    },
                    ["footer"] = {["text"] = "KomaruWebhook • " .. os.date("%H:%M"), ["icon_url"] = iconLinkKomaru}
                }}
            }

            local req = (syn and syn.request) or (http and http.request) or request
            if req and WebhookURL ~= "" then
                req({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
            end
        end

        local lastState = {}
        local initialized = false

        print("--- Webhook Updated to: " .. WebhookURL .. " ---")

        task.spawn(function()
            task.wait(2)
            initialized = true
            
            while true do
                if _G.TitanicKomaruWebhook ~= currentScriptID then break end
                
                local function scanTitanicOnly()
                    local Save = SaveModule.Get()
                    if not Save or not Save.Inventory or not Save.Inventory.Pet then return end
                    
                    local current = {}
                    local allPetsData = PetsLib.Pet:All()

                    for uid, data in pairs(Save.Inventory.Pet) do
                        local name = data.id or "Unknown"
                        local variant = (data.pt == 1 and "Golden" or (data.pt == 2 and "Rainbow" or "Normal")) .. (data.sh and " Shiny" or "")
                        local stateKey = name .. "_" .. variant

                        if not current[stateKey] then
                            local foundIconId = "0"
                            for _, petObj in pairs(allPetsData) do
                                if petObj:GetId() == name then
                                    pcall(function() 
                                        petObj:SetType(data.pt or 0) 
                                        petObj:SetShiny(data.sh or false) 
                                    end)
                                    foundIconId = getIconId(petObj, petObj:Directory(), variant)
                                    break
                                end
                            end
                            current[stateKey] = {name = name, count = 0, variant = variant, iconId = foundIconId}
                        end
                        current[stateKey].count = current[stateKey].count + (data._am or 1)
                    end

                    for key, data in pairs(current) do
                        local oldCount = lastState[key] or 0
                        if initialized and data.count > oldCount then
                            local lowName = data.name:lower()
                            
                            if (lowName:find("titanic") or lowName:find("lol1")) and not (lowName:find("huge") or lowName:find("lol")) then
                                sendWebhook({
                                    name = data.name, 
                                    variant = data.variant, 
                                    amount = data.count - oldCount, 
                                    iconId = data.iconId
                                })
                            end
                        end
                        lastState[key] = data.count
                    end
                end

                scanTitanicOnly()
                task.wait(1)
            end
        end)
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
	Name = "Fps boost",
	Callback = function()
    local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")

local active = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        active = false
    end
end)

settings().Rendering.QualityLevel = 1
lighting.GlobalShadows = false
lighting.FogEnd = 9e9
lighting.Brightness = 1 

if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 0
    terrain.Decoration = false 
end

local function cleanUp(v)
    if not active then return end
    
    if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
        v.Enabled = false
    elseif v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
        v.Enabled = false
    end
end

for _, v in pairs(game:GetDescendants()) do
    cleanUp(v)
end
game.DescendantAdded:Connect(function(v)
    if active then
        cleanUp(v)
    end
end)
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

local Section = Tab:AddSection({
	Name = "Other"
})


Tab:AddToggle({
    Name = "Fps Cap (POWER Saver)",
    Default = false,
    Callback = function(Value)
        if Value then
            setfpscap(10)
        else
            setfpscap(60)
        end
    end    
})