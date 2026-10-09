# Breathing Blades — Game Design Bible and Production Plan

> **Status:** Pre-production design, followed by a controlled vertical slice.
>
> **Current project state:** The existing generated arena and combat scripts are a disposable prototype. They are useful for checking that Rojo and RemoteEvents work, but they are not the foundation of the final game.

## 0. The north star

Breathing Blades should feel like a high-skill Demon Slayer duel captured inside an accessible Roblox RPG:

1. **Every attack communicates intent.** The player sees the stance, hears the wind-up, understands the threat, and has a fair response.
2. **Movement is part of swordsmanship.** Footwork, spacing, acceleration, recovery, jumps, air control, and dashes should make a player feel like a trained swordsman rather than a Roblox avatar sliding on a floor.
3. **The spectacle follows the strike.** Water, flame, mist, wind, lightning, and blood are authored visual expressions attached to a real sword path, not random neon geometry that deals damage by itself.
4. **The source material informs identity.** A style is defined by its rhythm, body mechanics, range, risk, and forms—not only by its color.
5. **PvP stays readable.** Big effects may be dramatic, but hit timing, hurtboxes, guard states, and punish windows remain legible.
6. **The server is fair and the client is responsive.** The client predicts movement and presentation; the server validates state, timing, collision, damage, and progression.

## 1. Scope and originality decision

This is a Demon Slayer-inspired fan prototype. The source material can guide the design study, but the project must not copy source code, extracted animations, models, sound files, logos, UI, or effects from the anime, official games, or Roblox games.

For a private fan prototype, we can study canon forms and use lore-faithful move concepts. For a public or monetized release, we need either appropriate rights or an original setting with renamed styles, characters, terminology, and visual motifs. The implementation will keep **data-driven move behavior** separate from presentation assets so that a future original-IP conversion is possible.

## 2. Research conclusions

### 2.1 Canon rules that should shape gameplay

Public summaries of the manga/anime establish several important rules:

- Breathing Styles are swordsmanship systems derived from Sun Breathing and adapted to the user's strengths.
- Total Concentration Breathing increases physical performance and concentration. Constant concentration is a mastery state, not a free toggle every beginner can sustain.
- Most breathing visuals communicate the style and motion; they should not automatically be treated as literal elemental damage. A water dragon-shaped slash can represent a sword path while the hit still comes from the blade and body mechanics.
- Blood Demon Arts are supernatural abilities developed by demons, individualized by biology, personality, history, and power. They should not feel like a second generic spellbook shared by every demon.
- Demons have regeneration and special weaknesses. Nichirin blades, sunlight, and wisteria need to matter in the correct contexts instead of being cosmetic lore references.
- The style family tree matters. Water, Flame, Thunder, Wind, and Stone are major branches; Mist, Beast, Flower, Insect, Love, Serpent, Sound, Moon, and Sun each have a recognizable physical language.

### 2.2 Style identity map

| Style | Canon-inspired physical identity | Game role | Animation language |
| --- | --- | --- | --- |
| Water | Adaptable flow, redirection, clean transitions | Balanced control and defense | Low center of gravity, continuous arcs, turns that preserve momentum |
| Flame | Direct commitment, heat, explosive finishing power | Close-range pressure and punish damage | Strong planted stances, forward drives, large follow-through |
| Thunder | Leg power, explosive linear acceleration, Iaijutsu-like burst | High-risk engage and whiff punish | Compressed anticipation, near-instant dash, hard stop after contact |
| Wind | Aggressive air pressure, cyclones, multi-angle slashes | Space control and armor breaking | Torso rotation, wide shoulder arcs, violent recovery |
| Mist | Obscured tempo, deceptive speed, disappearing/reappearing | Neutral disruption and mix-ups | Sudden speed changes, partial silhouettes, delayed reveals |
| Beast | Instinctive angles, irregular dual-blade attacks, heightened senses | Scramble pressure and tracking | Low crouches, off-axis attacks, asymmetrical poses |
| Insect | Precision thrusts, poison, mobility over raw force | Hit-and-run status specialist | Small steps, tip-first attacks, minimal but exact motion |
| Sound | Rhythm, explosives, dual wielding, setup | Area denial and burst windows | Alternating weapon hands, planted beats, timed detonations |
| Love | Flexible range, unusual angles, elastic body language | Mid-range harassment and evasive pressure | Large ribbon-like blade paths, hip/shoulder flexibility |
| Serpent | Curved unpredictable paths and target wrapping | Guard-side pressure and tracking | Coiling torso, curved blade trajectories, delayed hit angles |
| Stone | Weight, reach, chained weapon control, stability | Slow control, armor, and punish | Deliberate wind-up, grounded feet, high impact landings |
| Moon | Crescent projections and layered sword patterns | High-threat ranged melee hybrid | Multiple orbiting arcs, layered timing, oppressive screen space |
| Sun | Continuous linked forms, heat, endurance, ultimate mastery | Endgame mastery style; difficult but complete | No dead space between forms, sustained rotation, exhausting finish |

