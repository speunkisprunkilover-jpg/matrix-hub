-- Matrix Mod Menu by speunkisprunkilover-jpg (Upgraded Edition)
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

-- Active connections tracking for clean unloading
local activeConnections = {}

local function trackConnection(conn)
	table.insert(activeConnections, conn)
	return conn
end

trackConnection(player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end))

-- Remove existing GUI if re-executed
if CoreGui:FindFirstChild("MatrixModMenu") then
	CoreGui.MatrixModMenu:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MatrixModMenu"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

--------------------------------------------------------------------------------
-- CINEMATIC MATRIX LOADING SCREEN
--------------------------------------------------------------------------------
local loadScreen = Instance.new("Frame")
loadScreen.Name = "LoadScreen"
loadScreen.Parent = screenGui
loadScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadScreen.Size = UDim2.new(1, 0, 1, 0)
loadScreen.ZIndex = 100

local loadText = Instance.new("TextLabel")
loadText.Parent = loadScreen
loadText.BackgroundTransparency = 1
loadText.Position = UDim2.new(0.5, -200, 0.5, -50)
loadText.Size = UDim2.new(0, 400, 0, 100)
loadText.Font = Enum.Font.Code
loadText.Text = "INITIALIZING MATRIX..."
loadText.TextColor3 = Color3.fromRGB(0, 255, 65)
loadText.TextSize = 24
loadText.TextTransparency = 1

TweenService:Create(loadText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

-- Code rain visual effect
local rainRoutine = task.spawn(function()
	local chars = "01ABCDEFXYZ#*+-_"
	while loadScreen and loadScreen.Parent do
		local glyph = Instance.new("TextLabel")
		glyph.Parent = loadScreen
		glyph.BackgroundTransparency = 1
		glyph.Position = UDim2.new(math.random(), 0, -0.1, 0)
		glyph.Size = UDim2.new(0, 20, 0, 20)
		glyph.Font = Enum.Font.Code
		glyph.TextColor3 = Color3.fromRGB(0, 200, 45)
		glyph.TextSize = math.random(14, 22)
		glyph.Text = string.sub(chars, math.random(1, #chars), math.random(1, #chars))
		
		TweenService:Create(glyph, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {
			Position = UDim2.new(glyph.Position.X.Scale, 0, 1.1, 0),
			TextTransparency = 1
		}):Play()
		
		task.delay(1.2, function() glyph:Destroy() end)
		task.wait(0.05)
	end
end)

task.wait(1.8)
task.cancel(rainRoutine)
TweenService:Create(loadScreen, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
TweenService:Create(loadText, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
task.wait(0.6)
loadScreen:Destroy()

--------------------------------------------------------------------------------
-- FLOATING TOGGLE BALL (Open/Close Button)
--------------------------------------------------------------------------------
local toggleBall = Instance.new("TextButton")
toggleBall.Name = "ToggleBall"
toggleBall.Parent = screenGui
toggleBall.BackgroundColor3 = Color3.fromRGB(0, 20, 5)
toggleBall.Position = UDim2.new(0, 20, 0.5, -30)
toggleBall.Size = UDim2.new(0, 60, 0, 60)
toggleBall.Font = Enum.Font.Code
toggleBall.Text = "⚡"
toggleBall.TextColor3 = Color3.fromRGB(0, 255, 65)
toggleBall.TextSize = 26

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = toggleBall

local ballStroke = Instance.new("UIStroke")
ballStroke.Parent = toggleBall
ballStroke.Color = Color3.fromRGB(0, 255, 65)
ballStroke.Thickness = 2

-- Smooth floating bounce animation for the toggle ball
task.spawn(function()
	while toggleBall and toggleBall.Parent do
		TweenService:Create(toggleBall, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = toggleBall.Position + UDim2.new(0, 0, 0, -6)
		}):Play()
		task.wait(1)
		TweenService:Create(toggleBall, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = toggleBall.Position + UDim2.new(0, 0, 0, 6)
		}):Play()
		task.wait(1)
	end
end)

--------------------------------------------------------------------------------
-- MAIN MENU GUI (Draggable + Mobile Friendly)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 5)
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
frameStroke.Color = Color3.fromRGB(0, 255, 65)
frameStroke.Thickness = 2.5

-- Title Bar (Draggable Handler)
local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(0, 25, 8)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Font = Enum.Font.Code
titleBar.Text = " [ MATRIX MOD MENU ]"
titleBar.TextColor3 = Color3.fromRGB(0, 255, 65)
titleBar.TextSize = 15
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.AutoButtonColor = false

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

-- Draggable implementation for Main Frame
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

trackConnection(UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end))

-- Scrolling Container for Features
local scrollContainer = Instance.new("ScrollingFrame")
scrollContainer.Parent = mainFrame
scrollContainer.BackgroundTransparency = 1
scrollContainer.Position = UDim2.new(0, 0, 0, 50)
scrollContainer.Size = UDim2.new(1, 0, 1, -50)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 950)
scrollContainer.ScrollBarThickness = 6
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 65)

