# DuoJump

A local two-player split-screen platformer for macOS. Open source, built with [Godot](https://godotengine.org/) (GDScript).

## How to play

- **Player 1**: Arrow keys to move, `Up` to jump.
- **Player 2**: `A` / `D` to move, `W` to jump.
- Push crates by walking into them — use them to climb ledges you can't jump to directly.
- Falling off the level respawns you at the start of it. No lives, just try again.
- Both players must be standing in the goal zone at the same time to clear a level.
- `Esc` pauses.
- 5 levels, split screen either side-by-side or stacked (pick in the menu).

## Requirements

- macOS 11+
- [Godot 4](https://godotengine.org/) (installed automatically via Homebrew below)

## Install via Homebrew

```bash
brew tap PavlovIvan1/2d-macos-game https://github.com/PavlovIvan1/2d-macos-game.git && brew trust pavlovivan1/2d-macos-game && brew install duojump
```

Installs Godot (if you don't already have it) plus DuoJump into `/Applications`, shows up in Launchpad/Spotlight. The cask stitches the app together on your machine at install time instead of shipping a prebuilt binary, so Gatekeeper doesn't block it and no notarization/Apple Developer account is required.

## Run from source

```bash
git clone git@github.com:PavlovIvan1/2d-macos-game.git
cd 2d-macos-game
godot --path game
```

## Build a `.app` bundle locally

```bash
./build_app.sh
open DuoJump.app
```

## License

MIT — see [LICENSE](LICENSE).
