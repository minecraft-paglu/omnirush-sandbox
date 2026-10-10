import { add, distanceXZ, forwardFromYaw, scale, vec3 } from "./math";
import { setState } from "./movement";
import type { Action, ActorState, CombatEvent, InputFrame, MoveSpec } from "./types";

const marker = (tick: number, type: MoveSpec["markers"][number]["type"], value?: number) => ({ tick, type, value });
const hit = (radius: number, forward: number, height: number, damage: number, guardDamage: number, launch = 0, knockback = 2, tags: string[] = []) => ({ radius, forward, height, damage, guardDamage, launch, knockback, tags });

export const MOVES: Record<string, MoveSpec> = {
  light1: { id: "universal.light.1", name: "First Cut", startup: 5, active: 3, recovery: 11, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.35, 1.25, 1.1, 8, 12), markers: [marker(5, "activeStart"), marker(8, "activeEnd"), marker(5, "vfx")], displacement: 0.2, kind: "light" },
  light2: { id: "universal.light.2", name: "Second Cut", startup: 5, active: 3, recovery: 12, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.45, 1.35, 1.1, 9, 13), markers: [marker(5, "activeStart"), marker(8, "activeEnd"), marker(5, "vfx")], displacement: 0.25, kind: "light" },
  light3: { id: "universal.light.3", name: "Third Cut", startup: 6, active: 3, recovery: 13, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.5, 1.4, 1.15, 10, 14), markers: [marker(6, "activeStart"), marker(9, "activeEnd"), marker(6, "vfx")], displacement: 0.3, kind: "light" },
  light4: { id: "universal.light.4", name: "Crescent Finish", startup: 7, active: 4, recovery: 17, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.7, 1.55, 1.15, 14, 18, 1.2, 4), markers: [marker(7, "activeStart"), marker(11, "activeEnd"), marker(7, "vfx")], displacement: 0.4, kind: "light" },
  air1: { id: "universal.air.1", name: "Falling Cut", startup: 4, active: 3, recovery: 10, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.2, 1.2, 1.2, 8, 11, 0.5, 2), markers: [marker(4, "activeStart"), marker(7, "activeEnd")], displacement: 0.15, kind: "light" },
  air2: { id: "universal.air.2", name: "Rising Cut", startup: 4, active: 3, recovery: 12, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.25, 1.3, 1.3, 11, 12, 1.1, 3), markers: [marker(4, "activeStart"), marker(7, "activeEnd")], displacement: 0.2, kind: "light" },
  heavy: { id: "universal.heavy", name: "Iron Breaker", startup: 12, active: 4, recovery: 20, cost: 0, armorFrom: 17, guardBreak: true, hit: hit(1.55, 1.35, 1.1, 22, 35, 1.5, 5, ["breaker"]), markers: [marker(17, "activeStart"), marker(21, "activeEnd"), marker(17, "camera")], displacement: 0.65, kind: "heavy" },
  throw: { id: "universal.throw", name: "Shoulder Throw", startup: 7, active: 4, recovery: 18, cost: 0, armorFrom: 99, guardBreak: false, hit: hit(1.05, 1.05, 1.1, 16, 0, 1, 4, ["throw"]), markers: [marker(7, "activeStart"), marker(11, "activeEnd")], displacement: 0.1, kind: "throw" },
  "river.ripple": { id: "river.ripple", name: "Ripple Draw", startup: 9, active: 5, recovery: 16, cost: 18, armorFrom: 99, guardBreak: false, hit: hit(1.8, 1.35, 1.15, 12, 16, 0.5, 3), markers: [marker(9, "activeStart"), marker(14, "activeEnd"), marker(9, "vfx")], displacement: 0.35, kind: "form" },
  "river.current": { id: "river.current", name: "Crescent Current", startup: 8, active: 8, recovery: 20, cost: 24, armorFrom: 99, guardBreak: false, hit: hit(1.5, 1.6, 1.1, 18, 20, 0.4, 4), markers: [marker(8, "activeStart"), marker(16, "activeEnd"), marker(8, "displacement", 2), marker(8, "vfx")], displacement: 2, kind: "form" },
  "river.basin": { id: "river.basin", name: "Basin Turn", startup: 6, active: 4, recovery: 14, cost: 20, armorFrom: 99, guardBreak: false, hit: hit(1.5, 1.1, 1.2, 10, 8, 0, 2, ["parry" ]), markers: [marker(6, "activeStart"), marker(10, "activeEnd"), marker(6, "vfx")], displacement: 0, kind: "form" },
  "river.undertow": { id: "river.undertow", name: "Undertow Step", startup: 5, active: 3, recovery: 18, cost: 22, armorFrom: 99, guardBreak: false, hit: hit(1.3, 1.7, 1.1, 9, 12, 0, 3), markers: [marker(5, "activeStart"), marker(8, "activeEnd"), marker(5, "displacement", 1.6)], displacement: 1.6, kind: "form" },
  "river.falling": { id: "river.falling", name: "Falling Channel", startup: 14, active: 4, recovery: 26, cost: 32, armorFrom: 99, guardBreak: true, hit: hit(1.7, 1.3, 1.0, 22, 34, 2.2, 5, ["breaker"]), markers: [marker(14, "activeStart"), marker(18, "activeEnd"), marker(14, "camera")], displacement: 0.8, kind: "form" },
  "river.ultimate": { id: "river.ultimate", name: "River That Returns", startup: 24, active: 8, recovery: 48, cost: 3, armorFrom: 99, guardBreak: false, hit: hit(2.2, 1.5, 1.1, 38, 40, 2, 7, ["ultimate"]), markers: [marker(24, "activeStart"), marker(32, "activeEnd"), marker(24, "camera"), marker(25, "vfx")], displacement: 2.8, kind: "ultimate" },
  "thread.stitch": { id: "thread.stitch", name: "First Stitch", startup: 8, active: 3, recovery: 14, cost: 15, armorFrom: 99, guardBreak: false, hit: hit(1.25, 1.25, 1.1, 8, 10), markers: [marker(8, "activeStart"), marker(11, "activeEnd"), marker(8, "vfx")], displacement: 0.1, kind: "form" },
  "thread.snare": { id: "thread.snare", name: "Crossgrain Snare", startup: 12, active: 6, recovery: 22, cost: 24, armorFrom: 99, guardBreak: false, hit: hit(1.6, 1.5, 1.1, 14, 18, 0.5, 4, ["anchor"]), markers: [marker(12, "activeStart"), marker(18, "activeEnd"), marker(12, "vfx")], displacement: 1.2, kind: "form" },
  "thread.step": { id: "thread.step", name: "Hemline Step", startup: 5, active: 8, recovery: 12, cost: 18, armorFrom: 99, guardBreak: false, hit: hit(1.1, 1.3, 1.2, 0, 0), markers: [marker(5, "activeStart"), marker(13, "activeEnd"), marker(5, "displacement", 2)], displacement: 2, kind: "form" },
  "thread.break": { id: "thread.break", name: "Pattern Break", startup: 10, active: 5, recovery: 25, cost: 28, armorFrom: 99, guardBreak: true, hit: hit(2.1, 1.4, 1.15, 20, 32, 1, 5, ["breaker"]), markers: [marker(10, "activeStart"), marker(15, "activeEnd"), marker(10, "camera")], displacement: 0, kind: "form" },
  "thread.seam": { id: "thread.seam", name: "Red Seam", startup: 16, active: 5, recovery: 28, cost: 34, armorFrom: 99, guardBreak: false, hit: hit(1.8, 1.8, 1.1, 24, 26, 1.2, 5), markers: [marker(16, "activeStart"), marker(21, "activeEnd"), marker(16, "vfx")], displacement: 0.5, kind: "form" },
  "thread.ultimate": { id: "thread.ultimate", name: "Grand Tapestry", startup: 26, active: 8, recovery: 52, cost: 3, armorFrom: 99, guardBreak: false, hit: hit(2.5, 1.5, 1.2, 42, 42, 2, 7, ["ultimate"]), markers: [marker(26, "activeStart"), marker(34, "activeEnd"), marker(26, "camera"), marker(27, "vfx")], displacement: 1.5, kind: "ultimate" },
};

