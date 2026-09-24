# Stardew-like 2D Game

A small-scale **top-down 2D farming/life-sim game built from scratch with LÖVE (Lua)**.

This project is primarily a learning project focused on understanding how a 2D game is actually put together: game loops, entity architecture, tilemaps, collision, animation, game states, farming systems, NPCs, dialogue, saving, and game packaging.

The goal is not to recreate Stardew Valley. It is to build a small, complete game while learning the fundamentals behind this kind of game.

## Current Status

🚧 **Early development**

The project is being developed incrementally through a 30-day development plan. The current implementation is intentionally small and will grow one system at a time.

## Planned Features

* Top-down player movement
* Tile-based world built with [Tiled](https://www.mapeditor.org/)
* Sprite-sheet animation
* Camera and scrolling world
* Collision with world objects
* Interactable objects
* Basic farming
* Crops with multiple growth stages
* Inventory and hotbar
* Simple day/night cycle
* NPCs with basic schedules
* Dialogue system
* Save/load system
* Menu and pause screens
* Music and sound effects
* Small playable farm/village environment

## Tech Stack

* **Language:** Lua
* **Framework:** [LÖVE](https://love2d.org/)
* **Map Editor:** [Tiled](https://www.mapeditor.org/)
* **Version Control:** Git
* **Target Platform:** Windows

## Project Structure

```text
MyGame/
│
├── main.lua
├── conf.lua
├── README.md
│
├── src/
│   ├── game.lua
│   ├── input.lua
│   ├── assets.lua
│   ├── animation.lua
│   ├── camera.lua
│   ├── tilemap.lua
│   ├── time.lua
│   ├── inventory.lua
│   ├── audio.lua
│   ├── save.lua
│   │
│   ├── entities/
│   │   ├── player.lua
│   │   ├── npc.lua
│   │   └── object.lua
│   │
│   ├── systems/
│   │   ├── collision.lua
│   │   ├── interaction.lua
│   │   ├── farming.lua
│   │   └── dialogue.lua
│   │
│   ├── ui/
│   │   ├── hotbar.lua
│   │   └── dialogue.lua
│   │
│   └── states/
│       ├── menu.lua
│       ├── gameplay.lua
│       └── pause.lua
│
├── data/
│   ├── crops.lua
│   ├── items.lua
│   ├── npcs.lua
│   └── dialogue.lua
│
├── assets/
│   ├── tiles/
│   ├── characters/
│   ├── objects/
│   ├── sounds/
│   ├── music/
│   └── fonts/
│
└── maps/
```

## Architecture

The project uses a lightweight modular architecture rather than a large game-engine-style framework.

```text
LÖVE
 │
 └── main.lua
       │
       └── Game
             │
             ├── Menu
             ├── Gameplay
             └── Pause
                    │
                    ├── Player
                    ├── NPCs
                    ├── World
                    ├── Farming
                    ├── Inventory
                    └── UI
```

Game content is kept separate from the systems that operate on it where practical.

For example, crop definitions live in:

```text
data/crops.lua
```

while farming logic lives in:

```text
src/systems/farming.lua
```

This keeps content easier to extend without constantly changing core game logic.

## Controls

Current:

| Action     | Keyboard  |
| ---------- | --------- |
| Move Up    | `W` / `↑` |
| Move Down  | `S` / `↓` |
| Move Left  | `A` / `←` |
| Move Right | `D` / `→` |

More controls will be added as gameplay systems are implemented.

## Running the Game

Install [LÖVE](https://love2d.org/), then open a terminal in the project directory and run:

```bash
love .
```

The game can also eventually be packaged as a `.love` file or a standalone Windows build.

## Development Roadmap

The project is being developed across 30 small milestones:

1. Project bootstrap
2. Game architecture
3. Input system
4. Player movement
5. Player entity architecture
6. Asset loading
7. Sprite animation
8. Tiled map creation
9. Tilemap loading
10. Tilemap rendering
11. Collision map
12. Player collision
13. Camera
14. Interaction system
15. World objects
16. Game clock and days
17. Farm plots
18. Farming actions
19. Crop growth
20. Items and inventory
21. Pickups and hotbar
22. NPCs
23. Dialogue
24. Day/night presentation
25. Save/load
26. Menu and pause
27. Audio
28. Content pass
29. Playtesting and bug fixing
30. Playable build

## Why I'm Building This

This project is an exercise in learning game development by actually building the systems instead of relying on a full-featured engine.

Particular focus is being placed on:

* Clean separation of game systems
* Understanding game loops and update timing
* Working with vectors and movement
* Tilemap-based world construction
* Data-driven game content
* Reusable entities and systems
* Building a complete game from prototype to packaged build

## License

This project is currently for learning and experimentation.

Asset licenses will be documented separately as external assets are added.
