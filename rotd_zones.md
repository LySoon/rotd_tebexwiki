# rotd_zones

Everything other resources and server developers can use. Call exports with `exports.rotd_zones:Name(...)` (or `exports['rotd_zones']:Name(...)`).

**Side** tells you where to call it: **client** = from a client script, **server** = from a server script.
`rotd_zones` depends on no zombie, medical, HUD or sound resource. Anything that needs outside data (zombie names, infection state, cure, cough reactions) is a registration export below.

## Index

| Export | Side | What it does |
|---|---|---|
| `GetZones` | client | all zones |
| `GetZonePlayerin` | client | zone the player is in now |
| `GetCurrentZone` | client | zone card data for the current zone |
| `GetZoneAtCoords` | client, server | zone at a position |
| `GetZoneInfoAtCoords` | client, server | full zone info at a position |
| `GetZoneSpawnInfoAtCoords` | client | spawn info (classes, peds, multipliers) |
| `CheckCoordsZoneType` | client | zone type for a ped |
| `CheckCoordsZoneTypeCoords` | client | zone summary at a position |
| `CheckCoordsZoneTypeCoordsRules` | client, server | rules at a position |
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

---

## Zones

### `GetZones()` (client)
- **Returns:** `table` of every created zone (internal zone objects, read only).

### `GetZonePlayerin()` (client)
- **Returns:** `table` `{ key, name, zombie_intensity, type, rules }` for the zone the player is in. Outside any zone: `name = 'None'`, `type = 'None'`, default rules.

### `GetCurrentZone()` (client)
- **Returns:** `table|nil` the data the zone card shows: `{ zoneData = {...}, sufferedRadiation, displaySettings }`, or `nil` outside zones.

### `GetZoneAtCoords(coords)` (client and server)
- **Input:** `coords` (vector3, or any table with `x`, `y`)
- **Returns:** `table|nil` `{ key, name, type, rules, intensity, priority }`. Overlapping zones: the highest priority wins.

### `GetZoneInfoAtCoords(coords)` (client and server)
- **Returns:** `table|nil` zone info with polygon data. Client: `{ name, type, rules, intensity, zombie_classes, dimensions, points2D, points3D }`. Server: `{ key, name, type, rules, intensity, dimensions, points2D }`.

### `GetZoneSpawnInfoAtCoords(coords)` (client)
- **Returns:** `table|nil` `{ key, name, type, intensity, classes, peds, noSleep, damageMult, healthMult, armorAdd }`. Meant for a zombie spawner: allowed classes plus ped models per class. Loot is deliberately not included, see `GetZoneExtraLoot`.

### `CheckCoordsZoneType(ped)` (client)
- **Returns:** `string|false` zone type (`'red'`, `'yellow'`, `'green'`, `'radiation'`, ...) or `false`.

### `CheckCoordsZoneTypeCoords(coords)` (client)
- **Returns:** `table|false` `{ key, name, type, rules, intensity }` or `false`.

### `CheckCoordsZoneTypeCoordsRules(coords)` (client and server)
- **Returns:** `table` the zone's rules, or the defaults outside any zone. Rules are booleans: `baseBuilding`, `baseRaiding`, `PvP`, `Weapons`, `blackout` (plus any key you add in config).

### `IsCoordsInGreenZone(coords)` (server)
- **Returns:** `boolean`

### `IsBaseBuildingAllowedAtCoords(coords)` (server)
- **Returns:** `boolean allowed`, `string|nil zoneName`, `string|nil zoneKey`

### `GetZoneExtraLoot(zoneKey, class)` (server)
- **Input:** `zoneKey` (key in `Config.Zones`), `class` (zombie class key)
- **Returns:** `table|nil` the `extraloot` list of that class in that zone. Server only so clients cannot touch loot.

---

## No-build gate (client)

Base building is blocked near rotd_blips landmarks and POIs. Radii come from `Config.NoBuild`.

- `CanBuildAtCoords(coords)` returns `boolean allowed`, `string|nil reason` (`'blip'` / `'poi'`), `number|nil distance`
- `GetNoBuildMessage(reason)` returns `string` (player-facing text from `Config.NoBuild.Messages`)
- `GetNoBuildInfo(coords)` returns `{ allowed, reason, distance, message }`
- `IsNoBuildReady()` returns `boolean` (the point index is built)

