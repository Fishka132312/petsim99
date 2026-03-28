local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")

_G.ClaimMail = false 

local function ultraClaim()
    if Network:FindFirstChild("Mailbox: Open") then
        Network["Mailbox: Open"]:FireServer()
    end
    task.wait(0.5)

    if Network:FindFirstChild("Index: Request Hatch Count") then
        Network["Index: Request Hatch Count"]:InvokeServer()
    end
    task.wait(0.5)

    local claimAll = Network:FindFirstChild("Mailbox: Claim All")
    if claimAll then
        local success = claimAll:InvokeServer()
        if success then
        end
    end

    local req = Network:FindFirstChild("Mailbox: Request")
    if req then
        local success, data = req:InvokeServer()
        if success and data and data.Inbox and #data.Inbox > 0 then
            for _, v in ipairs(data.Inbox) do
                Network["Mailbox: Claim"]:InvokeServer({{v.uuid}})
                task.wait(0.3)
            end
        end
    end
    
    if Network:FindFirstChild("Mailbox: Close") then
        Network["Mailbox: Close"]:FireServer()
    end
end

task.spawn(function()
    
    while true do
        if _G.ClaimMail then
            local ok, err = pcall(ultraClaim)
            if not ok then
            end
        end
        
        task.wait(10) 
    end
end)
