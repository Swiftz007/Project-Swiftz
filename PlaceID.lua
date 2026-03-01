--  Check PlaceId
local allowedPlaceId = 136801880565837

if game.PlaceId ~= allowedPlaceId then
    player:Kick("Not found map : Swiftz Hub")
    return
end

--  Load Script
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AsiiXacx/AcxScripter/refs/heads/main/FlickAcxV1.3"))()
end)

if not success then
    warn("[Swiftz Hub] Load Error:", err)
end
