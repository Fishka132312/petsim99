local function safeLoad(url)
    local success, res = pcall(function()
        return game:HttpGet(url)
    end)
    if success and res then
        local func, err = loadstring(res)
        if func then
            pcall(func)
            print("Loaded successfully")
        else
            warn("Syntax error in script: " .. err)
        end
    else
        warn("Failed to fetch script from URL")
    end
end

safeLoad('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/deleteguis.lua')
task.wait(1.5)

safeLoad('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/fpsboost2.lua')
task.wait(1.5)

safeLoad('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/antilag.lua')