function specFor(actor: ActorState, input: InputFrame): MoveSpec | undefined {
  if (input.pressed.ultimate && actor.special >= 3) return MOVES[`${actor.kit}.ultimate`];
  const formMap: Record<string, string[]> = { river: ["river.ripple", "river.current", "river.basin", "river.undertow", "river.falling"], thread: ["thread.stitch", "thread.snare", "thread.step", "thread.break", "thread.seam"] };
  const forms = formMap[actor.kit]!;
  const actions: Action[] = ["form1", "form2", "form3", "form4", "form5"];
  for (let i = 0; i < actions.length; i += 1) {
    const action = actions[i]!;
    if (input.pressed[action]) return MOVES[forms[i]!];
  }
  if (input.pressed.throw) return MOVES.throw;
  if (input.pressed.heavy) return MOVES.heavy;
  if (input.pressed.light) {
    const key = actor.position.y > 0.2 ? (actor.comboStep === 0 ? "air1" : "air2") : `light${Math.min(4, actor.comboStep + 1)}`;
    return MOVES[key];
  }
  return undefined;
}

export function startMove(actor: ActorState, input: InputFrame, events: CombatEvent[]): boolean {
  if (actor.activeMove || actor.hitstunTicks > 0 || actor.knockdownTicks > 0) return false;
  const spec = specFor(actor, input);
  if (!spec || actor.focus < spec.cost || (spec.kind === "ultimate" && actor.special < 3)) return false;
  actor.focus -= spec.cost;
  if (spec.kind === "ultimate") actor.special -= 3;
  actor.activeMove = { spec, tick: 0, hitTargets: new Set() };
  setState(actor, spec.startup > 0 ? "AttackStartup" : "AttackActive");
  events.push({ tick: input.tick, type: "swing", actorId: actor.id, moveId: spec.id });
  return true;
}

