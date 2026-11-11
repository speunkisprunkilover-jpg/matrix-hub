-- Sonic Mod Menu by speunkisprunkilover-jpg
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local connections = {}

table.insert(connections, player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end))

-- Remove existing GUI if re-executed
if CoreGui:FindFirstChild("SonicModMenu") then
	CoreGui.SonicModMenu:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SonicModMenu"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

--------------------------------------------------------------------------------
-- SONIC-THEMED LOADING SCREEN ANIMATION (10 Seconds)
--------------------------------------------------------------------------------
local loadScreen = Instance.new("Frame")
loadScreen.Name = "LoadScreen"
loadScreen.Parent = screenGui
loadScreen.BackgroundColor3 = Color3.fromRGB(0, 5, 20)
loadScreen.Size = UDim2.new(1, 0, 1, 0)
loadScreen.ZIndex = 100

local loadFrame = Instance.new("Frame")
loadFrame.Parent = loadScreen
loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadFrame.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadFrame.Size = UDim2.new(0, 360, 0, 140)

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 14)
loadCorner.Parent = loadFrame

local loadStroke = Instance.new("UIStroke")
loadStroke.Parent = loadFrame
loadStroke.Color = Color3.fromRGB(0, 170, 255)
loadStroke.Thickness = 3

local loadTitle = Instance.new("TextLabel")
loadTitle.Parent = loadFrame
loadTitle.BackgroundTransparency = 1
loadTitle.Position = UDim2.new(0, 0, 0, 12)
loadTitle.Size = UDim2.new(1, 0, 0, 25)
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Text = "⚡ SONIC SPEED KERNEL ⚡"
loadTitle.TextColor3 = Color3.fromRGB(255, 220, 0)
loadTitle.TextSize = 14

local statusText = Instance.new("TextLabel")
statusText.Parent = loadFrame
statusText.BackgroundTransparency = 1
statusText.Position = UDim2.new(0, 0, 0, 38)
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Font = Enum.Font.Gotham
statusText.Text = "Gotta go fast..."
statusText.TextColor3 = Color3.fromRGB(150, 220, 255)
statusText.TextSize = 12

local percentText = Instance.new("TextLabel")
percentText.Parent = loadFrame
percentText.BackgroundTransparency = 1
percentText.Position = UDim2.new(0, 0, 0, 104)
percentText.Size = UDim2.new(1, 0, 0, 25)
percentText.Font = Enum.Font.GothamBold
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.TextSize = 15

-- Ring-style Loading Bar Container
local barBg = Instance.new("Frame")
barBg.Parent = loadFrame
barBg.BackgroundColor3 = Color3.fromRGB(0, 15, 50)
barBg.Position = UDim2.new(0.08, 0, 0, 72)
barBg.Size = UDim2.new(0.84, 0, 0, 22)

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(0, 6)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Parent = barBg
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
barFill.Size = UDim2.new(0, 0, 1, 0)

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 6)
barFillCorner.Parent = barFill

-- Sonic ring-sparkle loading particles
task.spawn(function()
	while loadScreen.Parent do
		local ring = Instance.new("TextLabel")
		ring.Parent = loadScreen
		ring.BackgroundTransparency = 1
		ring.Position = UDim2.new(math.random(), 0, -0.1, 0)
		ring.Size = UDim2.new(0, 25, 0, 25)
		ring.Font = Enum.Font.GothamBold
		ring.TextColor3 = Color3.fromRGB(255, 215, 0)
		ring.TextSize = math.random(16, 24)
		ring.Text = "⭕"
		
		TweenService:Create(ring, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {
			Position = UDim2.new(ring.Position.X.Scale, 0, 1.1, 0),
			TextTransparency = 1
		}):Play()
		task.delay(1.2, function() ring:Destroy() end)
		task.wait(0.08)
	end
end)

-- 10-Second Loading Progress Sequence
task.spawn(function()
	local startTime = tick()
	local duration = 10
	
	local statuses = {
		{0.2, "Collecting Chaos Emeralds..."},
		{0.4, "Optimizing wind resistance..."},
		{0.6, "Injected speed vectors..."},
		{0.8, "Breaking sound barrier..."}
	}
	
	while true do
		local elapsed = tick() - startTime
		local alpha = math.clamp(elapsed / duration, 0, 1)
		local percent = math.floor(alpha * 100)
		
		barFill.Size = UDim2.new(alpha, 0, 1, 0)
		percentText.Text = percent .. "%"
		
		for _, data in ipairs(statuses) do
			if alpha >= data[1] then
				statusText.Text = data[2]
			end
		end
		
		if alpha >= 1 then break end
		task.wait(0.02)
	end
	
	loadTitle.Text = "READY TO ROLL!"
	statusText.Text = "Super Sonic Mode Activated."
	task.wait(0.5)
	
	TweenService:Create(loadFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	TweenService:Create(loadScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	loadScreen:Destroy()
end)

--------------------------------------------------------------------------------
-- INTERACTIVE SONIC TOGGLE BALL (Open/Close)
--------------------------------------------------------------------------------
local toggleBall = Instance.new("TextButton")
toggleBall.Name = "ToggleBall"
toggleBall.Parent = screenGui
toggleBall.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
toggleBall.Position = UDim2.new(0, 25, 0.5, -30)
toggleBall.Size = UDim2.new(0, 60, 0, 60)
toggleBall.Font = Enum.Font.GothamBold
toggleBall.Text = "🌀"
toggleBall.TextColor3 = Color3.fromRGB(255, 220, 0)
toggleBall.TextSize = 28

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = toggleBall

local ballStroke = Instance.new("UIStroke")
ballStroke.Parent = toggleBall
ballStroke.Color = Color3.fromRGB(0, 170, 255)
ballStroke.Thickness = 3

task.spawn(function()
	while toggleBall and toggleBall.Parent do
		TweenService:Create(ballStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Transparency = 0.1}):Play()
		TweenService:Create(toggleBall, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 64, 0, 64)}):Play()
		task.wait(0.8)
		TweenService:Create(ballStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Transparency = 0.6}):Play()
		TweenService:Create(toggleBall, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 60, 0, 60)}):Play()
		task.wait(0.8)
	end
