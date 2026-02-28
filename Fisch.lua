-- Check PlaceId
local allowedPlaceId = 136801880565837

if game.PlaceId ~= allowedPlaceId then
    game.Players.LocalPlayer:Kick("Not found map : Swiftz Hub")
    return
end

-- Script Flick
loadstring(game:HttpGet("https://raw.githubusercontent.com/AsiiXacx/AcxScripter/refs/heads/main/FlickAcxV1.3"))()