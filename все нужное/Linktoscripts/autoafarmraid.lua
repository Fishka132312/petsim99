-- Webhook Settings
_G.WebhooksPetsConfig = {
    -- Huge pets webhook
    HugeWebhook = "",
    
    -- Titanic pets webhook
    TitanicWebhook = "",

    -- Fake webhook (leave empty if no)
    TestName = "", 
    TestId = "", 
}

-- Turn off 3D graphic?
_G.VisualConfig = {
    -- true  = Default (Game is visible)
    -- false = FPS Boost (White screen, 3D off)
    Disable3D = true,
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/autofarmraid.lua'))()