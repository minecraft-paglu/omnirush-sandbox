# Research notes — Breathbound: Lanternfall

**Research date:** 2026-10-10
**Scope:** Publicly available material used to derive mechanics and presentation principles. This project is an original browser game; no source code, extracted asset, animation, logo, sound, or VFX from a reference product is used.

## Confidence legend

- **Confirmed:** stated by an official publisher/rights-holder manual, site, store page, or primary technical documentation.
- **Corroborated:** consistent across a first-party source and an independent maintained source.
- **Observed/community:** reported in gameplay footage, guides, wikis, or community discussion; useful for hypotheses, not canon fact.
- **Open:** the source was inaccessible, contradictory, undocumented, or requires hands-on testing.

## Source register

| Source | Date accessed | Confidence | Useful findings |
|---|---:|---|---|
| [Demon Slayer anime official site](https://demonslayer-anime.com/) | 2026-10-10 | Confirmed | Official arc chronology, production ownership, and separation between franchise canon and any original game fiction. |
| [VIZ series page](https://www.viz.com/demon-slayer-kimetsu-no-yaiba) | 2026-10-10 | Confirmed | Licensed synopsis, creator attribution, and official availability of manga/fanbook material. |
| [SEGA official Hinokami site](https://demonslayer-hinokami.sega.com/) | 2026-10-10 | Confirmed | Arena-fight positioning, 3D presentation goals, roster/mode framing, and official promotional language. |
| [Hinokami online manual — modes](https://demonslayer-hinokami.sega.com/manual/us/index.html) | 2026-10-10 | Confirmed | Story, VS, Training, Rewards, Archives, and Tutorials form a clear onboarding/progression loop. |
| [Hinokami online manual — controls](https://demonslayer-hinokami.sega.com/manual/us/play.html) | 2026-10-10 | Confirmed | Move, jump, sidestep, chase dash, guard, shove, parry, quick/rolling recovery, quick dodge, throw, skills, ultimate, boost, surge, support, and emergency escape inputs. |
| [Hinokami online manual — combat](https://demonslayer-hinokami.sega.com/manual/us/battle.html) | 2026-10-10 | Confirmed | Four-hit ground light chain, two-hit air chain, directional finishers, heavy armor/charge, guard durability, parry, gauges, combo timer, and resource costs. |
| [Hinokami online manual — tips](https://demonslayer-hinokami.sega.com/manual/us/advice.html) | 2026-10-10 | Confirmed | Defensive counterplay, visible danger telegraphs, opening-thread finisher context, map/scent exploration, and replayable training/reward structure. |
| [Steam product page](https://store.steampowered.com/app/1490890/Demon_SlayerKimetsu_no_Yaiba_The_Hinokami_Chronicles/) | 2026-10-10 | Confirmed | 2021 release, CyberConnect2/SEGA, online/local PvP, 30/60 FPS PC targets, and original game's licensed content boundary. |
| [Nintendo product page](https://www.nintendo.com/us/store/products/demon-slayer-kimetsu-no-yaiba-the-hinokami-chronicles-switch/) | 2026-10-10 | Confirmed | Adventure/Versus split, 1–2 local and 2 online players, and platform/feature constraints. |
| [Wikipedia: Demon Slayer series](https://en.wikipedia.org/wiki/Demon_Slayer:_Kimetsu_no_Yaiba) | 2026-10-10 | Corroborated | Convenient cross-reference for breathing, demon weaknesses, BDA examples, style branches, and publication chronology. Canon claims should be checked against the manga/anime/fanbooks before public lore publication. |
| [Try Hard Guides: Project Slayers controls](https://tryhardguides.com/project-slayers-controls-list/) | 2026-10-10 | Observed/community | Controls guide reports movement, light/heavy combat, block, dash, wall climb, ability keys, air/special routes, execute/carry/revive, and stamina context. Last updated 2022-11-08. |
| [Try Hard Guides: Project Slayers Trello](https://tryhardguides.com/project-slayers-trello-link/) | 2026-10-10 | Observed/community | Links the community Trello and describes trainers, breaths, BDAs, factions, quests, weapons, clans, and progression. Page last updated 2023-09-28. |
| [DSRPG2 Fandom controls](https://dsrpg2.fandom.com/wiki/Controls) | 2026-10-10 | Open/blocked | Fandom returned HTTP 403 in this environment. No detailed controls claim is treated as confirmed. |
| [DemonFall Fandom controls](https://demon-fall.fandom.com/wiki/Controls) | 2026-10-10 | Open/blocked | Fandom returned HTTP 403. Use guides/footage only as a hypothesis until hands-on verification. |
| [Project Slayers Fandom](https://project-slayers.fandom.com/wiki/Project_Slayers_Wiki) | 2026-10-10 | Open/blocked | Fandom returned HTTP 403; use the linked Trello/community guides with date labels. |
| Project Slayers 2 / Slayers 2 official/community pages | 2026-10-10 | Open | No stable, verifiable official specification was found for a product with that exact current name. Announcements/rumors are excluded from design requirements. |
| [Gaffer: Fix Your Timestep](https://gafferongames.com/post/fix_your_timestep/) | 2026-10-10 | Confirmed technical reference | Fixed timestep, accumulator, interpolation, spiral-of-death headroom, and deterministic simulation rationale. |
| [MDN: 3D collision detection](https://developer.mozilla.org/en-US/docs/Games/Techniques/3D_collision_detection) | 2026-10-10 | Confirmed technical reference | AABB/sphere tests and the recommendation to keep game-specific collision decisions explicit. |
| [MDN: WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) | 2026-10-10 | Confirmed technical reference | Browser support, connection lifecycle, buffered amount, and lack of built-in backpressure. |
| [MDN: Gamepad controls](https://developer.mozilla.org/en-US/docs/Games/Techniques/Control_mechanisms/Desktop_with_gamepad) | 2026-10-10 | Confirmed technical reference | Controller connection events, axes/buttons, dead zones, and device mapping caveats. |
| [MDN: WebGPU](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API) | 2026-10-10 | Confirmed technical reference | High-performance option, compute/render pipelines, and limited browser baseline; not selected as the only renderer. |
| [Three.js docs](https://threejs.org/docs/) | 2026-10-10 | Confirmed technical reference | WebGL-first renderer, skeletal animation, GLTF, particles/postprocessing, and optional WebGPU renderer. |

## Canon findings and gameplay implications

### Breathing, styles, and visual truth

The series presents Breathing Styles as trained swordsmanship and controlled respiration that produce exceptional physical performance. The anime visualizes water, flame, mist, thunder, and similar motifs, but the motifs are not automatically literal elemental damage. That distinction is a core rule for Lanternfall: the simulation owns reach, displacement, timing, and damage; the renderer may express a style through original ribbons, ink-like silhouettes, dust, sparks, and camera language.

Total Concentration implies a resource loop around breath control, posture, and recovery. Constant Total Concentration implies a sustained mastery state rather than an unlimited spell toggle. In play this becomes a focus meter that can be built by deliberate neutral, spent by forms, and strained by repeated cancels. Sun Breathing is the source tradition from which other branches derive in canon; Lanternfall uses branch-inspired taxonomy only in research and ships original style names.

Named forms read as a sequence of **stance → acceleration → body rotation/footwork → weapon path → recovery**. They should not be designed as colored projectiles first. A form earns its identity through commitment, angle, rhythm, and the situation it creates for the opponent.

Nichirin, sunlight, wisteria, regeneration, and decapitation imply asymmetric demon/slayer stakes. They are lore-sensitive and unsuitable as arbitrary PvP damage multipliers. The game will use a non-canon “dusk seal” rule for demons in competitive modes, while keeping sunlight/wisteria as readable PvE arena hazards. Public release must use original terminology, or obtain a license before using canon terminology in shipped marketing.

Blood Demon Arts are personal expressions of a demon's history, obsession, body, and choices. Reusable patterns include: a mark/setup that changes space; a delayed payoff; a strong tell; a resource or body cost; and a counter that rewards observation rather than a mirror spell. Rui's thread control, Enmu's dream intrusion, Akaza's compass/air pressure, Daki's obi, Gyutaro's poisoned blood sickles, Doma's ice, Hantengu's emotion manifestations, Gyokko's vessels, Nakime's room manipulation, Yahaba's vectors, Susamaru's thrown projectiles, Kyogai's drum rooms, and Nezuko's blood flames are useful **design patterns**, not assets or move data to copy.

### Canon style matrix

The table distinguishes canon identity from a game-role translation. “Symbolic” means the effect should remain a visual metaphor unless an original setting explicitly makes it physical.

| Style | Canon identity / users / branch | Physical language and typical range | Tendencies / mobility | Signature forms as visible action | Game role and counters | Keep symbolic |
|---|---|---|---|---|---|---|
| Water | Foundational branch; Tanjiro, Giyu, Urokodaki, Sabito, Makomo | Circular cuts, low center, adaptive mid range | Balanced defense, flowing reposition | Wheel-like turns, surface-like arcs, continuous links | Fundamentals/whiff punish; counter with delayed lows, guard pressure, anti-air | Water is motion/ribbon, not water damage |
| Flame | Branch of Sun; Rengoku, Shinjuro, Kyojuro | Tall posture, explosive linear entries, close-mid | High commitment, strong finish, limited retreat | Rising slash, forward charge, downward impact | Pressure/resolve; sidestep and bait recovery | Fire trail is heat/resolve language |
| Thunder | Branch of Sun; Zenitsu, Jigoro, Kaigaku | Compressed crouch then straight-line acceleration | Exceptional burst, narrow approach | Lightning-fast draw, repeated line attack | Rushdown; lateral awareness and armor timing | Lightning is speed silhouette |
| Wind | Branch of Sun; Sanemi | Wide torso rotation, irregular angles, mid-wide | Space denial, high pushback, risky whiffs | Tornado-like multi-cuts, sweeping footwork | Midrange control; close gaps during recovery | Wind crescents are cut paths |
| Mist | Branch of Wind; Muichiro | Vanishing rhythm, stop-start footwork, mid | Ambush and disengage, low information | Conceal/reveal, sudden angle change | Mix-up/stealth; patient tracking and area checks | Mist obscures presentation, not hit-confirmed smoke damage |
| Beast | Self-taught; Inosuke | Low crouch, dual-weapon sawing, close | Erratic mobility, strong scramble | Pounces, sensing, twin blades | Scramble/anti-zoning; whiff punish and guard discipline | Animal senses are feedback, not omniscience |
| Insect | Derived from Flower; Shinobu, Kanae lineage | Small steps, thrusts, precise point attacks | High mobility, low raw force, poison fiction | Needle thrusts and evasive darts | Hit-and-run/attrition; deny approach and cleanse | Butterfly motifs stay graphic language |
| Sound | Derived from Thunder; Tengen | Dual-blade rotations, planted explosive cadence | Midrange traps, strong tempo disruption | Bomb setup, rhythm-reading, paired blades | Trap/tempo; disarm setups and punish long preparation | Sound waves are telegraph rings, not unavoidable AoE |
| Love | Derived from Flame; Mitsuri | Elastic full-body arcs, long flexible reach | Wide coverage, vulnerable inside | Whip-like blade loops and aerial spirals | Range/anti-crowd; close through gaps, punish landing | Heart/pink effects remain expression |
| Serpent | Derived from Water; Obanai | Coiling path, deceptive blade angles | Tracking pressure, narrow lanes | Bending cuts around guard lines | Angle/mix-up; move perpendicular and hold spacing | Serpent shape is a path cue |
| Stone | Independent branch; Gyomei | Grounded stance, heavy weapon inertia, close-mid | Highest commitment, armor/control | Chain-and-axe crosses, crushing beats | Anchor/armor; bait swings, use throws/low-risk pokes | Stone dust is impact texture |
| Flower | Derived from Water; Kanae, Kanao | Elegant circular steps, precise timing | Counter-oriented, high awareness | Petal-like feints, focused perception | Counter/punish; delay attacks and vary rhythm | Petals are focus/readability cues |
| Moon | Lost branch of Sun; Kokushibo | Multi-angle sword projection, large rotational lanes | Dominant space control, high complexity | Layered crescent paths, persistent threat | Boss/control archetype; move through safe seams | Moon crescents are authored hit shapes |
| Sun | Original source branch; Yoriichi, later Tanjiro lineage | Continuous whole-body sequence, extreme precision | High mastery, stamina and injury cost | Linked forms with no dead beat | Capstone PvE identity; interrupt transitions and exhaust user | Fire/sun imagery is symbolic unless rule says otherwise |

### Comparison games

**DSRPG2.** Public guides and videos commonly describe a Roblox action-RPG control vocabulary: light/heavy attacks, guard/parry, dash, jump/air routes, skill slots, and progression into styles. Fandom pages were blocked during this pass, and the exact frame values, bugs, and current five-slot layout are not independently confirmed. We therefore borrow the high-level lesson—discoverable hotbar skills plus movement cancels—and explicitly do not claim exact DSRPG2 frame data. Potential frustrations to avoid are opaque stun/ragdoll rules, skill spam without resource telegraphs, and client-trusted hit results.

**DemonFall.** Community documentation is similarly fragmented. The durable design lesson is that grounded weapon commitment, stamina pressure, trainers, factions, and dangerous travel make a style feel earned in context. The failed lesson is grind used as a substitute for mastery: competitive Lanternfall will normalize combat stats and keep progression cosmetic/unlock-based.

**Project Slayers / “Project Slayers 2”.** The dated controls guide supports a broad loop of M1/M2 combat, block, dash, ability keys, wall climb, sprint, air/special input routes, and demon/slayer paths. The Trello guide confirms a large progression vocabulary but is not an official balance document. No stable source confirmed a current “Project Slayers 2 / Slayers 2” specification on 2026-10-10; announcements are treated as unknown. The useful lesson is identity through trainers, breath/BDA kits, equipment, and world activity. The risk is RNG/grind determining PvP power.

**Hinokami Chronicles.** The official manual is the strongest combat reference. It confirms four ground light hits, two air hits, directional finishers, armored chargeable heavy, unguardable throw, skill gauge spend, guard durability, parry, chase dash, sidestep, quick/rolling recovery, quick dodge costing 20% skill gauge, special bars for Boost/Surge/Ultimate, and support/emergency escape. It also explains combo timer colors, target/camera context, round win conditions, training ranks, rewards, and danger telegraphs. Lanternfall adopts the clarity and cadence—not character data, assets, or proprietary presentation.

## Confirmed, inferred, unknown

### Confirmed

1. A fixed simulation is appropriate for frame-accurate authored combat and future server validation.
2. A browser-compatible renderer must support WebGL fallback because WebGPU is not baseline across browsers.
3. The official manual makes defensive counterplay as important as spectacle: guard, parry, dodge, recovery, and punish are first-class actions.
4. Local practice and a dummy are necessary before networking.

### Inferred design decisions

1. A 60 Hz simulation with render interpolation is the best first target for readable attack timelines.
2. Three.js + TypeScript + Vite provides a low-friction WebGL renderer, GLTF/animation path, and a clean boundary around a renderer-independent simulation.
3. Server authority should validate input legality, timeline events, collision, resource use, and damage; clients may predict locomotion but never decide hits.
4. Two original kits—Riverform and Threadcraft—are enough for the first complete vertical slice if they have different geometry, rhythm, resource loops, and counterplay.

### Unknown / follow-up research

- Exact current DSRPG2 and DemonFall frame data, patch history, netcode, and bug catalogue.
- Whether “Project Slayers 2” is a released product or a community shorthand on the date of implementation.
- Final art direction, rig scale, audio licensing, and any commercial license for canon terminology.
- Browser-specific GPU budgets on the intended lowest supported hardware.

## Rejected ideas and changelog

- **Rejected:** restoring the Roblox/Rojo architecture. The repository's previous files were Roblox-specific; the requested target is a browser simulation.
- **Rejected:** literal elemental damage for breathing styles. Visual motifs must not decide combat semantics.
- **Rejected:** progression stats in ranked PvP. Earned identity should be moveset mastery, not grind advantage.
- **Accepted:** original names, original arena/characters, and generated placeholder geometry until commissioned art is available.
- **Accepted:** an explicit debug mode as a permanent production tool, not a throwaway prototype overlay.
