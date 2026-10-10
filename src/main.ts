import "./style.css";
import { installKeyboard, sampleInputs } from "./sim/input";
import { CombatWorld } from "./sim/world";
import { ArenaScene } from "./render/scene";

const canvas = document.querySelector<HTMLCanvasElement>("#game-canvas");
const debugElement = document.querySelector<HTMLElement>("#debug");
const tickElement = document.querySelector<HTMLElement>("#tick");
const feedElement = document.querySelector<HTMLElement>("#event-feed");
const healthElements = [document.querySelector<HTMLElement>("#p1-health"), document.querySelector<HTMLElement>("#p2-health")];
const focusElements = [document.querySelector<HTMLElement>("#p1-focus"), document.querySelector<HTMLElement>("#p2-focus")];
if (!canvas || !debugElement || !tickElement || !feedElement || healthElements.some((element) => !element) || focusElements.some((element) => !element)) throw new Error("Lanternfall HUD failed to initialize");
const hudDebug = debugElement!;
const hudTick = tickElement!;
const hudFeed = feedElement!;

installKeyboard();
const world = new CombatWorld();
const scene = new ArenaScene(canvas);
let debug = false;
let accumulator = 0;
let lastTime = performance.now();
let previousTick = 0;

window.addEventListener("keydown", (event) => {
  if (event.key === "F1") debug = !debug;
  if (event.key === "F2") world.reset();
});

function frame(now: number): void {
  const elapsed = Math.min(0.25, (now - lastTime) / 1000);
  lastTime = now;
  accumulator += elapsed;
  let steps = 0;
  while (accumulator >= 1 / 60 && steps < 8) {
    world.step(sampleInputs(world.tick));
    accumulator -= 1 / 60;
    steps += 1;
  }
  if (steps === 8 && accumulator >= 1 / 60) accumulator = 0;
  scene.update(world, accumulator / (1 / 60));
  updateHud();
  requestAnimationFrame(frame);
}

function updateHud(): void {
  const [a, b] = world.actors;
  hudTick.textContent = String(world.tick).padStart(4, "0");
  healthElements[0]!.style.width = `${a.health}%`;
  healthElements[1]!.style.width = `${b.health}%`;
  focusElements[0]!.style.width = `${a.focus}%`;
  focusElements[1]!.style.width = `${b.focus}%`;
  const last = world.events[world.events.length - 1];
  if (last && world.tick !== previousTick) {
    hudFeed.textContent = last.type === "hit" ? `${last.moveId} · ${last.value} damage` : last.type.toUpperCase();
    previousTick = world.tick;
  }
  hudDebug.hidden = !debug;
  if (debug) {
    hudDebug.textContent = world.actors.map((actor) => `${actor.name}  state=${actor.state} t=${actor.stateTick}\npos=(${actor.position.x.toFixed(2)}, ${actor.position.y.toFixed(2)}, ${actor.position.z.toFixed(2)}) vel=(${actor.velocity.x.toFixed(2)}, ${actor.velocity.y.toFixed(2)}, ${actor.velocity.z.toFixed(2)})\nmove=${actor.activeMove?.spec.id ?? "-"} moveTick=${actor.activeMove?.tick ?? "-"} invuln=${actor.invulnerableTicks} guard=${actor.guard.toFixed(0)} focus=${actor.focus.toFixed(0)}`).join("\n\n");
  }
}

requestAnimationFrame(frame);
