local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local oldGui = player.PlayerGui:FindFirstChild("PetTracker_V3")
if oldGui then
    oldGui:Destroy()
end

local Directory = require(game.ReplicatedStorage.Library.Directory)
local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)
local ItemLib = require(game.ReplicatedStorage.Library.Items.PetItem)


_G.PetDisplayID = tick()
local currentID = _G.PetDisplayID
local startTime = os.time()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PetTracker_V3"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")


local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 480)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)

UIStroke.Color = Color3.fromRGB(255, 145, 0)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PET INVENTORY TRACKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 180, 0, 35)
ProfileFrame.Position = UDim2.new(0, 10, 1, -40)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 30, 0, 30)
AvatarImg.Position = UDim2.new(0, 0, 0.5, -15)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.Image = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImg.Parent = ProfileFrame
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local AvatarStroke = Instance.new("UIStroke", AvatarImg)
AvatarStroke.Color = Color3.fromRGB(255, 145, 0)
AvatarStroke.Thickness = 1.5

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -35, 1, 0)
UsernameLabel.Position = UDim2.new(0, 35, 0, 0)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = player.DisplayName
UsernameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextSize = 12
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.Parent = ProfileFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    _G.PetDisplayID = nil 
task.wait(0.1)
    ScreenGui:Destroy()
end)

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 150, 0, 25)
TimerLabel.Position = UDim2.new(1, -160, 1, -35)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "Time: 00:00:00"
TimerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TimerLabel.Font = Enum.Font.Code
TimerLabel.TextSize = 14
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 145, 0)
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.Padding = UDim.new(0, 8)

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
makeDraggable(MainFrame)

local function createPetRow(name, amount, iconId, pt)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -8, 0, 60)
    Row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Row.BorderSizePixel = 0
    Instance.new("UICorner", Row)
    
    local Stroke = Instance.new("UIStroke", Row)
    Stroke.Thickness = 1
    if pt == 1 then Stroke.Color = Color3.fromRGB(255, 215, 0)
    elseif pt == 2 then Stroke.Color = Color3.fromRGB(0, 255, 255)
    else Stroke.Color = Color3.fromRGB(60, 60, 60) end

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, 5, 0.5, -25)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId 
    Icon.Parent = Row
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -120, 1, 0)
    NameLabel.Position = UDim2.new(0, 65, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Row
    
    local CountLabel = Instance.new("TextLabel")
    CountLabel.Size = UDim2.new(0, 50, 1, 0)
    CountLabel.Position = UDim2.new(1, -60, 0, 0)
    CountLabel.BackgroundTransparency = 1
    CountLabel.Text = "x" .. amount
    CountLabel.TextColor3 = Color3.fromRGB(255, 145, 0)
    CountLabel.Font = Enum.Font.GothamBold
    CountLabel.TextSize = 18
    CountLabel.TextXAlignment = Enum.TextXAlignment.Right
    CountLabel.Parent = Row
    
    return Row
end

local function updateInventory()
    local Save = SaveModule.Get()
    if not Save or not Save.Inventory or not Save.Inventory.Pet then return end
    
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local petGroups = {}

    for _, data in pairs(Save.Inventory.Pet) do
        local id = data.id
        if id and (id:lower():find("huge") or id:lower():find("titanic")) then
            local key = id 
            
            if not petGroups[key] then
                local petObject = ItemLib(id)
                
                local iconId = ""
                pcall(function()
                    iconId = petObject:GetIcon()
                end)
                
                if iconId == "" then
                    local petData = Directory.Pets[id]
                    iconId = petData and (petData.Icon or petData.Thumbnail) or ""
                end

                petGroups[key] = {
                    name = id,
                    amount = 0,
                    icon = iconId,
                    pt = 0
                }
            end
            petGroups[key].amount = petGroups[key].amount + (data._am or 1)
        end
    end
    
    for _, info in pairs(petGroups) do
        createPetRow(info.name, info.amount, info.icon, info.pt).Parent = Scroll
    end
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

task.spawn(function()
    while _G.PetDisplayID == currentID do
        local diff = os.time() - startTime
        local h, m, s = math.floor(diff/3600), math.floor((diff%3600)/60), diff%60
        TimerLabel.Text = string.format("Session Time: %02d:%02d:%02d", h, m, s)
        
        pcall(updateInventory)
        
        task.wait(5)
    end
end)

print("--- Inventory Tracker V3 Loaded (Icons Fixed) ---")