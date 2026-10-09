# Prompt: Research and Build a Browser-Based Demon-Slayer-Inspired Multiplayer Game

You are an autonomous senior game designer, gameplay engineer, technical artist, animation director, and production planner. Your task is to research, design, and gradually implement a polished browser-based action game inspired by the combat fantasy, movement language, lore, and visual energy of **Demon Slayer: Kimetsu no Yaiba**.

The game must run in a modern desktop browser first and be architected so online multiplayer can be added without rewriting the combat system. Do not make this a Roblox project. Do not assume Roblox APIs, Roblox character controllers, Roblox networking, Roblox assets, or Roblox-specific architecture.

You must work methodically. Do not rush into writing a shallow prototype. Research first, produce a complete design and technical plan, then implement the game in small vertical slices with repeatable tests.

## Core instruction

Before writing gameplay code:

1. Inspect the repository and identify its current stack, entry points, tooling, tests, and constraints.
2. Research the source material and comparison games listed below.
3. Record what is confirmed, what is inferred, and what remains unknown.
4. Create a detailed game design document and technical architecture document in the repository.
5. Define a phased production roadmap with acceptance criteria for every phase.
6. Only then begin implementation, starting with a small but polished movement/combat vertical slice.

Do not copy any existing game's source code, proprietary assets, extracted animations, sound effects, models, UI, logos, or ripped VFX. Study mechanics and presentation principles, then build original systems and assets. If the project is intended for public or commercial release, clearly separate canon-inspired research from original names, characters, terminology, art, and audio that can legally ship.

## Research requirements

Use multiple public sources. Prefer official sources, official game manuals, developer documentation, primary interviews, and clearly maintained community references. Do not rely on one wiki or one search snippet.

### A. Demon Slayer manga and anime

Study the actual manga/anime setting and explain the gameplay implications of:

- Total Concentration Breathing.
- Constant Total Concentration.
- The relationship between Sun Breathing and branch styles.
- How breathing styles differ in body mechanics, rhythm, range, and temperament.
- Nichirin blades, blade colors, demon weaknesses, sunlight, wisteria, regeneration, and decapitation rules.
- Demon physiology and how Blood Demon Arts emerge from a demon's individuality, history, obsession, and biology.
- The difference between breathing visual symbolism and literal supernatural effects.
- How named forms are portrayed through stance, acceleration, body rotation, footwork, weapon path, and recovery.
- Canon limitations, costs, injuries, exhaustion, and consequences.
- How major styles differ, including Water, Flame, Thunder, Wind, Mist, Beast, Insect, Sound, Love, Serpent, Stone, Flower, Moon, and Sun.

For each researched style, create a table containing:

- Canon identity.
- Known users.
- Derived branch, when applicable.
- Physical movement language.
- Typical range.
- Offensive and defensive tendencies.
- Mobility profile.
- Signature forms and what they visibly do.
- Suitable game role.
- Potential PvP counters.
- Which effects should remain visual symbolism instead of literal elemental damage.

For Blood Demon Arts, research a broad range of examples and compare how their abilities reflect the demon using them. Identify reusable design patterns without flattening every BDA into a generic spell loadout.

### B. DSRPG2

Research publicly available DSRPG2 controls, Trello/wiki pages, videos, combo guides, and community explanations.

Investigate:

- Basic attack cadence and combo length.
- Ground and air attacks.
- Heavy attacks.
- Guard and guard durability.
- Perfect guard/parry timing.
- Block breakers.
- Dash, chase dash, sidestep, jump, and movement cancels.
- Breathing activation and resource behavior.
- Skill inputs and the five-slot layout such as E/R/T/Y/X.
- Combo routes and reset routes.
- Ragdoll, knockdown, recovery, execute, and stun behavior.
- How styles differ rather than simply changing VFX colors.
- Known bugs, frustrating mechanics, unclear telegraphs, and networking issues.

Clearly label which behavior is directly documented, which is observed from footage, and which is community interpretation.

### C. DemonFall

Research DemonFall gameplay, public wiki/Trello material, videos, patch notes, and player guides.

Study:

- Grounded sword combat.
- Combat weight and attack commitment.
- Guard, parry, dash, stamina, and movement behavior.
- How training, trainers, factions, progression, and unlocks create context for a style.
- How the game makes exploration and risk matter.
- How PvE progression interacts with PvP fairness.
- Which systems feel immersive and which systems create unnecessary grind or frustration.

Do not blindly reproduce progression gates. Extract the successful player-experience principles.

### D. Project Slayers 2 / Slayers 2

Research the current public game, official showcases, community wiki, controls guides, progression guides, style guides, and Blood Demon Art guides.

Study:

- Slayer versus demon path design.
- Breathing style and BDA build identity.
- Open-world activity loop.
- Weapon and clan/progression systems.
- Skill acquisition and mastery.
- PvP and PvE balance challenges.
- How skill effects and combat readability are presented.
- What is confirmed versus merely announced or speculated.

If the game is unreleased, recently updated, or documentation is inconsistent, record the date of each source and avoid presenting rumors as facts.

### E. Hinokami Chronicles