---

## Radiation (client)

The dose is a number from 0 up (the indicator treats 2500 as full). It lives on the player's client.

### `AddRadiation(amount, applyResist, pierce)`
- **Input:** `amount` (number, ignored if 0 or less), `applyResist` (boolean, `false` ignores clothing resistance), `pierce` (0 to 1, share of the resistance this dose ignores; `0.3` means a 20% resistance only resists 14%)
- **Returns:** `number` the new total
- Use this for doses from other resources. It applies resistance for you, and it is safe next to the zone and decay loops (it adds a delta).

### `SetRadiation(value)`
- Sets the absolute dose (cures, admin tools). **Returns:** `number`

### `GetSufferedRadiation()`
- **Returns:** `number` current dose.

### `GetRadiationInfo()`
- **Returns:** `{ dose, resistance, inRadiationZone, maxHealth, maxStamina }`

### `GetRadiationDebuffs()`
- **Returns:** `{ maxhealth, maxstamina }` the current tier limits.

### `RadiationZone(inside, zonedata)`
- Internal: starts/stops the zone dose loop. Called by the zone detection, you normally never call it.

### Resistance
Resistance is a percentage (0 to 100). It comes from worn clothing (`Config.RadiationResistance.clothing`, entries saved by `/setradcloth`, inventory items with `metadata.radiationResistance`) plus modifiers below.

- `GetRadiationResistance()` returns `number` (0 to `Config.RadiationResistance.cap`)
- `AddResistanceModifier(id, percent, label)` returns `boolean`. `id` is any string you choose, `label` shows in the resistance notification. The same id replaces its value. It counts like a clothing slot: summed with the rest and capped.
- `RemoveResistanceModifier(id)` returns `boolean`

```lua
-- an anti-radiation pill: +30% for 5 minutes
exports.rotd_zones:AddResistanceModifier('antirad_pill', 30, 'Anti-Rad Pill')
SetTimeout(5 * 60000, function() exports.rotd_zones:RemoveResistanceModifier('antirad_pill') end)
```

---

## Radiation (server)

- `SetPlayerRadiation(src, value)` returns `boolean`: sets the dose on that player's client.
- `AddPlayerRadiation(src, amount, applyResistance, pierce)` returns `boolean`: adds a dose (resistance applied unless `applyResistance == false`).
- `GetPlayerRadiation(src)` returns `number`: the last dose the client saved (every few minutes, on logout and on resource stop), so it can lag behind. Stored in `charinfo.radiation` on QB/Qbox and in `rotd_player_data` on ESX.

---

## Infection and guards

Guard NPCs in green zones can detect, investigate and cure infected players. `rotd_zones` does not track infection itself. The medical/disease resource connects it with one detection export (client) and one cure export (server). With neither registered the guard infection checks simply never trigger.

### Detection (client): use ONE of the two

**`RegisterInfectionDetector(fn)`**: `fn()` is called about once a second and returns:

```lua
{
    infected = true,   -- boolean, is the player infected
    level    = 4,      -- number, infection level; 0 = none; guards escalate with the level (an escort joins at 7 and up)
    immune   = false,  -- boolean, immune players are ignored
}
```
Returns `boolean`. Errors inside `fn` are ignored.

**`SetInfectionState(state)`**: push the same table whenever it changes. Returns `boolean`.

### Cure (server)

**`RegisterInfectionCure(fn)`**: `fn(src)` is called when a guard finishes curing a player. Returns the number of registered handlers. Requests are limited to one per 20 seconds per player. Afterwards the player's client is told to clear any pushed infection state.

The server event `rotd_zones:infectionCured` (`src`) also fires, for resources that prefer events.

```lua
-- wasabi_ambulance example
-- client
exports.rotd_zones:RegisterInfectionDetector(function()
    return {
        infected = exports.wasabi_ambulance:IsInfected() and true or false,
        level    = exports.wasabi_ambulance:GetInfectionLevel() or 0,
        immune   = exports.wasabi_ambulance:IsImmune() and true or false,
    }
end)
-- server
exports.rotd_zones:RegisterInfectionCure(function(src)
    exports.wasabi_ambulance:CureInfection(src)
end)
```
Register again in the client event `rotd_zones:ready` so a restart of `rotd_zones` does not lose the registration.

