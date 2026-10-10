# Breathbound: Lanternfall

An original browser-based action duel about disciplined sword forms and demons who weaponize personal obsessions. Lanternfall studies the readable body mechanics, defensive cadence, and cinematic energy of demon-hunting anime and arena fighters while using original names, fiction, geometry, effects, and audio.

## Current slice

The repository now contains:

- A Vite + TypeScript + Three.js browser build.
- A renderer-independent 60 Hz simulation with render interpolation.
- Custom movement state ownership: acceleration, deceleration, facing, ground/jump/fall/landing, dash, air control, arena bounds, knockback, and recovery.
- Universal combat: four-hit ground chain, two-hit air chain, heavy guard breaker, guard durability, perfect guard, throw, dodge, launch, knockdown, and recovery.
- Two original kits: Riverform and Threadcraft, each with five forms and an ultimate.
- A local two-player arena, procedural development fighters, event-driven effect feedback, HUD, and F1 debug overlay.
- Vitest coverage for fixed movement, landing, dash invulnerability, authored attack timelines, deduplicated hits, parry, resource gating, and world reset.

## Run locally

```bash
npm install
npm run dev
```

Open the Vite URL printed in the terminal. Production validation:

```bash
npm test
npm run build
```

## Controls

| Player | Movement | Combat |
|---|---|---|
| P1 | WASD | J light, K heavy, L guard, Space jump, Shift dash, I throw, E/R/T/Y/X forms, U ultimate |
| P2 | Arrow keys | Numpad 1 light, 2 heavy, 3 guard, 0 jump, Enter dash, Decimal throw, Numpad 4–8 forms, 9 ultimate |

`F1` toggles the simulation debugger. `F2` resets the match.

## Architecture and design

Read these in order:

1. [`RESEARCH_NOTES.md`](RESEARCH_NOTES.md) — public sources, dates, confidence, contradictions, and IP boundary.
2. [`GAME_DESIGN_BIBLE.md`](GAME_DESIGN_BIBLE.md) — pillars, modes, movement, combat, kits, UI, and player experience.
3. [`TECHNICAL_ARCHITECTURE.md`](TECHNICAL_ARCHITECTURE.md) — module boundaries, fixed step, renderer, and future authority model.
4. [`MOVE_SPECIFICATIONS.md`](MOVE_SPECIFICATIONS.md) — frame-level universal and kit move data.
5. [`IMPLEMENTATION_ROADMAP.md`](IMPLEMENTATION_ROADMAP.md) — milestones and acceptance criteria.

The simulation is deliberately independent of Three.js so the future authoritative server can run the same state and move validation without a browser renderer. Multiplayer server authority, client prediction/reconciliation, skeletal production animation, authored audio, and a larger content roster are roadmap work.

## Content boundary

This is not a Roblox project and has no Roblox runtime dependency. The former repository files were a Roblox/Rojo prototype and are removed as part of this browser migration. Canon research is recorded for design study only; the implemented game uses original terms such as Riverform, Threadcraft, Lanternfall, and Moonlit Relay.
