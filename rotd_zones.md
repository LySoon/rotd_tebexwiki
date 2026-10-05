# rotd_zones

Zones, radiation, resistance, infection hooks and zombie names. Call exports with `exports.rotd_zones:Name(...)` (or `exports['rotd_zones']:Name(...)`).

> **Side.** The badge on each export tells you where to call it: **client** from a client script, **server** from a server script, **shared** from either.
> `rotd_zones` depends on no zombie, medical, HUD or sound resource. Anything that needs outside data (zombie names, infection state, cure, cough reactions) is a **registration export** further down.

## Overview

`rotd_zones` divides the map into **zones** (red, yellow, orange, green, radiation, ...) with their own **rules**, zombie settings and loot, and runs the systems that depend on them: safezone protection, radiation, guard NPCs, base-building limits, the map overlay and the zone UI.

**Requirements**

| Resource | Needed | Notes |
|---|---|---|
| `ox_lib` | yes | notifications, callbacks |
| `rotd_bridge` | yes | framework, inventory and optional-resource layer, see [[rotd_bridge]]. Start it before `rotd_zones` |
| A framework | yes | QBCore, Qbox or ESX (auto-detected) |
| An inventory | optional | `core_inventory` (default), `ox_inventory` or `qb-inventory`. Only used for radiation resistance from items |
| `rotd-hud` | optional | when it runs, it shows the zone cards; otherwise the **built-in zone UI** is used |

Nothing else is required: no zombie, medical, sound or HUD resource. Features that need outside data (zombie names, infection state and cure, cough reactions) are registration exports, see below.

**Install**
1. Put `rotd_bridge` and `rotd_zones` in your resources and make sure your framework and `ox_lib` start before them.
2. `ensure rotd_bridge` then `ensure rotd_zones`.
3. Players must **reconnect once** after the first start: the NUI files are downloaded when joining.

On ESX the bridge creates the table `rotd_player_data` the first time it is needed (it checks it on start, see [[rotd_bridge]]). QB and Qbox store the radiation dose in `charinfo` and need no table.

## Zones

Zones live in `Config.Zones` (`config.lua`). One entry:

```lua
Config.Zones = {
    Beach = {
        name = 'Beach',                          -- shown on the zone card and the map
        type = 'yellow',                         -- red | orange | yellow | green | radiation | death | white | gray | cyan
        priority = 10,                           -- optional: higher wins where zones overlap (then the smaller area)
        zombie_intensity = 2.0,                  -- spawn intensity multiplier
        zombie_classes = { 'normal', 'sprinter', 'spitter', 'howler', 'fat', 'tank' },   -- classes allowed here
        zombie_damage_mult = 1.0, zombie_health_mult = 1.0, zombie_armor_add = 0,        -- optional zombie stat changes
        no_sleep = false,                        -- optional
        rules = {                                -- booleans, all optional (default true)
            baseBuilding = true, baseRaiding = false, PvP = true, Weapons = false, blackout = true,
        },
        models = {                               -- per zombie class
            normal = { extraloot = { { name = 'money', chance = 8, min = 10, max = 35 } } },
        },
        zonedata = {
            type = 'poly',
            debug = false,
            coords = { vector3(-2304.19, -386.52, 1.57), vector3(-2070.0, -407.21, 11.42), ... },   -- polygon corners
        },
    },
}
```

Overlapping zones are ranked by `priority` (higher wins), then by the smaller area (`Config.ZoneRank`). **Radiation is not decided by the winner**: any radiation polygon containing the player irradiates them, even when a higher-priority zone owns that point.

### Rules

| Rule | Effect |
|---|---|
| `baseBuilding` | base building allowed (read by base-building resources through the exports) |
| `baseRaiding` | raiding allowed |
| `PvP` | player vs player allowed |
| `Weapons` | weapons allowed |
| `blackout` | the zone is in blackout; `Config.BlackoutInteriorLight` adds a faint cone of light so interiors stay barely readable. Blackout is suppressed inside garage interiors when `qb-garages` runs |

Rules are only data for **your** systems unless a feature below says otherwise. Read them with `CheckCoordsZoneTypeCoordsRules` / `GetZonePlayerin`, or react to `rotd_zones:enteredZone`.

### Safezones (green)

Membership in a green zone is **decided by the server** and replicated, so every client agrees. Inside it:
- players are protected from damage (server-authoritative), vehicles are made static or ghosted
- props that chain-explode (petrol pumps and the models in `Config.PropSafety.ProtectedModels`) are made indestructible around the player (`Config.PropSafety`)
- guard NPCs patrol and enforce the zone, see Guards below

### Zone builder (admin)

Draw a polygon on the big pause map and get a ready-to-paste `Config.Zones` block.

| Command | Does |
|---|---|
| `/zonebuilder` | start a session (open the map), run again to finish. Prints the block to the F8 console and appends it to `data/builder_zones.txt` |
| `/zbadd [me\|aim\|map\|<x> <y>]` | add a point (default: the map cursor) |
| `/zbundo`, `/zbdel <n>` | remove the last point / point `n` |
| `/zbins <n> [src]` | insert before point `n` |
| `/zblist` | print the points to F8 |
| `/zbname <name...>`, `/zbtype <type>` | set the zone name / type |
| `/zbdraw` | toggle world markers |
| `/zbdone`, `/zbclear` | finish / clear aliases |

On the pause map: **RMB or ENTER** places a point, **DELETE** removes the last one.

### Water bake (admin, once)

`/bakezones` makes the admin's character walk every zone's sample grid, classifies each cell as sea, land or dry, and saves the result to `data/waterbake.json` for all clients. Run it after changing zone polygons.

