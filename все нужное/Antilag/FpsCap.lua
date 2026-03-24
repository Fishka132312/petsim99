_G.FPS_Enabled = _G.FPS_Enabled or false
_G.FPS_Value = _G.FPS_Value or 60

print("Движок FPS запущен и ждет настроек из конфига...")

task.spawn(function()
    while true do
        if _G.FPS_Enabled == true then
            setfpscap(_G.FPS_Value)
        else
            setfpscap(999)
        end
        task.wait(0.5)
    end
end)
