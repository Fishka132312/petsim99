_G.OptimizeBreakables = false

local breakablesFolder = workspace:WaitForChild("__THINGS"):WaitForChild("Breakables")

local function optimizeMesh(mesh)
    if _G.OptimizeBreakables then
        if mesh:IsA("MeshPart") or mesh:IsA("SpecialMesh") then
            if mesh:IsA("MeshPart") then
                mesh.MeshId = ""
                mesh.TextureID = ""
            else
                mesh.MeshId = ""
                mesh.TextureId = ""
            end
            
            mesh.Transparency = 0.2
            mesh.Size = Vector3.new(1, 1, 1)
        end
    end
end

local function processBreakable(breakable)
    local meshObj = breakable:FindFirstChild("1")
    if meshObj then
        optimizeMesh(meshObj)
    end
end

breakablesFolder.ChildAdded:Connect(function(newBreakable)
    task.wait(0.1)
    processBreakable(newBreakable)
end)

for _, b in pairs(breakablesFolder:GetChildren()) do
    processBreakable(b)
end