end)

--------------------------------------------------------------------------------
-- MAIN MENU GUI (Sonic Blue & Gold Design)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 20, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.ClipsDescendants = true
mainFrame.Visible = false

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Parent = mainFrame
frameStroke.Color = Color3.fromRGB(0, 170, 255)
frameStroke.Thickness = 2.5

-- Title Bar
local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(0, 40, 100)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Font = Enum.Font.GothamBold
titleBar.Text = "  ⚡ SONIC MOD MENU ⚡"
titleBar.TextColor3 = Color3.fromRGB(255, 220, 0)
titleBar.TextSize = 14
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.AutoButtonColor = false

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local scrollContainer = Instance.new("ScrollingFrame")
scrollContainer.Parent = mainFrame
scrollContainer.BackgroundTransparency = 1
scrollContainer.Position = UDim2.new(0, 0, 0, 50)
scrollContainer.Size = UDim2.new(1, 0, 1, -50)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1200)
scrollContainer.ScrollBarThickness = 5
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local uiLayout = Instance.new("UIListLayout")
uiLayout.Parent = scrollContainer
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 10)

--------------------------------------------------------------------------------
-- DRAGGABLE SYSTEM
--------------------------------------------------------------------------------
local function makeDraggable(obj, handle)
	handle = handle or obj
	local dragging, dragStart, startPos

	table.insert(connections, handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end))

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))
end

makeDraggable(mainFrame, titleBar)
makeDraggable(toggleBall)

--------------------------------------------------------------------------------
-- HELPER BUILDERS
--------------------------------------------------------------------------------
local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = scrollContainer
	btn.BackgroundColor3 = Color3.fromRGB(10, 35, 80)
	btn.Size = UDim2.new(0.9, 0, 0, 45)
	btn.Font = Enum.Font.GothamBold
	btn.Text = "  [  ] " .. name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Color = Color3.fromRGB(0, 130, 220)
	stroke.Thickness = 1.5

	local active = false
	table.insert(connections, btn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			btn.Text = "  [X] " .. name
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 90, 200)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 220, 0)}):Play()
		else
			btn.Text = "  [  ] " .. name
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 35, 80)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 130, 220)}):Play()
		end
		callback(active)
	end))
end

local function createSlider(name, min, max, defaultVal, callback)
	local container = Instance.new("Frame")
	container.Parent = scrollContainer
	container.BackgroundColor3 = Color3.fromRGB(10, 35, 80)
	container.Size = UDim2.new(0.9, 0, 0, 65)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Parent = container
	stroke.Color = Color3.fromRGB(0, 130, 220)
	stroke.Thickness = 1.5

	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(1, -24, 0, 22)
	label.Font = Enum.Font.GothamBold
	label.Text = name .. ": " .. defaultVal
	label.TextColor3 = Color3.fromRGB(255, 220, 0)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left

	local sliderBar = Instance.new("TextButton")
	sliderBar.Parent = container
	sliderBar.BackgroundColor3 = Color3.fromRGB(5, 15, 40)
	sliderBar.Position = UDim2.new(0, 12, 0, 35)
	sliderBar.Size = UDim2.new(1, -24, 0, 16)
	sliderBar.Text = ""
	sliderBar.AutoButtonColor = false

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 5)
	barCorner.Parent = sliderBar

	local fill = Instance.new("Frame")
	fill.Parent = sliderBar
	fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	local initialAlpha = (defaultVal - min) / (max - min)
	fill.Size = UDim2.new(initialAlpha, 0, 1, 0)
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = fill

	local dragging = false
	
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
		local val = math.floor(min + ((max - min) * pos))
		label.Text = name .. ": " .. val
		callback(val)
	end

	table.insert(connections, sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input)
		end
	end))

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))
end

--------------------------------------------------------------------------------
-- FEATURE LOGIC IMPLEMENTATION
--------------------------------------------------------------------------------

