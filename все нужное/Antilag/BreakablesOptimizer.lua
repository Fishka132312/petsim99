_G.OptimizeBreakables = true

local breakablesFolder = workspace:WaitForChild("__THINGS"):WaitForChild("Breakables")

local function optimizeObject(obj)
    if not _G.OptimizeBreakables then return end

    local descendants = obj:GetDescendants()
    table.insert(descendants, obj)

    for _, v in pairs(descendants) do
        if v:IsA("MeshPart") then
            v.MeshId = ""
            v.TextureID = ""
            v.Transparency = 0.5
            v.Size = Vector3.new(1, 1, 1)
        elseif v:IsA("SpecialMesh") then
            v.MeshId = ""
            v.TextureId = ""
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

local function optimizeAll()
    if _G.OptimizeBreakables then
        for _, b in pairs(breakablesFolder:GetChildren()) do
            optimizeObject(b)
        end
    end
end

breakablesFolder.ChildAdded:Connect(function(newBreakable)
    if not _G.OptimizeBreakables then return end
    
    task.wait(0.2) 
    optimizeObject(newBreakable)
end)

optimizeAll()
