local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKeys = {
    "X2SX-1234-5678-RRRR-TTTT", -- Admin key
    "S9KX-4TQ7-2MZL-8PWR-6HJD", -- User key 1
    "SB3F-7XQ2-L9VN-5KTR-1ZPM", -- User key 2
    "S7DL-2QWX-8VJN-4RKP-9TGH", -- User key 3
    "SMX2-6QPL-3VKR-9ZWT-5HNF", -- User key 4
    "S4ZT-8KQM-1XVR-6LPD-2JHG", -- User key 5
    "SQ9L-5VXT-7KRP-3ZMN-8HWF", -- User key 6
    "S2XK-9LQV-4TRP-7ZHD-6MJN", -- User key 7
    "SR7P-3KXT-9VQL-2HZN-5MFW", -- User key 8
    "S8QV-1ZKP-6XTR-4LHM-9JWD", -- User key 9
    "ST5X-9QVL-2KRP-8ZMN-3HJF" -- User key 10
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
