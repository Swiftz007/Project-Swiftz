local TARGET_PLACE_ID = 93978595733734
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
if game.PlaceId == TARGET_PLACE_ID then
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Violence-District/refs/heads/main/eng.lua"
elseif _G.Script_Language == "Thai" then
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Normal/refs/heads/main/Thaixyz.lua"
else
    mainScript = "https://raw.githubusercontent.com/x2sxqz/Normal/refs/heads/main/kingxyz.lua"
end
local success = runScript(mainScript)
if success then
    runScript("https://raw.githubusercontent.com/x2sxqz/Libwtf/refs/heads/main/libwebhook2.lua")
end