### 2.3 Reference game lessons

#### DSRPG2

The publicly documented controls establish the useful Roblox action vocabulary: basic attack, heavy attack, dash, guard, breathing, five skill slots, and execute. Community documentation also discusses guard durability, perfect blocks, block-breaking skills, and style-specific combo routes.

**Takeaway:** use a compact action layout (`LMB`, `RMB`, `F`, `Q`, `G`, `E/R/T/Y/X`) and make defense a resource/decision rather than a permanent shield. Do not copy its exact moves or internal behavior.

#### Project Slayers 2

Use it as a reference for the long-term RPG layer: styles and demon arts are build-defining choices, abilities form the bulk of a player's combat identity, and progression needs to support experimentation without making a new player helpless.

**Takeaway:** separate a player's permanent progression from the duel's moment-to-moment skill test. A level advantage should not decide ranked PvP.

#### DemonFall

Use it as a reference for a more grounded Roblox action-RPG mood: travel, factions, trainers, training gates, risk, and a world where learning a style feels like an accomplishment rather than selecting a color from a menu.

**Takeaway:** unlocks should have context and training challenges, but the first playable combat test must start with a complete moveset so we can test combat before building an entire world.

#### Hinokami Chronicles

The official game describes itself as an arena fighter that transforms the anime's battles into 3D fights, with a cinematic visual style, a broad fighter roster, spectacular style skills, demon bosses, and online PvP. That is the most important presentation reference.

**Takeaway:** build the game around short, strongly framed encounters. Use arena spacing, camera composition, dramatic hit pauses, controlled camera shake, attack-specific close-ups, and finishers that are brief enough not to destroy PvP flow. We should reproduce the *principles* of cinematic combat with our own assets, not recreate footage or animation files.

The official online combat manual gives us a more concrete reference loop: a four-hit ground light chain (five while boosted), a shorter air chain, heavy attacks with armor and charge-based guard pressure, throws that cannot be guarded, a weakening guard meter, split-second parry, chase dash, quick recover, rolling recovery, dodge-cancel at a resource cost, and a separate skill gauge. Its resource stack also separates skill use, support/assist use, and a special gauge that powers Boost, Surge, and Ultimate Arts.

**Adaptation rule:** our first Roblox slice will not copy the character roster or exact values, but it will test the same interaction categories: light routing, heavy guard threat, parry timing, recovery decisions, chase/approach movement, limited resource cancels, and a separate climax meter.

## 3. Product structure

### 3.1 MVP: the vertical slice

The first real milestone is not “all styles.” It is one complete duel experience:

- One polished arena with readable cover and no random geometry.
- One human/slayer kit using Water-inspired mechanics.
- One demon kit with an original thread-based Blood Demon Art.
- Full custom movement and jump physics.
- LMB combo, RMB heavy, guard, perfect guard, dodge, dash, launcher, knockdown, get-up, and execute rules.
- Five Water forms and five BDA forms with animation, sound, VFX, hitbox, counterplay, and cooldown data.
- 1v1 unranked duel loop, rematch, round reset, and training dummy.
- Frame/timing debug overlay available to developers.
- A test checklist that can be repeated after every combat change.

