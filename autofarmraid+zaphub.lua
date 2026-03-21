local base = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

local scripts = {
    "deleteguis.lua",
    "fpsboost2.lua",
    "autotap.lua",
    "automagnet.lua",
    "autogifts.lua",
    "auto%20titanic.lua",
    "antilag.lua",
    "Raidfarm.lua",
    "turnoff3d.lua",
    "Raidfarm.lua",
    "serverhoptime.lua",
    "zaphub.lua"
}

for _,v in ipairs(scripts) do
    pcall(function()
        loadstring(game:HttpGet(base..v))()
    end)
    task.wait(1)
end
