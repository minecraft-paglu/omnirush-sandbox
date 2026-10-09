local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("CombatRemote")
local Physics = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("PhysicsConstants"))
local States = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MovementStates"))

local character
local humanoid
local root
local motors = {}
local held = {W = false, A = false, S = false, D = false, Shift = false}
local jumpBuffer = 0
local coyote = 0
local velocity = Vector3.zero
local facing = Vector3.new(0, 0, -1)
local grounded = false
local wasGrounded = false
local state = States.Idle
local dash = nil
local dashRecovery = 0
local externalMotion = nil
local animationClock = 0
local controllerFailed = false
local lastDebugLog = 0

local function debugLog(message, ...)
	print("[BreathingBlades][ClientMovement] " .. message, ...)
end

local function debugWarn(message, ...)
	warn("[BreathingBlades][ClientMovement] " .. message, ...)
end

local function flat(vector)
	return Vector3.new(vector.X, 0, vector.Z)
end

local function unitOr(vector, fallback)
	return vector.Magnitude > 0.001 and vector.Unit or fallback
end

local function setDefaultMovementStates(currentHumanoid)
	debugLog("Disabling default movement states for", character.Name)
	currentHumanoid.WalkSpeed = 0
	currentHumanoid.JumpPower = 0
	currentHumanoid.AutoRotate = false
	currentHumanoid.UseJumpPower = true
	for _, stateType in ipairs({
		Enum.HumanoidStateType.Running,
		Enum.HumanoidStateType.RunningNoPhysics,
		Enum.HumanoidStateType.Jumping,
		Enum.HumanoidStateType.Freefall,
		Enum.HumanoidStateType.Landed,
		Enum.HumanoidStateType.Climbing,
		Enum.HumanoidStateType.Swimming,
		Enum.HumanoidStateType.GettingUp,
	}) do
		currentHumanoid:SetStateEnabled(stateType, false)
	end
	currentHumanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local animate = character and character:FindFirstChild("Animate")
	if animate then animate.Disabled = true end
	debugLog("Default movement states disabled")
end

local function collectMotors()
	motors = {}
	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("Motor6D") then
			motors[descendant.Name] = descendant
		end
	end
end

local function getInputDirection()
	local camera = workspace.CurrentCamera
	if not camera then return Vector3.zero end
	local cameraForward = unitOr(flat(camera.CFrame.LookVector), Vector3.new(0, 0, -1))
	local cameraRight = unitOr(flat(camera.CFrame.RightVector), Vector3.new(1, 0, 0))
	local direction = Vector3.zero
	if held.W then direction += cameraForward end
	if held.S then direction -= cameraForward end
	if held.D then direction += cameraRight end
	if held.A then direction -= cameraRight end
	return unitOr(direction, Vector3.zero)
end

local function rayParams()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character}
	params.IgnoreWater = false
	return params
end

local function checkGround(position)
	local result = workspace:Raycast(
		position + Vector3.new(0, 0.55, 0),
		Vector3.new(0, -Physics.GroundProbeDistance, 0),
		rayParams()
	)
	if not result then return false, position end
	local walkable = result.Normal.Y >= math.cos(Physics.MaxSlopeAngle)
	if not walkable then return false, position end
	local targetY = result.Position.Y + Physics.BodyHalfHeight
	local closeEnough = position.Y - targetY <= Physics.GroundSnapDistance and position.Y >= targetY - 0.35
	return closeEnough, Vector3.new(position.X, targetY, position.Z)
end

local function slideMove(position, delta)
	if delta.Magnitude < 0.0001 then return position end
	local result = workspace:Blockcast(CFrame.new(position), Physics.BodySize, delta, rayParams())
	if not result then return position + delta end

	local direction = delta.Unit
	local travel = math.max(0, result.Distance - 0.035)
	local nextPosition = position + direction * travel
	local remaining = delta - direction * travel
	local intoSurface = remaining:Dot(result.Normal)
	if intoSurface < 0 then
		remaining -= result.Normal * intoSurface
	end
	return nextPosition + remaining
end

local function accelerate(current, target, amount)
	local difference = target - current
	if difference.Magnitude <= amount then return target end
	return current + difference.Unit * amount
end

local function requestDash()
	if dash or dashRecovery > 0 or not root then return end
	remote:FireServer("Dash")
end

local function beginDash(direction)
	if not root or dash or dashRecovery > 0 then return end
	dash = {direction = unitOr(flat(direction), facing), time = 0}
	velocity = Vector3.zero
	state = States.Dash
end

local function requestJump()
	jumpBuffer = Physics.JumpBuffer
end

