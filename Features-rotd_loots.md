# rotd_loots features

**Chests to crack, props to search, loot to scan for.** Lootable chests with locks and minigames, searchable world props, a scan that outlines loot nearby, and loot that renews on its own. Loot is rolled on the server, so it can't be faked. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory and target resource.

---

## Highlights

- **Chests with locks:** 10 lock levels, a minigame per chest, loot tables with chances, amounts and item metadata
- **75 searchable map prop groups** (290 models): computers, folders, laptops, bins, vending machines, boxes, cabinets and more
- **Loot sense:** press a key to outline lootable props around you, with a radar sweep; skill systems can boost it
- **Synced and fair:** the first player to finish a chest gets the loot, everyone sees the same state, every location renews on its own timer
- **Minigames your way:** `rotd-minigame`, `qb-minigames`, `ox_lib` skill checks, or none, set in the config
- **Server-side loot:** loot rolls, chest state and distance checks all happen on the server
- **Works with your setup:** `core_inventory`, `ox_inventory` or `qb-inventory`; `ox_target`, `qb-target` or a key prompt
- **Optional locations pack (+$15):** a ready map of 169 zones, 1,015 prop groups and 4,429 spawn points
- Code is protected; the config stays open for you to edit

---

## Features in detail

### Chests

- Props are placed at the coordinates of an area and appear around the player by distance
- A chest has a lock (1 to 10, or none), a minigame (or a pool of games) and a loot table
- Loot tables: item (or a list of items to pick from), amount (fixed or a range), chance, optional item metadata
- Limits: a chest can only yield a set number of reward lines, rarest first, so one chest can't empty the table
- One reward or all rewards per chest; the prop can disappear after looting
- Looting sound per chest type

### Map props

- Searchable world objects with a progress bar and an optional minigame
- Each group has its own loot table, prompt text and difficulty range
- Every prop renews on its own timer

### Minigames

- 10 lock difficulty levels mapped to 7 minigame difficulties, with per-chest overrides
- Game pools per chest profile (lockpick, crowbar, keypads, safe dial, wires, fuse box, valve and more)
- Without `rotd-minigame`: `qb-minigames`, `ox_lib` skill checks, or no minigame, your choice

### Loot sense

- One key press outlines every un-looted lootable prop around you, fading out over a few seconds, with a radar sweep
- Range, duration, cooldown, colours and the sweep are configurable
- Exports let a skill system boost the range or the duration, or trigger the scan from code

### Sync and respawn

- The server keeps the looted state; nobody loots a chest twice
- Players can open the same chest together: the first to finish wins
- Each chest or prop renews on its own timer (default 60 minutes), a spawned chest is replaced by a freshly rolled one

### Admin tools

- `/lootdebug`: draws 3D text above every lootable prop, with an adjustable distance
- `/lootcount`: how many props are spawned around you

### Notifications

- One notification system for every message: `ox_lib` or QBCore, switch in the config
- Optional "You received: item x2" message

---

## Optional locations pack (+$15)

A ready `Config.LootSpawns` for the map, so you don't have to place a single chest:

| | |
|---|---|
| Zones | 169 |
| Prop groups | 1,015 |
| Spawn points | 4,429 |
| Prop models | 103 |
| Loot lines | 7,275 |
| Item names | 331 |

Includes 24/7 supermarkets (10), Ammu-Nation shops (10), gas stations and their areas (38), power stations (19), liquor markets (5), deadman stashes (9), clothing stores (13), military base areas (10), military ships (4), construction sites (10), mechanic workshops (6), Humane Labs areas (4), MRPD areas (3), living areas (5), and 23 more such as factories, bars, a hospital, a mining cave, a cargo ship and a recycling factory.

The base resource ships with **no ready loot areas** (one small sample area and the map props); you can add your own, or add the pack.

---

## Works with

| Resource | What you get |
|---|---|
| **rotd-minigame** | the full set of lock minigames |
| **qb-minigames** | fallback minigames when `rotd-minigame` is not running |
| **ox_target / qb-target** | search prompts on chests and props; `[E]` prompt without them |
| **Your inventory** | `core_inventory`, `ox_inventory` or `qb-inventory`, detected automatically |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- Exports: `TriggerLootSense`, `SetLootSenseBonus`, `GetLootSenseState`, `GetAllLootProps`
- Full documentation: [[rotd_loots]]

---

## Installation

See [[Install-rotd_loots]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_loots]] · Install: [[Install-rotd_loots]]
