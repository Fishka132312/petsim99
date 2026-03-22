local lighting = game:GetService("Lighting")

local visualTrash = {
    "Decal", "Texture", "ParticleEmitter", "Trail", "Beam", 
    "Smoke", "Fire", "Sparkles", "PostEffect", "Light", "Clothing",
    "BillboardGui", "SurfaceGui", "ScreenGui", "SelectionBox", "SelectionHighlight"
}

local function simplify(obj)
    if not obj or not obj.Parent then return end

    for _, className in ipairs(visualTrash) do
        if obj:IsA(className) then
            pcall(function()
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Light") then
                    obj.Enabled = false
                elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ScreenGui") then
                    obj.Enabled = false
                elseif obj:IsA("PostEffect") then
                    obj.Enabled = false
                end
            end)
            return 
        end
    end

    if obj:IsA("MeshPart") then
        if obj.MeshId ~= "" or obj.TextureID ~= "" then
            pcall(function()
                obj.MeshId = ""
                obj.TextureID = ""
            end)
        end
    end

    if obj:IsA("SpecialMesh") or obj:IsA("DataModelMesh") then
        pcall(function()
            obj.Scale = Vector3.new(0, 0, 0)
            if obj:IsA("SpecialMesh") then obj.TextureId = "" end 
        end)
        return
    end

    if obj:IsA("BasePart") then
        if obj.Material ~= Enum.Material.Plastic or obj.CastShadow ~= false then
            pcall(function()
                obj.Color = Color3.fromRGB(163, 162, 165)
                obj.Material = Enum.Material.Plastic
                obj.CastShadow = false
                obj.Reflectance = 0
            end)
        end
    end
end

local function fullScan(root)
    simplify(root)
    for _, child in ipairs(root:GetDescendants()) do
        simplify(child)
    end
end

workspace.DescendantAdded:Connect(function(newObj)
    task.wait(0.1)
    simplify(newObj)
end)

task.spawn(function()
    while true do
        for _, item in ipairs(workspace:GetDescendants()) do
            if (item:IsA("MeshPart") and item.MeshId ~= "") or 
               (item:IsA("Decal") and item.Transparency < 1) or 
               (item:IsA("ParticleEmitter") and item.Enabled == true) then
                simplify(item)
            end
        end
        task.wait(1) 
    end
end)

lighting.GlobalShadows = false
fullScan(workspace)
fullScan(lighting)