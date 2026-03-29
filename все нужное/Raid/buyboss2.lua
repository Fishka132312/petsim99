while true do
local args = {

2


}


game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Raids_BossChallenge"):InvokeServer(unpack(args))
wait(2)
end
