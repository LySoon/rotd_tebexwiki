# rotd_events

Server-run world events: a hostile armoured vehicle patrols the map, a destroyed vehicle drops loot crates. Only the helicopter event is enabled in the default config; the APC and tank events are in the code and the config, commented out.

Needs `ox_lib` and `rotd_bridge`. Optional: `rotd_zones` (night check for the searchlight). Loot crates use a stash on the inventory that `rotd_bridge` detected (`core_inventory`, `ox_inventory` or `qb-inventory`).

## Server exports

#### `GetActiveVehicles()`

Lists the vehicles the event system currently owns. `vehicle_spawner` uses it so its cleanup sweep leaves them alone.

**Returns** `number[]`: entity handles of the helicopter and ground vehicle the event system owns, or an empty table.

<details>
<summary>Example</summary>

```lua
local keep = {}
for _, veh in ipairs(exports.rotd_events:GetActiveVehicles()) do keep[veh] = true end
```

</details>

## Callback

#### `eventsystem:server:GetActiveEvent` (client to server, `lib.callback`)

Gives the running event, for your own UI.

**Returns** `table|nil`: `{ name = 'heli', data = <the Config.Events entry>, timeLeft = <milliseconds> }`, or `nil` when no event runs.

<details>
<summary>Example</summary>

```lua
local event = lib.callback.await('eventsystem:server:GetActiveEvent', false)
if event then
    print(event.name, math.floor(event.timeLeft / 1000) .. ' s left')
end
```

</details>

## Events

| Event | Side | Payload | Notes |
|---|---|---|---|
| `eventsystem:client:StartEvent` | client | `name`, `data`, `timeLeft` (ms) | sent to every player when an event starts, and once to a player who joins while one runs |
| `eventsystem:client:StopEvent` | client | none | the event ended or was stopped |
| `eventsystem:server:StopEvent` | server | none | stops the running event and cleans up. **Admins only** when triggered from a client; the server console and other server resources can trigger it freely |

```lua
-- stop the event from another server script
TriggerEvent('eventsystem:server:StopEvent')

-- react to an event on the client
RegisterNetEvent('eventsystem:client:StartEvent', function(name, data, timeLeft)
    print(('event %s started, %d s'):format(name, timeLeft / 1000))
end)
```

The other `eventsystem:server:*` events (`HeliAggro`, `HeliSearchlight`, `EventGunfire`, `HeliCrashed`, `GroundDestroyed`, `GiveLoot`, ...) are used between the resource's own client and server. They are checked on the server, but they are not an API: do not call them from your scripts.

## Command

`/event` (client): shows the event card for the running event: name, details, tips and time left.

## Config: `config.lua`

#### Scheduling

```lua
Config = {
    cooldown = 10,        -- minutes after an event that actually ran
    abortCooldown = 2,    -- minutes after a cancelled event; 0 disables
    LootOpenRadius = 40.0,-- metres a player must be within to open a crate (checked on the server)
    testmode = true,      -- true = start events back to back; false = start on 10-minute real-time marks
}
```

Set `testmode = false` on a live server.

#### Event definition (`Config.Events[<key>]`)

```lua
['heli'] = {
    label = 'Helicopter Assault',
    details = 'Hostile helicopters patrol the area. Engage or evade.',
    tips = 'Tip1 | Tip2 | Tip3',          -- split on "|"
    activetime = 30,                       -- minutes
    image = 'https://...',
    startlocations = { vector4(x, y, z, heading), ... },
    models = {
        ['valkyrie'] = {
            vision = 300, hp = 1000, armor = 1000, regen = 5, speed = 30.0, colour = 1,
            agression = { gun = true, damage = true, fullagro = false },
            destroyptfx = { dict = 'none', particle = 'none' },
            seats = { { seat = 1, model = 's_m_y_marine_01', weapon = 'WEAPON_MILITARYRIFLE', hp = 300, armor = 100 } },
            objects = { <crates, see below> },
        },
    },
}
```

Ground events (`apc`, `tank`) use `driverModel`, a `turret = true` flag on one seat (the gunner), `speed` in m/s and the same `objects`. The tank has a single seat and uses the driver as its gunner, so `seats = {}`.

#### Loot crate (`models[...].objects[]`)

```lua
{
    prop = 'gr_prop_gr_rsply_crate04b',
    offset = vector3(4.0, 0.0, 0.0),     -- from the wreck
    rewards = {
        { name = 'rifle_ammo', chance = 70, min = 30, max = 60 },
        { name = 'weapon_pistol', chance = 75, max = 1, metadata = { ammo = 60, durability = 80 } },
    },
}
```

`chance` is a percentage per entry. Amount: `max = 1` gives exactly 1; with both `min` and `max` it is rolled between them; with only `max` it is `max`; with neither it is 1. `metadata` is passed to the inventory item. The shipped config has six crates per model: Weapons, Medical, Crafting, Metal and Engineering, Food, Valuables.

#### Tuning tables

| Table | What it controls |
|---|---|
| `Config.HeliZombieFire` | door gun fire at zombies: range, bursts, damage, accuracy, tracer |
| `Config.HeliTurret` | door guns against players: range, cooldown, simultaneous targets, burst, damage, accuracy, retaliation |
| `Config.EventRockets` | rocket line of sight and interior checks |
| `Config.HeliFlight` | cruise height, landing radius, speed, turbulence, collision proofing, recovery from landing |
| `Config.HeliSearchlight` | mode (`scripted`, `native`, `auto`), night only, tracking, sweep, beam shape and colour |
| `Config.EventRepair` | slow vehicle repair per tick (crews are never healed, destroyed vehicles are never repaired) |
| `Config.EventGunfireAudio` | range and cap of the gunfire replayed for nearby players |
| `Config.ApcTurret`, `ApcPatrol`, `ApcBlip`, `ApcObstacle`, `ApcStuck` | APC turret, patrol area, blip, obstacle handling, stuck recovery |
| `Config.TankTurret`, `TankPatrol`, `TankBlip`, `TankObstacle`, `TankStuck` | the same for the tank |
| `Config.HeliStuck` | stuck detection for the helicopter |

Each table is documented line by line in `config.lua`.

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| `rotd_zones` | `IsNightTime` for the searchlight when `OnlyAtNight` is on | the searchlight uses its own `NightStart` / `NightEnd` hours; one console line says so |
| `vehicle_spawner` | calls `GetActiveVehicles` so event vehicles are not swept | nothing to do |

## Notes

- The Discord status embed in `server/main.lua` is switched off (its update call is commented out). Do not put a bot token in the file; keep it in a convar.
- An `eventsystem:server:StopEvent` call from a client that is not an admin is ignored.
