_G.AutoHatchBestEggForRanks = false
_G.ReturnToPos = true 

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Network = require(Library.Client.Network)
local EggCmds = require(Library.Client.EggCmds)
local Directory = require(Library.Directory)
local Variables = require(Library.Variables)
local CurrencyCmds = require(Library.Client.CurrencyCmds)
local Balancing = require(Library.Balancing)

local function IsHatching()
    if Variables.OpeningEgg and Variables.OpeningEgg > 0 then return true end
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and (playerGui:FindFirstChild("EggOpen") or playerGui:FindFirstChild("EggSkip")) then return true end
    return false
end

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
    return bestId, maxNum
end

local function SmartHatch()
    if IsHatching() then return end

    local player = game.Players.LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local oldPos = root.CFrame
    local eggId, eggNum = GetBestEgg()
    if not eggId then return end

    local eggData = Directory.Eggs[eggId]
    if eggData and eggData.currency then
        local success, price = pcall(function() 
            return Balancing.CalcEggPrice(eggId, EggCmds.GetMaxHatch()) 
        end)
        
        if not success then
            success, price = pcall(function() return Balancing.GetEggPrice(eggId) end)
        end

        local myMoney = CurrencyCmds.Get(eggData.currency)
        
        if success and myMoney < price then
            return 
        end
    end

    local eggModel = nil
    local things = game.Workspace:FindFirstChild("__THINGS")
    
    if things then
        local foldersToSearch = {
            things:FindFirstChild("Eggs"),
            things:FindFirstChild("ZoneEggs"),
            things:FindFirstChild("RenderedEggs")
        }

        for _, folder in pairs(foldersToSearch) do
            if folder then
                for _, v in pairs(folder:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:match("^" .. tonumber(eggNum)) or v.Name == tostring(eggNum)) then
                        eggModel = v
                        break
                    end
                end
            end
            if eggModel then break end
        end
    end

    if not eggModel then return end

    local targetPart = eggModel.PrimaryPart or eggModel:FindFirstChild("Center") or eggModel:FindFirstChild("Tier") or eggModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return end

    local distance = (root.Position - targetPart.Position).Magnitude
    local needTeleport = distance > 20

    if needTeleport then
        _G.Teleportbestlocationaccept = tick() + 8
        root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
        task.wait(0.2)
    end

    local success, err = Network.Invoke("Eggs_RequestPurchase", eggId, EggCmds.GetMaxHatch())
    
    if _G.ReturnToPos and needTeleport then
        root.CFrame = oldPos
    end

    if not success and err then
        warn("Ошибка покупки: " .. tostring(err))
    end
end

task.spawn(function()
    print("--- СИСТЕМА AUTO-HATCH ЗАПУЩЕНА ---")
    while true do
        if _G.AutoHatchBestEggForRanks then
            local ok, err = pcall(SmartHatch)
            if not ok then 
                warn("Критическая ошибка цикла: " .. tostring(err)) 
            end
        end
        task.wait(0.5)
    end
end)
