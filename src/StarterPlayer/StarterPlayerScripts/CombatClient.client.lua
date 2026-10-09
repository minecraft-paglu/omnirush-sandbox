local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("CombatRemote")
local Config = require(ReplicatedStorage:WaitForChild("CombatConfig"))

local currentStyle = "Tide"
local cooldownEnds = {E = 0, R = 0, T = 0, Y = 0, X = 0}
local blocking = false
local breathing = false
local ui = {}

local function colorFor(style)
	return Config.Styles[style] and Config.Styles[style].Color or Color3.new(1, 1, 1)
end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do object[property] = value end
	object.Parent = parent
	return object
end

local function createUI()
	local gui = make("ScreenGui", {Name = "CombatHUD", ResetOnSpawn = false, IgnoreGuiInset = true}, player:WaitForChild("PlayerGui"))
	local vignette = make("Frame", {Name = "Vignette", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 10, 22), BackgroundTransparency = 0.62, BorderSizePixel = 0}, gui)
	make("UIGradient", {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(8, 10, 22), Color3.fromRGB(29, 38, 68)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(0.55, 0.8), NumberSequenceKeypoint.new(1, 0.15)})}, vignette)

	local title = make("TextLabel", {Size = UDim2.fromOffset(330, 58), Position = UDim2.fromOffset(28, 24), BackgroundTransparency = 1, Text = "BREATHING BLADES", TextColor3 = Color3.fromRGB(233, 242, 255), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBlack, TextSize = 25}, gui)
	make("TextLabel", {Size = UDim2.fromOffset(330, 22), Position = UDim2.fromOffset(31, 70), BackgroundTransparency = 1, Text = "DUEL UNTIL THE LAST BREATH", TextColor3 = Color3.fromRGB(130, 157, 199), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 11}, gui)

	local stylePanel = make("Frame", {Size = UDim2.fromOffset(224, 238), Position = UDim2.new(0, 28, 1, -270), BackgroundColor3 = Color3.fromRGB(13, 18, 35), BackgroundTransparency = 0.1, BorderSizePixel = 0}, gui)
	make("UICorner", {CornerRadius = UDim.new(0, 12)}, stylePanel)
	make("UIStroke", {Color = Color3.fromRGB(69, 89, 135), Transparency = 0.35, Thickness = 1}, stylePanel)
	make("TextLabel", {Size = UDim2.new(1, -24, 0, 28), Position = UDim2.fromOffset(12, 8), BackgroundTransparency = 1, Text = "CHOOSE YOUR PATH", TextColor3 = Color3.fromRGB(156, 178, 218), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 12}, stylePanel)

	for index, styleName in ipairs(Config.StyleOrder) do
		local style = Config.Styles[styleName]
		local button = make("TextButton", {Name = styleName, Size = UDim2.new(1, -24, 0, 39), Position = UDim2.fromOffset(12, 39 + (index - 1) * 45), BackgroundColor3 = Color3.fromRGB(27, 36, 61), BackgroundTransparency = 0.2, Text = string.format("%d   %s", index, style.DisplayName), TextColor3 = Color3.fromRGB(225, 233, 250), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamSemibold, TextSize = 13, AutoButtonColor = false}, stylePanel)
		make("UICorner", {CornerRadius = UDim.new(0, 7)}, button)
		make("Frame", {Size = UDim2.fromOffset(4, 25), Position = UDim2.fromOffset(8, 7), BackgroundColor3 = style.Color, BorderSizePixel = 0}, button)
		button.MouseButton1Click:Connect(function() remote:FireServer("Style", styleName) end)
	end

	local abilityPanel = make("Frame", {Size = UDim2.fromOffset(650, 82), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -28), BackgroundTransparency = 1}, gui)
	local keys = {"E", "R", "T", "Y", "X"}
	for index, data in ipairs(keys) do
		local card = make("Frame", {Size = UDim2.fromOffset(122, 70), Position = UDim2.fromOffset((index - 1) * 130, 0), BackgroundColor3 = Color3.fromRGB(13, 18, 35), BackgroundTransparency = 0.08, BorderSizePixel = 0}, abilityPanel)
		make("UICorner", {CornerRadius = UDim.new(0, 10)}, card)
		make("UIStroke", {Color = Color3.fromRGB(69, 89, 135), Transparency = 0.3, Thickness = 1}, card)
		local ability = Config.Styles[currentStyle].Abilities[data]
		make("TextLabel", {Size = UDim2.fromOffset(30, 29), Position = UDim2.fromOffset(8, 9), BackgroundColor3 = colorFor(currentStyle), Text = data, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 16}, card)
		make("UICorner", {CornerRadius = UDim.new(0, 6)}, card:FindFirstChildOfClass("TextLabel"))
		local abilityName = make("TextLabel", {Size = UDim2.fromOffset(78, 25), Position = UDim2.fromOffset(40, 11), BackgroundTransparency = 1, Text = ability.Name, TextColor3 = Color3.fromRGB(222, 231, 249), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 9, TextTruncate = Enum.TextTruncate.AtEnd}, card)
		local timer = make("TextLabel", {Name = data .. "Timer", Size = UDim2.fromOffset(112, 18), Position = UDim2.fromOffset(8, 43), BackgroundTransparency = 1, Text = "READY", TextColor3 = Color3.fromRGB(125, 157, 199), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 9}, card)
		ui[data] = {card = card, key = card:FindFirstChildOfClass("TextLabel"), abilityName = abilityName, timer = timer}
	end

	local breathPanel = make("Frame", {Size = UDim2.fromOffset(220, 76), Position = UDim2.new(1, -250, 0, 28), BackgroundColor3 = Color3.fromRGB(13, 18, 35), BackgroundTransparency = 0.08, BorderSizePixel = 0}, gui)
	make("UICorner", {CornerRadius = UDim.new(0, 9)}, breathPanel)
	make("UIStroke", {Color = Color3.fromRGB(69, 89, 135), Transparency = 0.3, Thickness = 1}, breathPanel)
	make("TextLabel", {Size = UDim2.fromOffset(92, 18), Position = UDim2.fromOffset(10, 7), BackgroundTransparency = 1, Text = "BREATH", TextColor3 = Color3.fromRGB(160, 180, 220), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 10}, breathPanel)
	local breathText = make("TextLabel", {Size = UDim2.fromOffset(108, 18), Position = UDim2.fromOffset(102, 7), BackgroundTransparency = 1, Text = "100 / 100", TextColor3 = Color3.fromRGB(125, 220, 185), TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold, TextSize = 10}, breathPanel)
	local breathBack = make("Frame", {Size = UDim2.fromOffset(200, 8), Position = UDim2.fromOffset(10, 30), BackgroundColor3 = Color3.fromRGB(35, 45, 70), BorderSizePixel = 0}, breathPanel)
	make("UICorner", {CornerRadius = UDim.new(1, 0)}, breathBack)
	local breathFill = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = colorFor(currentStyle), BorderSizePixel = 0}, breathBack)
	make("UICorner", {CornerRadius = UDim.new(1, 0)}, breathFill)
	make("TextLabel", {Size = UDim2.fromOffset(92, 18), Position = UDim2.fromOffset(10, 42), BackgroundTransparency = 1, Text = "GUARD", TextColor3 = Color3.fromRGB(160, 180, 220), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 10}, breathPanel)
	local guardText = make("TextLabel", {Size = UDim2.fromOffset(108, 18), Position = UDim2.fromOffset(102, 42), BackgroundTransparency = 1, Text = "100 / 100", TextColor3 = Color3.fromRGB(165, 205, 255), TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold, TextSize = 10}, breathPanel)
	local guardBack = make("Frame", {Size = UDim2.fromOffset(200, 8), Position = UDim2.fromOffset(10, 63), BackgroundColor3 = Color3.fromRGB(35, 45, 70), BorderSizePixel = 0}, breathPanel)
	make("UICorner", {CornerRadius = UDim.new(1, 0)}, guardBack)
	local guardFill = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(113, 178, 255), BorderSizePixel = 0}, guardBack)
	make("UICorner", {CornerRadius = UDim.new(1, 0)}, guardFill)

	local hint = make("TextLabel", {Size = UDim2.fromOffset(760, 24), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 18), BackgroundTransparency = 1, Text = "LMB  COMBO     RMB  BREAKER     F  GUARD     Q  DASH     E / R / T / Y / X  FORMS     G  BREATHE", TextColor3 = Color3.fromRGB(140, 161, 198), Font = Enum.Font.GothamMedium, TextSize = 11}, gui)
	ui.gui = gui
	ui.vignette = vignette
	ui.title = title
	ui.breathText = breathText
	ui.breathFill = breathFill
	ui.guardText = guardText
	ui.guardFill = guardFill
