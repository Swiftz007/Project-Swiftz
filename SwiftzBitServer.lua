--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

---------------------------------------------------------
-- MAIN UI
---------------------------------------------------------

local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 300)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.05
Main.Active = true
Main.Parent = gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

---------------------------------------------------------
-- RAINBOW BORDER
---------------------------------------------------------

local Border = Instance.new("UIStroke", Main)
Border.Thickness = 2
Border.Color = Color3.fromRGB(255,0,0)

task.spawn(function()
    local hue = 0
    while Main.Parent do
        hue = (hue + 0.0025) % 1
        Border.Color = Color3.fromHSV(hue, 1, 1)
        task.wait()
    end
end)

---------------------------------------------------------
-- DRAG + BOUNCE
---------------------------------------------------------

local dragging = false
local dragInput, dragStart, startPos

local function Bounce(frame)
	local g1 = TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 530, 0, 310)
	})
	local g2 = TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 520, 0, 300)
	})
	g1:Play()
	g1.Completed:Wait()
	g2:Play()
end

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
	startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				Bounce(Main)
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

---------------------------------------------------------
-- TITLE
---------------------------------------------------------

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Server Finder • Advanced"
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(255,255,255)

---------------------------------------------------------
-- STATUS + PING TEXT
---------------------------------------------------------

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 60)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamMedium
Status.TextSize = 18
Status.TextColor3 = Color3.fromRGB(220,220,220)
Status.Text = "Status: Ready"
Status.TextXAlignment = Enum.TextXAlignment.Left

local PingTXT = Instance.new("TextLabel", Main)
PingTXT.Size = UDim2.new(1, -20, 0, 30)
PingTXT.Position = UDim2.new(0, 10, 0, 90)
PingTXT.BackgroundTransparency = 1
PingTXT.Font = Enum.Font.Gotham
PingTXT.TextSize = 18
PingTXT.TextColor3 = Color3.fromRGB(220,220,220)
PingTXT.Text = "Ping: Checking..."
PingTXT.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
	while gui.Parent do
		local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		PingTXT.Text = "Ping: "..math.floor(ping).." ms"
		task.wait(1)
	end
end)

---------------------------------------------------------
-- TOGGLE HIGH / LOW PING
---------------------------------------------------------

local Mode = "Low"

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 170, 0, 40)
Toggle.Position = UDim2.new(0.34,0,0.45,0)
Toggle.Font = Enum.Font.GothamMedium
Toggle.TextSize = 18
Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.Text = "Mode: Low Ping"
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)

Toggle.MouseButton1Click:Connect(function()
	if Mode == "Low" then
		Mode = "High"
		Toggle.Text = "Mode: High Ping"
		Toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
	else
		Mode = "Low"
		Toggle.Text = "Mode: Low Ping"
		Toggle.BackgroundColor3 = Color3.fromRGB(50,150,50)
	end
end)

---------------------------------------------------------
-- BUTTON CREATOR (Hover Animation)
---------------------------------------------------------

local function MakeButton(parent, text, color)
	local B = Instance.new("TextButton", parent)
	B.Size = UDim2.new(0, 180, 0, 45)
	B.Font = Enum.Font.GothamMedium
	B.TextSize = 20
	B.TextColor3 = Color3.fromRGB(255,255,255)
	B.Text = text
	B.BackgroundColor3 = color
	Instance.new("UICorner", B).CornerRadius = UDim.new(0,10)

	B.MouseEnter:Connect(function()
		TweenService:Create(B, TweenInfo.new(0.2),
		{BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.15)}):Play()
	end)

	B.MouseLeave:Connect(function()
		TweenService:Create(B, TweenInfo.new(0.2),
		{BackgroundColor3 = color}):Play()
	end)

	return B
end

local Cancel = MakeButton(Main, "Cancel", Color3.fromRGB(70,70,70))
Cancel.Position = UDim2.new(0.05,0,0.75,0)