local uiLayout = Instance.new("UIListLayout")
uiLayout.Parent = scrollContainer
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 10)

--------------------------------------------------------------------------------
-- HELPER BUILDERS WITH JUICY ANIMATIONS
--------------------------------------------------------------------------------
local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = scrollContainer
	btn.BackgroundColor3 = Color3.fromRGB(10, 30, 12)
	btn.Size = UDim2.new(0.9, 0, 0, 45)
	btn.Font = Enum.Font.Code
	btn.Text = "  [ ] " .. name
	btn.TextColor3 = Color3.fromRGB(0, 255, 65)
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Color = Color3.fromRGB(0, 150, 35)
	stroke.Thickness = 1

	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		
		-- Juicy click feedback animation
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.85, 0, 0, 40)
		}):Play()
		task.delay(0.15, function()
			if btn and btn.Parent then
				TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0.9, 0, 0, 45)
				}):Play()
			end
		end)

		if active then
			btn.Text = "  [X] " .. name
			TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 70, 25)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 65)}):Play()
		else
			btn.Text = "  [ ] " .. name
			TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(10, 30, 12)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 150, 35)}):Play()
		end
		callback(active)
	end)
end

local function createSlider(name, min, max, defaultVal, callback)
	local container = Instance.new("Frame")
	container.Parent = scrollContainer
	container.BackgroundColor3 = Color3.fromRGB(10, 30, 12)
	container.Size = UDim2.new(0.9, 0, 0, 65)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Parent = container
	stroke.Color = Color3.fromRGB(0, 150, 35)
	stroke.Thickness = 1

	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 5)
	label.Size = UDim2.new(1, -20, 0, 25)
	label.Font = Enum.Font.Code
	label.Text = name .. ": " .. defaultVal
	label.TextColor3 = Color3.fromRGB(0, 255, 65)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left

	local sliderBar = Instance.new("TextButton")
	sliderBar.Parent = container
	sliderBar.BackgroundColor3 = Color3.fromRGB(5, 15, 8)
	sliderBar.Position = UDim2.new(0, 10, 0, 35)
	sliderBar.Size = UDim2.new(1, -20, 0, 15)
	sliderBar.Text = ""

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 4)
	barCorner.Parent = sliderBar

	local fill = Instance.new("Frame")
	fill.Parent = sliderBar
	fill.BackgroundColor3 = Color3.fromRGB(0, 255, 65)
	local initialAlpha = (defaultVal - min) / (max - min)
	fill.Size = UDim2.new(initialAlpha, 0, 1, 0)
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 4)
	fillCorner.Parent = fill

	local draggingSlider = false
	
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(pos, 0, 1, 0)
		local val = math.floor(min + ((max - min) * pos))
		label.Text = name .. ": " .. val
		callback(val)
	end

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			update(input)
		end
	end)

	trackConnection(UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end))

	trackConnection(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end))
end

--------------------------------------------------------------------------------
-- FEATURE LOGIC IMPLEMENTATION
--------------------------------------------------------------------------------

-- 1. INF JUMP
local infJumpEnabled = false
trackConnection(UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))
createToggle("INF JUMP", function(state)
	infJumpEnabled = state
end)

-- 2. NO GRAVITY
createToggle("NO GRAVITY", function(state)
	if state then
		workspace.Gravity = 0
	else
		workspace.Gravity = 196.2
	end
end)

-- 3. GUI SIZE (1-500)
createSlider("GUI SIZE", 1, 500, 350, function(val)
	local scale = val / 350
	mainFrame.Size = UDim2.new(0, math.clamp(350 * scale, 150, 700), 0, math.clamp(400 * scale, 150, 750))
end)

-- 4. AIMBOT
local aimbotEnabled = false
local aimbotFov = 50
createToggle("AIMBOT", function(state)
	aimbotEnabled = state
end)
createSlider("AIMBOT FOV", 0, 250, 50, function(val)
	aimbotFov = val
end)

