local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library", 10)

if Library then
    local success, AutoFarmCmds = pcall(function()
        return require(Library.Client.AutoFarmCmds)
    end)

    if success and AutoFarmCmds then
        pcall(function()
            if not AutoFarmCmds.IsEnabled() then
                AutoFarmCmds.Enable()
            else
                print("da blya")
            end
        end)
    end
end
