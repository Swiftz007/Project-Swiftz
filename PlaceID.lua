local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKey = "KEY-123-456-789"

if getgenv().Key ~= correctKey then
    player:Kick("Invalid Hwid")
     print("[Swiftz Hub]")
    return
end

print("Swiftz Hub better Script Forever")
   task.wait(1)

-- Check PlaceId
local allowedPlaceId = 136801880565837

if game.PlaceId ~= allowedPlaceId then
    game.Players.LocalPlayer:Kick("Not found map : Swiftz Hub")
    return
end

-- Script Flick
loadstring(game:HttpGet("https://raw.githubusercontent.com/AsiiXacx/AcxScripter/refs/heads/main/FlickAcxV1.3"))()