No progression, gacha, giant open world, clans, or ten styles should be added before this slice is fun for two players.

### 3.2 Modes after the vertical slice

1. **Training Grounds:** dummy settings, hitbox display, frame display, move recording, and reset.
2. **Unranked Duel:** best-of-three 1v1 with rematch.
3. **Ranked Duel:** normalized stats, seasonal rating, replay metadata, disconnect handling.
4. **Team Duel:** 2v2 with assist/partner rules inspired by arena fighters, added only after 1v1 is stable.
5. **Story/World:** trainers, missions, demon hunts, faction progression, and bosses.
6. **Custom lobbies:** map choice, damage normalization, move bans, and tournament settings.

## 4. Custom movement and physics mandate

The final game will not use Roblox's default character locomotion or default falling behavior.

### 4.1 What is disabled

The custom controller must disable or bypass:

- Default `Humanoid.WalkSpeed` movement.
- Default jump impulse and `Humanoid.Jump` behavior.
- Default `Running`, `Jumping`, `Freefall`, `Landed`, `Climbing`, `Swimming`, and automatic character state transitions.
- Automatic character rotation.
- Default friction/acceleration assumptions for combat movement.
- Physics-driven knockback as the source of truth.

The Humanoid remains for health, rig compatibility, and animation playback, but movement is owned by our controller. Character locomotion is kinematic and state-driven, not an unexamined Roblox force.

### 4.2 Controller architecture

Every frame, the controller performs this sequence:

1. Read normalized input and camera-relative intent.
2. Resolve the current combat state: idle, locomotion, guard, startup, active, recovery, hitstun, knockdown, airborne, dash, or execute.
3. Select target horizontal velocity using style/state acceleration curves.
4. Apply custom gravity only when the state permits it.
5. Apply dash/attack displacement curves authored per move.
6. Perform custom capsule/cylinder sweeps against static geometry using `Blockcast`/`Shapecast` and floor raycasts.
7. Slide along surfaces using the collision normal; never teleport through walls.
8. Resolve ground snap, slope limits, coyote time, jump buffering, and landing state.
9. Update the collision root transform.
10. Drive the visual rig from the resolved root and animation state.
11. Send input sequence numbers to the server; reconcile corrections smoothly.

The server runs the same deterministic movement rules at a lower visual cost and validates the client's claimed state. The client may predict its own movement for responsiveness, but it never decides damage or progression.

### 4.3 Movement targets

These are starting targets, not final balance values:

| System | Target behavior |
| --- | --- |
| Acceleration | Quick enough for anime footwork, with visible commitment during attacks |
| Deceleration | Fast in neutral, move-specific during attacks |
| Sprint | A real locomotion state with stamina cost and a readable entry animation |
| Dash | Directional step with startup, travel, recovery, and a small authored invulnerability window |
| Jump | Custom initial velocity, variable height, air steering, and style-specific jump attacks |
| Gravity | Tuned separately for normal jump, attack launch, knockback, and cinematic finisher |
| Ground snap | Prevents visual hovering without forcing the player down slopes they cannot stand on |
| Slope limit | Rejects impossible surfaces and slides the player along steep geometry |
| Air control | Limited but expressive; no infinite mid-air steering |
| Collision | Capsule sweep for body, separate weapon sweeps for attacks |
| Knockback | Authored displacement/state timelines instead of raw `AssemblyLinearVelocity` |

### 4.4 Jump and fall animation rules

Jumping is a combat state, not a default Roblox animation:

- `JumpAnticipation`: crouch/weight shift for a short readable wind-up.
- `JumpLaunch`: hips and shoulders drive upward; feet leave the floor only after the launch frame.
- `Airborne`: custom pose and directional lean based on velocity.
- `AirAttack`: move-specific root and blade path; attack determines drift.
- `Fall`: compressed protective pose with authored gravity curve.
- `LandingSoft`: low impact on a clean landing.
- `LandingHard`: dust, camera impulse, recovery frames, and possible punish window after a heavy drop.
- `LandingCancel`: a small timing reward for landing an attack or dash at the correct moment.

