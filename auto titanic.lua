_G.LuckyRaidBossTitanicChances = true

task.spawn(function()
    while _G.LuckyRaidBossTitanicChances do
        local args = {"LuckyRaidBossTitanicChances"}
        
        local network = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
        if network then
            local remote = network:FindFirstChild("EventUpgrades: Purchase")
            if remote then
                remote:InvokeServer(unpack(args))
            end
        end
        
        task.wait(5)
    end
end)