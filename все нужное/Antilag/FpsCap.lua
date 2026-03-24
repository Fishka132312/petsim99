_G.FPS_Enabled = false
_G.FPS_Value = 60

task.spawn(function()
    while true do
        if _G.FPS_Enabled then
            setfpscap(tonumber(_G.FPS_Value) or 60)
        else
            setfpscap(999)
        end
        task.wait(0.5)
    end
end)
