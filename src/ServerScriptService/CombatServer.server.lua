local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("CombatConfig"))

local remote = ReplicatedStorage:FindFirstChild("CombatRemote") or Instance.new("RemoteEvent")
remote.Name = "CombatRemote"
remote.Parent = ReplicatedStorage

local states = {}

local function makePart(parent, name, size, cframe, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.Anchored = true
	part.CanCollide = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function createArena()
	if workspace:FindFirstChild("BladeArena") then
		return
	end

	local arena = Instance.new("Folder")
	arena.Name = "BladeArena"
	arena.Parent = workspace

	local dark = Color3.fromRGB(13, 18, 34)
	local trim = Color3.fromRGB(38, 51, 87)
	makePart(arena, "ArenaFloor", Vector3.new(150, 2, 150), CFrame.new(0, -1, 0), dark, Enum.Material.Slate)
	makePart(arena, "NorthWall", Vector3.new(150, 22, 2), CFrame.new(0, 10, -75), trim, Enum.Material.Basalt)
	makePart(arena, "SouthWall", Vector3.new(150, 22, 2), CFrame.new(0, 10, 75), trim, Enum.Material.Basalt)
	makePart(arena, "EastWall", Vector3.new(2, 22, 150), CFrame.new(75, 10, 0), trim, Enum.Material.Basalt)
	makePart(arena, "WestWall", Vector3.new(2, 22, 150), CFrame.new(-75, 10, 0), trim, Enum.Material.Basalt)

	for index, position in ipairs({Vector3.new(-42, 1, -42), Vector3.new(42, 1, -42), Vector3.new(-42, 1, 42), Vector3.new(42, 1, 42)}) do
		local spawn = Instance.new("SpawnLocation")
		spawn.Name = "DuelSpawn" .. index
		spawn.Size = Vector3.new(10, 1, 10)
		spawn.Position = position
		spawn.Color = Color3.fromRGB(49, 75, 116)
		spawn.Material = Enum.Material.Neon
		spawn.Transparency = 0.35
		spawn.Neutral = true
		spawn.Duration = 0
		spawn.Parent = arena
	end

	for _, position in ipairs({Vector3.new(0, 5, 0), Vector3.new(-22, 2, 0), Vector3.new(22, 2, 0), Vector3.new(0, 2, -22), Vector3.new(0, 2, 22)}) do
		makePart(arena, "Cover", Vector3.new(7, 7, 7), CFrame.new(position), Color3.fromRGB(27, 36, 61), Enum.Material.Slate)
	end
end

local function getState(player)
	if not states[player] then
		states[player] = {style = "Tide", combo = 0, lastAttack = 0, cooldowns = {}, blocking = false, blockStarted = 0, guard = Config.MaxGuard, stunnedUntil = 0, breath = Config.MaxBreath, breathing = false}
	end
	return states[player]
end

local function getCharacterParts(player)
	local character = player.Character
	if not character then return nil end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root or humanoid.Health <= 0 then return nil end
	return character, humanoid, root
end

local function getTargetHumanoids(boxCFrame, boxSize, ignoreCharacter)
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances = {ignoreCharacter}
	overlap.MaxParts = 80
	local parts = workspace:GetPartBoundsInBox(boxCFrame, boxSize, overlap)
	local found = {}
	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")
		local humanoid = model and model:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			found[humanoid] = true
		end
	end
	return found
end

local function setStunned(player, duration)
	if not player then return end
	local state = getState(player)
	state.stunnedUntil = math.max(state.stunnedUntil, os.clock() + duration)
	local character = player.Character
	if character then
		character:SetAttribute("Stunned", true)
		task.delay(duration, function()
			if character.Parent and os.clock() >= state.stunnedUntil then
				character:SetAttribute("Stunned", false)
			end
		end)
	end
end

local function damageTarget(attacker, targetHumanoid, amount, force, sourcePosition, guardBreak)
	local targetCharacter = targetHumanoid.Parent
	local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
	if not targetRoot or targetHumanoid.Health <= 0 then return end

	local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
	local targetState = targetPlayer and getState(targetPlayer)
	local blocked = targetState and targetState.blocking or false
	local perfectBlocked = blocked and targetState.blockStarted and os.clock() - targetState.blockStarted <= Config.PerfectBlockWindow
	if perfectBlocked then
		setStunned(attacker, 0.7)
		remote:FireAllClients("PerfectBlock", {position = targetRoot.Position, player = targetPlayer})
		return
	end

	if blocked and (guardBreak or targetState.guard <= math.max(15, amount * 0.8)) then
		blocked = false
		targetState.blocking = false
		targetState.blockStarted = 0
		targetState.guard = 0
		targetCharacter:SetAttribute("Blocking", false)
		targetCharacter:SetAttribute("BlockBroken", true)
		setStunned(targetPlayer, Config.BlockBreakStun)
		remote:FireAllClients("GuardBreak", {position = targetRoot.Position, player = targetPlayer})
	elseif blocked then
		targetState.guard = math.max(0, targetState.guard - Config.GuardDrainPerHit - amount * 0.65)
		remote:FireClient(targetPlayer, "Guard", {value = targetState.guard, max = Config.MaxGuard})
	end

	local finalDamage = blocked and math.floor(amount * Config.BlockMultiplier) or amount
	targetHumanoid:TakeDamage(finalDamage)

	if force > 0 and not blocked then
		local direction = (targetRoot.Position - sourcePosition)
		if direction.Magnitude < 0.1 then direction = Vector3.new(0, 0, -1) end
		targetRoot.AssemblyLinearVelocity = direction.Unit * force + Vector3.new(0, math.min(force * 0.28, 28), 0)
		setStunned(targetPlayer, guardBreak and Config.BlockBreakStun or Config.StunTime)
	end

	remote:FireAllClients("Impact", {
		position = targetRoot.Position,
		blocked = blocked,
		damage = finalDamage,
		style = targetPlayer and getState(targetPlayer).style or "Tide",
	})
end

local function performHit(player, boxCFrame, boxSize, damage, force, sourcePosition, guardBreak)
	local character = player.Character
	for humanoid in pairs(getTargetHumanoids(boxCFrame, boxSize, character)) do
		damageTarget(player, humanoid, damage, force, sourcePosition, guardBreak)
	end
end

local function canAct(player)
	local state = getState(player)
	return os.clock() >= state.stunnedUntil and getCharacterParts(player) ~= nil
end

local function doAttack(player)
	if not canAct(player) then return end
	local state = getState(player)
	local now = os.clock()
	if now - state.lastAttack < Config.AttackCooldown then return end
	state.lastAttack = now
	state.combo = now - (state.comboTime or 0) < Config.ComboResetTime and (state.combo % Config.MaxCombo) + 1 or 1
	state.comboTime = now

	local character, _, root = getCharacterParts(player)
	local style = Config.Styles[state.style]
	remote:FireAllClients("Slash", {player = player, origin = root.Position, forward = root.CFrame.LookVector, style = state.style, combo = state.combo})
	task.delay(0.065, function()
		if not character.Parent then return end
		local distance = state.combo == Config.MaxCombo and 5.3 or 4.2
		local size = state.combo == Config.MaxCombo and Vector3.new(7, 6, 8) or Vector3.new(5.5, 5, 6)
		performHit(player, root.CFrame * CFrame.new(0, 0, -distance), size, 8 + state.combo * 3, state.combo == Config.MaxCombo and 48 or 16, root.Position, false)
	end)
end

local function doHeavy(player)
	if not canAct(player) then return end
	local state = getState(player)
	local now = os.clock()
	if now - (state.lastHeavy or 0) < Config.HeavyCooldown then return end
	state.lastHeavy = now
	local character, _, root = getCharacterParts(player)
	local forward = root.CFrame.LookVector
	remote:FireAllClients("Heavy", {player = player, origin = root.Position, forward = forward, style = state.style})
	task.delay(0.14, function()
		if not character.Parent then return end
		performHit(player, root.CFrame * CFrame.new(0, 0, -5), Vector3.new(6.5, 6, 7), 18, 70, root.Position, true)
	end)
end

local function doDash(player)
	if not canAct(player) then return end
	local state = getState(player)
	if os.clock() - (state.lastDash or 0) < 1.15 then return end
	state.lastDash = os.clock()
	local _, _, root = getCharacterParts(player)
	root.AssemblyLinearVelocity = root.CFrame.LookVector * 78 + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
	remote:FireAllClients("Dash", {player = player, origin = root.Position, forward = root.CFrame.LookVector, style = state.style})
end

local function doAbility(player, key)
	if not canAct(player) then return end
	local state = getState(player)
	local style = Config.Styles[state.style]
	local ability = style and style.Abilities[key]
	if not ability then return end
	local now = os.clock()
	if now < (state.cooldowns[key] or 0) then return end
	if state.breath < ability.Cost then
		remote:FireClient(player, "BreathDenied", {key = key, needed = ability.Cost, breath = state.breath})
		return
	end
	state.cooldowns[key] = now + ability.Cooldown
	state.breath -= ability.Cost
	remote:FireClient(player, "Breath", {value = state.breath, max = Config.MaxBreath})

	local character, _, root = getCharacterParts(player)
	local forward = root.CFrame.LookVector
	remote:FireAllClients("Ability", {player = player, origin = root.Position, forward = forward, style = state.style, key = key, kind = ability.Kind})

	if key == "E" then
		root.AssemblyLinearVelocity = forward * math.min(ability.Range * 3.2, 75) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
	end

	task.delay(0.16, function()
		if not character.Parent then return end
		local center = root.Position + forward * (ability.Range * 0.45)
		local hitCFrame = CFrame.new(center, center + forward)
		performHit(player, hitCFrame, Vector3.new(ability.Radius * 2, 7, ability.Range), ability.Damage, ability.Force, root.Position, ability.BlockBreak == true)
	end)
end

local function setBlocking(player, isBlocking)
	local state = getState(player)
	if isBlocking and not canAct(player) then return end
	state.blocking = isBlocking
	state.blockStarted = isBlocking and os.clock() or 0
	local character = player.Character
	if character then character:SetAttribute("Blocking", isBlocking) end
	remote:FireAllClients("Block", {player = player, active = isBlocking, style = state.style})
end

local function setBreathing(player, active)
	local state = getState(player)
	if active and not canAct(player) then return end
	state.breathing = active
	local character = player.Character
	if character then character:SetAttribute("Breathing", active) end
	remote:FireAllClients("Breathing", {player = player, active = active, style = state.style, value = state.breath, max = Config.MaxBreath})
end

remote.OnServerEvent:Connect(function(player, action, value)
	local state = getState(player)
	if action == "Attack" then
		doAttack(player)
	elseif action == "Heavy" then
		doHeavy(player)
	elseif action == "Dash" then
		doDash(player)
	elseif action == "Ability" and (value == "E" or value == "R" or value == "T" or value == "Y" or value == "X") then
		doAbility(player, value)
	elseif action == "Block" then
		setBlocking(player, value == true)
	elseif action == "Breath" then
		setBreathing(player, value == true)
	elseif action == "Style" and Config.Styles[value] then
		state.style = value
		state.cooldowns = {}
		local character = player.Character
		if character then character:SetAttribute("Style", value) end
		remote:FireClient(player, "StyleChanged", {style = value})
		remote:FireAllClients("StylePulse", {player = player, style = value})
	end
end)

Players.PlayerAdded:Connect(function(player)
	getState(player)
	player.CharacterAdded:Connect(function(character)
		local state = getState(player)
		state.blocking = false
		state.guard = Config.MaxGuard
		state.combo = 0
		state.breath = Config.MaxBreath
		state.breathing = false
		character:SetAttribute("Style", state.style)
		character:SetAttribute("Blocking", false)
		character:SetAttribute("Breathing", false)
		character:SetAttribute("Stunned", false)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	states[player] = nil
end)

createArena()

task.spawn(function()
	while true do
		for player, state in pairs(states) do
			if not state.blocking then
				state.guard = math.min(Config.MaxGuard, state.guard + Config.GuardRegen * 0.2)
				remote:FireClient(player, "Guard", {value = state.guard, max = Config.MaxGuard})
			end
			if state.breathing then
				state.breath = math.min(Config.MaxBreath, state.breath + Config.BreathRegen * 0.2)
				remote:FireClient(player, "Breath", {value = state.breath, max = Config.MaxBreath})
			end
		end
		task.wait(0.2)
	end
end)
