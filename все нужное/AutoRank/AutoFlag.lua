local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)
local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local ConsumeEvent = Network:WaitForChild("FlexibleFlags_Consume")

_G.UseFlag = nil

local function useFlags(amount)
    local data = Save.Get()
    if not data or not data.Inventory then 
        return 
    end
    
    local flagsInInventory = {}

    for category, items in pairs(data.Inventory) do
        for uid, item in pairs(items) do
            if item.id and string.find(tostring(item.id), "Flag") then
                table.insert(flagsInInventory, {
                    id = item.id,
                    uid = uid
                })
            end
        end
    end

    if #flagsInInventory > 0 then
        local randomSelection = flagsInInventory[math.random(1, #flagsInInventory)]
        
        for i = 1, amount do
            task.spawn(function()
                local success, err = pcall(function()
                    return ConsumeEvent:InvokeServer(randomSelection.id, randomSelection.uid)
                end)

                if not success then
                end
            end)
            task.wait(0.1)
        end
    else
    end
end

task.spawn(function()
    while true do
        if type(_G.UseFlag) == "number" and _G.UseFlag > 0 then
            local count = _G.UseFlag
            _G.UseFlag = nil
            
            useFlags(count)
        end
        task.wait(0.5)
    end
end)
