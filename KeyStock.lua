local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKeys = {
    "X2SX-1234-5678-RRRR-TTTT"
    "S9KX-4TQ7-2MZL-8PWR-6HJD",
    "SB3F-7XQ2-L9VN-5KTR-1ZPM",
    "S7DL-2QWX-8VJN-4RKP-9TGH",
    "SMX2-6QPL-3VKR-9ZWT-5HNF",
    "S4ZT-8KQM-1XVR-6LPD-2JHG",
    "SQ9L-5VXT-7KRP-3ZMN-8HWF",
    "S2XK-9LQV-4TRP-7ZHD-6MJN",
    "SR7P-3KXT-9VQL-2HZN-5MFW",
    "S8QV-1ZKP-6XTR-4LHM-9JWD",
    "ST5X-9QVL-2KRP-8ZMN-3HJF"
}

local key = getgenv().Key

-- ตรวจว่ามีคีย์หรือไม่
if not key then
    player:Kick("Please set getgenv().Key first")
    return
end

-- ฟังก์ชันเช็คคีย์
local function isValidKey(k)
    for _, v in ipairs(correctKeys) do
        if k == v then
            return true
        end
    end
    return false
end

if not isValidKey(key) then
    player:Kick("Invalid Key")
    return
end

print("Key verified! Loading main script...")
task.wait(0.5)

-- โหลด PlaceID.lua
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Project-Swiftz/refs/heads/main/PlaceID.lua"))()
end)

if not success then
    warn("[Swiftz Hub] Load Error:", err)
end