There will be no default Roblox “falling” animation driving the body. Animation markers and the physics state must agree on the exact launch, contact, and landing frames.

## 5. Combat system specification

### 5.1 Universal actions

| Input | Action | Design purpose |
| --- | --- | --- |
| LMB | Light attack chain | Neutral confirmation and combo routing |
| RMB | Heavy attack | Guard pressure, whiff punish, launcher/knockdown variants |
| F | Guard | Protect, manage guard durability, fish for perfect guard |
| Q | Directional dash/step | Footwork, escape, approach, side-switch |
| Space | Custom jump | Vertical repositioning and air route access |
| G | Breathing/focus | Enter/maintain style state, refill or manage breath resource |
| E/R/T/Y/X | Five forms | Style-specific game plan |
| B | Execute/interact | Only available in approved downed states |

### 5.2 Light attack chain

The standard chain has four authored attacks, but each hit has a purpose:

1. **Check:** fast horizontal cut, low commitment, confirms at close range.
2. **Link:** diagonal cut that preserves position and can turn slightly toward the target.
3. **Route:** style-neutral launcher, side-sweep, or body-turn chosen from grounded/air input.
4. **Ender:** either a knockback finisher, downslam, or safe reset based on directional input.

The fourth hit should not be the only interesting part. Players should be able to stop at hit two, dash cancel with a cost, route into a form, or intentionally whiff a reset. M1 spam must be less effective than understanding the route.

### 5.3 Heavy and block breaker

Heavy is a deliberate action with clear armor/guard behavior:

- Startup is visible and punishable.
- It has a narrower but stronger hit path than normal attacks.
- It damages guard heavily and can break guard when the move metadata says so.
- A perfect guard can still defeat the heavy unless a specific move is explicitly marked unblockable.
- A blocked heavy should create a meaningful spacing/reset interaction instead of stopping the attacker in place.

### 5.4 Guard and perfect guard

Guard is not a permanent binary shield:

- Guard has durability and regeneration delay.
- Guard reduces damage and prevents most hitstun but does not erase pushback, resource drain, or positional disadvantage.
- A perfect guard window occurs at guard entry and is intentionally brief.
- Perfect guard grants a stable advantage: attacker stagger, breath refund, or guaranteed punish depending on the move.
- Projectiles and area attacks have defined guard rules; they never use accidental generic behavior.

### 5.5 Dodge and dash

Dodges use authored displacement and a small invulnerability window. The window is shorter than the full movement so a player cannot mash through every attack. Direction matters:

- Forward dash threatens space but can be checked.
- Side dash changes attack angle and is useful against linear forms.
- Backstep creates distance but gives up initiative.
- Air dash is not available by default; a style may earn one as a signature mechanic.

### 5.6 State machine

All actions pass through the same state machine:

```text
Neutral
  ├─ Guard
  ├─ Sprint
  ├─ Jump / Airborne
  ├─ Dash
  ├─ AttackStartup → Active → Recovery
  ├─ FormStartup → Active → Recovery
  └─ Hitstun / Knockdown / Execute
```

Each state defines:

- Movement permissions.
- Rotation permissions.
- Cancel windows.
- Invulnerability/armor windows.
- Collision profile.
- Whether guard, dash, jump, or forms can interrupt it.
- Whether it can be interrupted by hitstun.
- Camera and animation layer.

No move may bypass the state machine by setting a random velocity or directly damaging a target.

### 5.7 Move data contract

Every form is a data record, not a one-off script:

```text
MoveId
StyleOrArt
Input
DisplayName
StartupFrames
ActiveFrames
RecoveryFrames
CancelWindows
MovementTimeline
HitboxTimeline
GuardType
BlockBreak
ArmorFrames
IFrameFrames
Damage
GuardDamage
PoiseDamage
LaunchOrKnockback
ResourceCost
Cooldown
ComboTags
CounterTags
AnimationId
SoundSet
VfxSet
CameraProfile
```

