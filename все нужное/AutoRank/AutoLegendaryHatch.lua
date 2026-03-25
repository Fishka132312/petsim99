_G.AutoHatchForLegendaryRank = true 
_G.ReturnToPos = true 

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Network = require(Library.Client.Network)
local EggCmds = require(Library.Client.EggCmds)
local Directory = require(Library.Directory)
local Variables = require(Library.Variables)

local function IsHatching()
    if Variables.OpeningEgg and Variables.OpeningEgg > 0 then return true end
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and (playerGui:FindFirstChild("EggOpen") or playerGui:FindFirstChild("EggSkip")) then return true end
    return false
end

local function GetBestEgg()
    local maxNum = -1
    for id, info in pairs(Directory.Eggs) do
        if info and info.eggNumber and type(info.eggNumber) == "number" then
            if not EggCmds.IsEggLocked(id) then
                if info.eggNumber > maxNum then
                    maxNum = info.eggNumber
                end
            end
        end
    end

    local targetNum = maxNum > 1 and (maxNum - 1) or maxNum
    local targetId = nil

    for id, info in pairs(Directory.Eggs) do
        if info.eggNumber == targetNum then
            targetId = id
            break
        end
    end
    return targetId, targetNum
end

local function SmartHatch()
    if IsHatching() then return end

    local eggId, eggNum = GetBestEgg()
    if not eggId then return end

    local player = game.Players.LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local oldPos = root.CFrame
    local eggModel = nil
    local things = game.Workspace:FindFirstChild("__THINGS")
    
    if things then
        local folders = {things:FindFirstChild("Eggs"), things:FindFirstChild("ZoneEggs"), things:FindFirstChild("RenderedEggs")}
        for _, folder in pairs(folders) do
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

    local teleported = false
  
    if eggModel then
        local targetPart = eggModel.PrimaryPart or eggModel:FindFirstChild("Center") or eggModel:FindFirstChild("Tier") or eggModel:FindFirstChildWhichIsA("BasePart")
        if targetPart then
            local distance = (root.Position - targetPart.Position).Magnitude
            if distance > 20 then
                _G.Teleportbestlocationaccept = tick() + 8
                root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
                teleported = true
                task.wait(0.3)
            end
        end
    end
    local success, err = Network.Invoke("Eggs_RequestPurchase", eggId, EggCmds.GetMaxHatch())
    
    if _G.ReturnToPos and teleported then
        root.CFrame = oldPos
    end

    if not success and err then
        warn("Ошибка покупки: " .. tostring(err))
    end
end

task.spawn(function()
    while true do
        if _G.AutoHatchForLegendaryRank then
            pcall(SmartHatch)
        end
        task.wait(0.6)
    end
end)
