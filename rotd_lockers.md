# rotd_lockers

Personal lockers: every character can buy a locker in an area, open it at the locker points and upgrade it at the Stashmaster. The level decides the size. The resource has no exports; this page documents the config, the saved data and the events.

Needs `ox_lib` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`, and `ox_target`, `qb-target` or an [E] prompt.

## How it works

- Each area (`Config.Areas`) has locker points and a Stashmaster NPC.
- Level 0 means no locker. "Buy a locker" at the Stashmaster is the upgrade to level 1.
- An upgrade costs the items of the next level in `Config.UpgradeRequirements` and always goes up by exactly one level.
- The server decides the level, the size and the distance checks; the client only says which area it talks about.

## Stash size per inventory

| Inventory | How the size is set |
|---|---|
| `qb-inventory` | `slots` and weight are sent every time the locker is opened, so an upgrade resizes it at once. One stash per character and area |
| `ox_inventory` | the stash is registered with `slots` and weight when opened; one that is already loaded is resized too. One stash per character and area |
| `core_inventory` | the size comes from the stash **type** `personal_stash_level_<n>` in core_inventory's own config; the level is part of the stash id and the items are moved to the new type on an upgrade |

On `core_inventory` you must define the stash types `personal_stash_level_1` to `personal_stash_level_10` (or as many levels as you use) in core_inventory with the size you want. The `x` and `y` of the config only mirror that grid in the upgrade menu.

## Config: `config.lua`

```lua
Config.WeightPerSlot = 15000      -- grams; weight = slots * this when a level has no `weight` (ox / qb)
Config.OpenDistance = 6.0         -- server check: metres to a locker point
Config.UpgradeDistance = 10.0     -- server check: metres to the Stashmaster
```

#### Area (`Config.Areas[n]`)

```lua
[1] = {
    name = 'AirportSafezone',     -- saved with the level: never rename it once players own lockers
    label = 'Airport Safezone',
    TargetPoints = { vector4(x, y, z, heading), ... },   -- where a locker can be opened
    UpgrageNPC = { model = 'cs_old_man1a', coords = vector4(x, y, z, heading),
                   scenario = nil, talklabel = nil, talkicon = nil },   -- the Stashmaster (the spelling is the real key)
},
```

#### Level (`Config.UpgradeRequirements[level]`)

```lua
[2] = {
    level = 2,
    time = 60,                    -- upgrade progress time
    items = { dogtag = 2 },       -- cost of reaching THIS level; items must exist in your inventory
    stats = { x = 150, y = 10, slots = 150, weight = nil },   -- slots / weight: ox and qb size; x, y: grid shown in the menu
},
[10] = { level = 10, maxlevel = true, stats = { x = 60, y = 10, slots = 600 } },
```

`maxlevel = true` marks the last level. Shipped: levels 0 to 10, from 100 to 600 slots, costs 1 to 20 `dogtag`. The last level has no `items`, so reaching it is free unless you add some.

## Saved data

The levels are saved per character as `stashlevel` = `{ [areaName] = level }` through `rotd_bridge`: in character data on QBCore and Qbox, in the table `rotd_player_data` on ESX (created by the bridge).

## Callbacks and events

Not an API; listed so you can read the data.

| Name | Type | Side | Purpose |
|---|---|---|---|
| `personalStash:initialize` | `lib.callback` | server | creates the level entry (0) of every area, returns `{ [area] = level }` |
| `personalStash:levels` | `lib.callback` | server | returns `{ [area] = level }` |
| `rotd_lockers:countItems` | `lib.callback` | server | how many of the given items the player holds (upgrade menu) |
| `locker:open` | net event | server | open the locker of an area (checked: distance and saved level) |
| `personalStash:upgrade` | net event | server | upgrade by one level (checked: area, distance, max level, items) |
| `personalStash:upgradeSuccess` | client event | client | sent after an upgrade: `areaName`, `newLevel` |
| `locker:notifyNoLocker` | client event | client | "you don't own a locker here" |

## Optional integrations

None needed. A target resource gives the "Open Locker" and "Talk to the Stashmaster" options; without one an [E] prompt is used. On `qb-target` the locker points are built as invisible props, see `Bridge.Target` in [[rotd_bridge]].
