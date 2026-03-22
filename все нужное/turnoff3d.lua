local visual = _G.VisualConfig or {}

if visual.Disable3D == false then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
elseif visual.Disable3D == true then
    game:GetService("RunService"):Set3dRenderingEnabled(true)
end