### Map overlay

Zones are drawn as coloured shapes on the minimap and pause map (`Config.MapOverlay`: fill and border opacity, texture sizes, build batch size). `RebuildMapOverlays` redraws them after changing zones at runtime.

## Radiation

A zone of type `radiation` irradiates the player. Add `RadiationSources` and `Center` inside its `zonedata`:

```lua
zonedata = {
    type = 'poly',
    coords = { ... },
    RadiationSources = { vector3(3480.05, 3647.18, 43.03), vector3(3429.15, 3655.68, 44.25) },   -- hot spots
    Center = vector3(3534.02, 3717.38, 32.5),
}
```

**Gain.** Each second inside the zone the dose rises by:
- every source within 15 m: `max(1, floor(10 - distance))`
- plus the centre falloff: `max(0.05, 50 / (1 + distance² / 5000))`

multiplied by `(1 - resistance / 100)`. After login there is a protection window: no dose for `Config.RadiationGraceMs` (8 s), then the dose ramps from 0 to full over `Config.RadiationRampMs` (8 s).

**Loss.** Outside radiation zones the dose decays by about 0.05 to 0.25 per second.

**Damage.** Inside the zone the gain also hurts. It builds up and one point of damage is applied each time it reaches 1. `Config.RadiationDamageScale` scales the damage (1.0 = full, the dose itself is not changed). Each hit shows the damage feedback below.

**Sprint debuff.** In the zone, sprint stamina is capped by the tier below and the character moves with a hurt walking style.

### Tiers

The dose decides the debuffs and the screen effect. A screen effect carries up to the next one. Below 50 there is nothing and health and stamina are normal (200, 100%).

| Dose | Max health | Stamina cap | Screen effect | Cough chance per second (cooldown) | Ragdoll |
|---|---|---|---|---|---|
| 50 | 195 | 100% | | | |
| 100 | 190 | 100% | | | |
| 200 | 185 | 95% | | | |
| 300 | 180 | 90% | `BeastLaunch` | | |
| 400 | 175 | 90% | | 2% (35 s) | |
| 500 | 170 | 85% | | 3% (30 s) | |
| 600 | 165 | 85% | `MenuMGRemixIn` | 5% (30 s) | |
| 700 | 160 | 80% | | 6% (30 s) | |
| 800 | 155 | 85% | | 7% (30 s) | |
| 900 | 150 | 70% | `BeastIntroScene` | 8% (30 s) | |
| 1000 | 145 | 70% | | 9% (30 s) | |
| 1100 | 140 | 65% | `DrugsDrivingOut` | 10% (30 s) | |
| 1200 | 135 | 65% | | 11% (25 s) | |
| 1300 | 130 | 60% | `ChopVision` | 12% (22 s) | |
| 1400 | 125 | 60% | | 13% (20 s) | |
| 1500 | 120 | 60% | `MenuSurvivalAlienIn` | 14% (17.5 s) | |
| 1600 | 115 | 55% | | 15% (15 s) | |
| 1700 | 110 | 50% | `MP_race_crash` | 16% (12.5 s) | |
| 1800 | 105 | 45% | | 17% (10 s) | |
| 1900 | 100 | 40% | | 18% (15 s) | |
| 2000+ | 95 | 35% | `DeathFailMPIn` | 19% (15 s) | 5% per second, 3 to 15 s |

Only one screen effect runs at a time. When the dose crosses a tier the new effect starts first and the old one stops 1.5 seconds later, so the screen cross-fades. At 0 the last effect runs out. Max health moves one point per second toward the tier value, both down and up.

### Coughing

