local baseUrl = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

local nestedScripts = {
    ["Antilag"] = "AntiLag.lua",
    ["DeleteGuis"] = "DeleteGuis.lua",
    ["Disable3d"] = "Disable3d.lua",
    ["FpsBoost2"] = "FpsBoost2.lua"
}

local rootScripts = {
    "autotap.lua", "automagnet.lua", "autogifts.lua", 
    "auto%20titanic.lua", "Raidfarm.lua", 
    "serverhoptime.lua", "megaspeedpets.lua"
}

for folder, file in pairs(nestedScripts) do
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet(baseUrl .. folder .. "/" .. file))() end)
    end)
    task.wait(0.2)
end

for _, scriptName in ipairs(rootScripts) do
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
