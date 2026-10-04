# rotd_bridge

The shared layer between ROTD resources and your framework, inventory and optional partner resources. A resource never calls `QBCore`, `ox_inventory` and so on directly: it asks the bridge.

> `rotd_bridge` has **no exports to call for gameplay**. It builds a global `Bridge` table inside every resource that loads it. The functions below live on that table.

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

## Bridge.Framework (server)

`src` is the player's server id (`number`).

#### `Bridge.Framework.GetPlayer(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `table`: the framework's own player object.

<details>
<summary>Example</summary>

```lua
local player = Bridge.Framework.GetPlayer(src)
```

</details>

#### `Bridge.Framework.GetIdentifier(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `string`: the `citizenid` on QB/Qbox, the `identifier` on ESX.

<details>
<summary>Example</summary>

```lua
local cid = Bridge.Framework.GetIdentifier(src)
```

</details>

#### `Bridge.Framework.GetName(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `string`: first and last name of the character.

<details>
<summary>Example</summary>

```lua
print(Bridge.Framework.GetName(src))
```

</details>

#### `Bridge.Framework.GetCharValue(src, key)`

Reads a persistent per-character value (charinfo on QB/Qbox, `rotd_player_data` on ESX).

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `key` | `string` | Name of the value. |

**Returns** `any`: the stored value, or `nil`.

<details>
<summary>Example</summary>

```lua
local data = Bridge.Framework.GetCharValue(src, 'blipdata') or {}
```

</details>

#### `Bridge.Framework.SetCharValue(src, key, value, opts)`

Stores a persistent per-character value.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `key` | `string` | Name of the value. |
| `value` | `any` | Value to store. |
| `opts` | `table?` | `{ save = false }` updates memory only (QB/Qbox). |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
-- remember a value for a character on any framework
Bridge.Framework.SetCharValue(src, 'blipdata', { poi_fuel_3 = true })
```

</details>

#### `Bridge.Framework.IsAdmin(src)`

Checks the framework permission, the ESX group, or the ACE `command` permission. The console counts as admin.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if Bridge.Framework.IsAdmin(src) then
    -- allow
end
```

</details>

#### `Bridge.Framework.RegisterCommand(name, help, params, fn, opts)`

Registers a command that works on any framework.

| Parameter | Type | Description |
|---|---|---|
| `name` | `string` | Command name. |
| `help` | `string` | Help text. |
| `params` | `table` | Parameter definitions (`{}` for none). |
| `fn` | `function` | `fn(source, args)`, runs when the command is used. |
| `opts` | `table?` | `{ admin = true }` makes the command admin-only. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
Bridge.Framework.RegisterCommand('hello', 'Say hello', {}, function(source, args)
    print('hello from', source)
end, { admin = true })
```

</details>

## Bridge.Framework (client)

#### `Bridge.Framework.GetPlayerData()`

**Returns** `table`: the framework's local player data.

<details>
<summary>Example</summary>

```lua
local pd = Bridge.Framework.GetPlayerData()
```

</details>

#### `Bridge.Framework.IsLoggedIn()`

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if Bridge.Framework.IsLoggedIn() then
    -- character is loaded
end
```

</details>

#### `Bridge.Framework.OnPlayerLoaded(cb)`

Runs a callback on every login, and once immediately when the player is already logged in.

| Parameter | Type | Description |
|---|---|---|
| `cb` | `function` | Called with no arguments. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
Bridge.Framework.OnPlayerLoaded(function()
    print('character ready')
end)
```

</details>

#### `Bridge.Framework.OnPlayerUnloaded(cb)`

| Parameter | Type | Description |
|---|---|---|
| `cb` | `function` | Called with no arguments on logout. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
Bridge.Framework.OnPlayerUnloaded(function()
    -- clean up
end)
```

</details>

#### `Bridge.Framework.GetCharValue(key)`

Persistent per-character value of the local player.

| Parameter | Type | Description |
|---|---|---|
| `key` | `string` | Name of the value. |

**Returns** `any`: the stored value, or `nil`.

<details>
<summary>Example</summary>

```lua
local data = Bridge.Framework.GetCharValue('blipdata')
```

</details>

#### `Bridge.Framework.GetGender()`

**Returns** `number`: `0` male, `1` female.

<details>
<summary>Example</summary>

```lua
local isFemale = Bridge.Framework.GetGender() == 1
```

</details>

## Bridge.Inventory (server)

#### `Bridge.Inventory.GetItems(src)`

Lists a player's items in one format, whichever inventory runs (core_inventory, ox_inventory, qb-inventory).

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `table[]`: `{ { name, count, slot, metadata, worn }, ... }`.

| Field | Type | Description |
|---|---|---|
| `name` | `string` | Item name. |
| `count` | `number` | Stack size. |
| `slot` | `number` | Inventory slot. |
| `metadata` | `table` | Item metadata. |
| `worn` | `boolean` | Whether the item is worn clothing. |

<details>
<summary>Example</summary>

```lua
for _, item in ipairs(Bridge.Inventory.GetItems(src)) do
    if item.name == 'bandage' then print('has bandage', item.count) end
end
```

</details>

#### `Bridge.Inventory.Name`

A value, not a function.

**Returns** `string`: which inventory is in use.

<details>
<summary>Example</summary>

```lua
print('inventory:', Bridge.Inventory.Name)
```

</details>

