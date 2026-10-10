# Technical architecture

## Selected stack

- TypeScript with strict checking.
- Vite for development/build and static deployment.
- Three.js WebGLRenderer for broad modern-browser support, with WebGPU as an optional future backend rather than a baseline requirement.
- Vitest for deterministic simulation tests.
- Optional Node WebSocket server in a later package; the first client runs offline/local.

Three.js supplies rendering, camera, GLTF and animation primitives. It does not own player motion, combat state, hit results, or authoritative collision. This follows MDN's WebGL compatibility guidance and avoids requiring WebGPU, whose browser baseline is limited.

## Repository layout

```text
src/
  sim/                 renderer-independent fixed-step game
    math.ts            vector/angle helpers
    types.ts           shared serializable types
    input.ts           input frames and keyboard/gamepad adapter
    movement.ts        state machine, integration, arena collision
    combat.ts          authored attack timelines and hit resolution
    world.ts           actors, dummy, match rules
  render/              Three.js only
    scene.ts            arena, stylized procedural fighters, VFX
    camera.ts           midpoint/lock-on presentation
  ui/                  DOM HUD/debug overlay
  main.ts              composition and fixed-step render loop
tests/                 simulation and network contract tests
server/                future authoritative adapter (not required by slice)
```

## Simulation loop

Simulation tick is exactly 1/60 s. The browser frame adds elapsed time to an accumulator, clamps a runaway frame to 250 ms, advances at most eight ticks per render frame, and renders an interpolation between previous/current presentation state. If the cap is reached, the debug HUD reports a slow simulation instead of allowing a spiral of death. Inputs are sampled at render time but converted to a numbered immutable `InputFrame` consumed by ticks.

```text
DOM/Gamepad → InputMapper → InputFrame(sequence, tick, buttons, axes)
                                      ↓
                       Simulation.step(inputFrames, 1/60)
                                      ↓
              state snapshot + combat events + debug traces
                         ↙                         ↘
                 Three.js presentation              HUD/replay
```

## State and data ownership

`ActorState` is JSON-safe and contains position/velocity/facing, movement state, grounded/contact normal, health/guard/focus, hitstun/knockdown, invulnerability, active move id/tick, and per-move hit deduplication. Move data is declarative: startup/active/recovery ticks, displacement curve, hit shapes, damage, guard result, armor, tags, cost, and event markers. The same timeline drives hit queries, VFX markers, audio markers, and animation requests.

Arena collision is a small authored set of planes/AABBs. A swept capsule/sphere query may be implemented for robustness, but resolution is project code: integrate, sweep, clamp to boundary, project velocity onto a slope tangent, and record normal. No physics engine is allowed to decide a combat transition.

## Networking plan

Phase 1–3 runs one simulation with two local input sources. Phase 4 adds a Node authoritative room over WebSocket (WebSocket is broadly supported but has no browser backpressure, so messages are bounded and rate-limited). The client sends `{roomId, sequence, clientTick, inputBits, moveX, moveY, aim}` at 30–60 Hz. The server validates schema, sequence monotonicity, max input age, legal transitions, resource costs, and movement bounds, then steps the same simulation and broadcasts snapshots/events.

The local client predicts only its owned locomotion and queued action presentation. On snapshot, it rewinds to the authoritative tick, applies the snapshot, and replays buffered inputs. Presentation objects interpolate snapshots and never feed data back into simulation. Rollback is an option for rare competitive hit disputes; initial networking uses server snapshots plus reconciliation because it is simpler to operate and debug.

Hit validation is server-side: resolve the attacker's authored timeline at server tick, transform hit shapes from authoritative position/facing, test hurt shapes, apply one hit per attack/target id, and emit a canonical combat event. Clients may show a speculative trail but not damage.

Anti-cheat: reject unknown move ids, impossible state/input combinations, excessive sequence gaps, impossible displacement, repeated same-tick actions, and malformed payloads. Log reason codes without trusting client clocks. Reconnect restores a snapshot or returns to lobby; no client-owned persistent combat state exists.

## Asset and animation pipeline

The slice uses procedural placeholder fighters so the simulation is testable without proprietary or missing assets. Production assets are GLTF with a documented skeleton, animation clips, additive breathing layers, and marker metadata. Asset manifests are hashed and cached; lazy-load arena/style packs; dispose GPU resources on room change. See `ANIMATION_VFX_PIPELINE.md`.

## Performance targets

- 60 simulation ticks at <2 ms average on a low-end desktop target.
- Render 60 FPS at 1080p with two fighters, 150 transient particles, and no more than 3 postprocess passes.
- Main bundle <500 KB compressed before optional assets; first arena ready <3 s on a warm cache.
- No per-tick allocations in the hot simulation path; pooled events and VFX.
- Debug overlays can be disabled and must not affect simulation.

## Persistence and deployment

Settings, keybinds, accessibility flags, and local replays use versioned localStorage/IndexedDB schemas. Account progression belongs on a server and is not trusted from local storage. Static builds deploy to any HTTPS CDN (GitHub Pages, Cloudflare Pages, Netlify, or S3); authoritative rooms deploy as a small Node service behind TLS with health checks and room limits.

## Risks

| Risk | Mitigation |
|---|---|
| Browser tab throttling | Pause/rebase render clock; never simulate unbounded catch-up; server remains authoritative online. |
| Different refresh rates | Fixed tick and interpolation tests. |
| Visual effect overload | Per-style budgets, pooled objects, reduced-flash mode, performance scene. |
| Input mapping drift | Canonical action enum plus keyboard/gamepad contract tests. |
| Netcode disagreement | Serialize snapshots and input frames; deterministic math helpers; server hit tests. |
| Missing art delays gameplay | Procedural silhouette renderer and marker-driven effects are valid development assets. |
