-- Swiftz Hub (Fixed) - Part 1/6
-- NOTE: Run in an executor that supports loadstring and game:HttpGet

-- ======================
-- 1) Load Fluent UI & Addons
-- ======================
local ok, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)
if not ok or not Fluent then
    warn("Failed to load Fluent UI library.")
    return
end

local SaveManager, InterfaceManager = nil, nil
pcall(function()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Swiftz Hub",
    SubTitle = " [ Blox Fruits ]",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local FarmTab = Window:AddTab({ Title = "Auto Farm", Icon = "home" })
local TeleportTab = Window:AddTab({ Title = "Teleport", Icon = "map" })
local EspTab = Window:AddTab({ Title = "ESP / Visual", Icon = "eye" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

Fluent:Notify({
    Title = "Swiftz Hub",
    Content = "Merged UI + Core loading...",
    Duration = 4
})

-- ======================
-- 2) Global control variables (defaults)
-- ======================
getgenv().AutoFarm = false
getgenv().AutoFarmMaterial = false
getgenv().SelectMaterial = ""
getgenv().ESPPlayer = false
getgenv().ChestESP = false
getgenv().IslandESP = false
getgenv().AutoFarmFruitMastery = false

-- Short refs
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- ======================
-- 3) Utility helpers
-- ======================
local function isnil(v) return v == nil end
local function round(n) return math.floor(tonumber(n) + 0.5) end
local function safeWait(t) task.wait(t or 0.03) end

local function topos(cf)
    if not cf then return end
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

-- ======================
-- 4) MaterialMon()
-- ======================
function MaterialMon()
    if getgenv().SelectMaterial == "Radioactive Material" then
        MMon = "Factory Staff"
        MPos = CFrame.new(-507.7895202636719, 72.99479675292969, -126.45632934570312)
        SP = "Bar"
    elseif getgenv().SelectMaterial == "Mystic Droplet" then
        MMon = "Water Fighter"
        MPos = CFrame.new(-3214.218017578125, 298.69952392578125, -10543.685546875)
        SP = "ForgottenIsland"
    elseif getgenv().SelectMaterial == "Magma Ore" then
        if game.PlaceId == 2753915549 then
            MMon = "Military Spy"
            MPos = CFrame.new(-5850.2802734375, 77.28675079345703, 8848.6748046875)
            SP = "Magma"
        elseif game.PlaceId == 4442272183 then
            MMon = "Lava Pirate"
            MPos = CFrame.new(-5234.60595703125, 51.953372955322266, -4732.27880859375)
            SP = "CircleIslandFire"
        end
    elseif getgenv().SelectMaterial == "Angel Wings" then
        MMon = "Royal Soldier"
        MPos = CFrame.new(-7827.15625, 5606.912109375, -1705.5833740234375)
        SP = "Sky2"
    elseif getgenv().SelectMaterial == "Leather" then
        if game.PlaceId == 2753915549 then
            MMon = "Pirate"
            MPos = CFrame.new(-1211.8792724609375, 4.787090301513672, 3916.83056640625)
            SP = "Pirate"
        elseif game.PlaceId == 4442272183 then
            MMon = "Marine Captain"
            MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
            SP = "Greenb"
        elseif game.PlaceId == 7449423635 then
            MMon = "Jungle Pirate"
            MPos = CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375)
            SP = "PineappleTown"
        end
    elseif getgenv().SelectMaterial == "Scrap Metal" then
        if game.PlaceId == 2753915549 then
            MMon = "Brute"
            MPos = CFrame.new(-1132.4202880859375, 14.844913482666016, 4293.30517578125)
            SP = "Pirate"
        elseif game.PlaceId == 4442272183 then
            MMon = "Mercenary"
            MPos = CFrame.new(-972.307373046875, 73.04473876953125, 1419.2901611328125)
            SP = "DressTown"
        elseif game.PlaceId == 7449423635 then
            MMon = "Pirate Millionaire"
            MPos = CFrame.new(-289.6311950683594, 43.8282470703125, 5583.66357421875)
            SP = "Default"
        end
    elseif getgenv().SelectMaterial == "Demonic Wisp" then
        MMon = "Demonic Soul"
        MPos = CFrame.new(-9503.388671875, 172.139892578125, 6143.0634765625)
        SP = "HauntedCastle"
    elseif getgenv().SelectMaterial == "Vampire Fang" then
        MMon = "Vampire"
        MPos = CFrame.new(-5999.20458984375, 6.437741279602051, -1290.059326171875)
        SP = "Graveyard"
    elseif getgenv().SelectMaterial == "Conjured Cocoa" then
        MMon = "Chocolate Bar Battler"
        MPos = CFrame.new(744.7930908203125, 24.76934242248535, -12637.7255859375)
        SP = "Chocolate"
    elseif getgenv().SelectMaterial == "Dragon Scale" then
        MMon = "Dragon Crew Warrior"
        MPos = CFrame.new(5824.06982421875, 51.38640213012695, -1106.694580078125)
        SP = "Hydra1"
    elseif getgenv().SelectMaterial == "Gunpowder" then
        MMon = "Pistol Billionaire"
        MPos = CFrame.new(-379.6134338378906, 73.84449768066406, 5928.5263671875)
        SP = "Default"
    elseif getgenv().SelectMaterial == "Fish Tail" then
        MMon = "Fishman Captain"
        MPos = CFrame.new(-10961.0126953125, 331.7977600097656, -8914.29296875)
        SP = "PineappleTown"
    elseif getgenv().SelectMaterial == "Mini Tusk" then
        MMon = "Mythological Pirate"
        MPos = CFrame.new(-13516.0458984375, 469.8182373046875, -6899.16064453125)
        SP = "BigMansion"
    else
        -- No material selected
        MMon = nil
        MPos = nil
        SP = nil
    end
