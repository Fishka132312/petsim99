_G.AutoCollectGifts = false

task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local network = ReplicatedStorage:WaitForChild("Network")
    local giftRemote = network:WaitForChild("Redeem Free Gift")
    
    print("Система сбора подарков готова. Ожидание (AutoCollectGifts = true)...")

    while true do
        if _G.AutoCollectGifts then
            for i = 1, 12 do
                if not _G.AutoCollectGifts then break end
                
                pcall(function()
                    giftRemote:InvokeServer(i)
                end)
                
                task.wait(0.5)
            end
            
            task.wait(60)
        else
            task.wait(1)
        end
    end
end)
