import { clamp, distanceXZ, vec3 } from "./math";
import { stepCombat } from "./combat";
import { stepMovement } from "./movement";
import type { ActorState, CombatEvent, InputFrame } from "./types";

export class CombatWorld {
  readonly actors: [ActorState, ActorState];
  tick = 0;
  events: CombatEvent[] = [];

  constructor() {
    this.actors = [createActor(1, "Mira", "river", vec3(-5, 0, 0), 0.55), createActor(2, "Vey", "thread", vec3(5, 0, 0), -0.55)];
  }

  reset(): void {
    this.actors[0] = createActor(1, "Mira", "river", vec3(-5, 0, 0), 0.55);
    this.actors[1] = createActor(2, "Vey", "thread", vec3(5, 0, 0), -0.55);
    this.tick = 0;
    this.events = [];
  }

  step(inputs: [InputFrame, InputFrame]): void {
    this.tick += 1;
    this.events = [];
    for (let i = 0; i < this.actors.length; i += 1) {
      const actor = this.actors[i]!;
      const input = inputs[i]!;
      if (input.pressed.guard) actor.guardStartTick = actor.stateTick;
      if (!input.held.guard) actor.guardStartTick = Math.max(0, actor.guardStartTick - 1);
      stepMovement(actor, input);
      stepCombat(actor, this.actors[i === 0 ? 1 : 0], input, this.tick, this.events);
      actor.guard = clamp(actor.guard + (actor.guardStartTick === 0 ? 0.45 : 0), 0, 100);
      actor.comboWindow = Math.max(0, actor.comboWindow - 1);
      if (actor.comboWindow === 0) actor.comboStep = 0;
    }
    // Keep local fighters from occupying the same center line; this is a custom soft collision, not browser physics.
    const [a, b] = this.actors;
    const separation = distanceXZ(a.position, b.position);
    if (separation < 1.25) {
      const push = (1.25 - separation) * 0.5;
      const direction = a.position.x <= b.position.x ? -1 : 1;
      a.position.x += direction * push;
      b.position.x -= direction * push;
    }
  }
}

function createActor(id: number, name: string, kit: ActorState["kit"], position: ActorState["position"], facing: number): ActorState {
  return { id, name, kit, position, previousPosition: { ...position }, velocity: vec3(), facing, state: "Idle", stateTick: 0, grounded: true, health: 100, guard: 100, focus: 100, special: 3, invulnerableTicks: 0, hitstunTicks: 0, knockdownTicks: 0, comboStep: 0, comboWindow: 0, guardStartTick: 0, dashDirection: vec3() };
}