end

-- End of Part 1/6
-- ======================
-- 5) ตรวจว่าอยู่โลกไหน
-- ======================
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

-- ======================
-- 6) ฟังก์ชัน CheckQuest() – เช็คว่าจะไปตีมอน/รับเควสที่ไหน
-- ======================
function CheckQuest()
    local MyLevel = 1
    pcall(function()
        MyLevel = LocalPlayer.Data.Level.Value
    end)

    -- ✅ ค่า Default ป้องกัน Error ถ้า Level ไม่เข้าเงื่อนไข
    Mon = Mon or "Bandit"
    LevelQuest = LevelQuest or 1
    NameQuest = NameQuest or "BanditQuest1"
    NameMon = NameMon or "Bandit"
    CFrameQuest = CFrameQuest or CFrame.new(1059, 15, 1549)
    CFrameMon = CFrameMon or CFrame.new(1045, 27, 1560)

    -- 🌍 ========== WORLD 1 ==========
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059, 15, 1549)
            CFrameMon = CFrame.new(1045, 27, 1560)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1600, 36, 153)
            CFrameMon = CFrame.new(-1448, 67, 11)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1600, 36, 153)
            CFrameMon = CFrame.new(-1130, 40, -525)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141, 4, 3831)
            CFrameMon = CFrame.new(-1103, 13, 3896)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141, 4, 3831)
            CFrameMon = CFrame.new(-1140, 14, 4322)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(897, 6, 4392)
            CFrameMon = CFrame.new(932, 7, 4487)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(897, 6, 4392)
            CFrameMon = CFrame.new(1578, 10, 4373)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1385, 87, -1294)
            CFrameMon = CFrame.new(1188, 106, -1369)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1385, 87, -1294)
            CFrameMon = CFrame.new(1280, 112, -1415)
        elseif MyLevel >= 120 and MyLevel <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5030, 28, 4324)
            CFrameMon = CFrame.new(-4982, 22, 4245)
        elseif MyLevel >= 150 and MyLevel <= 174 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4970, 718, -2622)
            CFrameMon = CFrame.new(-4890, 701, -2620)
        elseif MyLevel >= 175 and MyLevel <= 224 then
            Mon = "Dark Master"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4970, 718, -2622)
            CFrameMon = CFrame.new(-5259, 393, -2277)
        end
    end -- World1 End

    -- 🌍 ========== WORLD 2 (เริ่ม) ==========
    if World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-426, 72, 1836)
            CFrameMon = CFrame.new(-746, 39, 2390)
        elseif MyLevel >= 725 and MyLevel <= 774 then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-426, 72, 1836)
            CFrameMon = CFrame.new(-1053, 72, 1436)
        end
    end
