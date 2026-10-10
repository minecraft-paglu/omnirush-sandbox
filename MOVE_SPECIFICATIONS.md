# Move specifications

All frames are 60 Hz. `S` is startup, `A` active, and `R` recovery. Hitboxes are authored in actor-local coordinates and sampled from the same timeline as animation/VFX markers. Damage values are normalized for 100 HP.

## Universal actions

| Move | Input | S/A/R | Cost | Hit/guard/armor | Counterplay and authority |
|---|---|---:|---:|---|---|
| Light 1–4 | J; repeat within buffer | 5 / 3 / 11 | 0 | 8–14 dmg; 4th directional branch; guardable; no armor | Guard/parry/step; server owns chain and dedup. |
| Air light 1–2 | J airborne | 4 / 3 / 12 | 0 | 7–10 dmg; launches slightly; guardable | Air sidestep/quick recover; server owns airborne state. |
| Heavy | K; release/charge | 12 / 3–5 / 20 | 0 | 18–28 dmg; charged guard break; armor from S+5 | Jump, throw during startup, parry before armor; server checks charge ticks. |
| Guard | hold L | 0 / held / 4 exit | 0 | Front cone reduces 80%; guard −12 per hit; no back protection | Throw, flank, guard pressure; server owns facing/cone. |
| Perfect guard | press L | 0 / 5 / 8 | 0 | Negates and staggers non-ultimate; +18 focus | Delay/throw/multi-hit; server owns exact tick. |
| Throw | I near target | 7 / 4 / 18 | 0 | 16 dmg, ignores guard, no armor | Jump/step/attack; target distance server-checked. |
| Dash | Shift + direction | 3 / 8 / 5 | 0 | No hit; invulnerable ticks 2–6 | Chase with read, wall limits; server resolves sweep. |
| Sidestep | directional Shift/face button | 2 / 7 / 5 | 0 | Invulnerable ticks 2–5 | Track landing/recovery; server owns i-frames. |
| Chase dash | Shift toward airborne/locked target | 3 / 10 / 6 | 0 | 6 stagger damage; cancelable into light/jump/guard | Sidestep or guard; server resolves target snapshot. |
| Quick dodge | dodge during marked light/skill window | 1 / 6 / 6 | 20 focus | Invulnerable active | Bait resource; server checks cancel window/cost. |
| Jump | Space | 3 / launch / air | 0 | Movement only | Anti-air and throw; server owns ground check. |
| Quick recovery | Space while launched | 2 / 6 / 5 | 15 focus | Invulnerable 2–4 | Bait resource and meet landing; server owns timing. |
| Rolling recovery | direction + Shift while down | 2 / 8 / 8 | 10 focus | Invulnerable 1–7 | Cover roll end; server owns down window. |
| Guard break | heavy charge or tagged form | move-specific | move | Guard durability to zero → 28f break stun | Perfect guard, evade, interrupt before armor; server authoritative. |
| Execute opening | PvE interact during opening | 12 / authored / 24 | 1 charge | PvE only, demon seal/decapitation fiction | Disabled in ranked; server validates opening token. |

## Riverform forms

| Form | Input | S/A/R | Cost | Design and counter |
|---|---|---:|---:|---|
| Ripple Draw | E | 9 / 5 / 16 | 18 focus | Short crescent, 12 dmg, turns 35°; guardable; sidestep the turn. |
| Crescent Current | R + direction | 8 / 8 / 20 | 24 focus | Curved 4 m advance, 18 dmg, low push; backstep/armor the end. |
| Basin Turn | T | 6 / 4 / 14 | 20 focus | 8f defensive parry bubble, 10 dmg on success; delayed throw beats it. |
| Undertow Step | Y | 5 / 3 / 18 | 22 focus | Side entry into light-chain state, 6 dmg; whiffs are punishable. |
| Falling Channel | X | 14 / 4 / 26 | 32 focus | Overhead launcher/guard pressure, 22 dmg; jump or perfect guard. |
| River That Returns | U, 3 charges | 24 / authored / 48 | 3 charges | Cinematic linked route, 38 dmg max, ends at original position; escape after first tell. |

## Threadcraft forms

| Form | Input | S/A/R | Cost | Design and counter |
|---|---|---:|---:|---|
| First Stitch | E | 8 / 3 / 14 | 15 focus | Places one anchor and pokes for 8; anchor is visible and destroyable. |
| Crossgrain Snare | R + direction | 12 / 6 / 22 | 24 focus | Links two anchors; pulls target 2 m if line intersects; move perpendicular. |
| Hemline Step | T | 5 / 8 / 12 | 18 focus | Teleports only along existing anchor line, no damage; punish empty setup. |
| Pattern Break | Y | 10 / 5 / 25 | 28 focus | Severs all lines for 20 cross-cut damage; guardable if read; remove anchors first. |
| Red Seam | X | 16 / 5 / 28 | 34 focus | Three-beat delayed cross, guard pressure not a true projectile; leave line. |
| Grand Tapestry | U, 3 charges | 26 / authored / 52 | 3 charges | Six-anchor arena weave, 42 max damage and forced displacement; ward/interrupt setup. |

## Timeline/event contract

Every move emits `startup`, `activeStart`, `activeEnd`, `recoveryStart`, `displacement`, `footstep`, `weaponContact`, `vfx`, `sound`, and `cameraImpact` markers. The combat resolver consumes hit shapes only between active markers. Animation clips may add visual detail, but a marker mismatch fails review.
