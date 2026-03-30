_G.UseConsumables = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local ConsumeRemote = Network:WaitForChild("Consumables_Consume")
local SaveModule = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save"))

task.spawn(function()
    while true do
        if _G.UseConsumables then
            local save = SaveModule.Get()
            
            if save and save.Inventory and save.Inventory.Consumable then
                for id, data in pairs(save.Inventory.Consumable) do
                    if not _G.UseConsumables then break end

                    local itemHash = data._id or id
                    local itemName = data.id or "Unknown"

                    local success, err = pcall(function()
                        ConsumeRemote:InvokeServer(tostring(itemHash), 1)
                    end)

                    if not success then
                    end

                    task.wait(0.3) 
                end
            end
        end
        
        task.wait(2) 
    end
end)
