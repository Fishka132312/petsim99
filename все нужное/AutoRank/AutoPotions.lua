local v_u_5 = require(game.ReplicatedStorage.Library.Items)
local v_u_10 = require(game.ReplicatedStorage.Library.Client.InventoryCmds)
local v_u_17 = require(game.ReplicatedStorage.Library.Client.Network)

local function usePotion(targetTier)
    local inventory = v_u_10.Container()
    if not inventory then return end

    local allPotions = inventory:All(v_u_5.Potion)
    local targetUID = nil
    
    for uid, item in pairs(allPotions) do
        local data = item._data
        if not data then continue end

        local id = data.id or ""
        local tier = data.tn or data.Tier or data._tn or data.tier
        
        if not tier then
            local digit = string.match(id, "%d+")
            tier = tonumber(digit)
        end

        if tonumber(tier) == tonumber(targetTier) then
            targetUID = uid
            break
        end
    end

    if targetUID then
        v_u_17.Fire("Potions: Consume", targetUID)
    else
    end
end


_G.PotionToUse = nil 


task.spawn(function()
    while true do
        if _G.PotionToUse ~= nil and type(_G.PotionToUse) == "number" then
            local requestedTier = _G.PotionToUse
            
            usePotion(requestedTier)
            
            _G.PotionToUse = nil 
            print("reset")
        end
        task.wait(0.5)
    end
end)