This lets the balance team change numbers and frame windows without rewriting hit detection.

## 6. First style kits

The first implementation should use canon-inspired behavior while keeping presentation assets original.

### 6.1 Water vertical slice

| Slot | Behavior | Counterplay |
| --- | --- | --- |
| E | Fast, accurate forward slash with strong confirmation | Side dodge or guard at the read |
| R | Circular aerial/ground wheel that changes vertical angle | Hold distance or punish recovery |
| T | Whirlpool-like guard pressure that redirects projectiles and pulls lightly | Leave the radius or perfect guard the core hit |
| Y | Low-footing movement form that preserves momentum through a dash route | Track the endpoint and punish the exit |
| X | Long linked finisher with rising damage but escalating recovery | Interrupt before the final link or dodge the ender |

Water should be the onboarding style: forgiving transitions, excellent repositioning, moderate damage, and strong defensive expression without becoming a turtle style.

### 6.2 Flame slice after Water

| Slot | Behavior |
| --- | --- |
| E | High-commitment forward charge |
| R | Rising anti-air arc |
| T | Circular guard-pressure sweep |
| Y | Multi-hit tiger-like rush with a clear linear path |
| X | Devastating straight-line finisher with a large punish window on miss |

Flame must feel powerful because it commits, not because it has the safest numbers.

### 6.3 Thunder slice after Flame

| Slot | Behavior |
| --- | --- |
| E | Near-instant linear burst with strong startup audio |
| R | Multi-step dash route with direction selection |
| T | High-speed guard pressure that leaves the user exposed if read |
| Y | Leg-focused self-buff that increases burst but adds recovery/strain |
| X | Single decisive finisher; strongest whiff-punish identity |

Thunder must be the most demanding style to animate and network because the fantasy depends on acceleration and stop timing.

## 7. Blood Demon Art system

### 7.1 BDA design rules

Each BDA gets a personality, a resource loop, a weakness, and five forms. It should not be “Breathing Style with red particles.”

Every BDA must answer:

1. What obsession or physical trait produced it?
2. What is its preferred distance?
3. What does it do when the opponent refuses to interact?
4. What are its setup and payoff actions?
5. What can a skilled slayer read and punish?
6. How does sunlight, Nichirin, wisteria, regeneration, or demon physiology affect it?

### 7.2 First BDA: Threadcraft

An original thread-manipulation art used for the vertical slice:

- `E — Needle Line:` a thin, readable line attack; high reward for precise aim.
- `R — Crossweave:` two crossing lines create a temporary denial zone.
- `T — Severing Knot:` guard pressure/block breaker if the target is already marked.
- `Y — Puppet Pull:` short displacement/control attempt with a visible tether and break distance.
- `X — Loom of Ruin:` ultimate arena pattern with safe lanes that reward movement knowledge.

Counterplay is cutting the source thread, leaving the marked zone, using a perfect guard, or forcing the demon into sunlight/wisteria conditions in relevant modes.

### 7.3 Future BDA families

- Martial shockwave art: close-range pressure, rhythm detection, no passive zoning.
- Frost art: area denial, slow fields, brittle constructs that can be destroyed.
- Eye/illusion art: information warfare, false telegraphs that still obey fair tells.
- Blood sickle art: mid-range curved attacks and self-damage tradeoffs.
- Drum/space art: arena displacement and directional control with strong telegraphing.

Canon characters can be studied as references, but our first production assets use original demon identities so the mechanics stand on their own.

## 8. Animation direction

### 8.1 Authoring pipeline

1. Capture the move's gameplay beat sheet first: anticipation, commitment, contact, follow-through, recovery.
2. Block the pose in Roblox Animation Editor or Blender with a consistent R15/custom rig.
3. Animate the root and hips before the sword arms; the body must generate the strike.
4. Add blade arcs and hand offsets only after the body path feels credible.
5. Add animation markers for `Startup`, `ActiveStart`, `ActiveEnd`, `RecoveryStart`, `Footstep`, `Vfx`, and `Sound`.
6. Import the animation, test it with the custom physics controller, then tune hitboxes against markers.
7. Record a clean silhouette test with all VFX disabled.
8. Add VFX, camera motion, impact pause, and sound as separate layers.

