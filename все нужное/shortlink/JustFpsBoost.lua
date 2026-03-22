local base = "https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/"

for _,v in ipairs({"fpsboost2.lua","petsoptimizer.lua","antilag.lua","deleteguis.lua"}) do
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(base..v))()
        end)
    end)
    task.wait(1)
end
