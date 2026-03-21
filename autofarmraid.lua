local scripts = {
    "deleteguis.lua", "fpsboost2.lua", "autotap.lua", 
    "automagnet.lua", "autogifts.lua", "auto%20titanic.lua", 
    "antilag.lua", "Raidfarm.lua", "turnoff3d.lua", "serverhoptime.lua", "megaspeedpets.lua"
}

local baseUrl = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

for _, scriptName in ipairs(scripts) do
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(baseUrl .. scriptName))()
        end)
        if success then
            print("Successfully loaded: " .. scriptName)
        else
            warn("Failed to load " .. scriptName .. ": " .. err)
        end
    end)
    task.wait(1.5)
end
