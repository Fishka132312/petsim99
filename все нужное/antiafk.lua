local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

while true do
    task.wait(300)
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        task.wait(0.5)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        
        task.wait(0.2)
        
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
        task.wait(0.5)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
    end
end
