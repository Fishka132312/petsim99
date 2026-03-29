_G.AutoHatchBestEgg = false
_G.ReturnToPos = true 

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Network = require(Library.Client.Network)
local EggCmds = require(Library.Client.EggCmds)
local Directory = require(Library.Directory)
local Variables = require(Library.Variables)
local CurrencyCmds = require(Library.Client.CurrencyCmds)
local CalcEggPricePlayer = require(Library.Balancing.CalcEggPricePlayer)

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

local farmPos = nil

local function SmartHatch()
    if IsHatching() then return end

    local player = game.Players.LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local eggId, eggNum = GetBestEgg()
    if not eggId then return end

    local eggModel = nil
    local things = game.Workspace:FindFirstChild("__THINGS")
    
    if things then
        local folders = {
            things:FindFirstChild("Eggs"), 
            things:FindFirstChild("ZoneEggs"), 
            things:FindFirstChild("RenderedEggs")
        }
        
        for _, folder in pairs(folders) do
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    local name = v.Name
                    local onlyNumber = name:match("^(%d+)")
                    
                    if onlyNumber and tonumber(onlyNumber) == tonumber(eggNum) then
                        eggModel = v
                        break
                    elseif name:find("^" .. eggNum .. " ") or name == tostring(eggNum) then
                        eggModel = v
                        break
                    end
                end
            end
            if eggModel then break end
        end
    end

    if not eggModel and things:FindFirstChild("Eggs") then
        for _, v in pairs(things.Eggs:GetDescendants()) do
            if v:IsA("Model") and v.Name:match("^" .. eggNum) then
                eggModel = v
                break
            end
        end
    end

    if not eggModel then 
        warn("Критическая ошибка: Яйцо #" .. tostring(eggNum) .. " не найдено в мире!")
        return 
    end
    
    local targetPart = eggModel.PrimaryPart or eggModel:FindFirstChild("Center") or eggModel:FindFirstChild("Tier") or eggModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return end

    local oldPos = root.CFrame
    local distance = (root.Position - targetPart.Position).Magnitude
    local needTeleport = distance > 15

    if needTeleport then
        _G.Teleportbestlocationaccept = tick() + 8
        root.CFrame = targetPart.CFrame * CFrame.new(0, 4, 6) 
        task.wait(0.5)
    end

    local success, err = Network.Invoke("Eggs_RequestPurchase", eggId, EggCmds.GetMaxHatch())
    
    if _G.ReturnToPos and needTeleport then
        task.wait(0.2)
        root.CFrame = oldPos
    end

    if not success then
        local errorMsg = tostring(err)
        
        if _G.ReturnToPos then
            root.CFrame = oldPos
        end

        task.wait(5)
    end
end

task.spawn(function()
    while true do
        if _G.AutoHatchBestEgg then
            local ok, err = pcall(SmartHatch)
            if not ok then 
                warn("Критическая ошибка цикла: " .. tostring(err)) 
            end
        end
        task.wait(0.5)
    end
end)