end
-- ✅ End of Part 2/6
-- 🌍 ========== WORLD 2 (ต่อ) ==========
if World2 then
    if MyLevel >= 700 and MyLevel <= 724 then
        Mon = "Raider"
        LevelQuest = 1
        NameQuest = "Area1Quest"
        NameMon = "Raider"
        CFrameQuest = CFrame.new(-426, 72, 1836)
        CFrameMon = CFrame.new(-746, 39, 2390)
    elseif MyLevel >= 725 and MyLevel <= 774 then
        Mon = "Mercenary"
        LevelQuest = 2
        NameQuest = "Area1Quest"
        NameMon = "Mercenary"
        CFrameQuest = CFrame.new(-426, 72, 1836)
        CFrameMon = CFrame.new(-1053, 72, 1436)
    elseif MyLevel >= 775 and MyLevel <= 799 then
        Mon = "Swan Pirate"
        LevelQuest = 1
        NameQuest = "Area2Quest"
        NameMon = "Swan Pirate"
        CFrameQuest = CFrame.new(634, 73, 918)
        CFrameMon = CFrame.new(878, 122, 1235)
    elseif MyLevel >= 800 and MyLevel <= 874 then
        Mon = "Factory Staff"
        LevelQuest = 2
        NameQuest = "Area2Quest"
        NameMon = "Factory Staff"
        CFrameQuest = CFrame.new(634, 73, 918)
        CFrameMon = CFrame.new(295, 73, -56)
    end
end

-- 🌍 ========== WORLD 3 ==========
if World3 then
    if MyLevel >= 1500 and MyLevel <= 1524 then
        Mon = "Pirate Millionaire"
        LevelQuest = 1
        NameQuest = "PiratePortQuest"
        NameMon = "Pirate Millionaire"
        CFrameQuest = CFrame.new(-286, 43, 5579)
        CFrameMon = CFrame.new(-30, 44, 5855)
    elseif MyLevel >= 1525 and MyLevel <= 1574 then
        Mon = "Pistol Billionaire"
        LevelQuest = 2
        NameQuest = "PiratePortQuest"
        NameMon = "Pistol Billionaire"
        CFrameQuest = CFrame.new(-286, 43, 5579)
        CFrameMon = CFrame.new(-381, 73, 6073)
    elseif MyLevel >= 1575 and MyLevel <= 1599 then
        Mon = "Dragon Crew Warrior"
        LevelQuest = 1
        NameQuest = "AmazonQuest"
        NameMon = "Dragon Crew Warrior"
        CFrameQuest = CFrame.new(5835, 52, -1106)
        CFrameMon = CFrame.new(5823, 51, -1145)
    elseif MyLevel >= 1600 and MyLevel <= 1624 then
        Mon = "Dragon Crew Archer"
        LevelQuest = 2
        NameQuest = "AmazonQuest"
        NameMon = "Dragon Crew Archer"
        CFrameQuest = CFrame.new(5835, 52, -1106)
        CFrameMon = CFrame.new(5969, 71, -1211)
    elseif MyLevel >= 1625 and MyLevel <= 1649 then
        Mon = "Female Islander"
        LevelQuest = 1
        NameQuest = "AmazonQuest2"
        NameMon = "Female Islander"
        CFrameQuest = CFrame.new(5447, 601, 752)
        CFrameMon = CFrame.new(5313, 819, 1049)
    elseif MyLevel >= 1650 and MyLevel <= 1699 then
        Mon = "Giant Islander"
        LevelQuest = 2
        NameQuest = "AmazonQuest2"
        NameMon = "Giant Islander"
        CFrameQuest = CFrame.new(5447, 601, 752)
        CFrameMon = CFrame.new(5016, 602, 884)
    elseif MyLevel >= 1700 and MyLevel <= 1724 then
        Mon = "Marine Commodore"
        LevelQuest = 1
        NameQuest = "MarineTreeIsland"
        NameMon = "Marine Commodore"
        CFrameQuest = CFrame.new(2178, 28, -6735)
        CFrameMon = CFrame.new(2303, 84, -6900)
    elseif MyLevel >= 1725 and MyLevel <= 1774 then
        Mon = "Marine Rear Admiral"
        LevelQuest = 2
        NameQuest = "MarineTreeIsland"
        NameMon = "Marine Rear Admiral"
        CFrameQuest = CFrame.new(2178, 28, -6735)
        CFrameMon = CFrame.new(2258, 68, -7000)
    end
end
end -- ✅ ปิดฟังก์ชัน CheckQuest() ครบทุก World

