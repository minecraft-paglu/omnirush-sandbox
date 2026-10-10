import { approachAngle, clamp, forwardFromYaw, moveToward, normalizeXZ, scale, vec3, yawFor } from "./math";
import type { ActorState, InputFrame, MovementState } from "./types";

export const DT = 1 / 60;
export const ARENA = { minX: -13, maxX: 13, minZ: -8, maxZ: 8, groundY: 0, slopeLimit: 0.65 };
const GRAVITY = -22;
const WALK_SPEED = 4.2;
const SPRINT_SPEED = 6.5;

export function canMove(actor: ActorState): boolean {
  return ["Idle", "Walk", "Sprint", "GuardMove", "AirRise", "AirFall", "AirAttack"].includes(actor.state);
}

export function setState(actor: ActorState, state: MovementState): void {
  if (actor.state !== state) actor.stateTick = 0;
  actor.state = state;
}

export function stepMovement(actor: ActorState, input: InputFrame): void {
  actor.previousPosition = { ...actor.position };
  actor.stateTick += 1;
  actor.invulnerableTicks = Math.max(0, actor.invulnerableTicks - 1);

  if (actor.hitstunTicks > 0) {
    actor.hitstunTicks -= 1;
    setState(actor, actor.position.y > 0.35 ? "Launch" : "Hitstun");
    actor.velocity.x = moveToward(actor.velocity.x, 0, 32 * DT);
    actor.velocity.z = moveToward(actor.velocity.z, 0, 32 * DT);
  } else if (actor.knockdownTicks > 0) {
    actor.knockdownTicks -= 1;
    setState(actor, "Knockdown");
    if (input.pressed.roll && actor.knockdownTicks < 20) {
      actor.knockdownTicks = 0;
      actor.invulnerableTicks = 8;
      actor.velocity = scale(normalizeXZ(vec3(input.move.x, 0, -input.move.y)), 7);
      setState(actor, "RollingRecovery");
    }
  } else if (input.pressed.quickRecover && actor.position.y > 0.25) {
    actor.hitstunTicks = 0;
    actor.invulnerableTicks = 5;
    setState(actor, "QuickRecovery");
  } else if (canMove(actor)) {
    const moveDirection = normalizeXZ(vec3(input.move.x, 0, -input.move.y));
    const magnitude = Math.min(1, Math.hypot(input.move.x, input.move.y));
    const guarding = Boolean(input.held.guard);
    const sprinting = magnitude > 0.8 && Boolean(input.held.dash) && !guarding;
    const speed = guarding ? 2.2 : sprinting ? SPRINT_SPEED : WALK_SPEED;
    const acceleration = magnitude > 0 ? 28 : 20;
    const target = scale(moveDirection, speed * magnitude);
    actor.velocity.x = moveToward(actor.velocity.x, target.x, acceleration * DT);
    actor.velocity.z = moveToward(actor.velocity.z, target.z, acceleration * DT);
    if (magnitude > 0.05) actor.facing = approachAngle(actor.facing, yawFor(moveDirection), (guarding ? 7 : 12) * DT);
    if (guarding) setState(actor, magnitude > 0.05 ? "GuardMove" : "Idle");
    else if (sprinting) setState(actor, "Sprint");
    else if (magnitude > 0.05) setState(actor, "Walk");
    else setState(actor, "Idle");

    if (input.pressed.jump && actor.grounded) {
      actor.velocity.y = 7.3;
      actor.grounded = false;
      setState(actor, "JumpLaunch");
    }
    if (input.pressed.dash && magnitude === 0 && actor.grounded) {
      actor.dashDirection = forwardFromYaw(actor.facing);
      actor.invulnerableTicks = 6;
      actor.velocity = scale(actor.dashDirection, 12);
      setState(actor, "DashTravel");
    } else if (input.pressed.dash && magnitude > 0 && actor.grounded) {
      actor.dashDirection = moveDirection;
      actor.invulnerableTicks = 6;
      actor.velocity = scale(moveDirection, 12);
      setState(actor, "DashTravel");
    }
  }

  if (!actor.grounded || actor.position.y > ARENA.groundY) {
    actor.velocity.y += GRAVITY * DT;
    actor.position.y += actor.velocity.y * DT;
    if (actor.velocity.y > 0) setState(actor, actor.activeMove ? "AirAttack" : "AirRise");
    else if (actor.position.y > 0.05) setState(actor, actor.activeMove ? "AirAttack" : "AirFall");
  }
  actor.position.x += actor.velocity.x * DT;
  actor.position.z += actor.velocity.z * DT;
  actor.velocity.x = moveToward(actor.velocity.x, 0, 10 * DT);
  actor.velocity.z = moveToward(actor.velocity.z, 0, 10 * DT);

  const wasAirborne = !actor.grounded;
  if (actor.position.y <= ARENA.groundY) {
    actor.position.y = ARENA.groundY;
    actor.velocity.y = 0;
    actor.grounded = true;
    if (wasAirborne) setState(actor, Math.abs(actor.velocity.x) + Math.abs(actor.velocity.z) > 4 ? "HardLanding" : "SoftLanding");
  }
  const beforeX = actor.position.x;
  const beforeZ = actor.position.z;
  actor.position.x = clamp(actor.position.x, ARENA.minX, ARENA.maxX);
  actor.position.z = clamp(actor.position.z, ARENA.minZ, ARENA.maxZ);
  if (beforeX !== actor.position.x) actor.velocity.x = 0;
  if (beforeZ !== actor.position.z) actor.velocity.z = 0;
  if (actor.state === "DashTravel" && actor.stateTick >= 8) setState(actor, "DashRecovery");
  if (["SoftLanding", "HardLanding", "QuickRecovery", "RollingRecovery"].includes(actor.state) && actor.stateTick > 8) setState(actor, "Idle");
  if (actor.state === "DashRecovery" && actor.stateTick > 4) setState(actor, "Idle");
  actor.focus = clamp(actor.focus + (actor.state === "Idle" ? 0.35 : 0.08), 0, 100);
}
