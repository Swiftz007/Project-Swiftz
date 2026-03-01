local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKey = {
    "KEY-123-456-789"
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

--  Key Check
if not key or key ~= correctKey then
    warn("Swiftz Hub")
    player:Kick("Invalid Hwid")
    return
end

print("Swiftz Hub better Script Forever")
task.wait(1)
