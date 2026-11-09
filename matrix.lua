-- Matrix Mod Menu (10s Loading Edition) by speunkisprunkilover-jpg
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
-- 10-SECOND LOADING SCREEN WITH PROGRESS BAR
--------------------------------------------------------------------------------
local loadScreen = Instance.new("Frame")
loadScreen.Name = "LoadScreen"
loadScreen.Parent = screenGui
loadScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadScreen.Size = UDim2.new(1, 0, 1, 0)
loadScreen.ZIndex = 100

local loadFrame = Instance.new("Frame")
loadFrame.Parent = loadScreen
loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadFrame.BackgroundColor3 = Color3.fromRGB(3, 12, 5)
loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadFrame.Size = UDim2.new(0, 340, 0, 110)

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 10)
loadCorner.Parent = loadFrame

local loadStroke = Instance.new("UIStroke")
loadStroke.Parent = loadFrame
loadStroke.Color = Color3.fromRGB(0, 255, 65)
loadStroke.Thickness = 2

local loadText = Instance.new("TextLabel")
loadText.Parent = loadFrame
loadText.BackgroundTransparency = 1
loadText.Position = UDim2.new(0, 0, 0, 12)
loadText.Size = UDim2.new(1, 0, 0, 25)
loadText.Font = Enum.Font.Code
loadText.Text = "INITIALIZING MATRIX..."
loadText.TextColor3 = Color3.fromRGB(0, 255, 65)
loadText.TextSize = 14

local percentText = Instance.new("TextLabel")
percentText.Parent = loadFrame
percentText.BackgroundTransparency = 1
percentText.Position = UDim2.new(0, 0, 0, 72)
percentText.Size = UDim2.new(1, 0, 0, 20)
percentText.Font = Enum.Font.Code
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(0, 255, 65)
percentText.TextSize = 13

-- Loading Bar Container
local barBg = Instance.new("Frame")
barBg.Parent = loadFrame
barBg.BackgroundColor3 = Color3.fromRGB(0, 20, 5)
barBg.Position = UDim2.new(0.1, 0, 0, 45)
barBg.Size = UDim2.new(0.8, 0, 0, 18)

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(0, 6)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Parent = barBg
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 65)
barFill.Size = UDim2.new(0, 0, 1, 0)

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 6)
barFillCorner.Parent = barFill

-- Matrix code rain during loading
task.spawn(function()
	local chars = "01ABCDEFXYZ#*+-_@$"
	while loadScreen.Parent do
		local glyph = Instance.new("TextLabel")
		glyph.Parent = loadScreen
		glyph.BackgroundTransparency = 1
		glyph.Position = UDim2.new(math.random(), 0, -0.1, 0)
		glyph.Size = UDim2.new(0, 20, 0, 20)
		glyph.Font = Enum.Font.Code
		glyph.TextColor3 = Color3.fromRGB(0, math.random(100, 255), 35)
		glyph.TextSize = math.random(14, 20)
		glyph.Text = string.sub(chars, math.random(1, #chars), math.random(1, #chars))
		
		TweenService:Create(glyph, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
			Position = UDim2.new(glyph.Position.X.Scale, 0, 1.1, 0),
			TextTransparency = 1
		}):Play()
		task.delay(1.5, function() glyph:Destroy() end)
		task.wait(0.05)
	end
end)

-- 10-Second Progress Animation
task.spawn(function()
	local startTime = tick()
	local duration = 10
	
	while true do
		local elapsed = tick() - startTime
		local alpha = math.clamp(elapsed / duration, 0, 1)
		local percent = math.floor(alpha * 100)
		
		barFill.Size = UDim2.new(alpha, 0, 1, 0)
		percentText.Text = percent .. "%"
		
		if alpha >= 1 then break end
		task.wait(0.03)
	end
	
	loadText.Text = "SYSTEM READY"
	task.wait(0.4)
	
	TweenService:Create(loadFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	TweenService:Create(loadScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	loadScreen:Destroy()
end)

--------------------------------------------------------------------------------
-- FLOATING INTERACTIVE TOGGLE BALL
--------------------------------------------------------------------------------
local toggleBall = Instance.new("TextButton")
toggleBall.Name = "ToggleBall"
toggleBall.Parent = screenGui
toggleBall.BackgroundColor3 = Color3.fromRGB(0, 15, 5)
toggleBall.Position = UDim2.new(0, 25, 0.5, -30)
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
ballStroke.Thickness = 2.5

task.spawn(function()
	while toggleBall and toggleBall.Parent do
		TweenService:Create(ballStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Transparency = 0.1}):Play()
		TweenService:Create(toggleBall, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 64, 0, 64)}):Play()
		task.wait(0.8)
		TweenService:Create(ballStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
		TweenService:Create(toggleBall, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 60, 0, 60)}):Play()
		task.wait(0.8)
	end
end)

--------------------------------------------------------------------------------
-- MAIN MENU GUI
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(3, 8, 4)
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
frameStroke.Thickness = 2

