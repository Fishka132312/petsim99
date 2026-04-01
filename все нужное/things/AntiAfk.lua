local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local VirtualInputManager = game:GetService("VirtualInputManager")


task.spawn(function()
    while true do
        local randomTime = math.random(5, 15) + math.random()
        Network.Fire("Idle Tracking: Update Timer", randomTime)
        
        Network.Fire("Idle Tracking: Focus Changed", true)
        
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)

        task.wait(math.random(15, 25))
    end
end)

local oldFire = Network.Fire
Network.Fire = function(self, name, ...)
    if name == "Idle Tracking: Stop Timer" then
        return
    end
    return oldFire(self, name, ...)
end
