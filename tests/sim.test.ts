import { describe, expect, it } from "vitest";
import { MOVES, stepCombat } from "../src/sim/combat";
import { vec3 } from "../src/sim/math";
import { ARENA, stepMovement } from "../src/sim/movement";
import { CombatWorld } from "../src/sim/world";
import type { ActorState, CombatEvent, InputFrame } from "../src/sim/types";

const input = (overrides: Partial<InputFrame> = {}): InputFrame => ({ sequence: 1, tick: 1, move: { x: 0, y: 0 }, held: {}, pressed: {}, ...overrides });
const actor = (id: number): ActorState => ({ id, name: `test-${id}`, kit: id === 1 ? "river" : "thread", position: vec3(id === 1 ? 0 : 1.2, 0, 0), previousPosition: vec3(id === 1 ? 0 : 1.2, 0, 0), velocity: vec3(), facing: id === 1 ? Math.PI / 2 : -Math.PI / 2, state: "Idle", stateTick: 0, grounded: true, health: 100, guard: 100, focus: 100, special: 3, invulnerableTicks: 0, hitstunTicks: 0, knockdownTicks: 0, comboStep: 0, comboWindow: 0, guardStartTick: 0, dashDirection: vec3() });

describe("fixed-step movement", () => {
  it("accelerates camera-relative movement and stops at arena bounds", () => {
    const testActor = actor(1);
    for (let i = 0; i < 400; i += 1) stepMovement(testActor, input({ move: { x: 1, y: 0 } }));
    expect(testActor.position.x).toBe(ARENA.maxX);
    expect(testActor.velocity.x).toBe(0);
    expect(testActor.state).toBe("Walk");
  });

  it("launches, falls, and lands under authored gravity", () => {
    const testActor = actor(1);
    stepMovement(testActor, input({ pressed: { jump: true } }));
    expect(testActor.grounded).toBe(false);
    expect(testActor.state).toBe("AirRise");
    for (let i = 0; i < 120; i += 1) stepMovement(testActor, input());
    expect(testActor.position.y).toBe(0);
    expect(testActor.grounded).toBe(true);
  });

  it("gives dash authored invulnerability and a finite recovery", () => {
    const testActor = actor(1);
    stepMovement(testActor, input({ pressed: { dash: true } }));
    expect(testActor.state).toBe("DashTravel");
    expect(testActor.invulnerableTicks).toBe(6);
    for (let i = 0; i < 15; i += 1) stepMovement(testActor, input());
    expect(testActor.state).toBe("Idle");
  });
});

describe("authored combat timelines", () => {
  it("emits a hit only inside active frames and deduplicates targets", () => {
    const attacker = actor(1); const target = actor(2); target.position.x = 1;
    const events: CombatEvent[] = [];
    attacker.activeMove = { spec: MOVES.light1!, tick: 0, hitTargets: new Set() };
    for (let tick = 0; tick < 30; tick += 1) stepCombat(attacker, target, input({ tick, pressed: {} }), tick, events);
    expect(events.filter((event) => event.type === "hit")).toHaveLength(1);
    expect(target.health).toBe(92);
  });

  it("parries a breaker during the perfect-guard window", () => {
    const attacker = actor(1); const target = actor(2); target.position.x = 1;
    target.state = "GuardMove"; target.stateTick = 2;
    attacker.activeMove = { spec: MOVES.heavy!, tick: MOVES.heavy!.startup, hitTargets: new Set() };
    const events: CombatEvent[] = [];
    stepCombat(attacker, target, input(), 20, events);
    expect(events.some((event) => event.type === "parry")).toBe(true);
    expect(attacker.hitstunTicks).toBeGreaterThan(0);
  });

  it("rejects a form when focus is insufficient", () => {
    const testActor = actor(1); testActor.focus = 0;
    const events: CombatEvent[] = [];
    stepCombat(testActor, actor(2), input({ pressed: { form1: true } }), 1, events);
    expect(testActor.activeMove).toBeUndefined();
    expect(events).toHaveLength(0);
  });
});

describe("world contract", () => {
  it("advances two local actors and can reset deterministically", () => {
    const world = new CombatWorld();
    const start = world.actors[0].position.x;
    for (let tick = 0; tick < 30; tick += 1) world.step([input({ tick, move: { x: 1, y: 0 } }), input({ tick })]);
    expect(world.tick).toBe(30);
    expect(world.actors[0].position.x).toBeGreaterThan(start);
    world.reset();
    expect(world.tick).toBe(0);
    expect(world.actors[0].position.x).toBe(start);
  });
});
