if _G.CraftRaidKeys == nil then
    _G.CraftRaidKeys = false
end

task.spawn(function()
    print("Автокрафт ключей запущен!")
    
    while true do
        if _G.CraftRaidKeys then
            local args = { 10 }
            
            pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Network")
                    :WaitForChild("LuckyRaidBossKey_Combine")
                    :InvokeServer(unpack(args))
            end)
            
            task.wait(10)
        else
            task.wait(1)
        end
    end
end)
