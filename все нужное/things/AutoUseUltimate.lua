_G.UseUltimate = false 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local UltimateRemote = Network:WaitForChild("Ultimates: Activate")
local UltimateCmds = require(ReplicatedStorage.Library.Client.UltimateCmds)

task.spawn(function()
    
    while true do
        task.wait(5) 

        if _G.UseUltimate then
            local equipped = UltimateCmds.GetEquippedItem()
            
            if equipped then
                local ultimateName = equipped:GetId() 
                
                local success, err = pcall(function()
                    UltimateRemote:InvokeServer(ultimateName)
                end)
                
                if success then
                    task.wait(10) 
                end
            end
        end
    end
end)
