import type { Vec3 } from "./math";

export type MovementState =
  | "Idle" | "Walk" | "Sprint" | "GuardMove" | "AttackStartup" | "AttackActive" | "AttackRecovery"
  | "DashStartup" | "DashTravel" | "DashRecovery" | "JumpAnticipation" | "JumpLaunch" | "AirRise"
  | "AirFall" | "AirAttack" | "SoftLanding" | "HardLanding" | "Hitstun" | "Launch" | "Knockdown"
  | "QuickRecovery" | "RollingRecovery" | "Execute";

export type Action = "light" | "heavy" | "guard" | "jump" | "dash" | "throw" | "quickRecover" | "roll" | "ultimate" | "form1" | "form2" | "form3" | "form4" | "form5";

export type InputFrame = {
  sequence: number;
  tick: number;
  move: { x: number; y: number };
  held: Partial<Record<Action, boolean>>;
  pressed: Partial<Record<Action, boolean>>;
};

export type MoveMarker = { tick: number; type: "activeStart" | "activeEnd" | "displacement" | "vfx" | "sound" | "camera"; value?: number };
export type HitShape = { radius: number; forward: number; height: number; damage: number; guardDamage: number; launch: number; knockback: number; tags: string[] };
export type MoveSpec = {
  id: string;
  name: string;
  startup: number;
  active: number;
  recovery: number;
  cost: number;
  armorFrom: number;
  guardBreak: boolean;
  hit: HitShape;
  markers: MoveMarker[];
  displacement: number;
  kind: "light" | "heavy" | "form" | "ultimate" | "throw";
};

export type ActiveMove = { spec: MoveSpec; tick: number; hitTargets: Set<number> };
export type ActorState = {
  id: number;
  name: string;
  kit: "river" | "thread";
  position: Vec3;
  previousPosition: Vec3;
  velocity: Vec3;
  facing: number;
  state: MovementState;
  stateTick: number;
  grounded: boolean;
  health: number;
  guard: number;
  focus: number;
  special: number;
  invulnerableTicks: number;
  hitstunTicks: number;
  knockdownTicks: number;
  activeMove?: ActiveMove;
  comboStep: number;
  comboWindow: number;
  guardStartTick: number;
  dashDirection: Vec3;
};

export type CombatEvent = { tick: number; type: "swing" | "hit" | "guard" | "parry" | "guardBreak" | "whiff" | "vfx"; actorId: number; targetId?: number; moveId?: string; value?: number; position?: Vec3 };
