# GAME DESIGN BIBLE — Breathbound: Lanternfall

## Product definition

**Lanternfall** is an original browser action duel about disciplined sword forms and demons who weaponize personal obsessions. It borrows the emotional contrast, breath-led body mechanics, and theatrical energy of demon-hunting anime while shipping original names, fiction, art, VFX, and audio. The first release target is desktop keyboard/gamepad, with local two-player practice and an authoritative-network-ready simulation.

## Pillars

1. **Read the body, then cut.** Every powerful action has an intentional stance, telegraph, active path, and recovery.
2. **Motion is the magic.** Styles differ through acceleration, range, angle, rhythm, and resource decisions before color or particles.
3. **Spectacle serves truth.** Camera punch, trails, ink, and sound amplify a confirmed event; they never hide a hitbox.
4. **Mastery over grind.** PvP stats are normalized. Progression unlocks expression, training, lore, and cosmetics.
5. **Server-ready from frame one.** The simulation has no rendering or browser-physics dependency and consumes numbered input frames.

## Modes

- **Lantern Yard:** offline practice with hitbox overlays, frame stepping, dummy behavior, and move recording.
- **Duel:** best-of-three local or online 1v1; 90-second rounds; health and focus reset between rounds.
- **Hunt:** 1–4 player PvE arenas with dusk hazards, demon regeneration, and co-op stagger windows.
- **Trial path:** short authored challenges that teach guard, parry, recovery, and style identity.
- **Workshop:** replay/timeline viewer and input export for balance review.

## Camera and arena

The first arena, **Moonlit Relay**, is a 28×20 m rectangular courtyard with low lantern posts, four non-blocking visual markers, and a soft boundary. The camera is a perspective over-the-shoulder arena camera: it frames both fighters, eases toward the midpoint, raises slightly on launches, and applies only brief hit-stop/impulse on confirmed impact. Lock-on is a simulation-neutral target choice; camera smoothing must not alter movement vectors. No cover or occluding geometry is used in the first slice.

## Universal movement

The authored states are: Idle, Walk, Sprint, GuardMove, AttackStartup, AttackActive, AttackRecovery, DashStartup, DashTravel, DashRecovery, JumpAnticipation, JumpLaunch, AirRise, AirFall, AirAttack, SoftLanding, HardLanding, Hitstun, Launch, Knockdown, QuickRecovery, RollingRecovery, and Execute. A state declares speed, acceleration, turn rate, gravity, collision, interruption, invulnerability, animation clip/markers, camera response, and permitted inputs.

Movement is camera-relative on XZ, with authored acceleration/deceleration. Ground is a plane query with slope threshold; gravity, jump launch, air control, landing, wall sweep, dash displacement, attack displacement, knockback, and recovery are all owned by the simulation. The browser never resolves an important outcome for us.

Base targets: walk 4.2 m/s, sprint 6.5 m/s, jump launch 7.3 m/s, gravity −22 m/s², dash travel 8 frames at 12 m/s, sidestep 14 frames with 6 invulnerable frames. Values are balance data, not source material claims.

## Universal combat rules

- Four-hit grounded light chain; hit four branches by directional intent.
- Two-hit air chain; landing cancels the second recovery only into landing/recovery states.
- Heavy starts armored after its anticipation, chargeable to a guard-break threshold, and has honest whiff recovery.
- Guard drains durability; guard recovers only after a short neutral delay. A broken guard causes stun.
- Perfect guard is a 5-frame window at guard start, staggers the attacker, and grants focus.
- Throw beats guard, loses to jump/dodge/attack-active armor, and has short range.
- Chase dash closes distance to a target but can be sidestepped and cannot hit through a wall.
- Sidestep/dodge has authored invulnerability and directional commitment.
- Quick dodge cancel costs 20 focus and is available only during specified light/skill windows.
- Launch and knockdown use diminishing hitstun and a combo decay timer; repeated launch hits add gravity/tech-out sooner.
- Quick recovery is a timed air input; rolling recovery is a ground input with invulnerability and positional cost.
- Execute exists only in PvE when a demon is in a low-health opening state; it is disabled in ranked PvP.

