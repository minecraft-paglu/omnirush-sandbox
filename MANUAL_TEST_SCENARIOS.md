# Manual test scenarios

Run `npm run dev` and open the printed URL. Use `F1` for the debug overlay and `F2` to reset.

- **One player vs dummy:** move P1 into range; verify four light hits, air chain, heavy, throw, five forms, ultimate, focus cost, and recovery.
- **Two local players:** P1 uses WASD/J/K/L; P2 uses arrows/numpad. Confirm both can move, guard, parry, dash, and attack without browser physics.
- **Perfect guard vs heavy:** hold/re-press guard as heavy becomes active. Verify parry feed, attacker hitstun, no damage.
- **Guard break at combo edge:** block the fourth light or heavy. Verify guard bar drains, guard break event, and stun window.
- **Air attack into landing:** jump, press attack twice, land near opponent. Verify no infinite ground hit and landing state appears in debug.
- **Wall collision during dash:** dash into each arena edge. Verify position clamps and velocity becomes zero.
- **Knockdown recovery:** take a launcher, use quick recovery while airborne, then rolling recovery while down. Verify invulnerability frames in debug.
- **Simultaneous attacks:** have both players press light on the same tick. Record whether ordering feels fair; this is a Phase 4 server-policy test.
- **Ultimate VFX:** press U after three special bars. Confirm one pooled ring per event and no persistent effect growth.
- **Low-end browser:** use a throttled CPU/GPU profile; verify simulation remains bounded and reduced effects remain readable.
- **Input extensibility:** connect a gamepad in the future input adapter; verify it emits the same `InputFrame` action enum as keyboard input.
