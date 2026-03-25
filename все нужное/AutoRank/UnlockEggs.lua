local UNLOCK_INTERVAL = 2

local Library = game.ReplicatedStorage:WaitForChild("Library")
local Directory = require(Library.Directory)
local Network = require(Library.Client.Network)

print("--- СЕРВИС AUTO-UNLOCK ЗАПУЩЕН ---")

local function UnlockEverything()
    local count = 0
    for eggId, info in pairs(Directory.Eggs) do
        task.spawn(function()
            local success = pcall(function()
                game:GetService("ReplicatedStorage").Network.Eggs_RequestUnlock:InvokeServer(eggId)
            end)
            if success then count = count + 1 end
        end)
    end
end

task.spawn(function()
    while true do
        local ok, err = pcall(UnlockEverything)
        if not ok then 
            warn("Ошибка в цикле Unlocker: " .. tostring(err)) 
        end
        task.wait(UNLOCK_INTERVAL)
    end
end)
