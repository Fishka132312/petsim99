_G.AntiAdminEnabled = true 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library", 10)
local Signal = Library and require(Library:WaitForChild("Signal"))

local function enableCheats()
    _G.AutoFarmRaid = true
    _G.AutoTap = true
    _G.AutoSpeedPets = true
    print("Система: Фарм включен.")
    if Signal then Signal.Fire("Instance Home Clicked") end
end

local function disableCheats(reason)
    _G.AutoFarmRaid = false
    _G.AutoTap = false
    _G.AutoSpeedPets = false
    print("Система защиты: ВЫКЛЮЧЕНО. Причина: " .. reason)
    if Signal then Signal.Fire("Migration_InitAutoRaid") end
end

local function updateState()
    local playerCount = #Players:GetPlayers()
    
    if _G.AntiAdminEnabled then
        if playerCount > 1 then
            if _G.AutoFarmRaid == true then
                disableCheats("Защита активна, игроки на сервере.")
            end
        else
            if _G.AutoFarmRaid == false then
                enableCheats()
            end
        end
    else
        if _G.AutoFarmRaid == false then
            print("Система: Защита отключена вручную. Игнорирую игроков.")
            enableCheats()
        end
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    updateState()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    updateState()
end)

task.spawn(function()
    while true do
        updateState() 
        task.wait(2)
    end
end)

updateState()

local baseUrl = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

local nested = {
    {"Antilag", "AntiLag.lua"},
    {"Antilag", "Disable3d.lua"},
    {"DeleteGuis", "DeleteGuis.lua"},
    {"FpsBoost2", "FpsBoost2.lua"}
}

local rootScripts = {
    "autotap.lua",
    "automagnet.lua", 
    "autogifts.lua", 
    "autoraidupgrades.lua", 
    "Raidfarm.lua", 
    "megaspeedpets.lua",
    "antiafk.lua"
}

_G.AntiAdminEnabled = true 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library", 10)
local Signal = Library and require(Library:WaitForChild("Signal"))

local function updateState()
    local playerCount = #Players:GetPlayers()
    
    if _G.AntiAdminEnabled then
        if playerCount > 1 then
            if _G.AutoFarmRaid == true then
                disableCheats("Защита активна, игроки на сервере.")
            end
        else
            if _G.AutoFarmRaid == false then
                enableCheats()
            end
        end
    else
        if _G.AutoFarmRaid == false then
            print("Система: Защита отключена вручную. Игнорирую игроков.")
            enableCheats()
        end
    end
end

for _, data in ipairs(nested) do
    task.spawn(function()
        local folder = data[1]
        local file = data[2]
        local fullPath = baseUrl .. folder .. "/" .. file
        pcall(function() loadstring(game:HttpGet(fullPath))() end)
    end)
    task.wait(0.2)
end

for _, scriptName in ipairs(rootScripts) do
    task.spawn(function()
        local fullPath = baseUrl .. "things/" .. scriptName
        pcall(function() loadstring(game:HttpGet(fullPath))() end)
    end)
    task.wait(0.2)
end

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. "WebhooksPets/webhookPets.lua"))()
    end)
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.2)
    updateState()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    updateState()
end)

task.spawn(function()
    while true do
        updateState() 
        task.wait(0.2)
    end
end)

updateState()