### 8.2 Anime-inspired visual grammar

- Use strong anticipation for powerful forms.
- Use sudden speed changes for Thunder and Mist rather than making every move permanently fast.
- Keep the character readable against effects with value separation and controlled bloom.
- Use 2D-looking slash ribbons, stylized particles, authored trails, and impact frames instead of generic spheres.
- Build effects from the attack path so the visual shape teaches the player where the hit is.
- Use one memorable hero shot per ultimate, not a long camera lock every time.
- Use color as a secondary signal; timing, silhouette, and audio must communicate the same move.

### 8.3 Animation standards

Every attack review must pass:

- Contact pose reads at 25% playback speed.
- Feet and hips are believable before VFX are enabled.
- The weapon path matches the server hitbox.
- The recovery is visually present and punishable.
- The move is recognizable in silhouette against another effect-heavy player.
- No animation relies on an extracted anime frame, ripped game animation, or copyrighted audio.

## 9. Camera and presentation

- Use a soft target lock for combat readability, with manual override.
- Keep both combatants visible whenever possible.
- Frame the active hitbox instead of forcing a cinematic angle that hides the defender.
- Add a short hit-stop on confirmed heavy impact, perfect guard, guard break, launcher, and ultimate climax.
- Camera shake is directional, capped, and disabled/reduced in accessibility settings.
- Attack telegraphs use anticipation pose, sound cue, and controlled VFX; never rely on screen flash alone.

## 10. Resources and balance

### 10.1 Starting normalized duel values

Use a normalized ruleset for ranked PvP:

- Health: `100`
- Guard: `100`
- Stamina: `100`
- Breath: `100`
- Ultimate gauge: `0–100`
- Target duel length: `90–180 seconds`
- Target round count: best of three

Progression may change cosmetics, unlock options, PvE bonuses, and training access. Ranked damage, health, guard, and cooldowns must be normalized.

### 10.2 Balance budgets

Every move spends a budget across:

- Damage.
- Guard damage.
- Range.
- Speed.
- Tracking.
- Movement displacement.
- Armor/i-frames.
- Crowd control.
- Safety on block.
- Safety on whiff.

If a move is excellent in three or more categories, it needs a clear cost, setup requirement, or punishable recovery. A block breaker must not also be the fastest, safest, longest-range, highest-damage option.

### 10.3 Balance test matrix

Every form is tested against:

- Neutral approach.
- Guard.
- Perfect guard.
- Forward, side, and back dodge.
- Jump and air attack.
- Heavy armor.
- Projectile/area attack.
- Wall and corner.
- Low ping and 150–200 ms simulated latency.
- One player intentionally spamming the request remote.

## 11. Technical architecture

### 11.1 Proposed tree

```text
ReplicatedStorage
  Shared
    CombatTypes.lua
    MoveDefinitions.lua
    StyleDefinitions.lua
    PhysicsConstants.lua
    StateDefinitions.lua
  Remotes
ServerScriptService
  Server
    MatchService.lua
    CombatService.lua
    MovementValidator.lua
    HitboxService.lua
    StatusService.lua
    ProgressionService.lua
StarterPlayer
  StarterPlayerScripts
    Client
      InputController.client.lua
      MovementController.client.lua
      CombatPresenter.client.lua
      CameraController.client.lua
      AnimationController.client.lua
      VfxController.client.lua
Workspace
  Arena
  SpawnPoints
```

### 11.2 Server authority

The client sends intent, never outcomes:

```text
Client: action + input sequence + aim direction
Server: validates state, cooldown, resource, geometry, and timing
Server: runs/approves hitbox and applies result
Server: broadcasts compact presentation event
Client: predicts movement and plays presentation
```