-- ======================
-- 7) ระบบ Auto Farm (เริ่มสร้างโครง)
-- ======================
spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            pcall(function()
                CheckQuest() -- อัปเดตตำแหน่งเควส & มอน
                -- (ส่วนตีมอน / รับเควสจะเติมใน Part 4)
            end)
        end
    end
end)

-- ✅ End of Part 3/6
-- ======================
-- 8) Auto Farm Attack Function
-- ======================
local function AttackMob(Monster)
    pcall(function()
        if not Monster:FindFirstChild("Humanoid") or Monster.Humanoid.Health <= 0 then return end
        if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Monster:FindFirstChild("HumanoidRootPart") then
            -- ล็อกตำแหน่งเข้าใกล้มอน
            LocalPlayer.Character.HumanoidRootPart.CFrame = Monster.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5)
            -- เปิด hitbox
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end)
end

-- ======================
-- 9) ระบบ Auto Farm หลัก (ตีมอน + รับเควส)
-- ======================
spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            pcall(function()
                CheckQuest()

                -- เช็คว่ารับเควสแล้วหรือยัง (ถ้าไม่มี ต้องไปรับ)
                local QuestCheck = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle
                if (not string.find(QuestCheck.Text, NameMon)) then
                    -- ไม่มีเควส → ไปหา NPC เพื่อรับ
                    topos(CFrameQuest)
                    task.wait(1)

                    -- กดคุย NPC (CommF_)
                    local args = {
                        [1] = "StartQuest",
                        [2] = NameQuest,
                        [3] = LevelQuest
                    }
                    if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                    end
                else
                    -- มีเควสแล้ว → หา Monster ไปตี
                    for _,v in pairs(Workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            -- เทเลพอร์ตไปใกล้มอน
                            topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5))

                            -- เปิด no-clip ป้องกันติด
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                LocalPlayer.Character.Humanoid:ChangeState(11)
                            end

                            -- โจมตี
                            AttackMob(v)

                            -- ถ้ามอนตาย จะออกจาก loop ไปหาตัวใหม่
                            if v.Humanoid.Health <= 0 then
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ======================
-- 10) เพิ่มปุ่ม Auto Farm เข้าใน UI
-- ======================
FarmTab:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm Level",
    Default = false
}):OnChanged(function(state)
    getgenv().AutoFarm = state
    if state then
        Fluent:Notify({Title = "Auto Farm", Content = "✅ Activated", Duration = 3})
    else
        Fluent:Notify({Title = "Auto Farm", Content = "⛔ Stopped", Duration = 3})
    end
end)

-- ✅ End of Part 4/6
-- ======================
-- 11) ESP System (Player / Chest / Island)
-- ======================
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "SwiftzESP"

local function ClearESP()
    for _,v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

-- Create ESP Billboard
local function CreateESP(obj, text)
    if not obj:FindFirstChild("HumanoidRootPart") then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_"..obj.Name
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0,100,0,100)
    Billboard.Adornee = obj:FindFirstChild("HumanoidRootPart")
    Billboard.Parent = ESPFolder

    local Label = Instance.new("TextLabel", Billboard)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(0,255,0)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,0,1,0)
end

-- Loop for ESP updates
spawn(function()
    while task.wait(1) do
        if getgenv().ESPPlayer or getgenv().ChestESP or getgenv().IslandESP then
            ClearESP()
            -- Player ESP
            if getgenv().ESPPlayer then
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        CreateESP(plr.Character, "[Player] "..plr.Name)
                    end
                end
            end
            -- Chest ESP
            if getgenv().ChestESP then
                for _,v in pairs(Workspace:GetChildren()) do
                    if string.find(v.Name,"Chest") and v:IsA("Model") then
                        if v:FindFirstChild("HumanoidRootPart") then
                            CreateESP(v, "[Chest]")
                        end
                    end
                end
            end
            -- Island ESP (simplified)
            if getgenv().IslandESP then
                for _,island in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
                    if island:IsA("Part") then
                        CreateESP(island, "[Island] "..island.Name)
                    end
                end
            end
        else
            ClearESP()
        end
    end
end)

-- UI Toggles (ESP Tab)
EspTab:AddToggle("ESPPlayerToggle", {Title="ESP Player",Default=false}):OnChanged(function(v) getgenv().ESPPlayer=v end)
EspTab:AddToggle("ESPChestToggle", {Title="ESP Chest",Default=false}):OnChanged(function(v) getgenv().ChestESP=v end)
EspTab:AddToggle("ESPIslandToggle", {Title="ESP Island",Default=false}):OnChanged(function(v) getgenv().IslandESP=v end)