Treat Hinokami Chronicles as the most important presentation and arena-combat reference. Research its official website, official online manual, Steam description, gameplay footage, training guides, and combat explanations.

Study in detail:

- Arena layout and camera framing.
- Target lock and opponent visibility.
- Ground light attack routes.
- Air attack routes.
- Heavy attack armor and charge behavior.
- Throws.
- Guard strength.
- Parry timing.
- Chase dash.
- Sidestep and dodge behavior.
- Quick recover and rolling recovery.
- Skill gauge.
- Support/assist gauge.
- Special meter.
- Boost, Surge, and Ultimate behavior.
- Support characters and emergency escape.
- Combo timer and combo readability.
- Round, health, time-limit, and win-condition structure.
- Dramatic hit pauses, camera motion, sound layering, attack trails, and ultimate presentation.
- How story battles, training, rewards, and versus modes are structured.

The goal is to understand why the combat feels cinematic and readable, not to copy its character data or assets.

## Browser technology research

Determine the best technology for the repository after inspecting its current state. Possible choices include TypeScript with a browser rendering framework, WebGL/WebGPU, Three.js, Babylon.js, Phaser, or another appropriate stack. Select based on the actual requirements rather than preference.

Research and document:

- Fixed-timestep simulation.
- Render interpolation.
- Client prediction.
- Server authority.
- Reconciliation and rollback options.
- WebSocket or WebTransport networking.
- Deterministic or semi-deterministic movement.
- Browser performance limits.
- Asset loading and caching.
- Animation blending.
- Skeletal rigs.
- GPU particle effects.
- Mobile/controller input extensibility.
- Anti-cheat and server-side hit validation.
- Deployment options.

The architecture must support a future authoritative multiplayer server even if the first milestone is offline or local multiplayer.

## Custom movement and physics requirements

Do not use a generic browser game character controller as the final movement system. Build a custom, fixed-timestep movement and combat simulation.

The simulation must explicitly own:

- Acceleration and deceleration.
- Facing and turning.
- Ground detection.
- Slope handling.
- Custom gravity.
- Jump launch.
- Air control.
- Falling.
- Landing.
- Dash and chase dash.
- Sidestep and dodge.
- Attack displacement.
- Knockback.
- Launches.
- Knockdowns.
- Quick recovery.
- Rolling recovery.
- Wall and arena collision.
- Invulnerability windows.
- Movement locks and recovery windows.

Do not allow the browser physics engine or an off-the-shelf character controller to secretly decide important combat outcomes. Collision queries and rendering APIs are allowed, but the game's movement state, integration, displacement curves, and combat transitions must be authored by the project.

Use a fixed simulation step, such as 60 Hz, with render interpolation. Define a movement state machine and document every transition.

### Movement states to plan and implement

- Idle.
- Walk.
- Sprint.
- Start/stop acceleration.
- Guard movement.
- Attack startup.
- Attack active.
- Attack recovery.
- Dash startup.
- Dash travel.
- Dash recovery.
- Jump anticipation.
- Jump launch.
- Airborne rise.
- Airborne fall.
- Air attack.
- Soft landing.
- Hard landing.
- Hitstun.
- Launch.
- Knockdown.
- Quick recovery.
- Rolling recovery.
- Execute.

Every state needs explicit values for movement, rotation, collision, attack interruption, invulnerability, animation, camera, and input permissions.

## Animation requirements

Animations must be custom-authored for the game's theme. Do not use default placeholder movement animations as the final result.

Plan an animation pipeline that includes:

1. Movement reference and pose study.
2. Rig selection and skeleton conventions.
3. Idle breathing and stance.
4. Walk and sprint with style-specific posture.
5. Jump anticipation, launch, airborne, fall, soft landing, and hard landing.
6. Directional dash and sidestep.
7. Guard, perfect guard, guard break, hitstun, knockdown, get-up, and roll recovery.
8. Four-hit light attack chain.
9. Heavy attack with charge and release.
10. Throw and counter animations.
11. Five skills per style/BDA.
12. Ultimate/finisher animations.
13. Additive breathing, fatigue, injury, and demon transformation layers.

Every attack animation must contain explicit markers for:

- Startup.
- Active start.
- Active end.
- Recovery start.
- Movement displacement.
- Footstep.
- Weapon contact.
- VFX emission.
- Sound impact.
- Camera impact.

Gameplay hitboxes and damage must be driven by the same authored timeline as the animation. Never tune hitboxes by eye after the animation is finished.

## Combat design requirements

Design universal combat first, then styles and BDAs.

The universal system should include:

- Four-hit grounded light chain.
- Short air chain.
- Directional light finishers.
- Heavy attack.
- Chargeable guard pressure.
- Throws.
- Guard durability.
- Perfect guard/parry.
- Chase dash.
- Sidestep/dodge.
- Quick dodge cancel with a resource cost.
- Jump attacks.
- Launchers.
- Knockdown.
- Quick recovery.
- Rolling recovery with invulnerability.
- Execute/opening-thread-style state only when justified.
- Combo timer.
- Hitstun and diminishing returns.
- Anti-infinite-combo rules.

