# Balance plan

## Normalized baseline

| Stat | Baseline |
|---|---:|
| Health | 100 |
| Guard durability | 100 |
| Focus | 100 |
| Light chain total | 32–42 damage |
| Heavy | 18–28 damage, guard threat |
| Form cost | 15–34 focus |
| Ultimate | 3 charges, 35–45 max damage |
| Combo timer | 42 ticks, refreshed by valid contact with diminishing return |
| Hitstun floor | 8 ticks; launch gravity increases after 3 juggle contacts |
| Round | 90 s, best of 3 |

## Frame targets

Neutral light should be reactable as a sequence, not startup alone: 5f startup, 3f active, 11f recovery. Perfect guard is 5f; heavy armor begins at 17f but has 12f vulnerable anticipation. A full touch should be 25–40% health only with resource, correct route, and no defensive escape. No move may loop into itself without an explicit reset and resource/payment.

## Matchup matrix (first slice)

| Riverform vs Threadcraft | River advantage | Thread advantage | Test question |
|---|---|---|---|
| Neutral | Curved entry can approach anchors safely | Anchors control retreat lines | Can River enter without erasing Threadcraft's identity? |
| Pressure | Safe Basin Turn and light route | Anchor displacement interrupts linear strings | Does defense create a turn rather than a stalemate? |
| Defense | Current Slip exits cross-lines | Pattern Break punishes predictable dodge | Does the defender read setup, not guess color? |
| Resource | Focus-efficient fundamentals | Expensive setup/payoff | Does Threadcraft feel powerful when prepared but weak when rushed? |
| Ultimate | Returns to safe origin | Grand Tapestry owns space briefly | Are both ultimates interruptible/readable before payoff? |

## Playtest process

1. Frame-data pass in dummy mode: confirm markers, hitboxes, guard, and displacement.
2. Blind readability pass: show silhouettes/VFX to new players and measure telegraph recognition.
3. Matchup pass: 20 games per pairing, record first-hit source, guard breaks, average combo damage, resource spend, and round length.
4. Latency pass: 50/100/150 ms RTT, 1% packet loss, reconnect, simultaneous attacks.
5. Performance pass: low-end laptop, 1080p/60, disabled postprocess, ultimate spam soak.

Balance changes must cite a measured failure and update move data plus this document. Never compensate for a readability problem by silently increasing damage.
