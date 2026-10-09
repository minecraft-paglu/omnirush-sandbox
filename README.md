# Breathing Blades

An original Roblox PvP arena prototype inspired by high-energy sword anime combat. The project is intentionally asset-free: the arena, combat feedback, energy trails, impact bursts, lightning, rings, and HUD are generated at runtime with Roblox Parts, Beams-style geometry, particles, lights, and tweens.

## What is included

- Server-authoritative melee combat with a 4-hit combo, recovery windows, heavy block-breaker, knockback, and stun feedback.
- Guarding with reduced incoming damage and a short perfect-block window that can parry even a breaker.
- A `G` breathing meter that powers abilities and regenerates while focused.
- Four selectable original combat paths:
  - **Tide Breathing** — flowing ranged waves.
  - **Ember Breathing** — explosive close-range pressure.
  - **Storm Breathing** — fast lunges and lightning cages.
  - **Crimson Blood Art** — forbidden bloodcraft with wide area control.
- Five abilities per path mapped to `E`, `R`, `T`, `Y`, and `X`, including a style-specific `T` block breaker and `X` ultimate.
- Generated duel arena with cover, walls, and four spawn pads.
- HUD showing style selection, ability names, cooldowns, and controls.

## Run it in Roblox Studio

This is a **Rojo** project. You need:

1. [Roblox Studio](https://create.roblox.com/)
2. [Git](https://git-scm.com/downloads)
3. The [Rojo Studio plugin](https://www.roblox.com/library/13916191980/Rojo)
4. The [Rojo command-line tool](https://rojo.space/docs/installation/)

After cloning the repository, open PowerShell in its folder and run:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
rojo serve
```

Open Roblox Studio, create a new **Baseplate** place, open the Rojo plugin, connect it to the printed server (normally `localhost:34872`), and sync the project. Press **Play**; the server script generates the arena automatically.

For a quick two-player test, use **Test > Start** with two players after syncing. Open the test clients and use the controls below to fight between them.

If you prefer not to use Rojo, create the same instance layout manually:

- `ReplicatedStorage/CombatConfig` as a ModuleScript
- `ServerScriptService/CombatServer.server.lua` as a Script
- `StarterPlayer/StarterPlayerScripts/CombatClient.client.lua` as a LocalScript

## Controls

| Input | Action |
| --- | --- |
| Left mouse | Four-hit light attack combo |
| Right mouse | Heavy attack / block breaker |
| `F` | Hold to guard; tap timing creates a perfect block |
| `Q` | Dash forward |
| `E` / `R` / `T` / `Y` / `X` | Style forms 1 - 5 |
| `G` | Toggle focused breathing to refill the breath meter |
| `1` - `4` | Select Tide, Ember, Storm, or Crimson |

## Combat rules

The interaction model follows the publicly documented DSRPG2-style loop: light attacks confirm a short combo, heavy attacks threaten a guard, and skills are separate cooldown actions. The prototype uses original style names, move names, and VFX rather than copying the reference game's assets or scripts. The server owns every hitbox, cooldown, breath cost, block, perfect-block, and block-break result; the client only predicts the feel and renders the result.

For a production game, the next layers would be matchmaking/rounds, persistent progression, animation assets, sound design, mobile controls, and anti-exploit telemetry. The combat foundation is already structured so those systems can be added without moving hit validation to the client.

## Publish your own public GitHub repository

The source folder is already a Git repository. If you want to publish it from your PC:

```powershell
git status
git add .
git commit -m "Build PvP breathing combat prototype"
git branch -M main
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Before the final command, create an empty repository on GitHub and set its visibility to **Public**. Do not initialize it with another README or `.gitignore`, since those files are already included here. GitHub will prompt you to authenticate through your browser or credential manager.
