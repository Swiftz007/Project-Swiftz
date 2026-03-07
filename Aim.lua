-- Rayfield (ใช้ตัวที่คุณให้)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/main/Libraries/Rayfield%20-%20Library.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "Swiftz Hub",
    LoadingTitle = "Swiftz Hub",
    LoadingSubtitle = "Aimbot System",
    ConfigurationSaving = {Enabled = false}
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config
local Config = {
    Aimbot = false,
    SilentAim = false,
    FOV = 120,
    Smooth = 0.15,
    Prediction = 0.12,
    TeamCheck = true,
    VisibleCheck = false,
    ShowFOV = true,
    AimPart = "Head"
}

-- FOV Circle
local Circle = Drawing.new("Circle")
Circle.Filled = false
Circle.Thickness = 2
Circle.NumSides = 100
Circle.Color = Color3.fromRGB(255,255,255)
Circle.Radius = Config.FOV
Circle.Visible = Config.ShowFOV

-- Visibility
local function IsVisible(part)
    if not Config.VisibleCheck then
        return true
    end

    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000

    local ray = Ray.new(origin, direction)
    local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)

    return hit and hit:IsDescendantOf(part.Parent)
end

-- Target Finder
local function GetClosestPlayer()

    local Closest
    local Shortest = Config.FOV

    for _,Player in pairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            if Config.TeamCheck and Player.Team == LocalPlayer.Team then
                continue
            end

            local Character = Player.Character
            if not Character then continue end

            local Part = Character:FindFirstChild(Config.AimPart)
            if not Part then continue end

            local Pos,Visible = Camera:WorldToViewportPoint(Part.Position)

            if Visible and IsVisible(Part) then

                local Distance =
                    (Vector2.new(Pos.X,Pos.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude

                if Distance < Shortest then
                    Shortest = Distance
                    Closest = Player
                end

            end

        end

    end

    return Closest
end

-- Prediction
local function Predict(part)
    return part.Position + (part.Velocity * Config.Prediction)
end

-- Aimbot
RunService.RenderStepped:Connect(function()

    Circle.Position = Vector2.new(Mouse.X,Mouse.Y)
    Circle.Radius = Config.FOV
    Circle.Visible = Config.ShowFOV

    if not Config.Aimbot then return end

    local Target = GetClosestPlayer()
    if not Target then return end

    local Part = Target.Character and Target.Character:FindFirstChild(Config.AimPart)
    if not Part then return end

    local AimPos = Predict(Part)

    local CF = CFrame.new(Camera.CFrame.Position, AimPos)
    Camera.CFrame = Camera.CFrame:Lerp(CF, Config.Smooth)

end)

-- Silent Aim
local Old
Old = hookmetamethod(game,"__index",newcclosure(function(self,index)

    if Config.SilentAim and self == Mouse and index == "Hit" then

        local Target = GetClosestPlayer()

        if Target then
            local Part = Target.Character and Target.Character:FindFirstChild(Config.AimPart)

            if Part then
                return CFrame.new(Predict(Part))
            end
        end

    end

    return Old(self,index)

end))

-- UI
local Tab = Window:CreateTab("Aimbot",4483362458)

Tab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v)
        Config.Aimbot = v
    end
})

Tab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(v)
        Config.SilentAim = v
    end
})

Tab:CreateSlider({
    Name = "FOV",
    Range = {50,300},
    Increment = 1,
    CurrentValue = 120,
    Callback = function(v)
        Config.FOV = v
    end
})

Tab:CreateSlider({
    Name = "Smooth",
    Range = {0,1},
    Increment = 0.01,
    CurrentValue = 0.15,
    Callback = function(v)
        Config.Smooth = v
    end
})

Tab:CreateSlider({
    Name = "Prediction",
    Range = {0,1},
    Increment = 0.01,
    CurrentValue = 0.12,
    Callback = function(v)
        Config.Prediction = v
    end
})

Tab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head","HumanoidRootPart","Torso"},
    CurrentOption = "Head",
    Callback = function(v)
        Config.AimPart = v
    end
})

Tab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(v)
        Config.TeamCheck = v
    end
})

Tab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = false,
    Callback = function(v)
        Config.VisibleCheck = v
    end
})

Tab:CreateToggle({
    Name = "Show FOV",
    CurrentValue = true,
    Callback = function(v)
        Config.ShowFOV = v
    end
})