end

local function pulsePart(position, color, size, duration, shape)
	local part = make("Part", {Name = "VFX", Shape = shape or Enum.PartType.Ball, Size = size, CFrame = CFrame.new(position), Color = color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.12}, workspace)
	local light = make("PointLight", {Color = color, Brightness = 3, Range = math.max(size.X, size.Y, size.Z) * 2.4}, part)
	local goal = {Size = size * 2.4, Transparency = 1}
	TweenService:Create(part, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
	TweenService:Create(light, TweenInfo.new(duration), {Brightness = 0, Range = 0}):Play()
	Debris:AddItem(part, duration + 0.1)
	return part
end

local function ring(position, color, radius, duration, rotation)
	local part = make("Part", {Name = "EnergyRing", Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.16, radius, radius), CFrame = CFrame.new(position) * (rotation or CFrame.Angles(0, 0, 0)), Color = color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.22}, workspace)
	TweenService:Create(part, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Vector3.new(0.08, radius * 1.8, radius * 1.8), Transparency = 1}):Play()
	Debris:AddItem(part, duration + 0.1)
end

local function spark(position, color, direction, count)
	for index = 1, count do
		local angle = (index / count) * math.pi * 2
		local velocity = (direction or Vector3.new(0, 1, 0)) + Vector3.new(math.cos(angle), math.sin(index * 2.7), math.sin(angle)) * 0.75
		local start = position + Vector3.new(0, 1, 0) * (index % 3) * 0.25
		local part = make("Part", {Name = "Spark", Size = Vector3.new(0.12, 0.12, 1.5), CFrame = CFrame.lookAt(start, start + velocity), Color = color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false}, workspace)
		local distance = 2.5 + (index % 4) * 0.8
		TweenService:Create(part, TweenInfo.new(0.3 + index * 0.015, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = part.CFrame + velocity.Unit * distance, Transparency = 1, Size = Vector3.new(0.02, 0.02, 0.2)}):Play()
		Debris:AddItem(part, 0.5)
	end
