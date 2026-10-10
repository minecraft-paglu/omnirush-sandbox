# Changelog

## 0.1.0 — Movement and combat slice

- Replaced the Roblox/Rojo runtime boundary with Vite, TypeScript, Three.js, and Vitest.
- Added research and production documents covering source confidence, original content boundaries, simulation architecture, move data, animation/VFX, balance, roadmap, and manual scenarios.
- Added a fixed 60 Hz simulation with an accumulator and render interpolation.
- Added custom movement states and authored arena collision for acceleration, facing, jump/fall/landing, dash, air control, knockback, and recovery.
- Added universal attack timelines, hitbox/hurtbox checks, guard, perfect guard, guard break, throw, launch, knockdown, and resource validation.
- Added original Riverform and Threadcraft kits with five forms and an ultimate each.
- Added procedural local two-player arena presentation, HUD, event VFX, and debug overlay.
- Added deterministic automated tests for movement and combat contracts.

## Rejected during design

- Roblox-specific controllers, networking, assets, and APIs.
- Literal elemental damage as the default interpretation of breathing visual motifs.
- Grind-based ranked PvP power.
- Copied source code, proprietary game data, extracted animations, sounds, logos, or VFX.
