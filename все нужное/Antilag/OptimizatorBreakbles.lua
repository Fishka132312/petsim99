local lighting = game:GetService("Lighting")

local function simplify(obj)
    if not obj or not obj.Parent then return end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Light") then
        obj.Enabled = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ScreenGui") then
        obj.Enabled = false
    elseif obj:IsA("PostEffect") then
        obj.Enabled = false
    end

    if obj:IsA("MeshPart") then
        if obj.MeshId ~= "" or obj.TextureID ~= "" then
            obj.MeshId = ""
            obj.TextureID = ""
        end
    end

    if obj:IsA("SpecialMesh") or obj:IsA("DataModelMesh") then
        obj.Scale = Vector3.new(0, 0, 0)
    end

    if obj:IsA("BasePart") then
        if obj.Material ~= Enum.Material.Plastic or obj.CastShadow ~= false then
            obj.Color = Color3.fromRGB(163, 162, 165)
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
        end
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

for _, desc in ipairs(workspace:GetDescendants()) do simplify(desc) end
for _, effect in ipairs(lighting:GetChildren()) do simplify(effect) end

print("🧱 Режим 'Серый мир' активен. Ничего не удалено, всё просто скрыто!")