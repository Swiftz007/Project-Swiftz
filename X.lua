local VD = 93978595733734
local A = nil
local B = nil
local C = nil
local D = nil
local E = nil
local F = nil
local G = nil

local function runScript(url)
    local success, result = pcall(function()
        local source = game:HttpGet(url)
        local func = loadstring(source)
        if not func then
            error("loadstring failed")
        end
        return func()
    end)
    return success, result
end
local mainScript
if game.PlaceId == VD then
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Violence-District/refs/heads/main/eng.lua"

elseif game.PlaceId == A then
    mainScript = "https://reaperxsecurity.vercel.app/A"

elseif game.PlaceId == B then
    mainScript = "https://reaperxsecurity.vercel.app/B"

elseif game.PlaceId == C then
    mainScript = "https://reaperxsecurity.vercel.app/C"

elseif game.PlaceId == D then
    mainScript = "https://reaperxsecurity.vercel.app/D"

elseif game.PlaceId == E then
    mainScript = "https://reaperxsecurity.vercel.app/E"

elseif game.PlaceId == F then
    mainScript = "https://reaperxsecurity.vercel.app/F"

elseif game.PlaceId == G then
    mainScript = "https://reaperxsecurity.vercel.app/G"

elseif _G.Script_Language == "Thai" then
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Normal/refs/heads/main/Thaixyz.lua"

else
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Normal/refs/heads/main/kingxyz.lua"
end
local success = runScript(mainScript)
if success then
    runScript("https://raw.githubusercontent.com/x2sxqz/Libwtf/refs/heads/main/libwebhook2.lua")
end
