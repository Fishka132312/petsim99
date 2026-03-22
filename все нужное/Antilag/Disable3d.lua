local visual = _G.VisualConfig or {}

local function applyGraphics()
    local RunService = game:GetService("RunService")
    if visual.Disable3D == true then
        RunService:Set3dRenderingEnabled(false)
        print("--- [Visual]: 3D Rendering DISABLED (FPS Boost) ---")
    else
        RunService:Set3dRenderingEnabled(true)
        print("--- [Visual]: 3D Rendering ENABLED ---")
    end
end

applyGraphics()
