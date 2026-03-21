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


Tab:AddToggle({
    Name = "Lucky Raid Auto-Farm",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidEnabled = Value

        if _G.LuckyRaidEnabled then
            getgenv().LuckyRaidSettings = {
                TargetRaidLevel = "Max",
                BossChest1 = true,
                BossChest2 = true,
                BossChest3 = true,
                OpenChests = {
                    TitanicChest = true,
                    HugeChest = true,
                    LootChest = true,
                    LeprechaunChest = true,
                    Tier1000Chest = true
                }
            }

            local Config = getgenv().LuckyRaidSettings
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local player = Players.LocalPlayer
            local things = workspace:WaitForChild("__THINGS")
            local breakables = things:WaitForChild("Breakables")
            local Active = things:WaitForChild("__INSTANCE_CONTAINER"):WaitForChild("Active")
            local Net = ReplicatedStorage:WaitForChild("Network")
            
            local Library = ReplicatedStorage:WaitForChild("Library")
            local RaidCmds = require(Library.Client.RaidCmds)
            local RaidInstance = require(Library.Client.RaidCmds.ClientRaidInstance)
            local Network = require(Library.Client.Network)

            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            local charAddedConn
            charAddedConn = player.CharacterAdded:Connect(function(c)
                if not _G.LuckyRaidEnabled then charAddedConn:Disconnect() return end
                hrp = c:WaitForChild("HumanoidRootPart")
            end)

            local function getBreakable()
                local target = nil
                local dist = math.huge
                local all = breakables:GetChildren()
                for i = 1, #all do
                    local v = all[i]
                    local id = v:GetAttribute("BreakableID")
                    if id and string.find(tostring(id), "LuckyRaid") then
                        local p = v:GetPivot().Position
                        local d = (hrp.Position - p).Magnitude
                        if d < dist then
                            dist = d
                            target = v
                        end
                    end
                end
                return target
            end

            task.spawn(function()
                while _G.LuckyRaidEnabled do
                    local target = getBreakable()
                    if target and target.Parent then
                        local targetPos = target:GetPivot() * CFrame.new(0, 4, 0)
                        if (hrp.Position - targetPos.Position).Magnitude > 10 then
                            hrp.CFrame = targetPos
                        end
                    end
                    task.wait(0.2)
                end
            end)

            local function openChests(openedThisRoom)
                local raidFolder = Active:FindFirstChild("LuckyRaid")
                local interact = raidFolder and raidFolder:FindFirstChild("INTERACT")
                if not interact then return end

                for _, obj in ipairs(interact:GetChildren()) do
                    if Config.OpenChests[obj.Name] and not openedThisRoom[obj] then
                        openedThisRoom[obj] = true
                        task.spawn(function()
                            pcall(function() Net.Raids_OpenChest:InvokeServer(obj.Name) end)
                        end)
                    end
                end
            end

            local function hasBreakables()
                for _, v in ipairs(breakables:GetChildren()) do
                    if string.find(tostring(v:GetAttribute("BreakableID") or ""), "LuckyRaid") then
                        return true
                    end
                end
                return false
            end

            task.spawn(function()
                local teleportedThisRaid = false
                local lastBossRoom = 0
                local openedThisRoom = {}
                local leaving = false
                local lastLeave = 0

                while _G.LuckyRaidEnabled do
                    local raid = RaidInstance.GetCurrent()
                    
                    if not raid then
                        teleportedThisRaid = false
                        openedThisRoom = {}
                        lastBossRoom = 0

                        if tick() - lastLeave > 3 then
                            local myRaid = RaidInstance.GetByOwner(player)
                            if myRaid and not myRaid:IsComplete() then
                                Network.Invoke("Raids_Join", myRaid:GetId())
                            else
                                local portal = nil
                                for i = 1, 10 do
                                    if not RaidInstance.GetByPortal(i) then portal = i break end
                                end
                                if portal then
                                    local lvl = (Config.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or tonumber(Config.TargetRaidLevel)
                                    RaidCmds.Create({Difficulty = lvl or 1, Portal = portal, PartyMode = 1})
                                end
                            end
                            lastLeave = tick()
                        end
                    else
                        openChests(openedThisRoom)
                        local room = raid:GetRoomNumber()

                        if not teleportedThisRaid and room == 1 then
                            teleportedThisRaid = true
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -10)
                        end

                        if room % 3 == 0 and lastBossRoom ~= room then
                            lastBossRoom = room
                            pcall(function()
                                if Config.BossChest1 then Net.LuckyRaid_PullLever:InvokeServer(1) Net.Raids_StartBoss:InvokeServer(1) end
                                if Config.BossChest2 then Net.LuckyRaid_PullLever:InvokeServer(2) Net.Raids_StartBoss:InvokeServer(2) end
                                if Config.BossChest3 then Net.LuckyRaid_PullLever:InvokeServer(3) Net.Raids_StartBoss:InvokeServer(3) end
                            end)
                        end

                        if room >= 10 and not leaving and not hasBreakables() then
                            leaving = true
                            pcall(function()
                                Net.Instancing_PlayerLeaveInstance:FireServer("LuckyRaid")
                                task.wait(1)
                                Net.Instancing_PlayerEnterInstance:InvokeServer("LuckyEventWorld")
                            end)
                            lastLeave = tick()
                            leaving = false
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end 
})


local Section = Tab:AddSection({
	Name = "Auto Upgrade"
})

Tab:AddToggle({
    Name = "Raid Pets Slots",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidPets = Value
        
        if _G.LuckyRaidPets then
            task.spawn(function()
                while _G.LuckyRaidPets do
                    local args = {"LuckyRaidPets"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Pets Damage",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidDamage = Value
        
        if _G.LuckyRaidDamage then
            task.spawn(function()
                while _G.LuckyRaidDamage do
                    local args = {"LuckyRaidDamage"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Pets Speed",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidPetSpeed = Value
        
        if _G.LuckyRaidPetSpeed then
            task.spawn(function()
                while _G.LuckyRaidPetSpeed do
                    local args = {"LuckyRaidPetSpeed"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Egg Cost",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidEggCost = Value
        
        if _G.LuckyRaidEggCost then
            task.spawn(function()
                while _G.LuckyRaidEggCost do
                    local args = {"LuckyRaidEggCost"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid More Currency",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidMoreCurrency = Value
        
        if _G.LuckyRaidMoreCurrency then
            task.spawn(function()
                while _G.LuckyRaidMoreCurrency do
                    local args = {"LuckyRaidMoreCurrency"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid XP",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidXP = Value
        
        if _G.LuckyRaidXP then
            task.spawn(function()
                while _G.LuckyRaidXP do
                    local args = {"LuckyRaidXP"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Better Loot",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidBetterLoot = Value
        
        if _G.LuckyRaidBetterLoot then
            task.spawn(function()
                while _G.LuckyRaidBetterLoot do
                    local args = {"LuckyRaidBetterLoot"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Key Drops",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidKeyDrops = Value
        
        if _G.LuckyRaidKeyDrops then
            task.spawn(function()
                while _G.LuckyRaidKeyDrops do
                    local args = {"LuckyRaidKeyDrops"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Boss Huge Chances",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidBossHugeChances = Value
        
        if _G.LuckyRaidBossHugeChances then
            task.spawn(function()
                while _G.LuckyRaidBossHugeChances do
                    local args = {"LuckyRaidBossHugeChances"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Boss Titanic Chances",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidBossTitanicChances = Value
        
        if _G.LuckyRaidBossTitanicChances then
            task.spawn(function()
                while _G.LuckyRaidBossTitanicChances do
                    local args = {"LuckyRaidBossTitanicChances"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})


Tab:AddToggle({
    Name = "Lucky Raid Titanic Chest",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidTitanicChest = Value
        
        if _G.LuckyRaidTitanicChest then
            task.spawn(function()
                while _G.LuckyRaidTitanicChest do
                    local args = {"LuckyRaidTitanicChest"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})



Tab:AddToggle({
    Name = "Lucky Raid Huge Chest",
    Default = false,
    Callback = function(Value)
        _G.LuckyRaidHugeChest = Value
        
        if _G.LuckyRaidHugeChest then
            task.spawn(function()
                while _G.LuckyRaidHugeChest do
                    local args = {"LuckyRaidHugeChest"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("EventUpgrades: Purchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
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
    Callback = function(Value)
        _G.AutoTap = Value

        if _G.AutoTap then
            local RADIUS = 150
            local MAX_TARGETS = 100
            local player = game.Players.LocalPlayer
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")

            local function getBreakables()
                local things = workspace:FindFirstChild("__THINGS")
                if not things then return nil end
                return things:FindFirstChild("Breakables")
            end

            task.spawn(function()
                while _G.AutoTap do
                    local character = player.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        local breakablesPath = getBreakables()
                        
                        if breakablesPath then
                            local rootPos = root.Position
                            local targets = {}
                            local allBreakables = breakablesPath:GetChildren()

                            for i = 1, #allBreakables do
                                local obj = allBreakables[i]
                                local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                                
                                if part then
                                    local dist = (rootPos - part.Position).Magnitude
                                    if dist <= RADIUS then
                                        table.insert(targets, {instance = obj, distance = dist})
                                    end
                                end
                            end

                            table.sort(targets, function(a, b)
                                return a.distance < b.distance
                            end)

                            local limit = math.min(#targets, MAX_TARGETS)
                            for i = 1, limit do
                                if not _G.AutoTap then break end
                                network:FireServer(targets[i].instance.Name)
                            end
                        end
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    end
})


Tab:AddToggle({
	Name = "SpeedPets",
	Default = false,
	Callback = function(Value)
		_G.SpeedPetsEnabled = Value
		
		if _G.SpeedPetsEnabled and not _G.SpeedPetsLoopStarted then
			_G.SpeedPetsLoopStarted = true
			
			local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Breakables_JoinPetBulk")
			local player = game:GetService("Players").LocalPlayer
			local things = workspace:WaitForChild("__THINGS")
			local breakables = things.Breakables
			local petsFolder = things.Pets

			local petIds = {}

			local function updatePetList()
				table.clear(petIds)
				for _, pet in ipairs(petsFolder:GetChildren()) do
					if pet.Name:match("^%d+$") then
						table.insert(petIds, pet.Name)
					end
				end
			end

			updatePetList()
			petsFolder.ChildAdded:Connect(updatePetList)
			petsFolder.ChildRemoved:Connect(updatePetList)

			local function getTargetsInRange(radius)
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if not root then return {} end
				
				local myPos = root.Position
				local found = {}
				local radiusSq = radius^2

				for _, obj in ipairs(breakables:GetChildren()) do
					if obj.Name:match("^%d+$") then
						local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
						if part then
							local diff = part.Position - myPos
							if (diff.X^2 + diff.Y^2 + diff.Z^2) <= radiusSq then
								table.insert(found, obj.Name)
							end
						end
					end
				end
				return found
			end

			task.spawn(function()
				while true do
					if not _G.SpeedPetsEnabled then 
						task.wait(1) 
					else
						local targets = getTargetsInRange(60)
						local attackData = {}

						if #targets > 0 and #petIds > 0 then
							if #targets >= 5 then
								for i, pId in ipairs(petIds) do
									local targetId = targets[((i - 1) % #targets) + 1]
									attackData[pId] = targetId
								end
							else
								local mainTarget = targets[1]
								for _, pId in ipairs(petIds) do
									attackData[pId] = mainTarget
								end
							end

							Network:FireServer(attackData)
						end
						task.wait(0.2)
					end
				end
			end)
		end
	end    
})

_G.AutoMagnet = false

Tab:AddToggle({
    Name = "Auto Magnet",
    Default = false,
    Callback = function(Value)
        _G.AutoMagnet = Value
    end    
})

task.spawn(function()
    while true do
        task.wait(0.3)
        
        if _G.AutoMagnet then
            local things = workspace:FindFirstChild("__THINGS")
            local orbs = things and things:FindFirstChild("Orbs")
            
            if orbs then
                for _, orb in pairs(orbs:GetChildren()) do
                    if not _G.AutoMagnet then break end
                    
                    local orbName = tonumber(orb.Name)
                    if orbName then
                        local args = {
                            [1] = {
                                [1] = orbName
                            }
                        }
                        
                        local network = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
                        local collectRemote = network and network:FindFirstChild("Orbs: Collect")
                        
                        if collectRemote then
                            collectRemote:FireServer(unpack(args))
                        end
                        
                        orb:Destroy()
                    end
                end
            end
        end
    end
end)


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
	Name = "AntiAfk",
	Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))();
  	end    
})


Tab:AddButton({
	Name = "Zap Hub",
	Callback = function()
    loadstring(game:HttpGet('https://zaphub.xyz/Exec'))()
  	end    
})

Tab:AddButton({
	Name = "remotespy",
	Callback = function()
    loadstring(game:HttpGet('loadstring(game:HttpGetAsync("https://github.com/richie0866/remote-spy/releases/latest/download/RemoteSpy.lua"))()'))()
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
	Name = "Avoid ban"
})

Tab:AddButton({
	Name = "Ghost Mode👻",
	Callback = function()
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

local function notify(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:DisplaySystemMessage("[SECURITY]: " .. msg) end
    else
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[SECURITY]: " .. msg,
            Color = Color3.fromRGB(255, 170, 0),
            Font = Enum.Font.SourceSansBold
        })
    end
end

notify("The protection system is active.")

local function performSecurityCheck()
    local s, isScreenshotEnabled = pcall(function()
        return settings():GetFFlag("ReportAnythingScreenshot")
    end)
    
    if s and isScreenshotEnabled == true then
        LocalPlayer:Kick("\n🚨 THE SCREENSHOT SYSTEM IS ACTIVATED\nRoblox has started monitoring the screen. The farm is stopped for safety.")
        return true
    end

    local s2, isRAEnabled = pcall(function()
        return settings():GetFFlag("ForceReportAnythingAnnotationEnabled")
    end)
    
    if s2 and isRAEnabled == true then
        LocalPlayer:Kick("\n🚨 IXP MONITORING IS ENABLED\nDeep environment check (Report Anything) is detected.")
        return true
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local success, rank = pcall(function() return player:GetRankInGroup(game.CreatorId) end)
            
            if (success and rank >= 200) or player.UserId < 0 then
                LocalPlayer:Kick("\n🚨 ADMIN DETECTED: " .. player.Name .. "\nThe farm was interrupted to avoid manual reporting.")
                return true
            end
        end
    end

    local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    if RobloxGui then
        local trustAndSafety = RobloxGui:FindFirstChild("TrustAndSafety")
        if trustAndSafety and trustAndSafety.Enabled then
             LocalPlayer:Kick("\n🚨 THE SECURITY WINDOW IS OPEN\nThe reporting system was initiated from the outside.")
             return true
        end
    end

    return false
end

task.spawn(function()
    while true do
        if performSecurityCheck() then break end
        task.wait(3)
    end
end)

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    performSecurityCheck()
end)
  	end    
})

Tab:AddButton({
	Name = "Shutdown Game if dev join",
	Callback = function()
			local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local isScriptActive = true

local function shutdownServer()
    if isScriptActive and #Players:GetPlayers() > 1 then
        game:Shutdown() 
    end
end

Players.PlayerAdded:Connect(function()
    shutdownServer()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        isScriptActive = false
    end
end)

shutdownServer()
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
