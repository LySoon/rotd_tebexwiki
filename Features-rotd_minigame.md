# rotd-minigame

**18 skill-check minigames behind two simple exports.** Lockpicks, safes, keypads, wiring, valves, crowbars, syringes, zombie grapples and more, with a realistic metal-and-glass look, seven difficulty levels, tool requirements and XP rewards. Add a minigame to any of your scripts in one line. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory.

---

## Highlights

- **18 minigame types** in one unified system, all drawn in the same polished look
- **7 difficulty levels** from Very Easy to Impossible, tuned per type, with randomized layouts so no two attempts are alike
- **Two exports** for developers: a blocking version for scripts and a callback version
- **Tool requirements:** a lockpick, crowbar, wrench, knife or syringe can be required, and used up on failure or success, decided by the server
- **XP rewards** per type and difficulty through the ROTD HUD, or into your own XP system
- **Fail lockout** for electronic games, ESC to leave, death-safe, one game at a time
- **Works with any inventory:** `core_inventory` (including equipped weapons), `ox_inventory` or `qb-inventory`
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### The minigames

| Type | What you do |
|---|---|
| `lockpick` | feel for the sweet spot in a lock; padlock, wooden door, metal door, car door, filing cabinet, bike lock and handcuff skins |
| `safedial` | spin the dial, find each number by its click, commit with the right timing |
| `keypad_matrix` | enter the target code on a scrambling keypad with hint pulses |
| `keypad_wave` | tune a signal on a scope to match the target wave |
| `wiresplice` | connect matching colours across a junction box |
| `cablecut` | defuse a bundle of cables |
| `fusebox` | wire breakers, fit spare fuses, flip the main lever |
| `repairpanel` | unscrew a cover, then repair the fuse panel in several stages |
| `crowbar` | pry open a crate with a pressure tube; noise can attract attention |
| `floorboard` | pry each nail with the right release timing |
| `lever` | pull a stiff lever against the spring |
| `valve` | turn stiff valve wheels to the required turns |
| `nutsbolts` | remove, install or replace nuts on a random engine or machine part, with rust, throwing and torque |
| `cutting` | cut something open with a blade |
| `hotwire` | splice ignition cables; switch to a lockpick (and spend one) if it goes wrong |
| `syringe` | steady-hand injection in three stages: find the vein, set the angle, press the plunger |
| `bite_dodge` | shove off a zombie lunge with perfect timing |
| `struggle` | mash keys to break free of a zombie grapple |

### Difficulty and variety

- Difficulty 1 to 7 changes zone sizes, speeds, decay, number of stages and time limits
- Layouts are randomized every attempt: codes, combinations, wire pairs, lock types, part themes
- Optional time limit per call, or none

### Tools and items

- Per type: which items allow a try (any one of a list), a friendly "You need a crowbar" message
- Items can be consumed on failure (with a chance, rolled on the server so it cannot be dodged) or on success
- Equipped weapons count on `core_inventory`
- Death, downing or leaving the game never wastes an item

### Fair play

- Electronic games lock for a few seconds after a real failure, scaled with difficulty; mechanical games can be retried at once
- Controls are blocked while a game runs; one game at a time; closing the resource ends the game cleanly
- XP amounts and item rules come from the server config, and awards are rate limited

### For admins

- `/testminigame <type> <1-7> [seconds]` and `/testminigamemenu` to try every game in game

---

## Works with

| Resource | What you get |
|---|---|
| **rotd-hud** | XP orbs and level bar on a successful minigame |
| **npc_guide** | quest objectives that count completed minigames, filtered by type or difficulty |
| **Your ambulance system** (any) | a dead or downed player ends the game |
| **rotd_loots, rotd_needs** | use the minigames for looting and repairs |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- `startMinigameSync(type, difficulty, timeLimit)` returns `success, reason, stage`; `startMinigame(type, difficulty, timeLimit, callback)` is non-blocking
- Server event `minigames:xpGranted` for your own XP system, client event `minigames:hearNoise` for alerts
- Full documentation with parameter tables and recipes: [[rotd_minigame]]

---

## Installation

See [[Install-rotd_minigame]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_minigame]] · Install: [[Install-rotd_minigame]]
