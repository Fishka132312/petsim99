_G.EatFruitsAndToys = false

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)

local toys = {
    "SqueakyToy_Consume",
    "ToyBall_Consume",
    "ToyBone_Consume"
}

local function getMyFruits()
    local data = Save.Get()
    if data and data.Inventory and data.Inventory.Fruit then
        local list = {}
        for hashID, _ in pairs(data.Inventory.Fruit) do
            table.insert(list, hashID)
        end
        return list
    end
    return {}
end

task.spawn(function()    
    while true do
        if _G.EatFruits then
            
            local fruits = getMyFruits()
            if #fruits > 0 then
                for _, fruitHash in ipairs(fruits) do
                    if not _G.EatFruits then break end
                    Network.Fire("Fruits: Consume", fruitHash, 1)
                    task.wait(0.1)
                end
            end
            
            if _G.EatFruits then
                for _, toyRemote in ipairs(toys) do
                    if not _G.EatFruits then break end
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Network[toyRemote]:InvokeServer()
                    end)
                    
                    task.wait(0.5)
                end
            end
            
            task.wait(2)
        else
            task.wait(1) 
        end
    end
end)
