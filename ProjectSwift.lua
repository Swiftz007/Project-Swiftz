-- RandomLowServerFinder_autoplace_exploit.lua
-- Executor environment required (syn.request / http.request / http_request)
-- ไม่ต้องตั้ง PLACE_ID ด้วยมือ — ใช้ game.PlaceId อัตโนมัติ

local HttpRequest = syn and syn.request or http and http.request or http_request -- รองรับหลาย executor
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ใช้ game.PlaceId อัตโนมัติ (ไม่ต้องตั้งค่า)
local PLACE_ID = tonumber(tostring(game.PlaceId)) or nil
if not PLACE_ID then
    warn("ไม่สามารถอ่าน game.PlaceId ได้")
    return
end

-- ปรับค่าได้ตามต้องการ
local MAX_PLAYERS_THRESHOLD = 3     -- <= ค่านี้ถือว่า 'คนน้อย'
local RESULT_LIMIT_PER_PAGE = 100
local MAX_PAGES_TO_FETCH = 6        -- เพิ่ม/ลดเพื่อควบคุมจำนวน request
local EXCLUDE_CURRENT = true
local MAX_CANDIDATES = 60
local TELEPORT_RETRY = 2

-- helper: safe http request
local function safe_request(opts)
    if not HttpRequest then return nil, "no-http" end
    local ok, res = pcall(function() return HttpRequest(opts) end)
    if not ok or not res then
        return nil, ok and res or "request-failed"
    end
    return res, nil
end

-- ดึงหน้า server list ของ place นี้
local function fetch_server_page(placeId, cursor)
    local url = ("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d&sortOrder=Asc")
                :format(placeId, RESULT_LIMIT_PER_PAGE)
    if cursor and tostring(cursor) ~= "" then
        url = url .. "&cursor=" .. HttpService:UrlEncode(tostring(cursor))
    end

    local res, err = safe_request({
        Url = url,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "Roblox",
        },
    })
    if not res then
        return nil, "http error: "..tostring(err)
    end
    if res.StatusCode ~= 200 then
        return nil, ("status %d"):format(res.StatusCode)
    end

    local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not ok then return nil, "json decode fail" end
    return data, nil
end

-- เก็บ candidates แบบ bounded
local function collect_candidates_for_place(placeId)
    local candidates = {}
    local cursor = nil
    local pages = 0
    local currentJobId = tostring(game.JobId or "")

    repeat
        pages = pages + 1
        local data, err = fetch_server_page(placeId, cursor)
        if not data then
            warn("fetch failed:", err)
            break
        end

        for _, s in ipairs(data.data or {}) do
            local playing = s.playing or 0
            local id = tostring(s.id or s.id)
            if playing <= MAX_PLAYERS_THRESHOLD then
                if not (EXCLUDE_CURRENT and id == currentJobId) then
                    table.insert(candidates, {id = id, playing = playing})
                    if #candidates >= MAX_CANDIDATES then break end
                end
            end
        end

        cursor = data.nextPageCursor
        if not cursor or cursor == "" then break end
    until pages >= MAX_PAGES_TO_FETCH or #candidates >= MAX_CANDIDATES

    return candidates
end

-- shuffle
local function shuffle(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- เลือกแบบสุ่ม แต่มี bias ไปที่เซิร์ฟเวอร์ที่ว่างกว่า
local function pick_random_candidate(cands)
    if #cands == 0 then return nil end
    table.sort(cands, function(a,b) return (a.playing or 0) < (b.playing or 0) end)
    local poolSize = math.max(1, math.floor(#cands * 0.45))
    local pool = {}
    for i = 1, poolSize do pool[#pool+1] = cands[i] end
    shuffle(pool)
    return pool[math.random(#pool)]
end

-- พยายาม teleport (retry)
local function try_teleport(placeId, instanceId)
    for attempt = 1, TELEPORT_RETRY do
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, instanceId, {LocalPlayer})
        end)
        if ok then return true end
        warn("Teleport attempt "..attempt.." failed:", tostring(err))
    end
    return false
end

-- main: หาแล้วย้าย (ใช้เกมปัจจุบันโดยอัตโนมัติ)
math.randomseed(tick() + os.time())
local function find_and_move_random_low_server_for_current_place()
    print("เริ่มค้นหาเซิร์ฟเวอร์คนน้อยสำหรับ place:", PLACE_ID)
    local candidates = collect_candidates_for_place(PLACE_ID)
    if not candidates or #candidates == 0 then
        warn("ไม่พบเซิร์ฟเวอร์ที่ตรงเงื่อนไข (คนน้อย <= "..tostring(MAX_PLAYERS_THRESHOLD)..")")
        return false
    end

    local chosen = pick_random_candidate(candidates)
    if not chosen then
        warn("เลือกไม่ได้")
        return false
    end

    print(("เลือก id=%s (playing=%d). พยายามย้าย..."):format(tostring(chosen.id), chosen.playing))
    local ok = try_teleport(PLACE_ID, chosen.id)
    if ok then
        print("เรียก teleport สำเร็จ (คำสั่งถูกส่งแล้ว)")
        return true
    end

    -- fallback: ลอง candidate อื่นแบบสุ่มเรียง
    shuffle(candidates)
    for _, c in ipairs(candidates) do
        if c.id ~= chosen.id then
            print("ลองย้ายไป:", c.id, c.playing)
            if try_teleport(PLACE_ID, c.id) then return true end
        end
    end

    warn("ย้ายล้มเหลวทั้งหมด")
    return false
end

-- เรียกใช้งาน
find_and_move_random_low_server_for_current_place()
