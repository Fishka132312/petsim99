_G.CoinJarUse = false

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local coinjar = network:WaitForChild("CoinJar_Spawn")

local args = { "9cb80a1d395d48f8b9d2542752142e89" }

while true do
    if _G.CoinJarUse then
        coinjar:InvokeServer(unpack(args))
        task.wait(1)
    else
        task.wait(0.1)
    end
end