trackConnection(RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local closestTarget = nil
		local shortestDist = aimbotFov
		
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then
					local headPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
					if onScreen then
						local mousePos = UserInputService:GetMouseLocation()
						local dist = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
						if dist < shortestDist then
							shortestDist = dist
							closestTarget = p.Character.Head
						end
					end
				end
			end
		end
		
		if closestTarget then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
		end
	end
end))

-- 5. INVISIBLE
createToggle("INVISIBLE (Local Only)", function(state)
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = state and 1 or (part.Name == "HumanoidRootPart" and 1 or 0)
			end
		end
	end
end)

-- 6. TINY AVATAR
createToggle("TINY AVATAR", function(state)
	if character and character:FindFirstChild("Humanoid") then
		local desc = character.Humanoid:GetAppliedDescription()
		if state then
			desc.HeadScale = 0.5
			desc.HeightScale = 0.5
			desc.WidthScale = 0.5
			desc.ProportionScale = 0.5
		else
			desc.HeadScale = 1
			desc.HeightScale = 1
			desc.WidthScale = 1
			desc.ProportionScale = 1
		end
		character.Humanoid:ApplyDescription(desc)
	end
end)

-- 7. JUMP BOOST
createSlider("JUMP BOOST", 0, 500, 50, function(val)
	if humanoid then
		humanoid.JumpPower = 50 + val
	end
end)

-- 8. NORMAL SPEED BOOST
createSlider("NORMAL SPEED BOOST", 0, 1000, 16, function(val)
	if humanoid then
		humanoid.WalkSpeed = 16 + val
	end
end)

-- 9. C-FRAME SPEED BOOST
local cframeSpeed = 0
createSlider("CFRAME SPEED BOOST", 0, 1000, 0, function(val)
	cframeSpeed = val
end)

trackConnection(RunService.RenderStepped:Connect(function()
	if cframeSpeed > 0 and rootPart then
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			rootPart.CFrame = rootPart.CFrame + (moveDir * (cframeSpeed / 50))
		end
	end
end))

--------------------------------------------------------------------------------
-- UNLOAD BUTTON (Panic / Clean Exit)
--------------------------------------------------------------------------------
local unloadBtn = Instance.new("TextButton")
unloadBtn.Parent = scrollContainer
unloadBtn.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
unloadBtn.Size = UDim2.new(0.9, 0, 0, 45)
unloadBtn.Font = Enum.Font.Code
unloadBtn.Text = "  [!] UNLOAD SCRIPT"
unloadBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
unloadBtn.TextSize = 14
unloadBtn.TextXAlignment = Enum.TextXAlignment.Left

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadBtn

local unloadStroke = Instance.new("UIStroke")
unloadStroke.Parent = unloadBtn
unloadStroke.Color = Color3.fromRGB(200, 40, 40)
unloadStroke.Thickness = 1

unloadBtn.MouseButton1Click:Connect(function()
	-- Disconnect all active loops and event listeners
	for _, conn in ipairs(activeConnections) do
		conn:Disconnect()
	end
	workspace.Gravity = 196.2
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end
	screenGui:Destroy()
end)

--------------------------------------------------------------------------------
-- 30X COOLER SPRING OPEN / CLOSE ANIMATION LOGIC
--------------------------------------------------------------------------------
local menuOpen = false

toggleBall.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		mainFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		
		-- Snappy Back/Spring open effect
		TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 350, 0, 400),
			Position = UDim2.new(0.5, -175, 0.5, -200)
		}):Play()
		
		TweenService:Create(toggleBall, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Rotation = 360, BackgroundColor3 = Color3.fromRGB(0, 60, 20)}):Play()
	else
		-- Smooth close effect
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not menuOpen then
				mainFrame.Visible = false
			end
		end)
		
		TweenService:Create(toggleBall, TweenInfo.new(0.3), {Rotation = 0, BackgroundColor3 = Color3.fromRGB(0, 20, 5)}):Play()
	end
end)

-- Make toggle ball draggable for mobile convenience
local draggingBall = false
local ballDragStart, ballStartPos

toggleBall.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingBall = true
		ballDragStart = input.Position
		ballStartPos = toggleBall.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingBall = false
			end
		end)
	end
end)

trackConnection(UserInputService.InputChanged:Connect(function(input)
	if draggingBall and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - ballDragStart
		toggleBall.Position = UDim2.new(ballStartPos.X.Scale, ballStartPos.X.Offset + delta.X, ballStartPos.Y.Scale, ballStartPos.Y.Offset + delta.Y)
	end
end))

print("Matrix Mod Menu (Upgraded) loaded successfully.")