end

local function slashEffect(data)
	local style = Config.Styles[data.style] or Config.Styles.Tide
	local color = style.Color
	local accent = style.Accent
	local origin = data.origin + Vector3.new(0, 1.8, 0) + data.forward * 2
	local side = data.forward:Cross(Vector3.new(0, 1, 0)).Unit
	local angle = data.combo % 2 == 0 and -0.55 or 0.55
	for index = 1, 3 do
		local offset = side * (index - 2) * 0.35
		local line = make("Part", {Name = "BladeTrail", Size = Vector3.new(0.16, 0.16, 5.8 + data.combo * 0.8), CFrame = CFrame.lookAt(origin + offset, origin + offset + data.forward) * CFrame.Angles(0, angle + (index - 2) * 0.08, 0), Color = index == 2 and accent or color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.08}, workspace)
		TweenService:Create(line, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.new(0.02, 0.02, 8.5)}):Play()
		Debris:AddItem(line, 0.3)
	end
	ring(origin, color, 2.5 + data.combo, 0.24, CFrame.Angles(0, math.pi / 2, 0))
	spark(origin, accent, data.forward, 5 + data.combo)
end

local function abilityEffect(data)
	local style = Config.Styles[data.style] or Config.Styles.Tide
	local color, accent = style.Color, style.Accent
	local origin = data.origin + Vector3.new(0, 1.5, 0)
	local forward = data.forward
	if data.key == "E" then
		for index = 1, 5 do
			local point = origin + forward * index * 3 + Vector3.new(0, math.sin(index) * 0.45, 0)
			pulsePart(point, index % 2 == 0 and accent or color, Vector3.new(1.1, 1.1, 1.1), 0.28)
		end
		local trail = make("Part", {Name = "FormTrail", Size = Vector3.new(4, 0.15, 12), CFrame = CFrame.lookAt(origin, origin + forward) * CFrame.new(0, 0, -6), Color = color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.4}, workspace)
		TweenService:Create(trail, TweenInfo.new(0.35), {Transparency = 1, Size = Vector3.new(0.2, 0.08, 16)}):Play()
		Debris:AddItem(trail, 0.45)
	elseif data.key == "X" then
		for index = 1, 2 do
			local wave = make("Part", {Name = "Wave", Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.3, 4 + index * 2, 4 + index * 2), CFrame = CFrame.new(origin + forward * (index * 5)) * CFrame.Angles(0, 0, math.pi / 2), Color = index == 1 and color or accent, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.2}, workspace)
			TweenService:Create(wave, TweenInfo.new(0.45 + index * 0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Vector3.new(0.08, 13 + index * 3, 13 + index * 3), Transparency = 1}):Play()
			Debris:AddItem(wave, 0.7)
		end
		spark(origin + forward * 5, accent, forward, 14)
	else
		pulsePart(origin + forward * 8, color, Vector3.new(5, 5, 5), 0.65)
		for index = 1, 4 do
			ring(origin + forward * (index * 3), index % 2 == 0 and accent or color, 5 + index * 2, 0.5, CFrame.Angles(0, math.pi / 2, 0))
		end
		spark(origin + forward * 8, accent, Vector3.new(0, 1, 0), 24)
	end
	if data.style == "Storm" then
		for index = 1, 3 do
			local bolt = make("Part", {Name = "Lightning", Size = Vector3.new(0.12, 0.12, 10), CFrame = CFrame.lookAt(origin + forward * (index * 5) + Vector3.new((index - 2) * 2, 2, 0), origin + forward * (index * 5 + 1)), Color = accent, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false}, workspace)
			TweenService:Create(bolt, TweenInfo.new(0.18), {Transparency = 1}):Play()
			Debris:AddItem(bolt, 0.25)
		end
	end
