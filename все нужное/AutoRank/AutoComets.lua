_G.CometUse = false

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local comet = network:WaitForChild("Comet_Spawn")

local args = { "171d402a1ea141fc97bfe3b3eb6231cb" }

while true do
    if _G.CometUse then
        comet:InvokeServer(unpack(args))
    end
    
    task.wait(1)
end
