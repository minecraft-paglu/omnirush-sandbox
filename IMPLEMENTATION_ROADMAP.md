# Implementation roadmap

## Phase 0 — repository and research (complete when this plan is approved)

**Deliverables:** browser stack decision, source register, confidence labels, original content boundary, seven design documents.
**Acceptance:** no Roblox dependency; all requested research gaps are explicit; implementation names are original.

## Phase 1 — simulation foundation

**Dependencies:** Phase 0.
**Work:** Vite/TypeScript, shared schemas, fixed 60 Hz loop, input abstraction, camera-relative custom movement, plane/AABB collision, slope/ground/jump/fall/landing/dash, debug overlay.
**Acceptance:** movement tests pass at different render rates; state transitions are logged; no physics engine decides movement; keyboard and gamepad input produce the same canonical frame.

## Phase 2 — universal combat sandbox

**Dependencies:** Phase 1.
**Work:** hurt/hit shapes, attack timelines, four light hits, air chain, heavy, guard, guard durability, perfect guard, block break, throw, dodge, chase dash, launch, knockdown, recovery, dummy, frame debugger.
**Acceptance:** timeline marker tests pass; one hit per attack/target; simultaneous hit policy is documented; every action has counterplay and debug visualization.

## Phase 3 — first complete vertical slice

**Dependencies:** Phase 2.
**Work:** Riverform, Threadcraft, five forms plus ultimate each, original procedural fighters, Moonlit Relay, HUD, VFX/audio hooks, local two-player.
**Acceptance:** two kits are mechanically distinct without VFX; all moves have marker-driven hitboxes; 20 matchup games produce no infinite loop; performance and reduced-flash passes pass.

## Phase 4 — multiplayer hardening

**Dependencies:** Phase 3.
**Work:** authoritative room server, input sequences, prediction, reconciliation, server hit validation, schema/rate limits, latency/packet/reconnect tests.
**Acceptance:** malicious clients cannot apply damage or impossible displacement; 150 ms/1% loss remains playable; server replay reproduces outcomes from inputs.

## Phase 5 — content expansion

**Dependencies:** Phase 4.
**Work:** one new style/BDA at a time, each with original fiction, form sheet, animation, VFX/audio grammar, counters, balance, and network review.
**Acceptance:** no new kit enters production until it passes the same checklist as Phase 3.

## Current slice status

This repository pass implements the foundation and a compact local combat slice first; commissioned skeletal animations, authored sound, remote server, and production asset packs remain roadmap work. Procedural silhouettes and marker-driven geometry are intentionally labeled development assets, not final animation content.

## Risk register

| Risk | Trigger | Response |
|---|---|---|
| Scope expands into roster | More than two kits before slice acceptance | Freeze content; finish tests/network contract. |
| VFX masks combat | Players cannot name counter after replay | Disable effects, fix marker/silhouette first. |
| Browser performance | <60 FPS on target low-end pass | Pool effects, lower particles, reduce postprocess, keep simulation cost fixed. |
| Netcode divergence | Snapshot replay differs | Add deterministic test fixture and remove renderer/time dependencies. |
| IP boundary drift | Canon name/asset enters implementation | Replace with original term; keep canon only in research notes. |