local Find = MakeButton(Main, "Find Server", Color3.fromRGB(0,120,255))
Find.Position = UDim2.new(0.55,0,0.75,0)

---------------------------------------------------------
-- POPUP GLASS
---------------------------------------------------------

local Popup = Instance.new("Frame", gui)
Popup.Size = UDim2.new(0, 330, 0, 190)
Popup.Position = UDim2.new(0.5,0,0.5,0)
Popup.AnchorPoint = Vector2.new(0.5,0.5)
Popup.BackgroundColor3 = Color3.fromRGB(30,30,30)
Popup.BackgroundTransparency = 0.25
Popup.Visible = false
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,15)

local PBorder = Instance.new("UIStroke", Popup)
PBorder.Thickness = 2
PBorder.Color = Color3.fromRGB(120,120,255)

local Blur = Instance.new("ImageLabel", Popup)
Blur.Size = UDim2.new(1,0,1,0)
Blur.BackgroundTransparency = 1
Blur.Image = "rbxassetid://8992230677"
Blur.ImageTransparency = 0.65
Instance.new("UICorner", Blur)

local PText = Instance.new("TextLabel", Popup)
PText.Size = UDim2.new(1,0,0,60)
PText.Position = UDim2.new(0,0,0.1,0)
PText.BackgroundTransparency = 1
PText.Font = Enum.Font.GothamBold
PText.TextSize = 22
PText.TextColor3 = Color3.fromRGB(255,255,255)
PText.Text = "Join this server?"

local Yes = MakeButton(Popup, "Yes", Color3.fromRGB(0,180,0))
Yes.Size = UDim2.new(0,130,0,45)
Yes.Position = UDim2.new(0.1,0,0.65,0)

local No = MakeButton(Popup, "No", Color3.fromRGB(180,0,0))
No.Size = UDim2.new(0,130,0,45)
No.Position = UDim2.new(0.55,0,0.65,0)

---------------------------------------------------------
-- FETCH SERVERS (with ping filter)
---------------------------------------------------------

local Cursor = ""
local SelectedServer = nil

local function FetchOne()
	local url =
		"https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"

	if Cursor ~= "" then url = url.."&cursor="..Cursor end

	local data = HttpService:JSONDecode(game:HttpGet(url))
	for _, s in ipairs(data.data) do
		if s.id ~= game.JobId and s.playing < s.maxPlayers then

			-- ตรวจสอบ ping
			if Mode == "Low" then
				local checkPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
				if checkPing <= 120 then
					return s
				end
			else
				return s
			end
		end
	end

	Cursor = data.nextPageCursor or ""
	return nil
end

local function FadeIn(obj)
	obj.Visible = true
	obj.BackgroundTransparency = 1
	TweenService:Create(obj, TweenInfo.new(0.25),
	{BackgroundTransparency = 0.25}):Play()
end

local function FadeOut(obj)
	TweenService:Create(obj, TweenInfo.new(0.25),
	{BackgroundTransparency = 1}):Play()
	task.wait(0.25)
	obj.Visible = false
end

local function StartFind()
	Status.Text = "Status: Searching..."
	Cursor = ""

	repeat
		local s = FetchOne()
		if s then
			SelectedServer = s
			PText.Text = "Players: "..s.playing.." • Ping OK?"
			FadeIn(Popup)
			return
		end

		Status.Text = "Searching next page..."
		task.wait(0.5)

	until false
end

---------------------------------------------------------
-- BUTTON EVENTS
---------------------------------------------------------

Find.MouseButton1Click:Connect(StartFind)

Cancel.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

No.MouseButton1Click:Connect(function()
	FadeOut(Popup)
	task.wait(0.1)
	StartFind()
end)

Yes.MouseButton1Click:Connect(function()
	TeleportService:TeleportToPlaceInstance(PlaceId, SelectedServer.id, LocalPlayer)
end)
