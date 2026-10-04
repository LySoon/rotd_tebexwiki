# rotd_bridge

The shared layer between ROTD resources and your framework, inventory and optional partner resources. A resource never calls `QBCore`, `ox_inventory` and so on directly: it asks the bridge.

`rotd_bridge` has **no exports to call for gameplay**. It builds a global `Bridge` table inside every resource that loads it.

## Using it in your resource

```lua
-- fxmanifest.lua
dependencies { 'ox_lib', 'rotd_bridge' }
shared_script '@ox_lib/init.lua'
shared_script '@rotd_bridge/init.lua'      -- builds the global `Bridge`
rotd_player_data 'yes'                      -- optional: you store per-character data (ESX table is created)
rotd_sql 'sql/install.sql'                  -- optional: tables the DB check should create and verify
```

Start `rotd_bridge` after your framework, inventory and `ox_lib`, before the ROTD resources.

## Configuration (`rotd_bridge/config.lua`)

| Key | Default | Meaning |
|---|---|---|
| `framework` | `'auto'` | `'qb'`, `'qbox'`, `'esx'` or auto-detect (convar `rotd_framework`) |
| `inventory` | `'auto'` | `'core_inventory'`, `'ox_inventory'`, `'qb-inventory'` or auto (convar `rotd_inventory`). Auto order: core_inventory, ox_inventory, qb-inventory (+ ps / lj forks) |
| `coreHolderRefs` | `{}` | core_inventory only: format patterns (`%s` = identifier) of inventories that hold worn clothing |
| `esxAdminGroups` | `{'admin','superadmin'}` | ESX groups counted as admin |
| `optionalGraceMs` | `8000` | wait before an optional-feature console line is printed |
| `dbCheckMinDelayMs`, `dbSettleMs`, `dbCheckMaxDelayMs` | 3000 / 2500 / 20000 | when the database check runs after start |
| `dbAutoCreate`, `dbAutoAddColumns` | `true` / `false` | create missing tables / add missing columns to resource tables |
| `dbScanNames`, `dbScanIgnore` | patterns / `{'rotd_whitelistv2'}` | which running resources the DB check looks at |

## Bridge.Framework

Server (`src` = server id):

| Function | Returns |
|---|---|
| `GetPlayer(src)` | the framework's player object |
| `GetIdentifier(src)` | citizenid (QB/Qbox) or identifier (ESX) |
| `GetName(src)` | first and last name |
| `GetCharValue(src, key)` | a persistent per-character value (charinfo on QB/Qbox, `rotd_player_data` on ESX) |
| `SetCharValue(src, key, value, opts)` | `boolean`. `opts.save = false` updates memory only (QB/Qbox) |
| `IsAdmin(src)` | `boolean` (framework permission, ESX group, or ACE `command`; the console counts) |
| `RegisterCommand(name, help, params, fn, opts)` | registers a command. `fn(source, args)`, `opts = { admin = true }` |

Client:

| Function | Returns |
|---|---|
| `GetPlayerData()` | the framework's local player data |
| `IsLoggedIn()` | `boolean` |
| `OnPlayerLoaded(cb)` | `cb()` on every login and once if already logged in |
| `OnPlayerUnloaded(cb)` | `cb()` on logout |
| `GetCharValue(key)` | persistent per-character value of the local player |
| `GetGender()` | `0` male, `1` female |

```lua
-- server: remember a value for a character on any framework
Bridge.Framework.SetCharValue(src, 'blipdata', { poi_fuel_3 = true })
local data = Bridge.Framework.GetCharValue(src, 'blipdata') or {}

-- admin-only command on any framework
Bridge.Framework.RegisterCommand('hello', 'Say hello', {}, function(source, args)
    print('hello from', source)
end, { admin = true })
```

## Bridge.Inventory (server)

| Function | Returns |
|---|---|
| `GetItems(src)` | `{ { name, count, slot, metadata, worn }, ... }` normalised for core_inventory, ox_inventory, qb-inventory |
| `Name` | which inventory is in use |

```lua
for _, item in ipairs(Bridge.Inventory.GetItems(src)) do
    if item.name == 'bandage' then print('has bandage', item.count) end
end
```

## Bridge.Optional(resource, meta)

Cooperation with a resource that may not run.

```lua
local zones = Bridge.Optional('rotd_zones', {
    feature  = 'Night-time helicopter behaviour',   -- shown in the console
    fallback = 'helicopters always use day behaviour',
    -- alt = 'built-in X',                           -- set when a built-in replacement exists: info line instead of warning
})

if zones.available() then
    local night = zones.call('IsNightTime')         -- pcall-wrapped export call, nil when unavailable
end
zones.onStart(function() print('rotd_zones came up') end)
zones.onStop(function() print('rotd_zones went away') end)
```

| Handle member | Meaning |
|---|---|
| `available()` | `boolean` |
| `call(exportName, ...)` | result or `nil` |
| `trigger(event, ...)` | local event when available |
| `triggerClient(target, event, ...)` | server to client event when available |
| `onStart(cb)`, `onStop(cb)` | live enable/disable |

Console output: `[rotd_bridge] <resource>: feature "<feature>" is DISABLED. To enable it, start resource "<partner>". Fallback: ...`, and `... ENABLED ...` when it appears later.

## Bridge.Hud

Optional integration with the ROTD HUD (not shipped). Calls are skipped while it is not running.

```lua
Bridge.Hud.Init('Zone card display', 'the built-in zone UI')  -- feature text, optional built-in fallback text
if Bridge.Hud.IsReady() then Bridge.Hud.Export('EnterZone', data) end
```

## Bridge.Medical

- `IsDead()` (client): `boolean`, works with any medical resource (falls back to player state and health)
- `Infection(feature)`: handle for a medical resource that has an infection system (see [[rotd_zones]] for the infection exports that replace it in zones)

## Bridge.Garage (client)

- `IsInGarage()`: `boolean` (qb-garages supported)

## Bridge.Log

`Bridge.Log.info / warn / error / debug(fmt, ...)`, prefixed `[rotd_bridge]`.

## Exports of rotd_bridge itself (server)

| Export | Use |
|---|---|
| `GetPlayerValue(identifier, key)` | ESX store read (`rotd_player_data`) |
| `SetPlayerValue(identifier, key, value)` | ESX store write |
| `GetDbHealth()` | table of the last DB check result per table |

## Database check

Runs once after start. It lists every running ROTD resource, creates missing tables declared with `rotd_sql '<file>'` (it reads the `CREATE TABLE` statements) and `rotd_player_data 'yes'`, reports missing columns and row counts. Re-run manually from the console: `rotdbridge db`.
