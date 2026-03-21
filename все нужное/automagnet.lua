_G.AutoMagnet = true

task.spawn(function()
    while true do
        task.wait(0.3)
        
        if _G.AutoMagnet then
            local things = workspace:FindFirstChild("__THINGS")
            local orbs = things and things:FindFirstChild("Orbs")
            
            if orbs then
                local allOrbs = orbs:GetChildren()
                
                for _, orb in pairs(allOrbs) do
                    if not _G.AutoMagnet then break end
                    
                    local orbName = tonumber(orb.Name)
                    if orbName then
                        local network = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
                        local collectRemote = network and network:FindFirstChild("Orbs: Collect")
                        
                        if collectRemote then
                            collectRemote:FireServer({[1] = orbName})
                        end
                        
                        orb:Destroy()
                    end
                end
            end
        end
    end
end)