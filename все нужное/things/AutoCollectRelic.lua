local WAIT_TIME = 0
local SAFE_OFFSET = Vector3.new(0, 1.2, 0)

if _G.RelicCollecting then return end 
_G.RelicCollecting = true

local lp = game.Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local RequestRelics = Network:WaitForChild("Relics_Request")

local screenGui = Instance.new("ScreenGui", pgui)
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0

local bgGradient = Instance.new("UIGradient", mainFrame)
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})
bgGradient.Rotation = 45

local loadingIcon = Instance.new("ImageLabel", mainFrame)
loadingIcon.Size = UDim2.new(0, 120, 0, 120)
loadingIcon.Position = UDim2.new(0.5, -60, 0.4, -60)
loadingIcon.BackgroundTransparency = 1
loadingIcon.Image = "rbxassetid://89214299641781"

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(0, 300, 0, 30)
statusLabel.Position = UDim2.new(0.5, -150, 0.4, 70)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextSize = 18
statusLabel.Text = "Collecting Relics: 0 / 0"

local barBackground = Instance.new("Frame", mainFrame)
barBackground.Size = UDim2.new(0.4, 0, 0, 14)
barBackground.Position = UDim2.new(0.3, 0, 0.85, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBackground.BorderSizePixel = 0

local barCorner = Instance.new("UICorner", barBackground)
barCorner.CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame", barBackground)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
barFill.BorderSizePixel = 0

local fillCorner = Instance.new("UICorner", barFill)
fillCorner.CornerRadius = UDim.new(1, 0)

local fillGradient = Instance.new("UIGradient", barFill)
fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 100))
})
local function createPlatform(pos)
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.CFrame = CFrame.new(pos - Vector3.new(0, 4, 0))
    part.Anchored = true
    part.Transparency = 0.5
    part.Color = Color3.new(1, 1, 1)
    part.Parent = workspace
    return part
end

local function collectWithClick()
    local success, allRelics = pcall(function() return RequestRelics:InvokeServer() end)
    if not success or not allRelics then 
        screenGui:Destroy()
        return 
    end

    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local originalCFrame = root.CFrame 
    
    local relicFolder = workspace:WaitForChild("__THINGS"):WaitForChild("ShinyRelics")

    local total = 0
    for _ in pairs(allRelics) do total = total + 1 end
    local current = 0

    local plat = createPlatform(root.Position)

    for id, data in pairs(allRelics) do
        current = current + 1
        barFill:TweenSize(UDim2.new(current/total, 0, 1, 0), "Out", "Quart", 0.3)
        statusLabel.Text = "Collecting Relics: " .. current .. " / " .. total
        
        local targetPos = (typeof(data.Position) == "CFrame") and data.Position.Position or data.Position
        
        root.Velocity = Vector3.new(0,0,0)
        plat.CFrame = CFrame.new(targetPos - Vector3.new(0, 3.5, 0))
        root.CFrame = CFrame.new(targetPos + SAFE_OFFSET)
        
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPos)
        
        task.wait(0)

        local targetModel = nil
        for _, obj in pairs(relicFolder:GetChildren()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) then
                if (obj:GetPivot().Position - targetPos).Magnitude < 5 then
                    targetModel = obj
                    break
                end
            end
        end

        if targetModel then
            local cd = targetModel:FindFirstChildWhichIsA("ClickDetector", true)
            if cd then
                fireclickdetector(cd)
            end
        end

        task.wait(WAIT_TIME)
    end
    
    root.CFrame = originalCFrame
    
    _G.RelicCollecting = false
    plat:Destroy()
    mainFrame:TweenPosition(UDim2.new(0, 0, 1, 0), "In", "Quad", 0.5)
    task.wait(0.5)
    screenGui:Destroy()
end

task.spawn(collectWithClick)
