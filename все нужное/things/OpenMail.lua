_G.OpenMail = false

local player = game:GetService("Players").LocalPlayer
local mailbox = player.PlayerGui:WaitForChild("_MACHINES"):WaitForChild("MailboxMachine")
local runService = game:GetService("RunService")

runService.RenderStepped:Connect(function()
    local targetState = _G.OpenMail
    
    if mailbox:IsA("ScreenGui") then
        if mailbox.Enabled ~= targetState then
            mailbox.Enabled = targetState
        end
    else
        if mailbox.Visible ~= targetState then
            mailbox.Visible = targetState
        end
    end
end)