local function updateAnimation(dt, moveAmount)
	if not character then return end
	animationClock += dt
	local speed = moveAmount
	local breathing = math.sin(animationClock * 2.1) * 0.018
	local runBlend = math.clamp(speed / Physics.SprintSpeed, 0, 1)
	local phase = animationClock * (8 + speed * 0.45)

	for _, motor in pairs(motors) do
		motor.Transform = CFrame.new()
	end

	local waist = motors.Waist
	local neck = motors.Neck
	local leftShoulder = motors.LeftShoulder
	local rightShoulder = motors.RightShoulder
	local leftHip = motors.LeftHip
	local rightHip = motors.RightHip

	if state == States.Jump then
		if waist then waist.Transform = CFrame.Angles(-0.12, 0, 0) end
		if neck then neck.Transform = CFrame.Angles(0.12, 0, 0) end
		if leftHip then leftHip.Transform = CFrame.Angles(-0.3, 0, -0.04) end
		if rightHip then rightHip.Transform = CFrame.Angles(0.3, 0, 0.04) end
	elseif state == States.Fall then
		if waist then waist.Transform = CFrame.Angles(0.18, 0, 0) end
		if leftShoulder then leftShoulder.Transform = CFrame.Angles(-0.28, 0, -0.18) end
		if rightShoulder then rightShoulder.Transform = CFrame.Angles(-0.28, 0, 0.18) end
	elseif state == States.Dash then
		if waist then waist.Transform = CFrame.Angles(0, 0, -0.12) end
		if neck then neck.Transform = CFrame.Angles(0.08, 0, 0) end
		if leftShoulder then leftShoulder.Transform = CFrame.Angles(-0.42, 0, -0.12) end
		if rightShoulder then rightShoulder.Transform = CFrame.Angles(-0.42, 0, 0.12) end
	else
		if waist then waist.Transform = CFrame.Angles(breathing - runBlend * 0.04, 0, 0) end
		if neck then neck.Transform = CFrame.Angles(-breathing * 0.45, 0, 0) end
		if runBlend > 0.04 then
			local legSwing = math.sin(phase) * 0.55 * runBlend
			if leftHip then leftHip.Transform = CFrame.Angles(legSwing, 0, 0) end
			if rightHip then rightHip.Transform = CFrame.Angles(-legSwing, 0, 0) end
			if leftShoulder then leftShoulder.Transform = CFrame.Angles(-legSwing * 0.55, 0, 0) end
			if rightShoulder then rightShoulder.Transform = CFrame.Angles(legSwing * 0.55, 0, 0) end
		end
	end
end

local function updateController(dt)
	if not character or not character.Parent or not humanoid or not root then return end
	if humanoid.Health <= 0 then return end

	dt = math.min(dt, 1 / 20)
	jumpBuffer = math.max(0, jumpBuffer - dt)
	dashRecovery = math.max(0, dashRecovery - dt)

	local position = root.Position
	local moveDirection = getInputDirection()
	local currentHorizontal = flat(velocity)
	local speed = held.Shift and Physics.SprintSpeed or Physics.WalkSpeed
	local desired = moveDirection * speed

	local detectedGround, groundPosition = checkGround(position)
	wasGrounded = grounded
	grounded = detectedGround
	if grounded then
		coyote = Physics.CoyoteTime
		position = groundPosition
	else
		coyote = math.max(0, coyote - dt)
	end

	if jumpBuffer > 0 and coyote > 0 and not dash then
		jumpBuffer = 0
		coyote = 0
		grounded = false
		velocity = Vector3.new(velocity.X, Physics.JumpSpeed, velocity.Z)
		state = States.Jump
	end

	if dash then
		dash.time += dt
		local dashAlpha = math.clamp(dash.time / Physics.DashDuration, 0, 1)
		local dashEase = 1 - dashAlpha * 0.35
		velocity = dash.direction * Physics.DashSpeed * dashEase
		if dash.time >= Physics.DashDuration then
			dash = nil
			dashRecovery = Physics.DashRecovery
			velocity = Vector3.zero
		end
	else
		local acceleration = grounded and (moveDirection.Magnitude > 0 and Physics.GroundAcceleration or Physics.GroundDeceleration) or (moveDirection.Magnitude > 0 and Physics.AirAcceleration or Physics.AirDeceleration)
		currentHorizontal = accelerate(currentHorizontal, desired, acceleration * dt)
		velocity = Vector3.new(currentHorizontal.X, velocity.Y, currentHorizontal.Z)
		if grounded and velocity.Y < 0 then velocity = Vector3.new(velocity.X, -2, velocity.Z) end
		if not grounded then velocity = Vector3.new(velocity.X, math.max(Physics.MaxFallSpeed, velocity.Y + Physics.Gravity * dt), velocity.Z) end
	end

	if externalMotion then
		externalMotion.time += dt
		local motionAlpha = math.clamp(externalMotion.time / externalMotion.duration, 0, 1)
		local motionFalloff = 1 - motionAlpha
		velocity = externalMotion.direction * externalMotion.force * motionFalloff
		velocity += Vector3.new(0, externalMotion.lift * motionFalloff, 0)
		if motionAlpha >= 1 then externalMotion = nil end
	end

	local nextPosition = slideMove(position, velocity * dt)
	local nowGrounded, snapped = checkGround(nextPosition)
	if nowGrounded and velocity.Y <= 0 then
		nextPosition = snapped
		velocity = Vector3.new(velocity.X, -2, velocity.Z)
		grounded = true
	else
		grounded = false
	end

	if moveDirection.Magnitude > 0.01 then
		facing = unitOr(moveDirection, facing)
	end
	local targetCFrame = CFrame.lookAt(nextPosition, nextPosition + facing)
	root.CFrame = targetCFrame
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero

	if dash then
		state = States.Dash
	elseif not grounded then
		state = velocity.Y > 0 and States.Jump or States.Fall
	elseif wasGrounded == false then
		state = States.Land
	elseif moveDirection.Magnitude > 0.05 then
		state = held.Shift and States.Sprint or States.Run
	else
		state = States.Idle
	end

	character:SetAttribute("MovementState", state)
	character:SetAttribute("Grounded", grounded)
	character:SetAttribute("CustomVelocity", velocity)
	updateAnimation(dt, flat(velocity).Magnitude)