Remote requests must validate types, finite numbers, move ownership, timing, player state, range, line of sight, and rate. The Roblox security guidance specifically warns against trusting client hit targets, arbitrary positions, or client-only cooldowns.

### 11.3 Hit detection

- Use authored box/capsule/arc sweeps for melee, not `Touched` as the combat authority.
- Use server `Blockcast`/`Shapecast`/raycasts with explicit filters.
- Cache overlap results per attack window so one target is not hit once per body part.
- Tag targets with attack IDs for replay/debugging.
- Use static-geometry line-of-sight validation where needed.
- Keep visual VFX client-side and damage server-side.

### 11.4 Performance budgets

- No per-frame creation of unbounded Parts for effects.
- Pool common particles, trails, attachments, hit markers, and sound emitters.
- Cap simultaneous high-cost VFX per client.
- Make distant effects cheaper and shorter.
- Keep server hitbox queries limited to active windows and relevant spatial regions.
- Test with multiple clients, not only solo Studio play.

## 12. Production phases and gates

### Phase 0 — Pre-production

- Lock the original/fan-project scope.
- Finish this design bible and move glossary.
- Build a style/BDA spreadsheet with one row per move.
- Create reference boards for body mechanics and effects.
- Decide R15 versus a custom combat rig.

**Gate:** no coding of additional styles until the movement and combat contracts are approved.

### Phase 1 — Custom movement sandbox

- Replace default locomotion with custom kinematic controller.
- Implement ground sweep, slope handling, custom gravity, jump, fall, land, sprint, dash, and air steering.
- Add debug collision capsule, velocity vectors, state label, and network correction display.
- Create a test room with slopes, stairs, walls, ledges, and moving platforms.

**Gate:** movement feels good with no combat and survives 100 test resets without tunneling or getting stuck.

### Phase 2 — Universal combat sandbox

- Build state machine, LMB chain, heavy, guard, perfect guard, dodge, hitstun, knockdown, get-up, and execute.
- Add deterministic move timelines and server hitbox service.
- Add two dummy types and local two-client tests.

**Gate:** the duel is fun with graybox animations and no style VFX.

### Phase 3 — Water + Threadcraft vertical slice

- Animate five Water forms and five Threadcraft forms from scratch.
- Build full sound/VFX pass.
- Add camera, hit-stop, UI, training dummy, replay debug, and rematch.

**Gate:** internal testers can identify every form, explain its counter, and complete a best-of-three duel without an obvious infinite loop.

### Phase 4 — Arena and PvP quality

- Build one finished arena with boundaries, lighting, destructible presentation props, and fair sightlines.
- Add matchmaking shell, round flow, rematch, disconnect handling, and normalized ranked rules.
- Test latency, streaming, camera, mobile fallback, and controller input.

**Gate:** stable 1v1 match from queue to results.

### Phase 5 — Style roster expansion

Implement Flame, Thunder, Wind, Mist, and one additional style one at a time. Each style requires an identity brief, move spreadsheet, animation pass, counterplay review, and performance test.

### Phase 6 — BDA roster and faction layer

Add additional original BDAs, demon regeneration/weakness rules, slayer tools, wisteria/sunlight interactions, and faction-specific missions.

### Phase 7 — Progression and world

Only after PvP is reliable: trainers, quests, ranks, cosmetics, PvE bosses, inventory, data saving, party flow, and social spaces.

## 13. Test plan

### Automated and deterministic tests

- Move metadata schema validation.
- State transition legality.
- Cooldown/resource validation.
- Hitbox deduplication.
- Collision sweep edge cases.
- Custom gravity and landing transitions.
- Reconciliation with delayed input sequences.
- Guard/perfect guard/block-break matrix.
- Damage/guard/poise budget checks.

### Studio tests

- 1, 2, 4, and 8 clients.
- 0, 50, 100, and 200 ms simulated latency.
- Spawn, death, reset, reconnect, and round transition.
- Player leaves during a finisher, guard break, or knockdown.
- Streaming enabled and disabled.
- Low-end graphics settings.
- Controller and touch layout.

