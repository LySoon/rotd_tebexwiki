# rotd_loots

Lootable chests and props with lock minigames, plus the "loot sense" scan.

Needs `ox_lib` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`, and `ox_target`, `qb-target` or standalone `[E]` prompts. Installation and the item names: [[Install-rotd_loots]], [[Items-rotd_loots]].

## How it works

1. **Chests** (`Config.LootSpawns`): props placed at the coordinates of an area. Every chest has a lock (1 to 10) and a minigame; the player searches it, plays the minigame, and the **server** rolls the loot from the chest's loot table.
2. **Map props** (`Config.AlwaysInteractableProps`): props that are always in the world (computers, folders, laptops, bins, vending machines, ...). The player searches them with a progress bar and an optional minigame; the server rolls the loot.
3. A looted chest or prop renews after `Config.LootRespawnMinutes`, per location. Players can open a chest together: the first to finish gets the loot.
4. Props are created and removed around the player by distance.

## Commands

| Command | Who | Does |
|---|---|---|
| `rotd_lootsense` (key `Z`) | everyone | scans for loot and outlines lootable props nearby |
| `/lootdebug` | admins | menu to draw 3D text above every lootable prop and set the draw distance |
| `/lootcount` | everyone | prints how many props are spawned around you to the console |

## Locations pack (+$15)

The base resource has one small sample area and the map props, but no ready loot areas. The optional locations pack is a ready `Config.LootSpawns` table:

| | |
|---|---|
| Zones | 169 |
| Prop groups | 1,015 |
| Spawn points | 4,429 |
| Prop models | 103 |
| Loot lines | 7,275 |
| Item names | 331 |

Zones include 24/7 supermarkets (10), Ammu-Nation shops (10), gas stations and their areas (38), power stations (19), liquor markets (5), deadman stashes (9), clothing stores (13), military base areas (10), military ships (4), construction sites (10), mechanic workshops (6), Humane Labs areas (4), MRPD areas (3), living areas (5) and 23 more such as factories, bars, the Pillbox hospital, a mining cave, a cargo ship and a recycling factory. Installation: see [[Install-rotd_loots]].

## Client exports: loot sense

Loot sense outlines nearby lootable props for a while (default key `Z`, command `rotd_lootsense`).

#### `TriggerLootSense(silent)`

Triggers a scan. Respects the cooldown.

| Parameter | Type | Description |
|---|---|---|
| `silent` | `boolean?` | `true` suppresses the notification. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_loots:TriggerLootSense(true)
```

</details>

#### `SetLootSenseBonus(distanceBonus, durationBonus, cooldownScale)`

Changes loot sense for the local player, for example from a skill. Pass `nil` to leave a value unchanged.

