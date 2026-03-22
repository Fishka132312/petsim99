local petsFolder = workspace:WaitForChild("__THINGS"):WaitForChild("Pets")

local trashClasses = {
    "SpecialMesh", "Mesh", "ParticleEmitter", "Decal", 
    "Texture", "Trail", "Beam", "SurfaceGui", "BillboardGui",
    "Light", "PointLight", "SpotLight", "SurfaceLight"
}

local function optimizePet(obj)
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        task.defer(function()
            if obj:IsA("MeshPart") then
                obj.MeshId = ""
                obj.TextureID = ""
            end

            obj.Color = Color3.fromRGB(120, 120, 120)
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.CanCollide = false
            obj.Size = Vector3.new(1, 1, 1)

            for _, child in ipairs(obj:GetChildren()) do
                local isTrash = false
                for _, className in ipairs(trashClasses) do
                    if child:IsA(className) then
                        isTrash = true
                        break
                    end
                end

                if isTrash or child.Name:find("FX") or child.Name:find("RAINBOW") then
                    child:Destroy()
                end
            end
        end)
    end
end

for _, desc in ipairs(petsFolder:GetDescendants()) do
    optimizePet(desc)
end

petsFolder.DescendantAdded:Connect(function(newObj)
    task.wait()
    optimizePet(newObj)
end)