-- ======================
-- 12) Farm Material
-- ======================
FarmTab:AddDropdown("MaterialSelect", {
    Title = "Select Material",
    Values = {"Magma Ore","Scrap Metal","Leather","Fish Tail","Mini Tusk","Conjured Cocoa"},
    Default = ""
}):OnChanged(function(v)
    getgenv().SelectMaterial = v
end)

FarmTab:AddToggle("AutoFarmMaterialToggle", {Title="Auto Farm Material", Default=false})
:OnChanged(function(v)
    getgenv().AutoFarmMaterial = v
end)

spawn(function()
    while task.wait() do
        if getgenv().AutoFarmMaterial then
            pcall(function()
                MaterialMon()
                if MMon and MPos then
                    topos(MPos)
                    for _,mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == MMon and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            AttackMob(mob)
                        end
                    end
                end
            end)
        end
    end
end)

-- ======================
-- 13) Teleport Tab
-- ======================
local TeleportLocations = {
    ["Start Island"] = CFrame.new(1059, 16, 1550),
    ["Marine Base"] = CFrame.new(-2450, 41, 3892),
    ["Middle Town"] = CFrame.new(-655, 7, 1436),
    ["Cafe (World2)"] = CFrame.new(-385, 74, 874),
    ["Port Town (World3)"] = CFrame.new(-287, 44, 5579)
}

TeleportTab:AddDropdown("TeleportSelect", {
    Title = "Select Location",
    Values = TeleportLocations,
    Default = "Start Island"
}):OnChanged(function(v)
    topos(TeleportLocations[v])
end)

-- ======================
-- 14) Server Hop (หาเซิร์ฟเวอร์ใหม่อัตโนมัติ)
-- ======================
local function ServerHop()
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local body = game:HttpGet(Api)
    local servers = Http:JSONDecode(body)
    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
            break
        end
    end
end

SettingsTab:AddButton("Server Hop", function()
    Fluent:Notify({Title="Server Hop",Content="Teleporting...",Duration=3})
    task.delay(1, ServerHop)
end)

-- ✅ End of Part 5/6
-- ======================
-- Part 6/6 — SaveManager / InterfaceManager / Finish + Cleanup
-- ======================

-- SaveManager / InterfaceManager integration (ถ้ามี)
if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetFolder("SwiftzHub/Configs")
    end)
end

if InterfaceManager then
    pcall(function()
        InterfaceManager:SetLibrary(Fluent)
        InterfaceManager:SetFolder("SwiftzHub/Interfaces")
    end)
end

-- Build settings UI sections if addons loaded
if SaveManager and InterfaceManager then
    pcall(function()
        InterfaceManager:BuildInterfaceSection(SettingsTab)
        SaveManager:BuildConfigSection(SettingsTab)
        SaveManager:LoadAutoloadConfig()
    end)
end

-- Select default tab and small ready notification
Window:SelectTab(1)
Fluent:Notify({
    Title = "Swiftz Hub",
    Content = "Loaded Successfully! ✅",
    Duration = 4
})

-- Optional: quick helper to stop all automation
SettingsTab:AddButton({
    Title = "Stop All",
    Description = "Turn off all toggles and automation",
    Callback = function()
        getgenv().AutoFarm = false
        getgenv().AutoFarmMaterial = false
        getgenv().ESPPlayer = false
        getgenv().ChestESP = false
        getgenv().IslandESP = false
        Fluent:Notify({Title = "Swiftz Hub", Content = "Stopped all systems", Duration = 3})
    end
})

-- Cleanup routine: remove created ESP guis / folders when Fluent unloads
task.spawn(function()
    while task.wait(1) do
        if Fluent.Unloaded then
            pcall(function()
                -- clear ESP folder (if created)
                local esp = game.CoreGui:FindFirstChild("SwiftzESP")
                if esp then esp:Destroy() end

                -- remove any Billboard/Text GUIs we created (robust cleanup)
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local child = plr.Character.HumanoidRootPart:FindFirstChild("SwiftzESP")
                        if child then child:Destroy() end
                    end
                end

                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name:match("ESP_") or obj.Name == "SwiftzESP" then
                        if obj.Parent then pcall(function() obj:Destroy() end) end
                    end
                end
            end)
            break
        end
    end
end)

-- End of merged Swiftz Hub (Fixed)