For every mechanic, document:

- Player input.
- Startup.
- Active window.
- Recovery.
- Hitbox and hurtbox behavior.
- Guard behavior.
- Perfect guard behavior.
- Armor behavior.
- Resource cost.
- Counterplay.
- Network authority.
- Animation and VFX requirements.

## Style and BDA implementation requirements

Do not create a style by changing only colors and names. Each style must have:

- A movement identity.
- A neutral game plan.
- A pressure game plan.
- A defensive option.
- A mobility option.
- A punish option.
- A guard interaction.
- A signature risk.
- Five or more forms/skills.
- A resource loop.
- A counterplay guide.
- An animation language.
- A VFX grammar.
- A sound palette.

Each BDA must additionally have:

- A demon personality and origin concept.
- A distinct supernatural rule.
- A setup/payoff loop.
- A weakness or limitation.
- A way for a slayer to read and counter it.
- Regeneration and sunlight/wisteria/Nichirin interactions when relevant.

## Design documentation deliverables

Before implementation, create these documents:

1. `RESEARCH_NOTES.md` — source links, findings, dates, confidence levels, contradictions, and open questions.
2. `GAME_DESIGN_BIBLE.md` — pillars, modes, movement, combat, styles, BDAs, progression, UI, camera, VFX, audio, and player experience.
3. `TECHNICAL_ARCHITECTURE.md` — browser stack, simulation, networking, modules, data flow, persistence, performance, and deployment.
4. `MOVE_SPECIFICATIONS.md` — one complete data sheet per universal action, breathing form, BDA form, and ultimate.
5. `ANIMATION_VFX_PIPELINE.md` — rig, animation markers, authoring workflow, effects budget, asset naming, and review checklist.
6. `BALANCE_PLAN.md` — normalized stats, frame targets, resource budgets, matchup matrix, and playtest process.
7. `IMPLEMENTATION_ROADMAP.md` — milestones, dependencies, acceptance criteria, and risk register.

Do not copy the current project's design decisions into these files. Discover the design from research and make independent decisions.

## Implementation process

After the documents are approved, implement in this order:

### Phase 1: repository and simulation foundation

- Set up the browser build and development workflow.
- Create shared types and data schemas.
- Build the fixed-timestep loop.
- Build input abstraction.
- Build camera-relative custom movement.
- Build ground, slope, jump, fall, landing, dash, and collision queries.
- Add a debug overlay showing state, velocity, frame, collision normals, and input sequence.

### Phase 2: universal combat sandbox

- Add hitboxes and hurtboxes.
- Add attack timeline data.
- Add light combo.
- Add heavy attack.
- Add guard, guard durability, perfect guard, and block break.
- Add dodge, chase dash, launch, knockdown, quick recover, and rolling recover.
- Add a dummy and frame-by-frame combat debugger.

### Phase 3: first complete vertical slice

- Implement one Water-inspired style.
- Implement one original Threadcraft-inspired BDA.
- Create five forms for each.
- Add custom animations, markers, VFX, sound, camera, and UI.
- Build one arena.
- Add local two-player testing or a simple authoritative server loop.

### Phase 4: multiplayer hardening

- Add server authority.
- Add input sequence numbers.
- Add client prediction.
- Add reconciliation.
- Add server hit validation.
- Add rate limits.
- Test latency, packet loss, reconnects, and malicious input.

### Phase 5: content expansion

Add additional styles and BDAs one at a time. Each must pass a complete design, animation, balance, counterplay, performance, and multiplayer review before another is started.

## Testing requirements

Create automated tests for:

- Fixed-timestep movement.
- Ground and slope collision.
- Jump/fall/landing transitions.
- Dash and dodge invulnerability.
- Attack timeline events.
- Guard/parry/block-break resolution.
- Hitbox deduplication.
- Combo timer and hitstun.
- Resource costs and regeneration.
- Client/server reconciliation.
- Invalid or malicious network requests.

Create manual test scenarios for:

- One player against a dummy.
- Two local players.
- High latency.
- Simultaneous attacks.
- Perfect guard against heavy attacks.
- Guard break at the edge of a combo.
- Air attack into landing.
- Wall collision during dash.
- Knockdown recovery.
- Ultimate VFX performance.
- Low-end browser hardware.
- Keyboard, gamepad, and future touch input.

Do not declare a milestone complete because the screen looks impressive. It is complete only when the movement, animation, hitboxes, counterplay, networking, performance, and tests all meet the documented acceptance criteria.

## Expected agent behavior

- Ask for clarification only when a decision blocks progress; continue independent research and setup work.
- Maintain a visible task list.
- Keep research, design, implementation, and test changes separated into understandable commits.
- Explain major tradeoffs.
- Do not silently replace working files.
- Do not add placeholder systems that pretend to be finished.
- Prefer small, testable vertical slices over a large incomplete roster.
- Keep a changelog of confirmed mechanics and rejected ideas.
- Report exactly what was researched, what was implemented, what was tested, and what remains.
- If a source is blocked or contradictory, say so and use another source instead of inventing certainty.
