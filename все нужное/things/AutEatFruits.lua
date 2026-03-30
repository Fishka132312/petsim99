_G.EatFruits = false
local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)

local function getMyFruits()
    local data = Save.Get()
    local fruitList = {}
    
    if data and data.Inventory and data.Inventory.Fruit then
        for hashID, _ in pairs(data.Inventory.Fruit) do
            table.insert(fruitList, hashID)
        end
    end
    return fruitList
end

task.spawn(function()
    
    while _G.EatFruits do
        local fruits = getMyFruits()
        
        if #fruits > 0 then
            for _, fruitHash in ipairs(fruits) do
                if not _G.EatFruits then break end
                
                Network.Fire("Fruits: Consume", fruitHash, 1)
                
                task.wait(0.1) 
            end
        else
            task.wait(5)
        end
        
        task.wait(0.5)
    end
end)
