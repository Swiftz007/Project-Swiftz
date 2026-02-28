local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKey = "KEY-123-456-789"

if getgenv().Key ~= correctKey then
    player:Kick("Key ไม่ถูกต้อง")
    return
end

print("Key ถูกต้อง โหลดสำเร็จ")

-- Check PlaceId
local allowedPlaceId = 136801880565837

if game.PlaceId ~= allowedPlaceId then
    game.Players.LocalPlayer:Kick("Not found map : Swiftz Hub")
    return
end

-- Script Flick
loadstring(game:HttpGet("https://raw.githubusercontent.com/AsiiXacx/AcxScripter/refs/heads/main/FlickAcxV1.3"))()
