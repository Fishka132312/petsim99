_G.AutoOpenEaster2026 = false

local args = {
    "EasterHatchEvent",
    "HatchRequest"
}

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_InvokeCustomFromClient")

if not _G.ScriptRunning then
    _G.ScriptRunning = true
    
    task.spawn(function()
        while true do
            if _G.AutoOpenEaster2026 then
                -- Вызываем сервер
                network:InvokeServer(unpack(args))
                -- Минимальная задержка, чтобы не крашнуло
                task.wait(0.05) 
            else
                -- Если выключено, ждем чуть дольше перед следующей проверкой переменной
                task.wait(1)
            end
        end
    end)
end