-- 1. C-FRAME SPEED BOOST (0-50000)
local cframeSpeed = 0
createSlider("C-FRAME SPEED", 0, 50000, 0, function(val)
	cframeSpeed = val
end)

table.insert(connections, RunService.RenderStepped:Connect(function()
	if cframeSpeed > 0 and rootPart then
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			rootPart.CFrame = rootPart.CFrame + (moveDir * (cframeSpeed / 50))
		end
	end
end))

-- 2. NORMAL SPEED BOOST (16-50000)
createSlider("NORMAL SPEED", 16, 50000, 16, function(val)
	if humanoid then
		humanoid.WalkSpeed = val
	end
end)

-- 3. INF JUMP
local infJumpEnabled = false
table.insert(connections, UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))
createToggle("INF JUMP", function(state)
	infJumpEnabled = state
end)

-- 4. JUMP BOOST (12-5000)
createSlider("JUMP BOOST", 12, 5000, 50, function(val)
	if humanoid then
		humanoid.JumpPower = val
	end
end)

-- 5. ESP (Red Highlight)
local espEnabled = false
createToggle("ESP (RED)", function(state)
	espEnabled = state
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local highlight = p.Character:FindFirstChild("SonicESPHighlight")
			if state and not highlight then
				local h = Instance.new("Highlight")
				h.Name = "SonicESPHighlight"
				h.Adornee = p.Character
				h.FillColor = Color3.fromRGB(255, 0, 0)
				h.OutlineColor = Color3.fromRGB(255, 255, 0)
				h.Parent = p.Character
			elseif not state and highlight then
				highlight:Destroy()
			end
		end
	end
end)

table.insert(connections, Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		if espEnabled then
			task.wait(1)
			local h = Instance.new("Highlight")
			h.Name = "SonicESPHighlight"
			h.Adornee = char
			h.FillColor = Color3.fromRGB(255, 0, 0)
			h.OutlineColor = Color3.fromRGB(255, 255, 0)
			h.Parent = char
		end
	end)
end))

-- 6. NOCLIP
local noclipConnection
createToggle("NOCLIP", function(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			if character then
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() end
	end
end)

-- 7. FREECAM (Makes camera fly around with keys while player stays put)
local freecamEnabled = false
local freecamConn
local freecamPos
createToggle("FREECAM", function(state)
	freecamEnabled = state
	if state then
		freecamPos = Camera.CFrame.Position
		Camera.CameraType = Enum.CameraType.Scriptable
		freecamConn = RunService.RenderStepped:Connect(function(dt)
			local move = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
			freecamPos = freecamPos + (Camera.CFrame:VectorToWorldSpace(move) * 70 * dt)
			Camera.CFrame = CFrame.new(freecamPos) * Camera.CFrame - Camera.CFrame.Position
		end)
	else
		if freecamConn then freecamConn:Disconnect() end
		Camera.CameraType = Enum.CameraType.Custom
	end
end)

-- 8. HITBOX EXPANDER (5-50000)
local hitboxSize = 5
createSlider("HITBOX EXPANDER", 5, 50000, 5, function(val)
	hitboxSize = val
end)

table.insert(connections, RunService.RenderStepped:Connect(function()
	if hitboxSize > 5 then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				hrp.Transparency = 0.7
				hrp.BrickColor = BrickColor.new("Bright red")
				hrp.CanCollide = false
			end
		end
	end
end))

--------------------------------------------------------------------------------
-- UNLOAD SCRIPT BUTTON
--------------------------------------------------------------------------------
local unloadBtn = Instance.new("TextButton")
unloadBtn.Parent = scrollContainer
unloadBtn.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
unloadBtn.Size = UDim2.new(0.9, 0, 0, 45)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.Text = "  [!] UNLOAD SCRIPT"
unloadBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
unloadBtn.TextSize = 13
unloadBtn.TextXAlignment = Enum.TextXAlignment.Left

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadBtn

local unloadStroke = Instance.new("UIStroke")
unloadStroke.Parent = unloadBtn
unloadStroke.Color = Color3.fromRGB(200, 30, 30)
unloadStroke.Thickness = 1.5

table.insert(connections, unloadBtn.MouseButton1Click:Connect(function()
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end
	if freecamConn then freecamConn:Disconnect() end
	if noclipConnection then noclipConnection:Disconnect() end
	Camera.CameraType = Enum.CameraType.Custom
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	screenGui:Destroy()
end))

--------------------------------------------------------------------------------
-- 30X COOLER OPEN / CLOSE ANIMATION LOGIC
--------------------------------------------------------------------------------
local menuOpen = false

table.insert(connections, toggleBall.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		mainFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		
		TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 350, 0, 400),
			Position = UDim2.new(0.5, -175, 0.5, -200)
		}):Play()
		
		TweenService:Create(toggleBall, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Rotation = 360, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	else
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not menuOpen then
				mainFrame.Visible = false
			end
		end)
		
		TweenService:Create(toggleBall, TweenInfo.new(0.3), {Rotation = 0, TextColor3 = Color3.fromRGB(255, 220, 0)}):Play()
	end
end))

print("Sonic Mod Menu loaded successfully.")