| Parameter | Type | Description |
|---|---|---|
| `distanceBonus` | `number?` | **Added** to the configured scan distance (meters). |
| `durationBonus` | `number?` | **Added** to the configured duration (seconds). |
| `cooldownScale` | `number?` | **Multiplies** the cooldown. `0.5` = half. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
-- a skill that improves loot sense
exports.rotd_loots:SetLootSenseBonus(15.0, 4.0, 0.5)   -- +15 m, +4 s, half cooldown
-- remove the bonus
exports.rotd_loots:SetLootSenseBonus(0.0, 0.0, 1.0)
```

</details>

#### `GetLootSenseState()`

**Returns** `table`:

| Field | Type | Description |
|---|---|---|
| `active` | `boolean` | A scan is running. |
| `onCooldown` | `boolean` | Waiting for the cooldown. |
| `remaining` | `number` | Seconds left (of the scan or the cooldown). |
| `distance` | `number` | Current scan distance. |
| `duration` | `number` | Current scan duration. |
| `cooldown` | `number` | Current cooldown length. |

<details>
<summary>Example</summary>

```lua
local state = exports.rotd_loots:GetLootSenseState()
if not state.onCooldown then exports.rotd_loots:TriggerLootSense(true) end
```

</details>

## Shared export (client and server)

#### `GetAllLootProps()`

Every prop definition from `Config.AlwaysInteractableProps` and `Config.LootSpawns`. Handy for map tools or no-build rules that need every lootable prop position.

**Returns** `table[]`: array of prop definitions.

<details>
<summary>Example</summary>

```lua
local props = exports.rotd_loots:GetAllLootProps()
print(#props, 'lootable props')
```

</details>

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| `rotd-minigame` | lock minigames on containers (`startMinigameSync`), see [[rotd-minigame]] | `Config.Minigame.fallback`: `qb-minigames` when it runs, otherwise `ox_lib` skill checks (or no minigame with `none`) |
| `qb-minigames` | fallback minigames (`Hacking`, `Lockpick`) | `ox_lib` skill checks |
| `ox_target` / `qb-target` | targeting of chests and props | standalone `[E]` prompts of this resource (`or_custom_eye_target_script` is also supported) |

## Config reference: `config/config.lua`

The file has short sections: general, notifications, looting, loot sense, minigames, always-interactable minigames, zombies, loot spawns and map props.

#### General

| Key | Meaning |
|---|---|
| `DebugMode` | debug logging |
| `LootRespawnMinutes` | minutes until a looted chest or prop renews, per location. A spawned chest is replaced by a freshly rolled one, a map prop becomes searchable again |
| `ChestOpenWindow` | seconds a started chest-open stays valid. Players may open a chest together: the first to finish gets the loot. Keep it above the longest minigame time plus `SpawnedPropSearchDuration` |
| `LootPromptDistance` | distance at which the search prompt appears |
| `ServerChestSync` | the server keeps the looted state, so nobody loots a chest twice and everyone sees the same state |

#### Notifications

`Config.Notify.system` is `'ox_lib'` or `'qbcore'` (`QBCore:Notify`); `duration` is in milliseconds, `title` and `position` apply to ox_lib. `Config.LootNotify.enabled` shows "You received: item x2" after looting; `perItem` gives one message per item instead of one combined message.

#### Looting

| Key | Meaning |
|---|---|
| `LootRollLimit` | a chest yields at most `maxRolls` reward lines; above that only the rarest `keepMin` to `keepMax` are given (amounts are not changed). Per chest, in its `data`: `no_roll_limit = true`, or `maxRolls`, `keepMin`, `keepMax` |
| `AlwaysInteractableSearchDuration`, `SpawnedPropSearchDuration` | search time in milliseconds for map props / for spawned chests after the lock minigame |
| `SearchAnimation` | animation while searching (`enabled`, `dict`, `name`, `flag`) |
| `LockpickAnimation`, `InteractionOffsetDistance`, `LockDifficulty` | not used by the code at the moment |

Targeting uses `ox_target` or `qb-target` through `rotd_bridge`, then `or_custom_eye_target_script`, then standalone `[E]` prompts. The inventory is detected by `rotd_bridge`.

#### Loot sense

The scan outlines nearby lootable props for a few seconds. Times are in **seconds**, distances in **metres**.

| Key | Meaning |
|---|---|
| `enabled` | switch the scan on or off |
| `distance`, `duration`, `cooldown` | base radius, outline time, time before the next scan |
| `maxDistance`, `maxDuration` | ceilings for what a skill system adds |
| `requireLineOfSight` | no outlines through walls |
| `startColour`, `endColour` | outline colour at the start and at the end of the fade |
| `fadeHold` | share of the duration at full brightness before the fade (0.45 = the first 45%) |
| `scanEffect` | the radar sweep: `pings` spheres go out once per scan, each takes `pingTravel` seconds; `alpha` 0 to 255, `colour`, `heightOffset` from the player's feet |
| `blockCover`, `blockCoverTime` | set `blockCover = true` only if the key is also GTA's cover key (Q): the cover input is swallowed for `blockCoverTime` milliseconds after a scan |
| `notifyOnCooldown` | message when the scan is on cooldown |

The default key is set in `client/client.lua` (`RegisterKeyMapping('rotd_lootsense', 'Scan for loot', 'keyboard', 'Z')`); all four arguments must stay plain strings. A player who rebound the key keeps their own choice (FiveM: Settings > Key Bindings > FiveM > "Scan for loot"). Skill systems change the base values at runtime with the exports above.

#### Minigames

Lock minigames come from `rotd-minigame` (`ox_lib` skill checks without it). A chest's `data.lock` (1 to 10) sets the difficulty and `data.minigame` picks the game(s); lock 0 opens without a minigame.

| Key | Meaning |
|---|---|
| `lockToDifficulty` | chest lock (1 to 10) to minigame difficulty (1 to 7) |
| `fallback` | what runs when `rotd-minigame` is not running: `'auto'` (qb-minigames if it runs, otherwise ox_lib skill checks), `'qb-minigames'` (Hacking for electronic locks, Lockpick for the rest), `'ox_lib'` (skill checks) or `'none'` (the lock simply opens) |
| `timeLimit` | `nil` = every game uses its own timing; `{ [difficulty] = seconds }` forces one curve. A chest's `data.time` always wins |
| `types` | the games usable on a lock |
| `profiles` | `data.minigame` number to a pool of games; one is picked when the chest is opened; `default` is used for an unknown number |
| `byChestType` | pool by chest `data.type` (highest priority), e.g. `supermarketSafeLocked = { 'safedial' }` |

Per chest, in its `data`: `difficulty = 1..7` (exact), `time = N` (seconds, 0 = unlimited), `minigame = <profile number or a game name such as "safedial">`.

#### Always-interactable minigames and props

`Config.AlwaysInteractableMinigame` holds the defaults for an entry of `Config.AlwaysInteractableProps` that has a `minigame` but no difficulty of its own: `defaultMinDiff`, `defaultMaxDiff` (1 to 7), `timeByDifficulty` (`nil` = each game's own timing) and `timeMultiplier` (used when `timeByDifficulty` has no entry for the difficulty). Entries without `minigame` only search.

An entry of `Config.AlwaysInteractableProps` (props that are always in the world: computers, folders, laptops, ...):

```lua
["elecboxAIP"] = {
    props = { "prop_elecbox_07a" },                       -- model names
    label = "Searching the box.",                         -- prompt text (optional)
    onlyOne = false,                                      -- true = one reward line only
    minigame = "fusebox",                                 -- false | "fusebox" | {"fusebox","cablecut"} (random) | 4 (profile)
    minDiff = 2, maxDiff = 4,                             -- random difficulty 1-7 (or difficulty = 5 for a fixed one)
    time = 15,                                            -- seconds, 0 = the game's own timing
    lootTable = { {item="wire", amount={1,3}, chance=90} },
},
```

#### Zombies

`ZombieSpawnCounts` and `ZombieSpawnDistance` are off (`disable = true`). When enabled, looting triggers `rotd_zombies:client:*` events that a zombie resource has to listen to. Counts are per chest type, with a `fallback` per zone colour.

#### Loot spawns

`Config.LootSpawns` has one entry per group of props:

```lua
{
    props = {"prop_ld_int_safe_01"},
    coords = { vector4(x, y, z, heading) },
    data = {
        type = "supermarketSafeLocked",   -- optional chest type
        lock = 4,                         -- 0 = no lock
        minigame = 11,                    -- profile number or game name
        difficulty = 5,                   -- optional, 1-7
        time = 10,                        -- optional, seconds
        one_reward = false,
        deleteprop = true,
        sound = "safe_cracking",
        lootTable = { {item={"money"}, amount={1500, 4000}, chance=95} },
    },
}
```

`item` can be one name or a list (one real item of your item list is picked); `amount` a number or `{min, max}`; `chance` is a percentage per line; `metadata` is passed to the item.

#### Export

`GetAllLootProps()` (client and server) returns every prop model of `Config.LootSpawns` and `Config.AlwaysInteractableProps`.

## Recipes

### Loot sense skill (client)

```lua
-- apply a bonus while the skill is active, remove it afterwards
local function setLootSenseSkill(active)
    if active then
        exports.rotd_loots:SetLootSenseBonus(15.0, 4.0, 0.5)     -- +15 m, +4 s, half the cooldown
    else
        exports.rotd_loots:SetLootSenseBonus(0.0, 0.0, 1.0)      -- back to the config values
    end
end

-- auto scan when a skill triggers it
local state = exports.rotd_loots:GetLootSenseState()
if not state.onCooldown and not state.active then
    exports.rotd_loots:TriggerLootSense(true)                    -- silent
else
    print(('loot sense ready in %d s'):format(state.remaining))
end
```

### Draw your own markers on every lootable prop

```lua
local props = exports.rotd_loots:GetAllLootProps()
print(('%d lootable props'):format(#props))
```