end

local function heavyEffect(data)
	local style = Config.Styles[data.style] or Config.Styles.Tide
	local origin = data.origin + Vector3.new(0, 1.7, 0) + data.forward * 2.5
	local side = data.forward:Cross(Vector3.new(0, 1, 0)).Unit
	for index = 1, 3 do
		local arc = make("Part", {Name = "BreakerArc", Size = Vector3.new(0.28, 0.28, 6.5), CFrame = CFrame.lookAt(origin + side * (index - 2) * 0.45, origin + side * (index - 2) * 0.45 + data.forward) * CFrame.Angles(0, (index - 2) * 0.14, 0), Color = index == 2 and Color3.fromRGB(255, 245, 170) or style.Color, Material = Enum.Material.Neon, Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 0.05}, workspace)
		TweenService:Create(arc, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.new(0.03, 0.03, 10)}):Play()
		Debris:AddItem(arc, 0.4)
	end
	ring(origin, Color3.fromRGB(255, 230, 140), 4.5, 0.35, CFrame.Angles(0, math.pi / 2, 0))
	spark(origin, Color3.fromRGB(255, 240, 180), data.forward, 16)
end

local function impactEffect(data)
	local color = data.blocked and Color3.fromRGB(160, 180, 205) or colorFor(data.style)
	pulsePart(data.position, color, data.blocked and Vector3.new(1.5, 1.5, 1.5) or Vector3.new(2.4, 2.4, 2.4), 0.3)
	ring(data.position, color, data.blocked and 3 or 4.5, 0.3, CFrame.Angles(0, math.pi / 2, 0))
	spark(data.position, color, Vector3.new(0, 1, 0), data.blocked and 5 or 9)
end

local function refreshAbilityUI()
	for key, data in pairs(ui) do
		if type(data) == "table" and data.timer then
			local remaining = math.max(0, (cooldownEnds[key] or 0) - os.clock())
			data.timer.Text = remaining > 0 and string.format("COOLDOWN  %.1fs", remaining) or "READY"
			data.timer.TextColor3 = remaining > 0 and Color3.fromRGB(231, 113, 126) or Color3.fromRGB(125, 220, 185)
			data.key.BackgroundColor3 = colorFor(currentStyle)
		end
	end
end

local function chooseStyle(index)
	local style = Config.StyleOrder[index]
	if style then remote:FireServer("Style", style) end
end

