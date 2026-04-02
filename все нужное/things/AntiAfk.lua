local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer

print("-=0=")

LP.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

task.spawn(function()
    while true do
        task.wait(math.random(20, 40))
        
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.2)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        
        VirtualUser:Button1Down(Vector2.new(100, 100))
        task.wait(0.1)
        VirtualUser:Button1Up(Vector2.new(100, 100))
        
    end
end)
