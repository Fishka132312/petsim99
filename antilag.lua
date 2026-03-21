local active = true

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")

settings().Rendering.QualityLevel = 1
lighting.GlobalShadows = false
lighting.FogEnd = 9e9
lighting.Brightness = 1 

if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 0
    terrain.Decoration = false 
end

local function cleanUp(v)
    if not active then return end
    
    pcall(function()
        if v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.MeshId = ""
            v.TextureID = ""
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.Color = Color3.fromRGB(163, 162, 165)
        elseif v:IsA("Part") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
            
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
            v.Enabled = false
        elseif v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        
        elseif v:IsA("SpecialMesh") then
            v.MeshId = ""
            v.TextureId = ""
        end
    end)
end

for _, v in pairs(game:GetDescendants()) do
    cleanUp(v)
end

game.DescendantAdded:Connect(function(v)
    if active then
        task.wait(0.05)
        cleanUp(v)
    end
end)