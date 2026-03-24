_G.AutoCollectRANK = false

task.spawn(function()
    local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
    local remote = network:WaitForChild("Ranks_ClaimReward")
    
    print("Система сбора рангов загружена. Ожидание (AutoCollectRANK = true)...")

    while true do
        if _G.AutoCollectRANK then
            print("--- ЗАПУЩЕН СБОР РАНГОВ (1-20) ---")

            for i = 1, 20 do
                if not _G.AutoCollectRANK then break end
                
                remote:FireServer(i)
                
                task.wait(0.2) 
            end
            
            task.wait(5)
        else
            task.wait(1)
        end
    end
end)
