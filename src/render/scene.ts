import * as THREE from "three";
import type { ActorState, CombatEvent } from "../sim/types";
import { clamp } from "../sim/math";
import type { CombatWorld } from "../sim/world";

type FighterView = { root: THREE.Group; body: THREE.Mesh; blade: THREE.Mesh; aura: THREE.Mesh; lastState: string };

export class ArenaScene {
  readonly scene = new THREE.Scene();
  readonly camera = new THREE.PerspectiveCamera(42, 1, 0.1, 100);
  readonly renderer: THREE.WebGLRenderer;
  private readonly fighters = new Map<number, FighterView>();
  private readonly effects = new THREE.Group();
  private readonly canvas: HTMLCanvasElement;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    this.scene.background = new THREE.Color("#090e1c");
    this.scene.fog = new THREE.Fog("#090e1c", 18, 40);
    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true, powerPreference: "high-performance" });
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.75));
    this.renderer.shadowMap.enabled = true;
    this.scene.add(new THREE.HemisphereLight("#9fb6e6", "#111321", 2.2));
    const key = new THREE.DirectionalLight("#ffd9a0", 3.2);
    key.position.set(-6, 12, 4);
    key.castShadow = true;
    this.scene.add(key);
    this.scene.add(this.createArena());
    this.scene.add(this.effects);
    this.camera.position.set(0, 9.5, 15);
    this.camera.lookAt(0, 0.8, 0);
    window.addEventListener("resize", () => this.resize());
    this.resize();
  }

  private createArena(): THREE.Group {
    const group = new THREE.Group();
    const floor = new THREE.Mesh(new THREE.PlaneGeometry(30, 20), new THREE.MeshStandardMaterial({ color: "#151e32", roughness: 0.9 }));
    floor.rotation.x = -Math.PI / 2;
    floor.receiveShadow = true;
    group.add(floor);
    const grid = new THREE.GridHelper(28, 28, "#334462", "#1c2940");
    grid.position.y = 0.015;
    group.add(grid);
    const lanternPositions: [number, number][] = [[-12, -7], [12, -7], [-12, 7], [12, 7]];
    for (const [x, z] of lanternPositions) {
      const lantern = new THREE.Mesh(new THREE.CylinderGeometry(0.15, 0.2, 2.2, 8), new THREE.MeshStandardMaterial({ color: "#3a2a2a", emissive: "#e89b48", emissiveIntensity: 1.2 }));
      lantern.position.set(x, 1.1, z);
      group.add(lantern);
    }
    return group;
  }

  update(world: CombatWorld, alpha: number): void {
    const [a, b] = world.actors;
    for (const actor of [a, b]) {
      let view = this.fighters.get(actor.id);
      if (!view) {
        view = this.createFighter(actor);
        this.fighters.set(actor.id, view);
        this.scene.add(view.root);
      }
      const x = actor.previousPosition.x + (actor.position.x - actor.previousPosition.x) * alpha;
      const y = actor.previousPosition.y + (actor.position.y - actor.previousPosition.y) * alpha;
      const z = actor.previousPosition.z + (actor.position.z - actor.previousPosition.z) * alpha;
      view.root.position.set(x, y, z);
      view.root.rotation.y = actor.facing;
      const pulse = actor.activeMove ? 1 + Math.sin(actor.stateTick * 0.8) * 0.06 : 1;
      view.body.scale.set(1, pulse, 1);
      view.aura.scale.setScalar(actor.invulnerableTicks > 0 ? 1.35 : 1);
      view.aura.visible = actor.invulnerableTicks > 0 || Boolean(actor.activeMove);
      view.lastState = actor.state;
    }
    this.renderCamera(a, b);
    this.updateEffects(world.events);
    this.renderer.render(this.scene, this.camera);
  }

  private createFighter(actor: ActorState): FighterView {
    const root = new THREE.Group();
    const color = actor.kit === "river" ? "#7bd9e9" : "#e44e69";
    const body = new THREE.Mesh(new THREE.CapsuleGeometry(0.45, 1.05, 4, 8), new THREE.MeshStandardMaterial({ color, roughness: 0.55, emissive: color, emissiveIntensity: 0.15 }));
    body.position.y = 1.0;
    body.castShadow = true;
    root.add(body);
    const head = new THREE.Mesh(new THREE.SphereGeometry(0.38, 12, 8), new THREE.MeshStandardMaterial({ color: "#e9c4a7", roughness: 0.9 }));
    head.position.y = 1.85;
    root.add(head);
    const blade = new THREE.Mesh(new THREE.BoxGeometry(0.08, 0.08, 1.9), new THREE.MeshStandardMaterial({ color: "#f7f1da", emissive: color, emissiveIntensity: 0.6, metalness: 0.8 }));
    blade.position.set(0.48, 1.05, 0.72);
    blade.rotation.x = Math.PI / 2.5;
    root.add(blade);
    const aura = new THREE.Mesh(new THREE.RingGeometry(0.62, 0.7, 32), new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.55, side: THREE.DoubleSide }));
    aura.rotation.x = -Math.PI / 2;
    aura.position.y = 0.03;
    root.add(aura);
    return { root, body, blade, aura, lastState: "Idle" };
  }

  private renderCamera(a: ActorState, b: ActorState): void {
    const midpoint = new THREE.Vector3((a.position.x + b.position.x) / 2, 0.8, (a.position.z + b.position.z) / 2);
    const span = Math.max(8, Math.hypot(a.position.x - b.position.x, a.position.z - b.position.z));
    const desired = new THREE.Vector3(midpoint.x, 7.2 + span * 0.12, midpoint.z + 12 + span * 0.35);
    this.camera.position.lerp(desired, 0.08);
    this.camera.lookAt(midpoint);
  }

  private updateEffects(events: CombatEvent[]): void {
    for (const event of events) {
      if (!["hit", "parry", "guardBreak", "vfx"].includes(event.type)) continue;
      const color = event.type === "parry" ? "#fff4b0" : event.actorId === 1 ? "#73e9f4" : "#f15a73";
      const ring = new THREE.Mesh(new THREE.RingGeometry(0.15, 0.38, 16), new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.85, side: THREE.DoubleSide }));
      ring.rotation.x = -Math.PI / 2;
      ring.position.set(event.position?.x ?? 0, 0.08, event.position?.z ?? 0);
      ring.userData.life = event.type === "guardBreak" ? 20 : 12;
      this.effects.add(ring);
    }
    for (const child of [...this.effects.children]) {
      const life = Number(child.userData.life ?? 0) - 1;
      child.userData.life = life;
      child.scale.multiplyScalar(1.08);
      const material = child instanceof THREE.Mesh ? child.material : undefined;
      if (material instanceof THREE.MeshBasicMaterial) material.opacity = clamp(life / 12, 0, 1);
      if (life <= 0) this.effects.remove(child);
    }
  }

  private resize(): void {
    const width = this.canvas.clientWidth || window.innerWidth;
    const height = this.canvas.clientHeight || window.innerHeight;
    this.renderer.setSize(width, height, false);
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
  }
}
