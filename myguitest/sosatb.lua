local UILib = {}
UILib.Flags = {}

local CONFIG_FILE = "MyUI_Config.json"

local HttpService = game:GetService("HttpService")

function UILib:LoadConfig()
	if isfile and isfile(CONFIG_FILE) then
		local data = readfile(CONFIG_FILE)
		local decoded = HttpService:JSONDecode(data)
		self.Flags = decoded
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

local Player = Players.LocalPlayer
UILib:LoadConfig()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyUI"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 320)
Main.Position = UDim2.new(0.5, -260, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Parent = ScreenGui
Main.ClipsDescendants = true

Instance.new("UICorner", Main)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TopBar.Parent = Main

Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel")
Title.Text = "My UI"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,30,1,0)
Close.Position = UDim2.new(1,-30,0,0)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200,60,60)
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = TopBar

Instance.new("UICorner", Close)

local Min = Instance.new("TextButton")
Min.Size = UDim2.new(0,30,1,0)
Min.Position = UDim2.new(1,-60,0,0)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(60,60,60)
Min.TextColor3 = Color3.new(1,1,1)
Min.Parent = TopBar

Instance.new("UICorner", Min)

local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

TopBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local delta = input.Position - dragStart
			Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

local minimized = false

Min.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		TweenService:Create(Main, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 200, 0, 35)
		}):Play()
	else
		TweenService:Create(Main, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 520, 0, 320)
		}):Play()
	end
end)

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 130, 1, -35)
Tabs.Position = UDim2.new(0,0,0,35)
Tabs.BackgroundColor3 = Color3.fromRGB(30,30,30)
Tabs.Parent = Main

Instance.new("UICorner", Tabs)

local UIList = Instance.new("UIListLayout", Tabs)
UIList.Padding = UDim.new(0,5)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -130, 1, -35)
Content.Position = UDim2.new(0,130,0,35)
Content.BackgroundTransparency = 1
Content.Parent = Main

function UILib:CreateTab(name)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1,-10,0,30)
	TabBtn.Text = name
	TabBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	TabBtn.TextColor3 = Color3.new(1,1,1)
	TabBtn.Parent = Tabs
	Instance.new("UICorner", TabBtn)

	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(1,0,1,0)
	TabFrame.Visible = false
	TabFrame.BackgroundTransparency = 1
	TabFrame.Parent = Content

	local Layout = Instance.new("UIListLayout", TabFrame)
	Layout.Padding = UDim.new(0,6)

	TabBtn.MouseButton1Click:Connect(function()
		for _,v in pairs(Content:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		TabFrame.Visible = true
	end)

	return TabFrame
end

function UILib:AddButton(parent, text, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 0, 35)
	Btn.Text = text
	Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Parent = parent

	Instance.new("UICorner", Btn)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(70,70,70)
		}):Play()
	end)

	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(50,50,50)
		}):Play()
	end)

	Btn.MouseButton1Click:Connect(callback)
end

function UILib:AddToggle(parent, text, flag, callback)
	local value = UILib.Flags[flag] or false

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 0, 35)
	Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Parent = parent

	Instance.new("UICorner", Btn)

	local function Update()
		Btn.Text = text .. " : " .. (value and "ON" or "OFF")

		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = value and Color3.fromRGB(0,170,100) or Color3.fromRGB(50,50,50)
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
