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
    -- false  = Default (Game is visible)
    -- true = FPS Boost (White screen, 3D off)
    Disable3D = true,
}

-- Anti Admin
_G.AntiAdminEnabled = false

loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/petsim99/refs/heads/main/%D0%B2%D1%81%D0%B5%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%D0%B5/shortlink/AutoFarmRaid.lua'))()
