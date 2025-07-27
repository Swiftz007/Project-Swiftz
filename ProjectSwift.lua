-- โหลด Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

-- UI Window
local Window = Rayfield:CreateWindow({
    Name = "Project Swiftz",
    LoadingTitle = "Swiftz Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Auto Buy", 4483362458)

-- รายชื่อ Gear
local gearListRaw = {
    "Watering Can", "Trowel", "Recall Wrench",
    "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler",
    "Medium Toy", "Medium Treat", "Magnifying Glass", "Tanning Mirror",
    "Cleaning Spray", "Favorite Tool", "Harvest Tool",
    "Friendship Pot", "Levelup Lollipop"
}

-- รายชื่อ Seed
local seedListRaw = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato",
    "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple",
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
    "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}

-- รายชื่อ Egg
local eggListRaw = {
    "Common", "Common Summer", "Rare Summer",
    "Mythical", "Paradise", "Bug"
}

-- เพิ่ม "All" เข้าไป
local function withAllOption(list)
    local newList = { "All" }
    for _, v in ipairs(list) do
        table.insert(newList, v)
    end
    return newList
end

local gearList = withAllOption(gearListRaw)
local seedList = withAllOption(seedListRaw)
local eggList = withAllOption(eggListRaw)

-- Remote
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GearRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyGearStock")
local SeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")
local EggRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyPetEgg")

-- State
local selectedGears, selectedSeeds, selectedEggs = {}, {}, {}
local autoBuyGear, autoBuySeed, autoBuyEgg = false, false, false

-- Buy Function
local function BuyItem(remote, itemName)
    if remote then
        pcall(function()
            remote:FireServer(itemName)
        end)
    end
end

-- Loop Gear
task.spawn(function()
    while true do
        if autoBuyGear then
            for _, gear in ipairs(selectedGears) do
                BuyItem(GearRemote, gear)
                task.wait(0.001)
            end
        end
        task.wait(0.001)
    end
end)

-- Loop Seed
task.spawn(function()
    while true do
        if autoBuySeed then
            for _, seed in ipairs(selectedSeeds) do
                BuyItem(SeedRemote, seed)
                task.wait(0.001)
            end
        end
        task.wait(0.001)
    end
end)

-- Loop Egg
task.spawn(function()
    while true do
        if autoBuyEgg then
            for _, egg in ipairs(selectedEggs) do
                BuyItem(EggRemote, egg)
                task.wait(0.001)
            end
        end
        task.wait(0.001)
    end
end)

-- === UI ===

-- Section: Seed
Tab:CreateDropdown({
    Name = "Select Seed",
    Options = seedList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedSeeds = table.find(option, "All") and seedListRaw or option
    end
})

Tab:CreateToggle({
    Name = "Auto Buy Seed",
    CurrentValue = false,
    Callback = function(value)
        autoBuySeed = value
    end
})

-- Section: Gear
Tab:CreateDropdown({
    Name = "Select Gear",
    Options = gearList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedGears = table.find(option, "All") and gearListRaw or option
    end
})

Tab:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Callback = function(value)
        autoBuyGear = value
    end
})

-- Section: Egg
Tab:CreateDropdown({
    Name = "Select Egg",
    Options = eggList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        selectedEggs = table.find(option, "All") and eggListRaw or option
    end
})

Tab:CreateToggle({
    Name = "Auto Buy Egg",
    CurrentValue = false,
    Callback = function(value)
        autoBuyEgg = value
    end
})
