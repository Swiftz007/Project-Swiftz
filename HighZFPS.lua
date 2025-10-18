local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FPS+"
gui.ResetOnSpawn = false

-- FPS Boost Function (Remove Textures, Clothes)
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    end
end

for _, v in pairs(Players:GetPlayers()) do
    if v.Character and v ~= player then
        for _, item in pairs(v.Character:GetDescendants()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                item:Destroy()
            end
        end
    end
end
