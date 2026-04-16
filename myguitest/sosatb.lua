local UILib = {}
UILib.Flags = {}

local CONFIG_FILE = "MyUI_Config.json"
local HttpService = game:GetService("HttpService")

function UILib:LoadConfig()
	if isfile and isfile(CONFIG_FILE) then
		self.Flags = HttpService:JSONDecode(readfile(CONFIG_FILE))
	end
end

function UILib:SaveConfig()
	if writefile then
		writefile(CONFIG_FILE, HttpService:JSONEncode(self.Flags))
	end
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

UILib:LoadConfig()

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyUI"
ScreenGui.Parent = game.CoreGui

-- MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 360)
Main.Position = UDim2.new(0.5, -280, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Parent = ScreenGui
Main.ClipsDescendants = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Transparency = 0.6
Stroke.Color = Color3.fromRGB(255,255,255)

-- ГРАДИЕНТ
local Gradient = Instance.new("UIGradient", Main)
Gradient.Rotation = 90
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(28,28,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
}

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "My UI ✨"
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0,15,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- TOP BUTTONS
local function TopButton(text, pos, hoverColor)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0,28,0,28)
	Btn.Position = pos
	Btn.Text = text
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 14
	Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Parent = TopBar
	
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = hoverColor
		}):Play()
	end)

	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(30,30,30)
		}):Play()
	end)

	return Btn
end

local Close = TopButton("✕", UDim2.new(1,-40,0,7), Color3.fromRGB(255,80,80))
local Min = TopButton("—", UDim2.new(1,-75,0,7), Color3.fromRGB(80,120,255))

Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- DRAG
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- MINIMIZE
local minimized = false
Min.MouseButton1Click:Connect(function()
	minimized = not minimized

	TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = minimized and UDim2.new(0, 200, 0, 42) or UDim2.new(0, 560, 0, 360)
	}):Play()
end)

-- TABS
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0,150,1,-42)
Tabs.Position = UDim2.new(0,0,0,42)
Tabs.BackgroundColor3 = Color3.fromRGB(22,22,22)
Tabs.Parent = Main

Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0,10)

local TabList = Instance.new("UIListLayout", Tabs)
TabList.Padding = UDim.new(0,8)

-- CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-150,1,-42)
Content.Position = UDim2.new(0,150,0,42)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- CREATE TAB
function UILib:CreateTab(name)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1,-12,0,34)
	Btn.Text = name
	Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 14
	Btn.Parent = Tabs

	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1,0,1,0)
	Frame.Visible = false
	Frame.BackgroundTransparency = 1
	Frame.Parent = Content

	local Layout = Instance.new("UIListLayout", Frame)
	Layout.Padding = UDim.new(0,8)

	Btn.MouseButton1Click:Connect(function()
		for _,v in pairs(Content:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		Frame.Visible = true
	end)

	return Frame
end

-- BUTTON
function UILib:AddButton(parent, text, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1,-12,0,36)
	Btn.Text = text
	Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Btn.TextColor3 = Color3.fromRGB(220,220,220)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 14
	Btn.Parent = parent

	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(45,45,45)
		}):Play()
	end)

	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(35,35,35)
		}):Play()
	end)

	Btn.MouseButton1Click:Connect(callback)
end

-- TOGGLE
function UILib:AddToggle(parent, text, flag, callback)
	local value = UILib.Flags[flag] or false

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1,-12,0,36)
	Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 14
	Btn.Parent = parent

	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

	local function Update()
		Btn.Text = text .. (value and "  ●" or "  ○")

		TweenService:Create(Btn, TweenInfo.new(0.25), {
			BackgroundColor3 = value and Color3.fromRGB(0,180,120) or Color3.fromRGB(35,35,35)
		}):Play()
	end

	Update()

	Btn.MouseButton1Click:Connect(function()
		value = not value
		UILib.Flags[flag] = value
		UILib:SaveConfig()
		Update()
		callback(value)
	end)

	callback(value)
end

return UILib