end

local function bindCharacter(newCharacter)
	character = newCharacter
	debugLog("Character bound", character:GetFullName())
	humanoid = character:WaitForChild("Humanoid")
	root = character:WaitForChild("HumanoidRootPart")
	velocity = Vector3.zero
	grounded = false
	wasGrounded = false
	dash = nil
	state = States.Idle
	setDefaultMovementStates(humanoid)
	collectMotors()
	remote:FireServer("MovementReady")
	debugLog("Custom movement ready; waiting for frame updates")
end

local function restoreDefaultMovement()
	if not humanoid then return end
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
	for _, stateType in ipairs({
		Enum.HumanoidStateType.Running,
		Enum.HumanoidStateType.RunningNoPhysics,
		Enum.HumanoidStateType.Jumping,
		Enum.HumanoidStateType.Freefall,
		Enum.HumanoidStateType.Landed,
		Enum.HumanoidStateType.Climbing,
		Enum.HumanoidStateType.Swimming,
		Enum.HumanoidStateType.GettingUp,
	}) do
		humanoid:SetStateEnabled(stateType, true)
	end
	local animate = character and character:FindFirstChild("Animate")
	if animate then animate.Disabled = false end
	remote:FireServer("MovementFailed")
	debugWarn("Controller disabled itself and restored default movement")
end

local function safeUpdate(dt)
	if controllerFailed then return end
	local ok, errorMessage = xpcall(function()
		updateController(dt)
	end, debug.traceback)
	if not ok then
		controllerFailed = true
		debugWarn("FRAME ERROR: " .. tostring(errorMessage))
		restoreDefaultMovement()
	end
end

UserInputService.InputBegan:Connect(function(input)
	if UserInputService:GetFocusedTextBox() then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W then held.W = true
	elseif key == Enum.KeyCode.A then held.A = true
	elseif key == Enum.KeyCode.S then held.S = true
	elseif key == Enum.KeyCode.D then held.D = true
	elseif key == Enum.KeyCode.LeftShift then held.Shift = true
	elseif key == Enum.KeyCode.Space then requestJump()
	elseif key == Enum.KeyCode.Q then requestDash() end
end)

UserInputService.InputEnded:Connect(function(input)
	local key = input.KeyCode
	if key == Enum.KeyCode.W then held.W = false
	elseif key == Enum.KeyCode.A then held.A = false
	elseif key == Enum.KeyCode.S then held.S = false
	elseif key == Enum.KeyCode.D then held.D = false
	elseif key == Enum.KeyCode.LeftShift then held.Shift = false end
end)

remote.OnClientEvent:Connect(function(action, data)
	if action == "DashApproved" then
		beginDash(data.direction)
	elseif action == "MotionApproved" and data.kind == "Lunge" then
		beginDash(data.direction)
	elseif action == "Knockback" then
		externalMotion = {
			direction = unitOr(flat(data.direction), facing),
			force = data.force,
			lift = data.lift,
			duration = data.duration,
			time = 0,
		}
	end
end)

debugLog("Script started")
player.CharacterAdded:Connect(function(newCharacter)
	controllerFailed = false
	bindCharacter(newCharacter)
end)
if player.Character then bindCharacter(player.Character) end

RunService.RenderStepped:Connect(safeUpdate)