The character coughs by tier: an animation, a sound (`Config.Sounds`), and the client event `rotd_zones:cough` with the position (zombies can hear it through your own handler, see [Cough](#cough-client)).

### Saving

The dose is stored in the character: `charinfo.radiation` on QB/Qbox, `rotd_player_data` on ESX. The client reports it to the server every `Config.RadiationSyncMs` (5 s, only when it changed), so a hard quit loses at most a few seconds; it is also saved on character logout and when the resource stops.

### Resistance

Resistance is a percentage (0 to 100) that reduces the dose gained and the damage. It comes from:

1. **The clothing table** `Config.RadiationResistance.clothing`: works on any server, even without clothing items. Each entry matches what the ped wears right now.
2. **Inventory items** (`core_inventory`, `ox_inventory`, `qb-inventory`) carrying `metadata.radiationResistance`, **while worn**: the item's clothing metadata (`mID`, `mModel`, `mTexture`, `wID`, ... and the prop keys) matches the ped, or `metadata.equipped` / `metadata.worn` is set.
3. **Modifiers** added by other resources with `AddResistanceModifier` (potions, buffs).

Per clothing slot the best value counts, slots add up, the total is capped by `Config.RadiationResistance.cap` (100 = immune). When the total changes (put on or take off a piece) a notification lists the total and the top pieces. Re-checking every `refreshMs` (3 s).

Fill the clothing table in game with the admin command **`/setradcloth`**: wear a piece, run `/setradcloth mask 25 Gas Mask`. Entries are saved to `data/radiation_clothing.json` (merged with the config table) and pushed to every client.

| `/setradcloth` | Does |
|---|---|
| *(no arguments)* | shows what you wear (drawable / texture per slot) and which pieces are already saved |
| `<mask\|tshirt\|jacket\|pants\|hands\|shoes\|all> <res %> [--tex] [--force] [label]` | saves the current piece(s). `--tex` also matches the texture, `--force` allows drawable 0 |
| `list` | prints every saved entry to the server console |
| `remove <slot\|all>` | removes the saved entries matching what you wear |

Your ped must be `mp_m_freemode_01` or `mp_f_freemode_01`.

### Radiation indicator and feedback

A small indicator at the bottom edge of the screen shows the dose (rolling digits, `+N` / `−N` popups, level name, gain and fade effects, a "Clear" flash at 0) and, in a radiation zone, **`RESISTANCE nn%`**. Damage shows a red screen-edge flash, an indicator flash and a short camera shake, all scaled by the size of the hit.

```lua
Config.RadiationUI = {
    enabled = true,                -- false = no indicator
    style = 'glow',                -- 'glow' (light bloom) | 'strip' (dark strip with faded ends)
    max = 2500, bottom = 0, scale = 1.0, updateMs = 250,
    showResistance = 'zone',       -- 'zone' | 'always' | 'off'
}
Config.RadiationDamageFX = { enabled = true, vignette = true, hudJolt = true, camShake = true, fullAt = 10 }
Config.RadiationDamageScale = 0.1  -- 1.0 = full damage
Config.RadiationSyncMs = 5000
Config.Sounds = true               -- built-in sound player (Geiger loop, cough)
```

Level names: Trace (< 100), Low (< 500), Moderate (< 1000), High (< 1500), Severe (< 2000), Critical (2000+). `/radiation` shows the exact dose and resistance.

## Zone UI

Entering a zone shows a **chip** (zone name, type, radiation). Hold **Left Alt** (key mapping `+zone_details`) for the **detail card**: zombie intensity, types, stats, the zone rules and radiation. The zone colour is shown in words (`Red zone · High danger`) and tints the whole UI.

- **`rotd-hud` running:** its own cards are used (the zone data is sent to it as before).
- **`rotd-hud` not running:** the built-in UI is shown. It follows the HUD live: when the HUD starts or stops, the built-in UI hides or reappears.

```lua
Config.ZoneUI = {
    showName = true, showType = true, showZombieIntensity = true, showZombieClasses = true,
    showRules = true, showRadiation = true, showZombieModifiers = true, showAmbient = false,
    builtin = true,                -- false = no zone UI at all without rotd-hud
    builtinStyle = 'tactical',     -- 'tactical' (corner brackets, default) | 'bar' | 'hex'
    showHint = true,               -- ALT key cap on the chip
}
```

Zombie class names on the card come from `Config.ZombieLabels` and from `RegisterZombieLabels`. A class without a name shows its key in Title Case.

## Guards and infection

Guard NPCs (`Config.Guards`, patrols in `Config.GuardPatrols`, lines in `Config.GuardSpeech`) protect green zones. They can also **detect, question and cure infected players**. `rotd_zones` does not track infection: your disease or medical resource tells it, with `RegisterInfectionDetector` / `SetInfectionState` (client) and handles the cure with `RegisterInfectionCure` (server). Without them the infection checks never trigger. See [Infection and guards](#infection-and-guards-client).

## No-build gate

Base building is blocked near `rotd_blips` landmarks and POIs. Radii come from `Config.NoBuild` (when that table is missing the module logs `config MISSING - using defaults`). Query it with `CanBuildAtCoords`; see [[rotd_blips]].

## Debug commands

`/showzones` (zone blips), `/szdebug` (safezone), `/zonesdebug [key]` (map overlay health), `/ambientdebug`, `/guarddebug`, `/rotd_zone_debug`. For development only.

## Console messages

| Message | Meaning |
|---|---|
| `[rotd_bridge] rotd_zones (client): "Zone card and pause-menu display" is using the built-in zone UI. Start resource "rotd-hud" to use its own UI instead.` | information: no HUD resource, the built-in UI is in use |
| `[rotd_zones][nobuild] module loaded (config MISSING - using defaults)` | `Config.NoBuild` is not defined, defaults apply |
| `[rotd_zones][nobuild] no points indexed, gate is inactive` | no no-build points found (`rotd_blips` not running or no points) |

## Troubleshooting

| Problem | Check |
|---|---|
| Console: `callback 'rotd_zones:getRadResistItems' does not exist` | `server.lua` did not load: look for a parse error above it in the server console |
| No radiation gained in the zone | the zone type must be `radiation` with `RadiationSources` and `Center`; `rotd_bridge` must run first; wait out the login grace (8 s + 8 s ramp) |
| Radiation lost after quitting | update to a version with `Config.RadiationSyncMs`; the dose is saved every few seconds now |
| No resistance from an item | the item needs `metadata.radiationResistance` and must be **worn** (matching clothing metadata or `metadata.equipped`); or use the clothing table / `/setradcloth` |
| New UI not showing / old look | disconnect fully and rejoin: NUI files are cached per connection |
| Zone card missing | `Config.ZoneUI.builtin` is false and `rotd-hud` is not running |

## Exports reference
## Index

| Export | Side | What it does |
|---|---|---|
| `GetZones` | client | all zones |
| `GetZonePlayerin` | client | zone the player is in now |
| `GetCurrentZone` | client | zone card data for the current zone |
| `GetZoneAtCoords` | shared | zone at a position |
| `GetZoneInfoAtCoords` | shared | full zone info at a position |
| `GetZoneSpawnInfoAtCoords` | client | spawn info (classes, peds, multipliers) |
| `CheckCoordsZoneType` | client | zone type for a ped |
| `CheckCoordsZoneTypeCoords` | client | zone summary at a position |
| `CheckCoordsZoneTypeCoordsRules` | shared | rules at a position |
| `IsCoordsInGreenZone` | server | safezone test |
| `IsBaseBuildingAllowedAtCoords` | server | base building rule at a position |
| `GetZoneExtraLoot` | server | extra loot of a zombie class in a zone |
| `CanBuildAtCoords`, `GetNoBuildMessage`, `GetNoBuildInfo`, `IsNoBuildReady` | client | no-build gate near blips / POIs |
| `AddRadiation`, `SetRadiation`, `GetSufferedRadiation`, `GetRadiationDebuffs`, `GetRadiationInfo`, `RadiationZone` | client | radiation dose |
| `GetRadiationResistance`, `AddResistanceModifier`, `RemoveResistanceModifier` | client | radiation resistance |
| `SetPlayerRadiation`, `AddPlayerRadiation`, `GetPlayerRadiation` | server | radiation from server code |
| `RegisterInfectionDetector`, `SetInfectionState` | client | tell the guards a player is infected |
| `RegisterInfectionCure` | server | cure handler for the guard cure |
| `RegisterZombieLabels`, `RegisterZombieLabel`, `GetZombieLabels` | client | zombie names on zone cards |
| `RegisterCoughHandler` | client | react to the player coughing |
| `IsNightTime`, `SetGlobalWeatherAmbient`, `SetGlobalWeatherPostFX` | client | day/night and weather layers |
| `RebuildMapOverlays` | client | redraw the map zone overlays |

## Zones (client)

#### `GetZones()`

Lists every zone that was created. The objects are internal and **read only**.

**Returns** `table`: every created zone.

<details>
<summary>Example</summary>

```lua
for _, zone in pairs(exports.rotd_zones:GetZones()) do
    -- inspect only, do not modify
end
```

</details>

#### `GetZonePlayerin()`

The zone the local player is standing in right now.

**Returns** `table`: `{ key, name, zombie_intensity, type, rules }`. Outside any zone the result has `name = 'None'`, `type = 'None'` and the default rules.

<details>
<summary>Example</summary>

```lua
local zone = exports.rotd_zones:GetZonePlayerin()
print(zone.name, zone.type) -- e.g. "Fort Zancudo", "red"
```

</details>

#### `GetCurrentZone()`

The data the zone card displays for the current zone.

**Returns** `table | nil`: `{ zoneData = {...}, sufferedRadiation, displaySettings }`, or `nil` outside zones.

<details>
<summary>Example</summary>

```lua
local card = exports.rotd_zones:GetCurrentZone()
if card then print('radiation dose', card.sufferedRadiation) end
```

</details>

#### `GetZoneSpawnInfoAtCoords(coords)`

Spawn information for a zombie spawner: which classes may spawn and which ped models each class uses. Loot is deliberately **not** included, see `GetZoneExtraLoot`.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position to look up. |

**Returns** `table | nil`: `{ key, name, type, intensity, classes, peds, noSleep, damageMult, healthMult, armorAdd }`.

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_zones:GetZoneSpawnInfoAtCoords(GetEntityCoords(PlayerPedId()))
if info then
    for _, class in ipairs(info.classes) do print('may spawn', class) end
end
```

</details>

#### `CheckCoordsZoneType(ped)`

Zone type for a ped.

| Parameter | Type | Description |
|---|---|---|
| `ped` | `number` | Ped entity handle. |

**Returns** `string | false`: the zone type (`'red'`, `'yellow'`, `'green'`, `'radiation'`, ...) or `false` outside zones.

<details>
<summary>Example</summary>

```lua
if exports.rotd_zones:CheckCoordsZoneType(PlayerPedId()) == 'green' then
    -- safezone
end
```

</details>

#### `CheckCoordsZoneTypeCoords(coords)`

Short zone summary at a position.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position to look up. |

**Returns** `table | false`: `{ key, name, type, rules, intensity }`, or `false` outside zones.

<details>
<summary>Example</summary>

```lua
local z = exports.rotd_zones:CheckCoordsZoneTypeCoords(coords)
if z then print(z.name, z.intensity) end
```

</details>

## Zones (shared)

Available on both the client and the server.

#### `GetZoneAtCoords(coords)`

Finds the zone at a position. When zones overlap, the one with the highest priority wins.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3 \| table` | Position. A table with `x` and `y` also works. |

**Returns** `table | nil`: `{ key, name, type, rules, intensity, priority }`, or `nil` when no zone matches.

<details>
<summary>Example</summary>

```lua
local zone = exports.rotd_zones:GetZoneAtCoords(vector3(215.0, -810.0, 30.0))
if zone then print(zone.name, zone.priority) end
```

</details>

#### `GetZoneInfoAtCoords(coords)`

Full zone info including the polygon data. The returned fields differ per side.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3 \| table` | Position. |

**Returns** `table | nil`:

| Side | Fields |
|---|---|
| client | `name`, `type`, `rules`, `intensity`, `zombie_classes`, `dimensions`, `points2D`, `points3D` |
| server | `key`, `name`, `type`, `rules`, `intensity`, `dimensions`, `points2D` |

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_zones:GetZoneInfoAtCoords(coords)
if info then print(#info.points2D, 'polygon points') end
```

</details>

#### `CheckCoordsZoneTypeCoordsRules(coords)`

The rules that apply at a position, or the defaults outside any zone.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position. |

**Returns** `table`: booleans `baseBuilding`, `baseRaiding`, `PvP`, `Weapons`, `blackout`, plus any key you add in the config.

<details>
<summary>Example</summary>

```lua
local rules = exports.rotd_zones:CheckCoordsZoneTypeCoordsRules(GetEntityCoords(PlayerPedId()))
if not rules.baseBuilding then print('no building here') end
```

</details>

## Zones (server)

#### `IsCoordsInGreenZone(coords)`

Safezone test.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position. |

**Returns** `boolean`: `true` when the position is inside a green zone.

<details>
<summary>Example</summary>

```lua
local isGreen = exports.rotd_zones:IsCoordsInGreenZone(GetEntityCoords(GetPlayerPed(src)))
```

</details>

#### `IsBaseBuildingAllowedAtCoords(coords)`

Whether the zone at a position allows base building.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position. |

**Returns** three values:

| Position | Type | Description |
|---|---|---|
| 1 | `boolean` | `true` when building is allowed. |
| 2 | `string \| nil` | Zone name. |
| 3 | `string \| nil` | Zone key. |

<details>
<summary>Example</summary>

```lua
local allowed, zoneName = exports.rotd_zones:IsBaseBuildingAllowedAtCoords(coords)
if not allowed then print('blocked by', zoneName) end
```

</details>

#### `GetZoneExtraLoot(zoneKey, class)`

Extra loot a zombie class drops in a zone. Server only so clients cannot touch loot.

| Parameter | Type | Description |
|---|---|---|
| `zoneKey` | `string` | Key in `Config.Zones`. |
| `class` | `string` | Zombie class key. |

**Returns** `table | nil`: the `extraloot` list of that class in that zone.

<details>
<summary>Example</summary>

```lua
local loot = exports.rotd_zones:GetZoneExtraLoot('fort_zancudo', 'military_tank')
```

</details>

## No-build gate (client)

Base building is blocked near `rotd_blips` landmarks and POIs. Radii come from `Config.NoBuild`.

#### `CanBuildAtCoords(coords)`

Checks whether building is allowed at a position.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position. |

**Returns** three values:

| Position | Type | Description |
|---|---|---|
| 1 | `boolean` | `true` when building is allowed. |
| 2 | `string \| nil` | Block reason: `'blip'` or `'poi'`. |
| 3 | `number \| nil` | Distance to the blocking point. |

<details>
<summary>Example</summary>

```lua
local ok, reason, dist = exports.rotd_zones:CanBuildAtCoords(coords)
if not ok then print('blocked by', reason, dist) end
```

</details>

#### `GetNoBuildMessage(reason)`

Player-facing text for a block reason.

| Parameter | Type | Description |
|---|---|---|
| `reason` | `string` | `'blip'` or `'poi'`. |

**Returns** `string`: the text from `Config.NoBuild.Messages`.

<details>
<summary>Example</summary>

```lua
local _, reason = exports.rotd_zones:CanBuildAtCoords(coords)
if reason then print(exports.rotd_zones:GetNoBuildMessage(reason)) end
```

</details>

#### `GetNoBuildInfo(coords)`

Everything about the no-build check in one table.

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Position. |

**Returns** `table`: `{ allowed, reason, distance, message }`.

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_zones:GetNoBuildInfo(coords)
if not info.allowed then print(info.message) end
```

</details>

#### `IsNoBuildReady()`

**Returns** `boolean`: `true` once the point index is built. Wait for it before relying on the other no-build exports.

<details>
<summary>Example</summary>

```lua
while not exports.rotd_zones:IsNoBuildReady() do Wait(250) end
```

</details>

## Radiation (client)

The dose is a number from `0` up (the indicator treats `2500` as full). It lives on the player's client.

#### `AddRadiation(amount, applyResist, pierce)`

Adds a dose. Use this for doses coming from other resources: it applies resistance for you and is safe next to the zone and decay loops (it adds a delta).

| Parameter | Type | Description |
|---|---|---|
| `amount` | `number` | Dose to add. Ignored when `0` or less. |
| `applyResist` | `boolean?` | `false` ignores clothing resistance. Default applies it. |
| `pierce` | `number?` | `0` to `1`, the share of the resistance this dose ignores. `0.3` means a 20% resistance only resists 14%. |

**Returns** `number`: the new total dose.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:AddRadiation(25.0)             -- resisted by clothing
exports.rotd_zones:AddRadiation(25.0, false)      -- raw dose, ignores resistance
exports.rotd_zones:AddRadiation(25.0, true, 0.3)  -- a bite: ignores 30% of the resistance
```

</details>

#### `SetRadiation(value)`

Sets the absolute dose. For cures and admin tools.

| Parameter | Type | Description |
|---|---|---|
| `value` | `number` | The new dose. |

**Returns** `number`: the dose after the change.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:SetRadiation(0) -- fully cured
```

</details>

#### `GetSufferedRadiation()`

**Returns** `number`: the current dose.

<details>
<summary>Example</summary>

```lua
if exports.rotd_zones:GetSufferedRadiation() > 1000 then
    -- heavily irradiated
end
```

</details>

#### `GetRadiationInfo()`

**Returns** `table`: `{ dose, resistance, inRadiationZone, maxHealth, maxStamina }`.

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_zones:GetRadiationInfo()
print(info.dose, info.resistance, info.inRadiationZone)
```

</details>

#### `GetRadiationDebuffs()`

**Returns** `table`: `{ maxhealth, maxstamina }`, the limits of the current radiation tier.

<details>
<summary>Example</summary>

```lua
local d = exports.rotd_zones:GetRadiationDebuffs()
print(d.maxhealth, d.maxstamina)
```

</details>

#### `RadiationZone(inside, zonedata)`

> **Internal.** Starts or stops the zone dose loop. The zone detection calls it, you normally never do.

| Parameter | Type | Description |
|---|---|---|
| `inside` | `boolean` | Whether the player is inside a radiation zone. |
| `zonedata` | `table` | The zone data. |

**Returns** nothing.

#### `GetRadiationResistance()`

Resistance is a percentage (`0` to `100`). It comes from worn clothing (`Config.RadiationResistance.clothing`, entries saved by `/setradcloth`, inventory items with `metadata.radiationResistance`) plus the modifiers below.

**Returns** `number`: `0` up to `Config.RadiationResistance.cap`.

<details>
<summary>Example</summary>

```lua
print(('resisting %d%%'):format(exports.rotd_zones:GetRadiationResistance()))
```

</details>

#### `AddResistanceModifier(id, percent, label)`

Adds a temporary resistance bonus. It counts like a clothing slot: summed with the rest and capped.

| Parameter | Type | Description |
|---|---|---|
| `id` | `string` | Any id you choose. Using the same id again replaces its value. |
| `percent` | `number` | Resistance in percent. |
| `label` | `string` | Name shown in the resistance notification. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
-- an anti-radiation pill: +30% for 5 minutes
exports.rotd_zones:AddResistanceModifier('antirad_pill', 30, 'Anti-Rad Pill')
SetTimeout(5 * 60000, function() exports.rotd_zones:RemoveResistanceModifier('antirad_pill') end)
```

</details>

#### `RemoveResistanceModifier(id)`

| Parameter | Type | Description |
|---|---|---|
| `id` | `string` | The id used in `AddResistanceModifier`. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:RemoveResistanceModifier('antirad_pill')
```

</details>

## Radiation (server)

#### `SetPlayerRadiation(src, value)`

Sets the dose on that player's client.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `value` | `number` | The new dose. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:SetPlayerRadiation(src, 0)
```

</details>

#### `AddPlayerRadiation(src, amount, applyResistance, pierce)`

Adds a dose to a player. Resistance is applied unless `applyResistance == false`.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `amount` | `number` | Dose to add. |
| `applyResistance` | `boolean?` | `false` ignores resistance. |
| `pierce` | `number?` | `0` to `1`, share of resistance ignored. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:AddPlayerRadiation(src, 120.0) -- e.g. a grenade
```

</details>

#### `GetPlayerRadiation(src)`

The last dose the client saved. It is saved every few minutes, on logout and on resource stop, so it can **lag behind**. Stored in `charinfo.radiation` on QB/Qbox and in `rotd_player_data` on ESX.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `number`: the last saved dose.

<details>
<summary>Example</summary>

```lua
local saved = exports.rotd_zones:GetPlayerRadiation(src)
```

</details>

## Infection and guards (client)

Guard NPCs in green zones can detect, investigate and cure infected players. `rotd_zones` does not track infection itself. The medical/disease resource connects it with **one detection export (client)** and **one cure export (server)**. With neither registered the guard infection checks simply never trigger.

Use **one** of the two detection exports.

#### `RegisterInfectionDetector(fn)`

Registers a function that is called about once a second. Errors inside `fn` are ignored.

| Parameter | Type | Description |
|---|---|---|
| `fn` | `function` | Returns the infection state table described below. |

`fn` returns:

| Field | Type | Description |
|---|---|---|
| `infected` | `boolean` | Whether the player is infected. |
| `level` | `number` | Infection level, `0` = none. Guards escalate with the level (an escort joins at `7` and up). |
| `immune` | `boolean` | Immune players are ignored. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
-- client (wasabi_ambulance example)
exports.rotd_zones:RegisterInfectionDetector(function()
    return {
        infected = exports.wasabi_ambulance:IsInfected() and true or false,
        level    = exports.wasabi_ambulance:GetInfectionLevel() or 0,
        immune   = exports.wasabi_ambulance:IsImmune() and true or false,
    }
end)
```

</details>

> Register again in the client event `rotd_zones:ready` so a restart of `rotd_zones` does not lose the registration.

#### `SetInfectionState(state)`

Push-style alternative: send the same table whenever it changes.

| Parameter | Type | Description |
|---|---|---|
| `state` | `table` | `{ infected, level, immune }`, same as above. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:SetInfectionState({ infected = true, level = 4, immune = false })
```

</details>

## Infection cure (server)

#### `RegisterInfectionCure(fn)`

Registers the handler that runs when a guard finishes curing a player. Requests are limited to one per 20 seconds per player. Afterwards the player's client is told to clear any pushed infection state. The server event `rotd_zones:infectionCured` (`src`) also fires, for resources that prefer events.

| Parameter | Type | Description |
|---|---|---|
| `fn` | `function` | `fn(src)`, called with the cured player's server id. |

**Returns** `number`: how many handlers are registered.

<details>
<summary>Example</summary>

```lua
-- server
exports.rotd_zones:RegisterInfectionCure(function(src)
    exports.wasabi_ambulance:CureInfection(src)
end)
```

</details>

## Zombie names on zone cards (client)

Zone cards show player-facing names instead of class keys such as `military_tank`. The map is `class id -> display name`:

```lua
-- key   = class id used in a zone's zombie_classes list (Config.Zones[...].zombie_classes)
-- value = the name the player sees
{
    normal        = 'Walker',
    sprinter      = 'Runner',
    military_tank = 'Juggernaut',
    rad_beamer    = 'Radiation Beamer',
}
```

A class without a name shows its key in Title Case. Static names can also go in `Config.ZombieLabels`.

#### `RegisterZombieLabels(map)`

Registers many names at once. Existing keys are overwritten, others kept.

| Parameter | Type | Description |
|---|---|---|
| `map` | `table` | `{ [classKey] = 'Display name' }`. |

**Returns** `number`: how many entries were accepted.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:RegisterZombieLabels({ normal = 'Walker', sprinter = 'Runner' })
```

</details>

#### `RegisterZombieLabel(class, label)`

| Parameter | Type | Description |
|---|---|---|
| `class` | `string` | Class key. |
| `label` | `string` | Display name. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:RegisterZombieLabel('military_tank', 'Juggernaut')
```

</details>

#### `GetZombieLabels()`

**Returns** `table`: a copy of the label table.

<details>
<summary>Example</summary>

```lua
local labels = exports.rotd_zones:GetZombieLabels()
print(labels.normal)
```

</details>

## Cough (client)

When radiation makes the player cough, other resources can react (for example zombies hear it). The client event `rotd_zones:cough` carries `coords` (`vector3`).

#### `RegisterCoughHandler(callback)`

| Parameter | Type | Description |
|---|---|---|
| `callback` | `function` | `callback(coords)` runs on every cough. Errors are ignored. |

**Returns** `number`: how many handlers are registered.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:RegisterCoughHandler(function(coords)
    print('cough at', coords)
end)
```

</details>

## Environment (client)

#### `IsNightTime()`

**Returns** `boolean`: `true` from 20:00 to 06:00 game time.

<details>
<summary>Example</summary>

```lua
if exports.rotd_zones:IsNightTime() then
    -- night behaviour
end
```

</details>

#### `SetGlobalWeatherAmbient(mod, instant)`

Sets the map-wide timecycle layer. A zone's own ambient wins over it.

| Parameter | Type | Description |
|---|---|---|
| `mod` | `string \| nil` | Timecycle modifier name, or `nil` to clear. |
| `instant` | `boolean?` | `true` skips the cross-fade. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:SetGlobalWeatherAmbient('REDMIST', false)
exports.rotd_zones:SetGlobalWeatherAmbient(nil)  -- clear
```

</details>

#### `SetGlobalWeatherPostFX(list)`

Replaces the map-wide post FX set. Effects no longer listed are stopped. Radiation effects are never touched.

| Parameter | Type | Description |
|---|---|---|
| `list` | `string[]` | Array of effect names. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:SetGlobalWeatherPostFX({ 'DrugsMichaelAliensFight' })
```

</details>

#### `RebuildMapOverlays()`

Redraws every zone's map overlay from `Config.Zones`. Call it after changing zones at runtime.

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_zones:RebuildMapOverlays()
```

</details>

## Events

| Event | Side | Payload | When |
|---|---|---|---|
| `rotd_zones:ready` | client | none | `rotd_zones` has started (register names, detectors here) |
| `rotd_zones:enteredZone` | client | `{ key, name, type, rules }` | player enters a zone |
| `rotd_zones:exitedZone` | client | `{ key, name, type }` | player leaves all zones |
| `rotd_zones:cough` | client | `coords` | radiation cough |
| `rotd_zones:infectionCured` | server | `src` | a guard cured a player |
| `rotd_zones:setradiation` | client | `value` | server sets the dose (used by `SetPlayerRadiation`) |
| `rotd_zones:addradiation` | client | `amount, applyResist, pierce` | server adds a dose (used by `AddPlayerRadiation`) |

```lua
-- client: react to zones
AddEventHandler('rotd_zones:enteredZone', function(zone)
    print('entered', zone.name, zone.type, zone.rules.PvP)
end)
AddEventHandler('rotd_zones:exitedZone', function(zone) print('left', zone.name) end)
```

> **Removed.** Older versions had a server net event `rotd_zones:setradiation` that any client could use to set another player's radiation. Use the admin command `/setradiation` or the server exports `SetPlayerRadiation` / `AddPlayerRadiation`.

## Commands

| Command | Who | What |
|---|---|---|
| `/radiation` | everyone | shows your dose (and resistance) |
| `+zone_details` (key mapping, Left Alt) | everyone | zone detail card |
| `/setradiation [id] <level>` | admin | sets a player's dose (0 to 2500; no id = yourself) |
| `/setradcloth ...` | admin | saves what you wear as radiation clothing, see [Resistance](#resistance) |
| `/zonebuilder`, `/zbadd`, `/zbundo`, `/zbdel`, `/zbins`, `/zblist`, `/zbname`, `/zbtype`, `/zbdraw`, `/zbdone`, `/zbclear` | admin | polygon zone builder, see [Zone builder](#zone-builder-admin) |
| `/bakezones` | admin | bakes the water mask into `data/waterbake.json` |
| `/showzones`, `/szdebug`, `/zonesdebug [key]`, `/ambientdebug`, `/guarddebug`, `/rotd_zone_debug` | development | debug helpers |

## Configuration pointers

`config.lua`: `Config.Zones`, `Config.ZoneUI`, `Config.RadiationUI`, `Config.RadiationDamageFX`, `Config.RadiationDamageScale`, `Config.RadiationSyncMs`, `Config.RadiationGraceMs`, `Config.RadiationRampMs`, `Config.RadiationResistance`, `Config.ZombieLabels`, `Config.Sounds`, `Config.PropSafety`, `Config.MapOverlay`, `Config.BlackoutInteriorLight`, `Config.Guards`, `Config.GuardPatrols`, `Config.GuardSpeech`, `Config.weaponsDamage`, `Config.NoBuild` (optional). See the guide sections above for what each does.

## Data shapes

### Zone types

`'red'`, `'yellow'`, `'orange'`, `'green'` (safezone), `'radiation'`, `'death'`, `'white'`, `'gray'`, `'cyan'`.

### Rules table

```lua
{ baseBuilding = true, baseRaiding = true, PvP = true, Weapons = true, blackout = false }   -- booleans
-- outside any zone the default rules are returned (every rule true on the client)
```

### Zone info (`GetZoneAtCoords`)

```lua
{ key = 'AirportSafeZone', name = 'Airport Safe Zone', type = 'green', rules = { ... }, intensity = 0.0, priority = 10 }   -- key = the Config.Zones table key
```

### Spawn info (`GetZoneSpawnInfoAtCoords`, client)

```lua
{
    key = '<Config.Zones key>', name = 'Military Base', type = 'red', intensity = 5.0,
    classes = { 'normal', 'tank', 'shunter' },                 -- allowed zombie classes
    peds = { normal = { `a_m_m_skater_01` }, tank = { ... } }, -- ped models per class
    noSleep = false, damageMult = 1.8, healthMult = 2.5, armorAdd = 25,
}
```

### Zone card data (`GetCurrentZone`, client)

```lua
{
    zoneData = {
        name = 'Military Base', type = 'red', zombie_intensity = 5.0,
        zombie_classes = { 'normal', 'tank' }, zombie_class_labels = { 'Walker', 'Juggernaut' },
        zombie_damage_mult = 1.8, zombie_health_mult = 2.5, zombie_armor_add = 25,
        rules = { ... }, radiation = nil,       -- radiation = dose, only in radiation zones
    },
    sufferedRadiation = 340,                    -- nil when 0
    displaySettings = { showName = true, showType = true, ... },   -- Config.ZoneUI
}
```

### `GetRadiationInfo` (client)

```lua
{ dose = 340.5, resistance = 35, inRadiationZone = true, maxHealth = 180, maxStamina = 0.9 }
```

### Radiation clothing entry (`Config.RadiationResistance.clothing`, also `data/radiation_clothing.json`)

```lua
{ slot = 'mask', drawable = 175, texture = nil, gender = nil, res = 5, label = 'Dust Filtered Mask' }
--  slot      mask | hat | glasses | ear | torso | jacket | tshirt | pants | hands | shoes | vest | accessory | decals | bag | watch | bracelet
--            (or comp = <component id> / prop = <prop id> instead of slot)
--  drawable  number or { numbers };  texture  number, { numbers } or nil = any;  gender  0 male / 1 female / nil = both
```

### Infection detector result

```lua
{ infected = true, level = 4, immune = false }    -- level 0 = none; an escort guard joins at level 7 and up
```

## Recipes

### Radiation grenade (server + client)

```lua
-- server: irradiate everyone inside 15 m
local function radiationBlast(coords)
    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        local ped = GetPlayerPed(src)
        if #(GetEntityCoords(ped) - coords) < 15.0 then
            exports.rotd_zones:AddPlayerRadiation(src, 150.0)          -- resistance is applied on the client
        end
    end
end

-- client: a bite that slips through the suit (ignores 30% of the resistance)
exports.rotd_zones:AddRadiation(40.0, true, 0.3)
```

### Anti-radiation pill (client)

```lua
RegisterNetEvent('mypills:client:antirad', function()
    exports.rotd_zones:AddResistanceModifier('antirad_pill', 30, 'Anti-Rad Pill')
    SetTimeout(5 * 60000, function()
        exports.rotd_zones:RemoveResistanceModifier('antirad_pill')
    end)
end)

-- cure item: remove the dose
RegisterNetEvent('mypills:client:radaway', function()
    exports.rotd_zones:SetRadiation(0.0)
end)
```

### React to zones (client)

```lua
AddEventHandler('rotd_zones:enteredZone', function(zone)
    if zone.type == 'green' then
        print('safezone, weapons allowed:', zone.rules.Weapons)
    end
end)
AddEventHandler('rotd_zones:exitedZone', function(zone) print('left', zone.name) end)

-- the zone the player is in right now
local zone = exports.rotd_zones:GetZonePlayerin()          -- zone.type == 'None' outside every zone
```

### Base building checks

```lua
-- server (authoritative)
RegisterNetEvent('mybase:server:place', function(coords)
    local src = source
    local allowed, zoneName = exports.rotd_zones:IsBaseBuildingAllowedAtCoords(coords)
    if not allowed then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = ('No building in %s'):format(zoneName or 'this zone') })
        return
    end
    -- place it
end)

-- client (for a nice preview colour)
local ok, reason, distance = exports.rotd_zones:CanBuildAtCoords(GetEntityCoords(PlayerPedId()))
if not ok then print(exports.rotd_zones:GetNoBuildMessage(reason)) end
```

### Connect a disease resource (infection guards)

```lua
-- client: the guards read this about once a second
exports.rotd_zones:RegisterInfectionDetector(function()
    local lvl = MyDisease.GetLevel()                       -- your own function
    return { infected = lvl > 0, level = lvl, immune = MyDisease.IsImmune() }
end)

-- server: the guard cured the player
exports.rotd_zones:RegisterInfectionCure(function(src)
    MyDisease.Cure(src)                                    -- your own function
end)

-- keep it registered after a restart of rotd_zones
AddEventHandler('rotd_zones:ready', function()
    exports.rotd_zones:RegisterInfectionDetector(function() ... end)
end)
```

### Register zombie names and react to coughs (client)

```lua
local function register()
    exports.rotd_zones:RegisterZombieLabels({
        normal = 'Walker', sprinter = 'Runner', tank = 'Juggernaut',
        military_tank = 'Military Juggernaut', rad_beamer = 'Radiation Beamer',
    })
    exports.rotd_zones:RegisterCoughHandler(function(coords)
        -- make noise at coords for your zombie AI
    end)
end
AddEventHandler('rotd_zones:ready', register)
CreateThread(function() Wait(1000) register() end)   -- in case rotd_zones started first
```

### Night-aware events

```lua
if exports.rotd_zones:IsNightTime() then
    -- spawn the night variant
end
```