## Bridge.Optional

#### `Bridge.Optional(resource, meta)`

Cooperation with a resource that may not run. Returns a handle you use instead of calling the resource directly.

| Parameter | Type | Description |
|---|---|---|
| `resource` | `string` | Name of the partner resource. |
| `meta.feature` | `string` | Feature name shown in the console. |
| `meta.fallback` | `string` | Text describing what happens without the partner. |
| `meta.alt` | `string?` | Set when a built-in replacement exists: prints an info line instead of a warning. |

**Returns** `table`: the handle, with these members:

| Member | Returns | Description |
|---|---|---|
| `available()` | `boolean` | Is the partner running. |
| `call(exportName, ...)` | `any` | Result of the export, or `nil` when unavailable (pcall-wrapped). |
| `trigger(event, ...)` | nothing | Local event, only when available. |
| `triggerClient(target, event, ...)` | nothing | Server to client event, only when available. |
| `onStart(cb)`, `onStop(cb)` | nothing | Live enable/disable callbacks. |

<details>
<summary>Example</summary>

```lua
local zones = Bridge.Optional('rotd_zones', {
    feature  = 'Night-time helicopter behaviour',
    fallback = 'helicopters always use day behaviour',
})

if zones.available() then
    local night = zones.call('IsNightTime')
end
zones.onStart(function() print('rotd_zones came up') end)
zones.onStop(function() print('rotd_zones went away') end)
```

</details>

Console output: `[rotd_bridge] <resource>: feature "<feature>" is DISABLED. To enable it, start resource "<partner>". Fallback: ...`, and `... ENABLED ...` when it appears later.

## Bridge.Hud

Optional integration with the ROTD HUD (not shipped). Calls are skipped while it is not running.

#### `Bridge.Hud.Init(feature, fallback)`

| Parameter | Type | Description |
|---|---|---|
| `feature` | `string` | Feature text for the console line. |
| `fallback` | `string?` | Text describing the built-in fallback. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
Bridge.Hud.Init('Zone card display', 'the built-in zone UI')
```

</details>

#### `Bridge.Hud.IsReady()`

**Returns** `boolean`: whether the HUD is running and ready.

<details>
<summary>Example</summary>

```lua
if Bridge.Hud.IsReady() then Bridge.Hud.Export('EnterZone', data) end
```

</details>

#### `Bridge.Hud.Export(name, ...)`

Calls an export of the HUD, skipped while the HUD is not running.

| Parameter | Type | Description |
|---|---|---|
| `name` | `string` | HUD export name. |
| `...` | `any` | Arguments passed to the export. |

**Returns** `any`: whatever the HUD export returns.

<details>
<summary>Example</summary>

```lua
Bridge.Hud.Export('EnterZone', data)
```

</details>

## Bridge.Medical

#### `Bridge.Medical.IsDead()` (client)

Works with any medical resource (falls back to player state and health).

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if Bridge.Medical.IsDead() then return end
```

</details>

#### `Bridge.Medical.Infection(feature)`

Handle for a medical resource that has an infection system. See [[rotd_zones]] for the infection exports that replace it in zones.

| Parameter | Type | Description |
|---|---|---|
| `feature` | `string` | Feature name for the console line. |

**Returns** `table`: the infection handle.

## Bridge.Garage (client)

#### `Bridge.Garage.IsInGarage()`

qb-garages is supported.

**Returns** `boolean`: whether the player is inside a garage.

<details>
<summary>Example</summary>

```lua
if Bridge.Garage.IsInGarage() then
    -- skip the check
end
```

</details>

## Bridge.Log

#### `Bridge.Log.info / warn / error / debug(fmt, ...)`

Prints a log line prefixed with `[rotd_bridge]`.

| Parameter | Type | Description |
|---|---|---|
| `fmt` | `string` | Format string (like `string.format`). |
| `...` | `any` | Values for the format string. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
Bridge.Log.info('loaded %d zones', 12)
Bridge.Log.warn('missing config key %s', 'foo')
```

</details>

## Exports of rotd_bridge itself (server)

#### `GetPlayerValue(identifier, key)`

Reads from the ESX store (`rotd_player_data`).

| Parameter | Type | Description |
|---|---|---|
| `identifier` | `string` | ESX identifier. |
| `key` | `string` | Name of the value. |

**Returns** `any`: the stored value, or `nil`.

<details>
<summary>Example</summary>

```lua
local v = exports.rotd_bridge:GetPlayerValue(identifier, 'blipdata')
```

</details>

#### `SetPlayerValue(identifier, key, value)`

Writes to the ESX store.

| Parameter | Type | Description |
|---|---|---|
| `identifier` | `string` | ESX identifier. |
| `key` | `string` | Name of the value. |
| `value` | `any` | Value to store. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_bridge:SetPlayerValue(identifier, 'blipdata', { seen = true })
```

</details>

#### `GetDbHealth()`

**Returns** `table`: the result of the last database check, per table.

<details>
<summary>Example</summary>

```lua
local health = exports.rotd_bridge:GetDbHealth()
print(json.encode(health))
```

</details>

## Database check

Runs once after start. It lists every running ROTD resource, creates missing tables declared with `rotd_sql '<file>'` (it reads the `CREATE TABLE` statements) and `rotd_player_data 'yes'`, reports missing columns and row counts. Re-run manually from the console: `rotdbridge db`.