local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(0, 22, 7)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Font = Enum.Font.Code
titleBar.Text = "  [ MATRIX MOD MENU ]"
titleBar.TextColor3 = Color3.fromRGB(0, 255, 65)
titleBar.TextSize = 15
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
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 950)
scrollContainer.ScrollBarThickness = 5
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 65)

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
	btn.BackgroundColor3 = Color3.fromRGB(8, 24, 10)
	btn.Size = UDim2.new(0.9, 0, 0, 45)
	btn.Font = Enum.Font.Code
	btn.Text = "  [  ] " .. name
	btn.TextColor3 = Color3.fromRGB(0, 255, 65)
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Color = Color3.fromRGB(0, 130, 30)
	stroke.Thickness = 1

	local active = false
	table.insert(connections, btn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			btn.Text = "  [X] " .. name
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 70, 22)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 65)}):Play()
		else
			btn.Text = "  [  ] " .. name
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(8, 24, 10)}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 130, 30)}):Play()
		end
		callback(active)
	end))
end

local function createSlider(name, min, max, defaultVal, callback)
	local container = Instance.new("Frame")
	container.Parent = scrollContainer
	container.BackgroundColor3 = Color3.fromRGB(8, 24, 10)
	container.Size = UDim2.new(0.9, 0, 0, 65)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Parent = container
	stroke.Color = Color3.fromRGB(0, 130, 30)
	stroke.Thickness = 1

	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(1, -24, 0, 22)
	label.Font = Enum.Font.Code
	label.Text = name .. ": " .. defaultVal
	label.TextColor3 = Color3.fromRGB(0, 255, 65)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left

	local sliderBar = Instance.new("TextButton")
	sliderBar.Parent = container
	sliderBar.BackgroundColor3 = Color3.fromRGB(3, 10, 5)
	sliderBar.Position = UDim2.new(0, 12, 0, 35)
	sliderBar.Size = UDim2.new(1, -24, 0, 16)
	sliderBar.Text = ""
	sliderBar.AutoButtonColor = false

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 5)
	barCorner.Parent = sliderBar

	local fill = Instance.new("Frame")
	fill.Parent = sliderBar
	fill.BackgroundColor3 = Color3.fromRGB(0, 255, 65)
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
-- FEATURE LOGIC
--------------------------------------------------------------------------------

local infJumpEnabled = false
table.insert(connections, UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))
createToggle("INF JUMP", function(state)
	infJumpEnabled = state
end)

createToggle("NO GRAVITY", function(state)
	if state then
		workspace.Gravity = 0
	else
		workspace.Gravity = 196.2
	end
end)

createSlider("GUI SIZE", 1, 500, 350, function(val)
	local scale = val / 350
	mainFrame.Size = UDim2.new(0, math.clamp(350 * scale, 150, 700), 0, math.clamp(400 * scale, 150, 750))
end)

local aimbotEnabled = false
local aimbotFov = 50
createToggle("AIMBOT", function(state)
	aimbotEnabled = state
end)
createSlider("AIMBOT FOV", 0, 250, 50, function(val)
	aimbotFov = val
end)

table.insert(connections, RunService.RenderStepped:Connect(function()
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

createToggle("INVISIBLE (Local Only)", function(state)
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = state and 1 or (part.Name == "HumanoidRootPart" and 1 or 0)
			end
		end
	end
end)

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

createSlider("JUMP BOOST", 0, 500, 50, function(val)
	if humanoid then
		humanoid.JumpPower = 50 + val
	end
end)

createSlider("NORMAL SPEED BOOST", 0, 1000, 16, function(val)
	if humanoid then
		humanoid.WalkSpeed = 16 + val
	end
end)

local cframeSpeed = 0
createSlider("CFRAME SPEED BOOST", 0, 1000, 0, function(val)
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

--------------------------------------------------------------------------------
-- UNLOAD SCRIPT BUTTON
--------------------------------------------------------------------------------
local unloadBtn = Instance.new("TextButton")
unloadBtn.Parent = scrollContainer
unloadBtn.BackgroundColor3 = Color3.fromRGB(40, 8, 8)
unloadBtn.Size = UDim2.new(0.9, 0, 0, 45)
unloadBtn.Font = Enum.Font.Code
unloadBtn.Text = "  [!] UNLOAD SCRIPT"
unloadBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
unloadBtn.TextSize = 13
unloadBtn.TextXAlignment = Enum.TextXAlignment.Left

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadBtn

local unloadStroke = Instance.new("UIStroke")
unloadStroke.Parent = unloadBtn
unloadStroke.Color = Color3.fromRGB(180, 30, 30)
unloadStroke.Thickness = 1

table.insert(connections, unloadBtn.MouseButton1Click:Connect(function()
	workspace.Gravity = 196.2
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	screenGui:Destroy()
end))

--------------------------------------------------------------------------------
-- OPEN / CLOSE ANIMATION LOGIC
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
		
		TweenService:Create(toggleBall, TweenInfo.new(0.3), {Rotation = 0, TextColor3 = Color3.fromRGB(0, 255, 65)}):Play()
	end
end))

print("Matrix Mod Menu loaded successfully.")
