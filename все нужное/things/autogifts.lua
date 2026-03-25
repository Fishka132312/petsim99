_G.AutoCollectGifts = true

task.spawn(function()
    local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
    local giftRemote = network:WaitForChild("Redeem Free Gift")
    

    while _G.AutoCollectGifts do
        for i = 1, 12 do
            if not _G.AutoCollectGifts then break end
            
            task.spawn(function()
                pcall(function()
                    giftRemote:InvokeServer(i)
                end)
            end)
            
            task.wait(0.3) 
        end
        
        task.wait(10)
    end
end)