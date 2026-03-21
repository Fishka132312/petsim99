local lighting = game:GetService("Lighting")

local function disableVisuals(obj)
    task.defer(function()
        if not obj or not obj.Parent then return end

        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") then
            obj.Enabled = false
        
        elseif obj:IsA("Light") then
            obj.Enabled = false

        elseif obj:IsA("Sky") then
        end
    end)
end

for _, child in ipairs(lighting:GetChildren()) do
    disableVisuals(child)
end
lighting.ChildAdded:Connect(disableVisuals)

lighting.GlobalShadows = false
lighting.FogEnd = 9e9
lighting.Brightness = 2 

local workspaceLightFolder = workspace:FindFirstChild("Light", true)

if workspaceLightFolder then
    local function silenceFolder(target)
        for _, item in ipairs(target:GetDescendants()) do
            if item:IsA("Light") or item:IsA("ParticleEmitter") then
                item.Enabled = false
            elseif item:IsA("BasePart") then
                item.Transparency = 1
                item.CastShadow = false
            elseif item:IsA("Decal") or item:IsA("Texture") then
                item.Transparency = 1
            end
        end
    end

    silenceFolder(workspaceLightFolder)
    
    workspaceLightFolder.DescendantAdded:Connect(function(new)
        task.defer(function()
            if new:IsA("Light") or new:IsA("ParticleEmitter") then
                new.Enabled = false
            elseif new:IsA("BasePart") or new:IsA("Decal") then
                new.Transparency = 1
            end
        end)
    end)
end