# Install: rotd_loots

Lootable chests and props with lock minigames, loot sense and synced respawns.

> Developer documentation (config, exports, commands): [[rotd_loots]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected): QBCore, Qbox or ESX |
| An inventory | yes: `core_inventory`, `ox_inventory` or `qb-inventory` |
| `ox_target` / `qb-target` | optional (standalone `[E]` prompts without them) |
| `rotd-minigame` | optional (`qb-minigames` or `ox_lib` skill checks without it, see `Config.Minigame.fallback`) |
| `qb-minigames` | optional (fallback minigames) |

## server.cfg

```
ensure rotd_bridge
ensure rotd-minigame   # optional
ensure rotd_loots
```

## Items

The loot tables use 132 item names in the base resource and 332 with the locations pack. Items you do not have are skipped with a console warning, so add the ones you want. The full lists are on [[Items-rotd_loots]].

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list.

## Database

None.

## Locations pack (+$15)

The base resource comes with one small sample area and the searchable map props, but **no ready loot areas**. The locations pack is the file `rotd_loots_full config +15$.lua`.

1. Back up `config/config.lua`.
2. Open `config/config.lua` and replace the whole `Config.LootSpawns = { ... }` table with the contents of the pack file (it is the same table, filled with 169 zones).
3. Add the items you want from [[Items-rotd_loots]] and restart `rotd_loots`.

You can also keep your own areas: add them to `Config.LootSpawns` (the format is on the [[rotd_loots]] page).

## First-time checklist

- `Config.Notify.system`: `'ox_lib'` or `'qbcore'`.
- `Config.Minigame.fallback`: what runs when `rotd-minigame` is missing (`'auto'`, `'qb-minigames'`, `'ox_lib'`, `'none'`).
- `Config.LootRespawnMinutes`: how long until a looted chest renews.
- `Config.LootNotify.enabled`: show "You received ..." after looting.
- Loot sense key: default `Z`, players rebind it in the FiveM key bindings.

## Test it

1. Restart the server and join near a chest of your areas (as admin run `/lootdebug` to draw 3D text above every lootable prop).
2. Search a chest: the lock minigame starts, the loot arrives in your inventory.
3. Search a computer, a folder or a vending machine (map props).
4. Press `Z` to scan for loot.