export function stepCombat(actor: ActorState, target: ActorState, input: InputFrame, tick: number, events: CombatEvent[]): void {
  if (!actor.activeMove) {
    startMove(actor, input, events);
    return;
  }
  const active = actor.activeMove;
  active.tick += 1;
  const total = active.spec.startup + active.spec.active + active.spec.recovery;
  if (active.tick < active.spec.startup) setState(actor, "AttackStartup");
  else if (active.tick < active.spec.startup + active.spec.active) setState(actor, actor.position.y > 0.2 ? "AirAttack" : "AttackActive");
  else if (active.tick < total) setState(actor, "AttackRecovery");
  const moveProgress = active.tick / Math.max(1, total);
  if (active.tick < active.spec.startup + active.spec.active && active.tick >= active.spec.startup) {
    if (!active.hitTargets.has(target.id) && distanceXZ(actor.position, target.position) <= active.spec.hit.radius + 0.8 && Math.abs(target.position.y - active.spec.hit.height) < 1.4) {
      const facing = forwardFromYaw(actor.facing);
      const toTarget = vec3(target.position.x - actor.position.x, 0, target.position.z - actor.position.z);
      const dot = facing.x * toTarget.x + facing.z * toTarget.z;
      if (dot > -0.2) {
        active.hitTargets.add(target.id);
        resolveHit(actor, target, active.spec, tick, events);
      }
    }
  }
  actor.position = add(actor.position, scale(forwardFromYaw(actor.facing), active.spec.displacement * (moveProgress < 0.7 ? 1 : 0) * (1 / Math.max(1, active.spec.startup))));
  if (active.tick >= total) {
    actor.comboStep = active.spec.kind === "light" ? (actor.comboStep + 1) % 4 : 0;
    actor.comboWindow = active.spec.kind === "light" ? 24 : 0;
    actor.activeMove = undefined;
    setState(actor, "Idle");
  }
}

function resolveHit(attacker: ActorState, target: ActorState, spec: MoveSpec, tick: number, events: CombatEvent[]): void {
  if (target.invulnerableTicks > 0) {
    events.push({ tick, type: "whiff", actorId: attacker.id, targetId: target.id, moveId: spec.id });
    return;
  }
  const guarding = target.state === "GuardMove" || target.state === "Idle" && target.guardStartTick > 0;
  const parry = guarding && target.stateTick <= 5 && !spec.hit.tags.includes("ultimate");
  if (parry) {
    attacker.hitstunTicks = 22;
    attacker.activeMove = undefined;
    target.focus = Math.min(100, target.focus + 18);
    events.push({ tick, type: "parry", actorId: target.id, targetId: attacker.id, moveId: spec.id, value: 18 });
    return;
  }
  if (guarding && !spec.hit.tags.includes("throw")) {
    target.guard -= spec.hit.guardDamage;
    target.focus = Math.min(100, target.focus + 4);
    events.push({ tick, type: "guard", actorId: attacker.id, targetId: target.id, moveId: spec.id, value: spec.hit.guardDamage });
    if (target.guard <= 0 || spec.guardBreak) {
      target.guard = 0;
      target.hitstunTicks = 28;
      target.guardStartTick = 0;
      events.push({ tick, type: "guardBreak", actorId: attacker.id, targetId: target.id, moveId: spec.id });
    }
    return;
  }
  target.health = Math.max(0, target.health - spec.hit.damage);
  target.hitstunTicks = spec.kind === "ultimate" ? 30 : 14;
  target.velocity = add(target.velocity, scale(forwardFromYaw(attacker.facing), spec.hit.knockback));
  if (spec.hit.launch > 0) {
    target.position.y = 0.5;
    target.velocity.y = spec.hit.launch;
    target.grounded = false;
  }
  if (target.health <= 0) target.knockdownTicks = 999999;
  events.push({ tick, type: "hit", actorId: attacker.id, targetId: target.id, moveId: spec.id, value: spec.hit.damage, position: target.position });
}
