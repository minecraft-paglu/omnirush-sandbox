# Animation and VFX pipeline

## Authoring principles

The game uses original silhouettes and a shared humanoid rig scale. Reference study is limited to broad human biomechanics: stance, weight transfer, hip/shoulder separation, weapon path, breathing, and recovery. No extracted or traced franchise animation is allowed.

## Rig conventions

- GLTF 2.0, meters, +Y up, right-handed world.
- Root at floor contact; `root`, `pelvis`, spine chain, head, clavicles, arms, hands, weapon sockets, and foot bones are required.
- Weapon is a separate authored prop attached to `weaponSocket`; hit shapes do not read mesh bounds.
- Clip names: `lf_<kit>_<action>_<variant>_v01`.
- Locomotion is in-place; displacement is simulation data/markers to avoid animation-driven network divergence.

## Clip inventory

Idle breathing, walk, sprint, start/stop, guard, perfect guard, guard break, hitstun, launch, knockdown, get-up, quick recover, rolling recovery, jump anticipation/launch/rise/fall/soft landing/hard landing, directional dash/sidestep, four ground lights, two air lights, heavy charge/release, throw/counter, five forms and one ultimate per first kit, additive breath/fatigue/injury, and demon transformation.

## Marker schema

Markers are exported as clip metadata and mirrored in move data by stable id:

```json
{
  "moveId": "river.falling-channel",
  "markers": [
    {"id":"startup","tick":0},
    {"id":"activeStart","tick":14},
    {"id":"activeEnd","tick":18},
    {"id":"recoveryStart","tick":19},
    {"id":"displacement","tick":12,"payload":{"distance":1.4}},
    {"id":"weaponContact","tick":15},
    {"id":"vfx","tick":14,"payload":{"effect":"river.arc"}},
    {"id":"sound","tick":15,"payload":{"cue":"steel.water.hit"}},
    {"id":"cameraImpact","tick":15,"payload":{"impulse":0.12}}
  ]
}
```

The simulation reads marker ticks for displacement, hitboxes, resources, and events. The animation preview reads the exact same data. A review tool highlights the active shape, hurtbox, actor capsule, and marker cursor frame by frame.

## VFX grammar and budget

Each action may use one silhouette/path layer, one contact burst, and one afterimage. Pool transient objects. Budget for the first slice: 150 particles, 12 line/ribbon segments per attack, 2 dynamic lights total, no persistent postprocess during ordinary hits, and one ultimate bloom burst. Reduced-flash mode removes screen shake, bloom, and high-frequency strobing while retaining direction cues.

Riverform uses cyan-white ribbons, curved splashes, and paper/ink edging. Threadcraft uses vermilion-black lines, anchor knots, and plucked-string pulses. Neither uses literal water/fire/blood textures from the reference franchise.

## Audio

Original recordings/synthesis only. Required events: breath in/out, footstep material, blade whoosh, guard, perfect guard, guard break, armor, contact, whiff, focus gain/spend, cooldown ready, anchor placed/severed, and ultimate. Mix with a short priority queue so hit confirmation is never masked by ambience.

## Review checklist

- [ ] Style identity reads with VFX hidden.
- [ ] Attack path and recovery are readable in silhouette.
- [ ] All marker ids exist once and match move data.
- [ ] Hitbox active ticks are not tuned separately by eye.
- [ ] Guard/parry/armor/interrupt outcomes are visible before impact.
- [ ] VFX stays within particle/light/postprocess budget.
- [ ] Low-end browser and reduced-flash pass complete.
- [ ] No unlicensed asset, sound, logo, name, or extracted animation.
