local Config = {}

Config.Styles = {
	Tide = {
		DisplayName = "Tide Breathing",
		Subtitle = "Flowing current",
		Color = Color3.fromRGB(55, 190, 255),
		Accent = Color3.fromRGB(175, 245, 255),
		Abilities = {
			E = {Name = "Riptide", Cooldown = 5, Cost = 12, Damage = 26, Range = 15, Radius = 7, Force = 42, Kind = "TideRiptide"},
			R = {Name = "Crescent Current", Cooldown = 8, Cost = 18, Damage = 34, Range = 22, Radius = 9, Force = 65, Kind = "TideCrescent"},
			T = {Name = "Breaker Wave", Cooldown = 11, Cost = 22, Damage = 39, Range = 18, Radius = 10, Force = 76, BlockBreak = true, Kind = "TideBreaker"},
			Y = {Name = "Tidal Prison", Cooldown = 15, Cost = 28, Damage = 44, Range = 20, Radius = 13, Force = 40, Kind = "TidePrison"},
			X = {Name = "Ocean's Roar", Cooldown = 23, Cost = 40, Damage = 58, Range = 20, Radius = 17, Force = 96, Kind = "TideUltimate"},
		},
	},
	Ember = {
		DisplayName = "Ember Breathing",
		Subtitle = "Unbroken ignition",
		Color = Color3.fromRGB(255, 93, 42),
		Accent = Color3.fromRGB(255, 225, 105),
		Abilities = {
			E = {Name = "Scorch Step", Cooldown = 5, Cost = 12, Damage = 29, Range = 17, Radius = 6, Force = 55, Kind = "EmberStep"},
			R = {Name = "Blazing Arc", Cooldown = 9, Cost = 18, Damage = 40, Range = 18, Radius = 10, Force = 72, Kind = "EmberArc"},
			T = {Name = "Ashen Breaker", Cooldown = 12, Cost = 22, Damage = 43, Range = 17, Radius = 9, Force = 84, BlockBreak = true, Kind = "EmberBreaker"},
			Y = {Name = "Cinder Rush", Cooldown = 15, Cost = 27, Damage = 48, Range = 21, Radius = 12, Force = 45, Kind = "EmberRush"},
			X = {Name = "Sunbreak", Cooldown = 25, Cost = 40, Damage = 65, Range = 24, Radius = 18, Force = 112, Kind = "EmberUltimate"},
		},
	},
	Storm = {
		DisplayName = "Storm Breathing",
		Subtitle = "Flash before thunder",
		Color = Color3.fromRGB(167, 114, 255),
		Accent = Color3.fromRGB(240, 235, 255),
		Abilities = {
			E = {Name = "Volt Lunge", Cooldown = 4, Cost = 11, Damage = 24, Range = 24, Radius = 5, Force = 40, Kind = "StormLunge"},
			R = {Name = "Thunder Cage", Cooldown = 9, Cost = 18, Damage = 37, Range = 20, Radius = 11, Force = 30, Kind = "StormCage"},
			T = {Name = "Flash Break", Cooldown = 11, Cost = 22, Damage = 41, Range = 22, Radius = 8, Force = 92, BlockBreak = true, Kind = "StormBreaker"},
			Y = {Name = "Static Field", Cooldown = 15, Cost = 28, Damage = 45, Range = 19, Radius = 14, Force = 55, Kind = "StormField"},
			X = {Name = "Sky Rend", Cooldown = 22, Cost = 40, Damage = 60, Range = 26, Radius = 16, Force = 124, Kind = "StormUltimate"},
		},
	},
	Crimson = {
		DisplayName = "Crimson Blood Art",
		Subtitle = "Forbidden bloodcraft",
		Color = Color3.fromRGB(239, 32, 87),
		Accent = Color3.fromRGB(255, 145, 190),
		Abilities = {
			E = {Name = "Blood Needle", Cooldown = 4, Cost = 11, Damage = 27, Range = 26, Radius = 4, Force = 25, Kind = "BloodNeedle"},
			R = {Name = "Scarlet Snare", Cooldown = 10, Cost = 19, Damage = 39, Range = 18, Radius = 12, Force = 50, Kind = "BloodSnare"},
			T = {Name = "Crimson Break", Cooldown = 12, Cost = 23, Damage = 47, Range = 19, Radius = 9, Force = 88, BlockBreak = true, Kind = "BloodBreaker"},
			Y = {Name = "Hemolock", Cooldown = 16, Cost = 29, Damage = 48, Range = 21, Radius = 14, Force = 48, Kind = "BloodLock"},
			X = {Name = "Red Moon", Cooldown = 26, Cost = 40, Damage = 70, Range = 22, Radius = 19, Force = 122, Kind = "BloodUltimate"},
		},
	},
}

Config.StyleOrder = {"Tide", "Ember", "Storm", "Crimson"}
Config.MaxCombo = 4
Config.ComboResetTime = 0.85
Config.AttackCooldown = 0.18
Config.BlockMultiplier = 0.28
Config.StunTime = 0.38
Config.PerfectBlockWindow = 0.2
Config.BlockBreakStun = 1.05
Config.HeavyCooldown = 1.05
Config.MaxGuard = 100
Config.GuardDrainPerHit = 16
Config.GuardRegen = 24
Config.MaxBreath = 100
Config.BreathRegen = 18

return Config
