local Physics = {}

-- These values are deliberately independent from Humanoid physics. The custom
-- controller integrates them and moves the combat root through swept queries.
Physics.BodySize = Vector3.new(2.6, 5.4, 2.6)
Physics.BodyHalfHeight = Physics.BodySize.Y * 0.5
Physics.Gravity = -112
Physics.JumpSpeed = 54
Physics.MaxFallSpeed = -92
Physics.GroundSnapDistance = 0.42
Physics.GroundProbeDistance = 4.2
Physics.MaxSlopeAngle = math.rad(46)
Physics.CoyoteTime = 0.11
Physics.JumpBuffer = 0.13

Physics.WalkSpeed = 15
Physics.SprintSpeed = 23
Physics.GroundAcceleration = 92
Physics.GroundDeceleration = 118
Physics.AirAcceleration = 25
Physics.AirDeceleration = 7
Physics.TurnSpeed = 15

Physics.DashSpeed = 64
Physics.DashDuration = 0.18
Physics.DashRecovery = 0.28
Physics.DashInvulnerability = 0.1

Physics.InputSendRate = 1 / 30
Physics.CorrectionPositionTolerance = 1.35
Physics.CorrectionAngleTolerance = math.rad(18)

return Physics
