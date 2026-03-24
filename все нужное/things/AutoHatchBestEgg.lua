_G.AutoHatchBestEgg = false
_G.ReturnToPos = true 

local Library = game.ReplicatedStorage:WaitForChild("Library")
local HatchingCmds = require(game.ReplicatedStorage.Library.Client.HatchingCmds)
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
    local bestId = nil
    local maxNum = -1
    local foundAny = false
    
    for id, info in pairs(Directory.Eggs) do
        foundAny = true
        if info and info.eggNumber and not EggCmds.IsEggLocked(id) then
            if info.eggNumber > maxNum then
                maxNum = info.eggNumber
                bestId = id
            end
        end
    end
    
    if not foundAny then warn("!!! Таблица Directory.Eggs пуста или не загружена") end
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

    local eggModel = nil
    local things = game.Workspace:FindFirstChild("__THINGS")
    
    if things then
        local foldersToSearch = {
            things:FindFirstChild("Eggs"),
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

    if not eggModel then 
        warn("Модель яйца №" .. eggNum .. " не найдена в Workspace, пропускаю ТП.")
        return 
    end

    local targetPart = eggModel.PrimaryPart or eggModel:FindFirstChild("Center") or eggModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return end

    local distance = (root.Position - targetPart.Position).Magnitude

    if distance > 20 then
        print("Лечу к яйцу " .. eggNum .. "...")
        root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
        task.wait(0.2)
    end

    local success, err = Network.Invoke("Eggs_RequestPurchase", eggId, EggCmds.GetMaxHatch())
    
    if _G.ReturnToPos and distance > 15 then
        root.CFrame = oldPos
    end

    if not success then
        warn("Ошибка покупки: " .. tostring(err))
    end
end

task.spawn(function()
    print("--- ЗАПУСК ДИАГНОСТИКИ ---")
    while true do
        if _G.AutoHatchBestEgg then
            local ok, err = pcall(SmartHatch)
            if not ok then warn("ОШИБКА: " .. tostring(err)) end
        end
        task.wait(1)
    end
end)