---

## Zombie names on zone cards (client)

Zone cards show player-facing names instead of class keys such as `military_tank`.

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

- `RegisterZombieLabels(map)` returns `number` accepted. Existing keys are overwritten, others kept.
- `RegisterZombieLabel(class, label)` returns `boolean`
- `GetZombieLabels()` returns a copy of the table

---

## Cough (client)

When radiation makes the player cough, other resources can react (for example zombies hear it).

- Event `rotd_zones:cough` with `coords` (vector3)
- `RegisterCoughHandler(callback)` returns `number` of handlers. `callback(coords)` runs on every cough, errors are ignored.

---

## Environment (client)

- `IsNightTime()` returns `boolean` (true from 20:00 to 06:00 game time)
- `SetGlobalWeatherAmbient(mod, instant)`: sets the map-wide timecycle layer. `mod` is a timecycle modifier name (string) or `nil` to clear; a zone's own ambient wins over it. `instant = true` skips the cross-fade.
- `SetGlobalWeatherPostFX(list)`: replaces the map-wide post FX set. `list` is an array of effect names; effects no longer listed are stopped. Radiation effects are never touched.
- `RebuildMapOverlays()`: redraws every zone's map overlay from `Config.Zones` (call after changing zones at runtime).

---

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

Note: the net event `rotd_zones:setradiation` (server) from older versions still exists and lets any client set another player's radiation. Prefer the server exports above; the event is kept only for compatibility.

---

## Commands

| Command | Who | What |
|---|---|---|
| `/radiation` | everyone | shows your dose (and resistance) |
| `/setradiation [id] <level>` | admin | sets a player's dose (0 to 2500) |
| `/setradcloth ...` | admin | saves what you wear as radiation clothing (`list`, `remove`, see `Config.RadiationResistance`) |
| `+zone_details` (key mapping, Left Alt) | everyone | zone detail card |

## Configuration pointers

`config.lua`: `Config.Zones`, `Config.ZoneUI` (built-in zone UI: `builtin`, `builtinStyle`, `showHint`), `Config.RadiationUI` (indicator style, position, `showResistance`), `Config.RadiationDamageFX`, `Config.RadiationDamageScale`, `Config.RadiationResistance`, `Config.ZombieLabels`, `Config.NoBuild`, `Config.Sounds`.

---

## Examples

```lua
-- client: react to zones
AddEventHandler('rotd_zones:enteredZone', function(zone)
    print('entered', zone.name, zone.type, zone.rules.PvP)
end)
AddEventHandler('rotd_zones:exitedZone', function(zone) print('left', zone.name) end)

-- client: is building allowed where the player stands?
local rules = exports.rotd_zones:CheckCoordsZoneTypeCoordsRules(GetEntityCoords(PlayerPedId()))
if not rules.baseBuilding then print('no building here') end

-- client: give radiation from your own source (resistance is applied for you)
exports.rotd_zones:AddRadiation(25.0)             -- resisted by clothing
exports.rotd_zones:AddRadiation(25.0, false)      -- raw dose, ignores resistance
exports.rotd_zones:AddRadiation(25.0, true, 0.3)  -- a bite: ignores 30% of the resistance

-- server: irradiate a player (e.g. a grenade) and read the last saved dose
exports.rotd_zones:AddPlayerRadiation(src, 120.0)
local saved = exports.rotd_zones:GetPlayerRadiation(src)

-- client: temporary resistance (an anti-radiation pill)
exports.rotd_zones:AddResistanceModifier('antirad_pill', 30, 'Anti-Rad Pill')
SetTimeout(5 * 60000, function() exports.rotd_zones:RemoveResistanceModifier('antirad_pill') end)

-- server: is this spot a safezone? may the player build here?
local isGreen = exports.rotd_zones:IsCoordsInGreenZone(GetEntityCoords(GetPlayerPed(src)))
local allowed, zoneName = exports.rotd_zones:IsBaseBuildingAllowedAtCoords(coords)
```
