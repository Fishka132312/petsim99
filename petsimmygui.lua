local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fishka132312/-/refs/heads/main/%D0%B4%D1%89%D0%B4"))()

local tab = UILib:CreateTab("Event Farm")

UILib:AddToggle(tab, "Lucky Raid Auto-Farm", "LuckyRaidRunning", function(v)

	if v then
		if getgenv().LuckyRaidRunning then return end
		getgenv().LuckyRaidRunning = true

		getgenv().LuckyRaidEnabled = true
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

		player.CharacterAdded:Connect(function(c)
			hrp = c:WaitForChild("HumanoidRootPart")
		end)

		local function getBreakable()
			local target = nil
			local dist = math.huge
			for _, v in ipairs(breakables:GetChildren()) do
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

		local function openChests(openedThisRoom)
			local raidFolder = Active:FindFirstChild("LuckyRaid")
			local interact = raidFolder and raidFolder:FindFirstChild("INTERACT")
			if not interact then return end

			for _, obj in ipairs(interact:GetChildren()) do
				if getgenv().LuckyRaidSettings.OpenChests[obj.Name] and not openedThisRoom[obj] then
					openedThisRoom[obj] = true
					task.spawn(function()
						pcall(function()
							Net.Raids_OpenChest:InvokeServer(obj.Name)
						end)
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
			while getgenv().LuckyRaidEnabled do
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

		task.spawn(function()
			local teleportedThisRaid = false
			local lastBossRoom = 0
			local openedThisRoom = {}
			local leaving = false
			local lastLeave = 0

			while getgenv().LuckyRaidEnabled do
				local raid = RaidInstance.GetCurrent()
				local Config = getgenv().LuckyRaidSettings

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
								if not RaidInstance.GetByPortal(i) then
									portal = i
									break
								end
							end

							if portal then
								local lvl = (Config.TargetRaidLevel == "Max") and RaidCmds.GetLevel() or tonumber(Config.TargetRaidLevel)
								RaidCmds.Create({
									Difficulty = lvl or 1,
									Portal = portal,
									PartyMode = 1
								})
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
							if Config.BossChest1 then
								Net.LuckyRaid_PullLever:InvokeServer(1)
								Net.Raids_StartBoss:InvokeServer(1)
							end
							if Config.BossChest2 then
								Net.LuckyRaid_PullLever:InvokeServer(2)
								Net.Raids_StartBoss:InvokeServer(2)
							end
							if Config.BossChest3 then
								Net.LuckyRaid_PullLever:InvokeServer(3)
								Net.Raids_StartBoss:InvokeServer(3)
							end
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

			getgenv().LuckyRaidRunning = false
		end)

	else
		getgenv().LuckyRaidEnabled = false
	end

end)


local tab = UILib:CreateTab("Auto Farm")


UILib:AddToggle(tab, "Auto Tap", "AutoTap", function(v)

    getgenv().Enabled = v

    if v then
        if getgenv().AutoTapRunning then return end
        getgenv().AutoTapRunning = true
    end

    if not v then
        getgenv().Enabled = false
        getgenv().AutoTapRunning = false
        return
    end

    task.spawn(function()
        local RADIUS = 150
        local MAX_TARGETS = 100

        local player = game.Players.LocalPlayer
        local replicatedStorage = game:GetService("ReplicatedStorage")

        local network = replicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage")
        local breakablesPath = workspace:WaitForChild("__THINGS"):WaitForChild("Breakables")

        while getgenv().Enabled do
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:FindFirstChild("HumanoidRootPart")

            if root then
                local rootPos = root.Position
                local targets = {}

                local allBreakables = breakablesPath:GetChildren()
                for i = 1, #allBreakables do
                    local obj = allBreakables[i]

                    if obj and obj.Parent then 
                        local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")

                        if part then
                            local dist = (rootPos - part.Position).Magnitude
                            if dist <= RADIUS then
                                table.insert(targets, {instance = obj, distance = dist})
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b)
                    return a.distance < b.distance
                end)

                for i = 1, math.min(#targets, MAX_TARGETS) do
                    if not getgenv().Enabled then break end

                    local targetObj = targets[i].instance
                    if targetObj and targetObj.Parent then
                        network:FireServer(targetObj.Name)
                    end
                end
            end

            task.wait(0.1)
        end

        getgenv().AutoTapRunning = false
    end)

end)


getgenv().AutoMagnetEnabled = getgenv().AutoMagnetEnabled or false

UILib:AddToggle(tab, "Auto Magnet", "AutoMagnet", function(v)
    if v then
        if getgenv().AutoMagnetEnabled then
            return
        end

        getgenv().AutoMagnetEnabled = true

        task.spawn(function()
            while getgenv().AutoMagnetEnabled do
                task.wait(0.3)

                local things = workspace:FindFirstChild("__THINGS")
                local orbs = things and things:FindFirstChild("Orbs")

                if orbs then
                    local allOrbs = orbs:GetChildren()

                    for _, orb in pairs(allOrbs) do
                        if not getgenv().AutoMagnetEnabled then
                            break
                        end

                        local orbName = tonumber(orb.Name)
                        if orbName then
                            local network = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
                            local collectRemote = network and network:FindFirstChild("Orbs: Collect")

                            if collectRemote then
                                collectRemote:FireServer({ [1] = orbName })
                            end

                            orb:Destroy()
                        end
                    end
                end
            end
        end)

    else
        getgenv().AutoMagnetEnabled = false
    end
end)


local tab = UILib:CreateTab("Misc")

UILib:AddToggle(tab, "deleteguis fpsboost", "deleteguis", function(v)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    if v then
        if getgenv().Enabled then return end
        getgenv().Enabled = true
    else
        if not getgenv().Enabled then return end
        getgenv().Enabled = false

        if getgenv()._guiCleanerConn then
            getgenv()._guiCleanerConn:Disconnect()
            getgenv()._guiCleanerConn = nil
        end
        return
    end

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
        for _, name in ipairs(mainGuiList) do
            wipe(playerGui:FindFirstChild(name))
        end

        wipe(playerGui:FindFirstChild("_INSTANCES"))

        local machines = playerGui:FindFirstChild("_MACHINES")
        if machines then
            for _, name in ipairs(machinesList) do
                wipe(machines:FindFirstChild(name))
            end
        end

        local misc = playerGui:FindFirstChild("_MISC")
        if misc then
            for _, name in ipairs(miscList) do
                wipe(misc:FindFirstChild(name))
            end
        end
    end

    purge()

    getgenv()._guiCleanerConn = playerGui.DescendantAdded:Connect(function(desc)
        if not getgenv().Enabled then return end

        task.defer(function()
            if not getgenv().Enabled then return end

            for _, name in ipairs(mainGuiList) do
                if desc.Name == name and desc.Parent == playerGui then
                    desc:Destroy()
                    return
                end
            end

            if desc.Name == "_INSTANCES" and desc.Parent == playerGui then
                desc:Destroy()
                return
            end

            if desc.Parent and (desc.Parent.Name == "_MACHINES" or desc.Parent.Name == "_MISC") then
                local list = desc.Parent.Name == "_MACHINES" and machinesList or miscList
                for _, name in ipairs(list) do
                    if desc.Name == name then
                        desc:Destroy()
                        break
                    end
                end
            end
        end)
    end)

    task.spawn(function()
        while getgenv().Enabled do
            task.wait(1)
            purge()
        end
    end)
end)
