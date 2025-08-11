-- ⚙️ โหลด Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 📦 Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GearRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyGearStock")
local SeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")
local EggRemote  = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyPetEgg")

-- 📋 รายการของ
local gearListRaw = {
    "Watering Can", "Trowel", "Recall Wrench", "Trading Ticket", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Master Sprinkler", "Medium Toy", "Medium Treat", "Magnifying Glass",
    "Tanning Mirror", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Grandmaster Sprinkler", "Levelup Lollipop"
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
    local copy = table.clone(list)
    table.insert(copy, 1, "All")
    return copy
end

-- 🪟 Fluent Window
local Window = Fluent:CreateWindow({
    Title = "Project Swiftz",
    SubTitle = "Grow a Graden",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- 🛍️ Multi Dropdowns สำหรับ Shop
local gearDropdown = Tabs.Shop:AddDropdown("GearDropdown", {
    Title = "Gears",
    Values = withAllOption(gearListRaw),
    Multi = true,
    Default = {},
})

local seedDropdown = Tabs.Shop:AddDropdown("SeedDropdown", {
    Title = "Seeds",
    Values = withAllOption(seedListRaw),
    Multi = true,
    Default = {},
})

local eggDropdown = Tabs.Shop:AddDropdown("EggDropdown", {
    Title = "Eggs",
    Values = withAllOption(eggListRaw),
    Multi = true,
    Default = {},
})

-- 🔄 ระบบเปิดปิด Auto Buy
local AutoBuyToggle = Tabs.Shop:AddToggle("AutoBuy", {
    Title = "Auto Buy (Fast Loop)",
    Default = false
})

-- 🧠 ฟังก์ชันเลือกไอเทม
local function getSelectedItems(dropdown, rawList)
    local selected = {}
    if dropdown.Value["All"] then
        return rawList
    end
    for item, state in pairs(dropdown.Value) do
        if state then
            table.insert(selected, item)
        end
    end
    return selected
end

-- 🔁 รัน Auto Buy Loop
task.spawn(function()
    while true do
        task.wait() -- ไม่มีดีเลย์เพื่อความเร็วสูงสุด
        if AutoBuyToggle.Value then
            -- ซื้อ Gear
            for _, item in ipairs(getSelectedItems(gearDropdown, gearListRaw)) do
                GearRemote:FireServer(item)
            end
            -- ซื้อ Seed
            for _, item in ipairs(getSelectedItems(seedDropdown, seedListRaw)) do
                SeedRemote:FireServer(item)
            end
            -- ซื้อ Egg
            for _, item in ipairs(getSelectedItems(eggDropdown, eggListRaw)) do
                EggRemote:FireServer(item)
            end
        end
    end
end)

-- ⚙️ SaveManager / Interface
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ProjectSwiftz")
SaveManager:SetFolder("ProjectSwiftz/GrowAGarden")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)

Fluent:Notify({
    Title = "Project Swiftz",
    Content = "Swiftz Loaded",
    Duration = 6
})
