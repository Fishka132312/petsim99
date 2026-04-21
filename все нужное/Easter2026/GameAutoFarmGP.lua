local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library", 10)

if _G.FarmEveryWhere == nil then
    _G.FarmEveryWhere = false
end

if Library then
    local success, AutoFarmCmds = pcall(function()
        return require(Library.Client.AutoFarmCmds)
    end)

    if success and AutoFarmCmds then
        task.spawn(function()
            while true do
                local isEnabled = false
                
                pcall(function()
                    isEnabled = AutoFarmCmds.IsEnabled()
                end)

                if _G.FarmEveryWhere then
                    if not isEnabled then
                        pcall(function() AutoFarmCmds.Enable() end)
                        print("AutoFarmEveryWhere: Enabled")
                    end
                else
                    if isEnabled then
                        pcall(function() AutoFarmCmds.Disable() end)
                        print("AutoFarmEveryWhere: Disabled")
                    end
                end
                
                task.wait(1)
            end
        end)
    end
end
