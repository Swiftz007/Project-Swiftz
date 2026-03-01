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
    "ST5X-9QVL-2KRP-8ZMN-3HJF", -- User key 10
    "SX4K-9QTL-2VHM-8RWP-6JND", -- User key 11
    "S7MP-3XQV-9LKT-2HZR-5WNF", -- User key 12
    "SK9L-5VXT-7QRP-3ZMN-8HWF", -- User key 13
    "S2XJ-8LQV-4TRP-7ZHD-6MKC", -- User key 14
    "SR6P-1KXT-9VQL-2HZN-5MFW", -- User key 15
    "S8QV-4ZKP-6XTR-1LHM-9JWD", -- User key 16
    "ST5X-9QVL-2KRP-8ZMN-3HJF", -- User key 17
    "S3LK-7VQX-1TRP-9ZHM-4NWD", -- User key 18
    "SN8Q-2XVL-5KRP-7ZMJ-1HDT", -- User key 19
    "S9ZT-6KQM-3XVR-8LPD-2JHG", -- User key 20
    "S4PX-8QVL-1KRT-6ZMN-5HJD", -- User key 21
    "SQ7L-3VXT-9KRP-2ZMH-8NWF", -- User key 22
    "S1XK-9LQV-4TRP-7ZHD-6MJB", -- User key 23
    "SM6P-2KXT-8VQL-5HZN-3RWF", -- User key 24
    "S8QV-1ZKP-6XTR-4LHM-9JYC", -- User key 25
    "ST2X-7QVL-3KRP-9ZMN-5HJF", -- User key 26
    "S5LK-9VQX-2TRP-8ZHM-4NWD", -- User key 27
    "SN3Q-6XVL-1KRP-7ZMJ-9HDT", -- User key 28
    "S9RT-4KQM-8XVL-2LPD-6JHG", -- User key 29
    "SX7P-5QVL-3KRT-1ZMN-8HJD" -- User key 30
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