## Resources and readability

Each fighter has 100 health, 100 guard, 100 focus, three technique charges, and a combo timer. Focus is built by breathing-neutral, parry, and clean contact; it is spent by forms and quick dodge. HUD displays health, guard color, focus, cooldowns, current chain, combo timer, and a small state label only in training. Color is never the only telegraph: motion, silhouette, audio transient, and controller vibration (when supported) agree.

## First kits

### Riverform (Water-inspired, original kit)

Identity: low center, circular footwork, adaptable midrange, safe exits that trade damage for position. Neutral rotates around feints and guarded approach. Pressure links light four into **Undertow Step**. Defense is **Still Basin**, a parry-like short guard with high focus gain. Mobility is **Current Slip**, a curved dash. Punish is **Falling Channel**, a delayed overhead that catches recovery. Guard interaction is chip plus pushback rather than immediate break. Risk: every form has visible lateral recovery; overusing escape dries focus. VFX uses translucent ribbon arcs, white spray-shaped linework, and no literal water damage. Sound is breath, wood, steel, and low chimes.

Forms: Ripple Draw, Crescent Current, Basin Turn, Undertow Step, Falling Channel, and ultimate **River That Returns**.

### Threadcraft BDA (original demon kit)

Origin: a former theatrical seamster demon who cannot tolerate broken patterns. Rule: attacks place visible **anchors** in space; a later pull, stitch, or sever action resolves only between linked anchors. Setup/payoff: weave two anchors, herd the opponent, then sever the line for a delayed cross-cut. Weakness: anchors are bright, limited to three, and disappear on demon hitstun; wisteria-like arena wards disable them briefly in Hunt mode. Slayers read anchor placement, cut the line by moving perpendicular, or force the demon to spend anchors defensively. Nichirin/sunlight interactions are represented by a PvE “seal” tag, never by hidden PvP multipliers. VFX uses red-black thread geometry, paper-cut silhouettes, and audible plucks.

Forms: First Stitch, Crossgrain Snare, Hemline Step, Pattern Break, Red Seam, and ultimate **Grand Tapestry**.

## BDA design rule

Each future BDA must have a personality, a single supernatural rule, a visible setup/payoff loop, a limitation, a Slayer counter, and a sound/VFX grammar. A BDA is not five generic spells with a new color. Regeneration is PvE-only until a health/round model proves it fair in PvP.

## Progression

Training trials unlock kit pages and cosmetic variations. A style is usable in PvP at normalized stats from the start; mastery adds replay challenges, emotes, pose variants, and lore. PvE can add temporary arena modifiers, not permanent ranked damage. Demon/slayer faction fiction affects quests and traversal, not competitive hit validation.

## UI, VFX, audio

The interface uses a dark indigo field, warm lantern gold, river cyan, and thread vermilion. Cards have a clear key, move name, cooldown/focus cost, and one-line counter hint. VFX has a silhouette layer, path layer, contact burst, and recovery fade with a strict budget. Audio layers breath/stance, weapon whoosh, material contact, hit confirmation, and resource feedback; no copyrighted franchise audio is used.

## Accessibility and controls

Keyboard defaults: WASD move, mouse aim/lock optional, J light, K heavy, L guard, Space jump, Shift dash, I throw, E/R/T/Y/X forms, U ultimate, Q quick dodge. Every action is remappable. Gamepad maps to left stick, face buttons, bumpers/triggers, and D-pad form shortcuts. Hold/toggle guard and reduced-flash options are supported. A future touch layer can expose a virtual stick and context actions without changing simulation inputs.

## Legal/content boundary

Canon names, organizations, weapons, characters, exact forms, logos, music, and visual designs are research references only. The shippable slice uses Lanternfall, Riverform, Threadcraft, Moonlit Relay, original fighters, original effects, and generated geometry. A licensed Demon Slayer product would require rights-holder approval and a separate content branch.
