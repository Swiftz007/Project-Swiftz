-- โหลด Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

-- UI Window
local Window = Rayfield:CreateWindow({
    Name = "Swiftz Hub - Auto Buyer",
    LoadingTitle = "Loading Auto Buyer...",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Auto Buy", 4483362458)

-- List Gears
local gearListRaw = {
    "Watering Can", "Trowel", "Recall Wrench",
    "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler",
    "Medium Toy", "Medium Treat", "Magnifying Glass", "Tanning Mirror",
    "Cleaning Spray", "Favorite Tool", "Harvest Tool",
    "Friendship Pot", "Levelup Lollipop"
}

-- List Seeds
local seedListRaw = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato",
    "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple",
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
    "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}

-- เพิ่ม "All" เข้าไปใน Dropdown
local gearList = { "All" }
for _, v in ipairs(gearListRaw) do table.insert(gearList, v) end

local seedList = { "All" }
for _, v in ipairs(seedListRaw) do table.insert(seedList, v) end

-- Remote references
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GearRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuyGearStock")
local SeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("BuySeedStock")

-- State
local selectedGears = {}
local selectedSeeds = {}
local autoBuyGear = false
local autoBuySeed = false

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
                task.wait(0.1)
            end
        end
        task.wait(0.1)
    end
end)

-- Loop Seed
task.spawn(function()
    while true do
        if autoBuySeed then
            for _, seed in ipairs(selectedSeeds) do
                BuyItem(SeedRemote, seed)
                task.wait(0.1)
            end
        end
        task.wait(0.1)
    end
end)

-- Dropdown Gear
Tab:CreateDropdown({
    Name = "Select Gear",
    Options = gearList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        if table.find(option, "All") then
            selectedGears = gearListRaw
        else
            selectedGears = option
        end
    end
})

-- Toggle Auto Buy Gear
Tab:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = false,
    Callback = function(state)
        autoBuyGear = state
    end
})

-- Dropdown Seed
Tab:CreateDropdown({
    Name = "Select Seed",
    Options = seedList,
    MultiSelection = true,
    CurrentOption = {},
    Callback = function(option)
        if table.find(option, "All") then
            selectedSeeds = seedListRaw
        else
            selectedSeeds = option
        end
    end
})

-- Toggle Auto Buy Seed
Tab:CreateToggle({
    Name = "Auto Buy Seed",
    CurrentValue = false,
    Callback = function(state)
        autoBuySeed = state
    end
})