### Human playtest questions

After every combat change, ask:

1. Did the defender know what was coming?
2. Did the attacker get a satisfying commitment/reward?
3. Was there at least one skillful response besides “also use the same move”?
4. Did the camera hide the important contact?
5. Did the VFX improve clarity or only add noise?
6. Did the move create a new infinite combo or safe loop?
7. Did latency change the intended outcome?

## 14. Immediate implementation order

The next coding work should be:

1. Add the shared state/move data contracts.
2. Disable default Humanoid locomotion and build the custom movement controller.
3. Build the movement sandbox and debug overlay.
4. Replace current velocity knockback and dash with authored displacement timelines.
5. Implement the universal combat state machine without style VFX.
6. Create the first custom sword idle, run, guard, jump, fall, land, light chain, heavy, and hit reactions.
7. Implement Water Form 1 and Threadcraft Form 1 end-to-end.
8. Playtest those two moves repeatedly before adding more forms.

The existing prototype should remain available as a reference harness, but new code should go into the new architecture instead of growing the single prototype scripts.

## 15. Research sources

### Source material

- [Demon Slayer official English character site](https://demonslayer-anime.com/hta/character/) — official character, faction, and style context.
- [Breathing Styles reference](https://demon-slayer-wiki.vercel.app/wiki/Breathing_Styles) — branch structure, Total Concentration, Constant Concentration, and style list.
- [Water Breathing forms](https://demon-slayer-wiki.vercel.app/wiki/Water_Breathing) — flow, redirection, mobility, defense, and form behavior.
- [Thunder Breathing forms](https://demon-slayer-wiki.vercel.app/wiki/Thunder_Breathing) — leg-driven burst, linear dash identity, and form progression.
- [Flame Breathing forms](https://demon-slayer-wiki.vercel.app/wiki/Flame_Breathing) — commitment, forward pressure, arcs, and finishing attacks.
- [Wind Breathing forms](https://demon-slayer-wiki.vercel.app/wiki/Wind_Breathing) — cyclones, multi-angle pressure, offense/defense overlap.
- [Mist Breathing forms](https://demon-slayer-wiki.vercel.app/wiki/Mist_Breathing) — obscured senses and tempo changes.
- [Blood Demon Arts overview](https://kimetsu-no-yaiba.fandom.com/wiki/Blood_Demon_Art) — supernatural, individualized demon ability premise.

### Game references

- [DSRPG2 controls](https://dsrpg2.fandom.com/wiki/Game_Controls)
- [DSRPG2 in-game mechanics](https://demon-slayer-rpg-2-new.fandom.com/wiki/In-game_Mechanics)
- [DSRPG2 breathing-style combo notes](https://demon-slayer-rpg-2-new.fandom.com/wiki/Breathing_style_combos)
- [DemonFall community wiki](https://demon-fall.fandom.com/wiki/Demon_Fall_Wiki)
- [DemonFall Trello/wiki directory](https://trellofinder.com/games/demonfall)
- [Project Slayers Evil Arts reference](https://project-slayers.fandom.com/wiki/Evil_Arts)
- [Hinokami Chronicles official site](https://demonslayer-hinokami.sega.com/)
- [Hinokami Chronicles official combat manual](https://demonslayer-hinokami.sega.com/manual/us/battle.html)
- [Hinokami Chronicles official combat tips](https://demonslayer-hinokami.sega.com/manual/us/advice.html)
- [Hinokami Chronicles Steam listing](https://store.steampowered.com/app/1490890/Demon_Slayer_Kimetsu_no_Yaiba_The_Hinokami_Chronicles/)

### Roblox technical references

- [Roblox input and cross-platform actions](https://create.roblox.com/docs/input)
- [Roblox client-server security](https://create.roblox.com/docs/scripting/security/client-server-boundary)
- [Roblox raycasting and spatial queries](https://create.roblox.com/docs/workspace/raycasting)
- [Rojo project format](https://rojo.space/docs/project-format/)
