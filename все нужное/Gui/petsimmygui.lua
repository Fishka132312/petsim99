local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/myguitest/sosatb.lua"))()


local eventTab = UILib:CreateTab("Event Farm")

UILib:AddButton(eventTab, "Start Event", function()
	print("Event started")
end)

UILib:AddToggle(eventTab, "AutoTap", "auto_tap", function(state)
	_G.AutoTap = state
end)

local farmTab = UILib:CreateTab("Auto Farm")
