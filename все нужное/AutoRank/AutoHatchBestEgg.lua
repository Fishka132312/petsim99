_G.AutoHatchBestEggForRank = false
_G.ReturnToPos = true 

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Network = require(Library.Client.Network)
local EggCmds = require(Library.Client.EggCmds)
local Directory = require(Library.Directory)
local Variables = require(Library.Variables)

local function IsHatching()
    if Variables.OpeningEgg and Variables.OpeningEgg > 0 then return true end
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    return playerGui and (playerGui:FindFirstChild("EggOpen") or playerGui:FindFirstChild("EggSkip"))
end

local function UnlockAllAvailableEggs()
    for eggId, info in pairs(Directory.Eggs) do
        task.spawn(function()
            pcall(function()
                game:GetService("ReplicatedStorage").Network.Eggs_RequestUnlock:InvokeServer(eggId)
            end)
        end)
    end
end

local function GetBestEggId()
    local bestId = nil
    local maxNum = -1
    for id, info in pairs(Directory.Eggs) do
        if info.eggNumber and info.eggNumber > maxNum then
            if not EggCmds.IsEggLocked(id) then
                maxNum = info.eggNumber
                bestId = id
            end
        end
    end
    return bestId, maxNum
end

local function SmartHatch()
    if IsHatching() then return end

    UnlockAllAvailableEggs()
    task.wait(0.1)

    local eggId, eggNum = GetBestEggId()
    if not eggId then return end

    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local eggModel = nil
    local things = workspace:FindFirstChild("__THINGS")
    if things then
        for _, folderName in pairs({"Eggs", "ZoneEggs", "RenderedEggs"}) do
            local folder = things:FindFirstChild(folderName)
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    if v.Name:match("^" .. tonumber(eggNum)) or v.Name == tostring(eggNum) then
                        eggModel = v; break
                    end
                end
            end
            if eggModel then break end
        end
    end

    if not eggModel then return end

    local targetPart = eggModel.PrimaryPart or eggModel:FindFirstChild("Center") or eggModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return end

    local oldPos = root.CFrame
    local distance = (root.Position - targetPart.Position).Magnitude
    local needTeleport = distance > 20

    if needTeleport then
        root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
        task.wait(0.3)
    end

    local success, err = Network.Invoke("Eggs_RequestPurchase", eggId, EggCmds.GetMaxHatch())
    
    if _G.ReturnToPos and needTeleport then
        root.CFrame = oldPos
    end
end

task.spawn(function()
    print("--- СИСТЕМА TOTAL UNLOCK + AUTO HATCH ЗАПУЩЕНА ---")
    while true do
        if _G.AutoHatchBestEggForRank then
            pcall(SmartHatch)
        end
        task.wait(0.8)
    end
end)
