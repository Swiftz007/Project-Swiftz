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

-- โหลด Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

local Window = Rayfield:CreateWindow({
    Name = "Project Swiftz",
    LoadingTitle = "Swiftz Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Tab แยกหมวดหมู่
local MainTab = Window:CreateTab("📖 Main", 4483362458)
local ShopTab = Window:CreateTab("🛒 Shop", 4483362458)
local PetTab = Window:CreateTab("🐣 Pet", 4483362458)

-- รายการไอเท็ม
local seedListRaw = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato",
    "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple",
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
    "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}

local gearListRaw = {
    "Watering Can", "Trowel", "Recall Wrench",
    "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler",
    "Medium Toy", "Medium Treat", "Magnifying Glass", "Tanning Mirror",
    "Cleaning Spray", "Favorite Tool", "Harvest Tool",
    "Friendship Pot", "Levelup Lollipop"
}

local eggListRaw = {
    "Common Egg", "Common Summer Egg", "Rare Summer Egg",
    "Mythical Egg", "Paradise Egg", "Bug Egg"
}

-- ใส่ All
local function withAll(list)
    local newList = { "All" }
    for _, item in ipairs(list) do table.insert(newList, item) end
    return newList
end

local seedList = withAll(seedListRaw)
local gearList = withAll(gearListRaw)
local eggList = withAll(eggListRaw)

-- Remote
local BuySeedRemote = ReplicatedStorage.GameEvents:FindFirstChild("BuySeedStock")
local BuyGearRemote = ReplicatedStorage.GameEvents:FindFirstChild("BuyGearStock")
local BuyEggRemote = ReplicatedStorage.GameEvents:FindFirstChild("BuyPetEgg")

-- State
local selectedSeeds = {}
local selectedGears = {}
local selectedEggs = {}
local autoBuySeed = false
local autoBuyGear = false
local autoBuyEgg = false

-- ฟังก์ชันซื้อ
local function BuyItem(remote, itemName)
    if remote then
        pcall(function()
            remote:FireServer(itemName)
        end)
    end
end

-- Loop Auto Buy (ทีละชิ้น)
task.spawn(function()
    while true do
        if autoBuySeed then
            for _, seed in ipairs(selectedSeeds) do
                    BuyItem(BuySeedRemote, seed)
                    task.wait(0.001)
                end
            end
        end
        task.wait(0.001)
    end
end)

task.spawn(function()
    while true do
        if autoBuyGear then
            for _, gear in ipairs(selectedGears) do
                for _ = 1, 10 do
                    BuyItem(BuyGearRemote, gear)
                    task.wait(0.001)
                end
            end
        end
        task.wait(0.001)
    end
end)

task.spawn(function()
    while true do
        if autoBuyEgg then
            for _, egg in ipairs(selectedEggs) do
                BuyItem(BuyEggRemote, egg)
                task.wait(0.001)
            end
        end
        task.wait(0.001)
    end
end)

-- ▼▼▼ UI Elements ▼▼▼

-- 🌱 Seed Shop
ShopTab:CreateDropdown({
    Name = "Select Seed",
    Options = seedList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(opt)
        selectedSeeds = table.find(opt, "All") and seedListRaw or opt
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Seed",
    CurrentValue = false,
    Callback = function(val)
        autoBuySeed = val
    end
})

-- ⚙️ Gear Shop
ShopTab:CreateDropdown({
    Name = "Select Gear",
    Options = gearList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(opt)
        selectedGears = table.find(opt, "All") and gearListRaw or opt
    end
})

ShopTab:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Callback = function(val)
        autoBuyGear = val
    end
})

-- 🥚 Pet Shop
PetTab:CreateDropdown({
    Name = "Select Egg",
    Options = eggList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(opt)
        selectedEggs = table.find(opt, "All") and eggListRaw or opt
    end
})

PetTab:CreateToggle({
    Name = "Auto Buy Egg",
    CurrentValue = false,
    Callback = function(val)
        autoBuyEgg = val
    end
})

-- 📌 Auto Collect Section (อยู่ระหว่างปิดใช้งาน)
MainTab:CreateParagraph({
    Title = "Auto Collect (กำลังพัฒนา)",
    Content = "เร็ว ๆ นี้จะมีระบบเก็บอัตโนมัติ ขอโม้ก่อน ตึงกว่าค่ายอื่นแน่นอนล้านเปอร์เซ็นต์" 
})
