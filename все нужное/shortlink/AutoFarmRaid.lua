local baseUrl = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

local scripts = {
    "deleteguis.lua", "fpsboost2.lua", "autotap.lua", 
    "automagnet.lua", "autogifts.lua", "auto%20titanic.lua", 
    "antilag.lua", "Raidfarm.lua", "turnoff3d.lua", 
    "serverhoptime.lua", "megaspeedpets.lua"
}

for _, scriptName in ipairs(scripts) do
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet(baseUrl .. scriptName))() end)
    end)
    task.wait(0.2)
end

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet(baseUrl .. "WebhooksPets/webhookPets.lua"))()
    end)
end)

print("--- [Hub]: Все системы запущены! ---")