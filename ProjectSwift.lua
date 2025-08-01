-- 🔒 ตรวจสอบชื่อแมพก่อนโหลด UI
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local expectedMapName = "Grow a Garden"
local success, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

if not success or not productInfo or not productInfo.Name:lower():match(expectedMapName:lower()) then
    Players.LocalPlayer:Kick("Project Swiftz : Not support this map\nDiscord : https://discord.gg/mqWbztWd")
    return
end

-- ✅ Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

-- 🌟 UI Window
local Window = Rayfield:CreateWindow({
    Name = "Project Swiftz",
    LoadingTitle = "Swiftz Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- 📦 Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local SeedTab = Window:CreateTab("Seed Shop", 4483362458)
local GearTab = Window:CreateTab("Gear Shop", 4483362458)
local PetTab = Window:CreateTab("Pet Shop", 4483362458)

-- 📜 Raw Lists
local gearListRaw = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Master Sprinkler", "Medium Toy", "Medium Treat", "Magnifying Glass",
    "Tanning Mirror", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Levelup Lollipop"
}

local seedListRaw = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon",
    "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom",
    "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}

local eggListRaw = {
    "Common Egg", "Common Summer Egg", "Rare Summer Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
}

local function withAllOption(list)
    local newList = { "All" }
    for _, v in ipairs(list) do table.insert(newList, v) end
    return newList
end

local gearList = withAllOption(gearListRaw)
local seedList = withAllOption(seedListRaw)
local eggList = withAllOption(eggListRaw)

-- 🔧 Remotes
local GearRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyGearStock")
local SeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")
local EggRemote  = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyPetEgg")

-- 🔁 State
local selectedGears, selectedSeeds, selectedEggs = {}, {}, {}
local autoBuyGear, autoBuySeed, autoBuyEgg = false, false, false

-- 🚀 Fast Buy Loop (ซื้อให้หมดก่อนเปลี่ยน)
local function FastBuyLoop(remote, selectedList)
    for _, item in ipairs(selectedList) do
        for _ = 1, 50 do
            pcall(function()
                remote:FireServer(item)
            end)
            task.wait(0.005)
        end
    end
end

-- 🌱 Auto Seed Buy
task.spawn(function()
    while true do
        if autoBuySeed then
            FastBuyLoop(SeedRemote, selectedSeeds)
        end
        task.wait(0.1)
    end
end)

-- ⚙️ Auto Gear Buy
task.spawn(function()
    while true do
        if autoBuyGear then
            FastBuyLoop(GearRemote, selectedGears)
        end
        task.wait(0.1)
    end
end)

-- 🐣 Auto Egg Buy (แบบเดิม)
task.spawn(function()
    while true do
        if autoBuyEgg then
            for _, egg in ipairs(selectedEggs) do
                pcall(function()
                    EggRemote:FireServer(egg)
                end)
                task.wait(0.005)
            end
        end
        task.wait(0.1)
    end
end)

-- 🌿 Seed Tab UI
SeedTab:CreateDropdown({
    Name = "Select Seed",
    Options = seedList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedSeeds = table.find(option, "All") and seedListRaw or option
    end
})

SeedTab:CreateToggle({
    Name = "Auto Buy Seed",
    CurrentValue = false,
    Callback = function(value)
        autoBuySeed = value
    end
})

-- ⚙️ Gear Tab UI
GearTab:CreateDropdown({
    Name = "Select Gear",
    Options = gearList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedGears = table.find(option, "All") and gearListRaw or option
    end
})

GearTab:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Callback = function(value)
        autoBuyGear = value
    end
})

-- 🐣 Pet Tab UI
PetTab:CreateDropdown({
    Name = "Select Egg",
    Options = eggList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedEggs = table.find(option, "All") and eggListRaw or option
    end
})

PetTab:CreateToggle({
    Name = "Auto Buy Egg",
    CurrentValue = false,
    Callback = function(value)
        autoBuyEgg = value
    end
})

-- 📌 Auto Collect Section (อยู่ระหว่างปิดใช้งาน)
MainTab:CreateParagraph({
    Title = "Auto Collect (กำลังพัฒนา)",
    Content = "เร็ว ๆ นี้จะมีระบบเก็บอัตโนมัติ ขอโม้ก่อน ตึงกว่าค่ายอื่นแน่นอนล้านเปอร์เซ็นต์" 
})