remote.OnClientEvent:Connect(function(action, data)
	if action == "Slash" then
		slashEffect(data)
	elseif action == "Ability" then
		abilityEffect(data)
	elseif action == "Impact" then
		impactEffect(data)
	elseif action == "Dash" then
		local style = Config.Styles[data.style] or Config.Styles.Tide
		spark(data.origin, style.Accent, data.forward, 10)
		pulsePart(data.origin, style.Color, Vector3.new(2, 2, 2), 0.24)
	elseif action == "Heavy" then
		heavyEffect(data)
	elseif action == "GuardBreak" then
		pulsePart(data.position, Color3.fromRGB(255, 108, 89), Vector3.new(3, 3, 3), 0.42)
		ring(data.position, Color3.fromRGB(255, 180, 120), 6, 0.48, CFrame.Angles(0, math.pi / 2, 0))
		spark(data.position, Color3.fromRGB(255, 180, 120), Vector3.new(0, 1, 0), 22)
	elseif action == "PerfectBlock" then
		pulsePart(data.position, Color3.fromRGB(240, 248, 255), Vector3.new(2.8, 2.8, 2.8), 0.35)
		ring(data.position, Color3.fromRGB(170, 220, 255), 5.5, 0.42, CFrame.Angles(0, math.pi / 2, 0))
		spark(data.position, Color3.fromRGB(225, 245, 255), Vector3.new(0, 1, 0), 18)
	elseif action == "Block" then
		if data.player == player then blocking = data.active end
		if data.active then pulsePart(data.player.Character and data.player.Character:GetPivot().Position or Vector3.zero, Color3.fromRGB(180, 210, 255), Vector3.new(1.8, 2.5, 1.8), 0.22) end
	elseif action == "StyleChanged" then
		currentStyle = data.style
		ui.title.TextColor3 = colorFor(currentStyle)
		for key, abilityUI in pairs(ui) do
			if type(abilityUI) == "table" and abilityUI.abilityName then
				abilityUI.abilityName.Text = Config.Styles[currentStyle].Abilities[key].Name
			end
		end
		refreshAbilityUI()
	elseif action == "Breathing" then
		breathing = data.active
		ui.title.Text = data.active and "BREATHING BLADES  •  FOCUS" or "BREATHING BLADES"
		ui.title.TextColor3 = data.active and Config.Styles[data.style].Accent or colorFor(currentStyle)
	elseif action == "Breath" then
		local percent = math.clamp(data.value / data.max, 0, 1)
		ui.breathText.Text = string.format("%d / %d", math.floor(data.value), data.max)
		ui.breathFill.Size = UDim2.fromScale(percent, 1)
	elseif action == "Guard" then
		local percent = math.clamp(data.value / data.max, 0, 1)
		ui.guardText.Text = string.format("%d / %d", math.floor(data.value), data.max)
		ui.guardFill.Size = UDim2.fromScale(percent, 1)
	elseif action == "BreathDenied" then
		cooldownEnds[data.key] = 0
		ui.breathText.Text = string.format("NEED %d BREATH", data.needed)
		ui.breathText.TextColor3 = Color3.fromRGB(255, 125, 130)
	elseif action == "StylePulse" and data.player == player then
		pulsePart(data.player.Character and data.player.Character:GetPivot().Position or Vector3.zero, colorFor(data.style), Vector3.new(2.5, 2.5, 2.5), 0.5)
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	-- Roblox marks some mouse/keyboard events as processed when CoreGui has focus.
	-- Only suppress combat while the player is actively typing into a text box.
	if UserInputService:GetFocusedTextBox() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		remote:FireServer("Attack")
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		remote:FireServer("Heavy")
	elseif input.KeyCode == Enum.KeyCode.F then
		remote:FireServer("Block", true)
	elseif input.KeyCode == Enum.KeyCode.Q then
		remote:FireServer("Dash")
	elseif input.KeyCode == Enum.KeyCode.G then
		remote:FireServer("Breath", not breathing)
	elseif input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.T or input.KeyCode == Enum.KeyCode.Y or input.KeyCode == Enum.KeyCode.X then
		local key = input.KeyCode.Name
		if os.clock() >= (cooldownEnds[key] or 0) then
			local ability = Config.Styles[currentStyle].Abilities[key]
			cooldownEnds[key] = os.clock() + ability.Cooldown
			remote:FireServer("Ability", key)
		end
	elseif input.KeyCode.Value >= Enum.KeyCode.One.Value and input.KeyCode.Value <= Enum.KeyCode.Four.Value then
		chooseStyle(input.KeyCode.Value - Enum.KeyCode.One.Value + 1)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then remote:FireServer("Block", false) end
end)

createUI()
task.spawn(function()
	while ui.gui and ui.gui.Parent do
		refreshAbilityUI()
		task.wait(0.1)
	end
end)
