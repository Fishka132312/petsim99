_G.OptimizePets = false

local function killPetGraphics(obj)
    if not _G.OptimizePets then return end
    
    if obj:IsA("MeshPart") then
        obj.MeshId = ""
        obj.TextureID = ""
    elseif obj:IsA("SpecialMesh") then
        obj.MeshId = ""
        obj.TextureId = ""
    end

    if obj:IsA("BasePart") then
        obj.Transparency = 0.5
        obj.Color = Color3.fromRGB(100, 100, 100)
        obj.Material = Enum.Material.Plastic
        obj.CastShadow = false
        obj.CanCollide = false
        obj.Size = Vector3.new(0.5, 0.5, 0.5)
    end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
       obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("BillboardGui") then
        obj:Destroy()
    end
end

local function getPetsFolder()
    local things = workspace:FindFirstChild("__THINGS")
    if things and things:FindFirstChild("Pets") then
        return things.Pets
    elseif workspace:FindFirstChild("Pets") then
        return workspace.Pets
    end
    return nil
end

local petsFolder = getPetsFolder()

if petsFolder then
    for _, desc in ipairs(petsFolder:GetDescendants()) do
        killPetGraphics(desc)
    end

    petsFolder.DescendantAdded:Connect(function(newObj)
        task.wait(0.3)
        killPetGraphics(newObj)
    end)
end
