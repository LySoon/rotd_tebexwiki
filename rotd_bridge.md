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
| `optionalGraceMs` | `8000` | how long a partner may be missing before it counts as off |
| `optionalClientMessages` | `false` | also print optional-feature lines in the client (F8) console |
| `dbCheckMinDelayMs`, `dbSettleMs`, `dbCheckMaxDelayMs` | 3000 / 2500 / 20000 | when the database check runs after start |
| `dbAutoCreate`, `dbAutoAddColumns` | `true` / `false` | create missing tables / add missing columns to resource tables |
| `dbScanNames`, `dbScanIgnore` | patterns / `{'rotd_whitelistv2'}` | which running resources the DB check looks at |
| `panel` | table | the admin panel: `enabled`, `command` (`'rotd'`), `key`, `ace` (`'rotd.admin'`), `allowFrameworkAdmins`, `keepErrors`, `ignore`. See [[Admin-Panel]] |

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

#### `GetPanelSnapshot()`

**Returns** `table`: what the admin panel shows right now: `resources` (state, dependencies, optional partners, recent console messages, server.cfg state), `stack` (detected framework, inventory, target, shop...), `db`, `items`, `schema`. See [[Admin-Panel]].

<details>
<summary>Example</summary>

```lua
local snap = exports.rotd_bridge:GetPanelSnapshot()
for _, r in ipairs(snap.resources) do print(r.n, r.state, #r.issues) end
```

</details>

## Admin panel (manifest keys and event)

The panel (`/rotd`, see [[Admin-Panel]]) reads two optional manifest keys from each ROTD resource:

| Key | Value | Used for |
|---|---|---|
| `rotd_items 'install/items.json'` | names (or `{name,label,weight}`) of the items the resource uses | the Items page compares them with your item list |
| `rotd_optional 'resource` + `\|` + `what it adds'` | one line per optional partner resource, the name and the text separated by a pipe | the Resources page lists it as running or not running |
| `rotd_settings 'install/settings.json'` | config file, root table and the fields to offer | the Settings page edits those lines |

The server event `rotd_bridge:optional` (`caller, partner, feature, fallbackText`) is triggered by `Bridge.Optional` when a resource declares an optional partner; the panel uses it to list partners. Choices made on the Detected setup page are stored in `rotd_bridge/overrides.json` (`framework`, `inventory`, `target`, `shop`); a convar of the same name wins.

## Database check

Runs once after start. It lists every running ROTD resource, creates missing tables declared with `rotd_sql '<file>'` (it reads the `CREATE TABLE` statements) and `rotd_player_data 'yes'`, reports missing columns and row counts. Re-run manually from the console: `rotdbridge db`.

## Recipes

### A complete small resource on the bridge (server)

```lua
-- fxmanifest.lua
-- dependencies { 'ox_lib', 'rotd_bridge' }
-- shared_script '@ox_lib/init.lua'
-- shared_script '@rotd_bridge/init.lua'
-- rotd_player_data 'yes'
-- server_script 'server.lua'

-- server.lua: works on QB, Qbox and ESX with any supported inventory
Bridge.Framework.RegisterCommand('givehello', 'Count how many times you said hello', {}, function(src)
    local n = (Bridge.Framework.GetCharValue(src, 'hello_count') or 0) + 1
    Bridge.Framework.SetCharValue(src, 'hello_count', n)
    TriggerClientEvent('ox_lib:notify', src, { description = ('hello #%d'):format(n) })
end)

-- items: count bandages on a player
local function bandages(src)
    local n = 0
    for _, item in ipairs(Bridge.Inventory.GetItems(src)) do
        if item.name == 'bandage' then n = n + item.count end
    end
    return n
end
```

### Use another ROTD resource only when it runs (client)

```lua
local zones = Bridge.Optional('rotd_zones', {
    feature = 'Safezone-aware weapons',
    fallback = 'weapons are always allowed',
})

CreateThread(function()
    while true do
        Wait(1000)
        local zone = zones.call('GetZonePlayerin')              -- nil when rotd_zones is not running
        if zone and zone.rules and zone.rules.Weapons == false then
            DisablePlayerFiring(PlayerId(), true)
        end
    end
end)
```

### Run code when a framework character loads (client)

```lua
Bridge.Framework.OnPlayerLoaded(function()
    print('character loaded, gender', Bridge.Framework.GetGender())
end)
Bridge.Framework.OnPlayerUnloaded(function() print('character left') end)
```

## Bridge.Inventory.Stash (server)

Shared containers (loot crates, lockers) on any supported inventory. Items go in and out through the inventory's own stash system, so players use the normal inventory UI.

| Function | Input | Returns |
|---|---|---|
| `Stash.Reset(id, opts)` | `id` string, `opts` `{ label, slots, weight }` | `boolean`: creates the stash if needed and **empties** it |
| `Stash.AddItem(id, item, amount, metadata)` | item name, amount (default 1), metadata table | `boolean` |
| `Stash.Open(src, id, opts)` | server id, stash id | `boolean`: opens it for the player |

`opts.label` defaults to `'Stash'`, `opts.slots` to 50, `opts.weight` to 500000 (grams). Supported: `core_inventory`, `ox_inventory`, `qb-inventory` (forks that copy the qb-inventory stash exports also work).

```lua
-- fill a loot crate and let a player open it
local id = ('crate_%d'):format(crateNumber)
Bridge.Inventory.Stash.Reset(id, { label = 'Supply Crate' })
Bridge.Inventory.Stash.AddItem(id, 'bandage', 3)
Bridge.Inventory.Stash.AddItem(id, 'water_bottle', 2, { quality = 80 })

RegisterNetEvent('mycrate:server:open', function()
    Bridge.Inventory.Stash.Open(source, id, { label = 'Supply Crate' })
end)
```

## Bridge.Weather (server)

| Function | Returns |
|---|---|
| `GetState()` | weather name (e.g. `'CLEAR'`) or `nil` when no weather resource runs |
| `GetTime(realClockFallback)` | `hour, minute` of the in-game time; with `realClockFallback = true` the real server clock is used when no weather resource runs, otherwise `nil, nil` |

Supported: `qb-weathersync`. One console line says which resource to start when none is running.

```lua
local weather = Bridge.Weather.GetState() or 'Unknown'
local hour, minute = Bridge.Weather.GetTime(true)
```

## Bridge.Target (client)

Interaction targeting on any supported target resource. Options use the `ox_target` shape.

| Function | Input |
|---|---|
| `AddLocalEntity(entity, options)` | `options` array of `{ label, icon, distance, onSelect(data), canInteract(entity) }`; `data.entity` is the entity |
| `RemoveLocalEntity(entity)` | the entity |
| `AddGlobalVehicle(options)` | options on every vehicle; filter with `canInteract(entity)`; `data.entity` is the vehicle. The `[E]` fallback looks at the nearest vehicle |
| `AddBoxZone({ coords, size, rotation, debug, options })` | box zone, ox_target shape (`coords` vec3 centre, `size` vec3, `rotation` heading). Returns a zone id |
| `RemoveZone(id)` | the id `AddBoxZone` returned |

Supported: `ox_target`, `qb-target`. `qb-target` only fires a box zone when the camera ray lands inside it, so a zone in empty space cannot be targeted; on `qb-target` the bridge therefore builds each box zone as an **invisible prop with collision** (`qbZoneProp` in the bridge config, default `prop_mil_crate_01`) and targets that. If the model cannot be loaded it falls back to a normal qb-target box zone. The props are removed with `RemoveZone` and when the resource stops. With neither running, a `[E] label` prompt (ox_lib text UI) is used and the console says so. Config: `target` and `targetPriority` in `rotd_bridge/config.lua`.

```lua
Bridge.Target.AddLocalEntity(crate, {
    {
        label = 'Open crate', icon = 'fas fa-box-open', distance = 2.0,
        onSelect = function(data) TriggerServerEvent('mycrate:server:open') end,
    },
})
```

## Bridge.Framework: needs (server)

| Function | Input | Returns |
|---|---|---|
| `GetNeed(src, name)` | `'hunger'` or `'thirst'` | `number` 0 to 100 (100 = full) |
| `SetNeed(src, name, value)` | value 0 to 100 (clamped) | `boolean` |

QBCore and Qbox keep needs in player metadata. ESX uses `esx_status` (its 0 to 1000000 scale is converted).

## Bridge.Medical: infection (server)

`Bridge.Medical.Infection(feature)` returns a handle; the server side has `CureInfection(src, duration)`, `IsInfected(src)`, `GetLevel(src)` and `Apply(src, level)`; the client side `IsInfected()`, `IsImmune()`, `GetLevel()`, `Apply(level)`, `Cure()` and `HealBleed()`. They need `wasabi_ambulance`; without it they return empty values and the console says which resource enables the feature.

## Bridge.Framework: money (server)

| Function | Input | Returns |
|---|---|---|
| `GetMoney(src, account)` | `account` `'cash'` (default) or `'bank'` | `number` |
| `AddMoney(src, account, amount, reason)` | | `boolean` |
| `RemoveMoney(src, account, amount, reason)` | | `boolean`: `false` and nothing taken when the player cannot pay (checked first, ESX would otherwise go negative) |

```lua
if Bridge.Framework.RemoveMoney(src, 'cash', 250, 'shop') then
    Bridge.Inventory.AddItem(src, 'bandage', 5)
end
```

### Stash size and `Stash.Open`

`Stash.Open(src, id, opts)` with `opts = { label, slots, weight, type }` (weight in grams):

| Inventory | Size |
|---|---|
| `qb-inventory` | `slots` and `weight` apply every time the stash is opened (a second open with new values resizes it) |
| `ox_inventory` | `slots` and `weight` are registered on open; a stash that is already loaded is resized with `SetSlotCount` / `SetMaxWeight` |
| `core_inventory` | the size comes from the stash **type** you pass in `opts.type` (defined in core_inventory's own config); `slots` and `weight` are ignored |

More stash functions (server): `Stash.Register(id, { label, slots, weight })` makes sure a stash exists with that size (ox_inventory, qb-inventory), `Stash.GetItems(id)` returns the rows `{ name, count, amount, slot, metadata, id }`, `Stash.RemoveItem(id, item, count, slot, instanceId)` removes by slot (or a core_inventory item id) and `Stash.AddItem(id, item, amount, metadata, stashType)` adds. On the **client**, `Inventory.IsOpen()` is true while the player's inventory window is open and `Inventory.GetItemLabel(item)` gives the display label.

`Stash.Move(oldId, newId, newType)` moves every item between two stashes on `core_inventory` (level based types). It does nothing on the other inventories, which keep one id at every size.

## Bridge.Inventory: player items (server)

| Function | Input | Returns |
|---|---|---|
| `AddItem(src, item, count, metadata)` | count default 1 | `boolean` |
| `RemoveItem(src, item, count, slot)` | `slot` optional: remove from that slot (unique items); ESX ignores it | `boolean` |
| `GetItemCount(src, item)` | | `number` (all stacks) |
| `HasAny(src, names)` | `names` = array of item names | the first name the player holds (count above 0), or `nil`. On `core_inventory` it also looks in the weapon holder inventories (`coreWeaponHolders` in the bridge config), where equipped weapons live |
| `SetItemMetadata(src, itemData, metadata)` | `itemData` from a usable-item callback | replaces the metadata of that one item (core_inventory by item id, ox_inventory and qb-inventory by slot); `false` where it cannot (ESX) |
| `RemoveUsedItem(src, itemData)` | `itemData` from a usable-item callback | removes exactly that one item (core_inventory by id, others by slot) |
| `RegisterUsableItem(item, cb)` | `cb(src, itemData)`; `itemData = { name, slot, metadata, info, id }` (metadata and info are the same table) | makes an item usable on QBCore, Qbox, ESX and ox_inventory. On ox_inventory the item definition needs `server = { export = '<resource>.<item>' }` and `consume = 0`; the bridge registers the export |
| `GetItemLabel(item)` | | display label of an item (ox_inventory, qb-core, qbx_core or ESX), or the item name when none is found |
| `ItemBox(src, item, kind, amount)` | `kind` `'add'` (default), `'remove'`, `'use'` | shows the item pop-up on `qb-inventory` (other inventories show their own on `AddItem`, so it does nothing there) |
| `GetName()` | | the inventory in use (`'core_inventory'`, `'ox_inventory'`, `'qb-inventory'`) or `nil`. Also works on the **client**, e.g. to build item image paths |

`core_inventory` and `qb-inventory` go through the framework player, `ox_inventory` through its exports; with no inventory resource ESX's own inventory is used.

## Bridge.Hud: notify, XP, events

| Function | Side | Does |
|---|---|---|
| `Notify(src, message, kind, seconds, title)` | server | HUD notification when the ROTD HUD runs, otherwise an ox_lib notification. `kind` = `success`, `error`, `warning`, `inform` |
| `Notify(message, kind, seconds, title)` | client | same, local |
| `AddXp(src, amount, reason)` | server | gives HUD XP, returns `false` when the HUD is not running (so you can do something else) |
| `GetPlayerXp(src)` | server | `xp, level`, or `nil` without the HUD |
| `TriggerClient(src, event, ...)` | server | sends a HUD client event (quest tracker, ...) when the HUD runs |

## Bridge.Shop (client)

`Shop.Open(shopKey, shopNum, ped, keys)` returns `boolean`.

| Provider | How it opens |
|---|---|
| `jim-shops` | `OpenShopMenu(shopKey, shopNum, ped)` |
| `qb-shops` | server event `qb-shops:server:openShop` with `{ shop = <key in qb-shops Config.Locations> }` |
| `ox_inventory` | shop type = key, id = `shopNum` |

Every shop resource names its shops differently, so `keys` is an optional table with the name each provider uses: `{ ['qb-shops'] = 'ltdgasoline', ox_inventory = 'MedicShop' }`. Without an entry `shopKey` itself is used. Choose the provider with `shop` / `shopPriority` in `rotd_bridge/config.lua` (default order jim-shops, qb-shops, ox_inventory). One console line says what to install when none is found.

```lua
Bridge.Shop.Open('medicshop', 1, ped, { ['qb-shops'] = 'ltdgasoline' })
```

### Barter shops: `Shop.OpenBarter` (client) and `Shop.RegisterBarter` (server)

For shops whose items are paid with other items (not money). `def = { label, society, items = { { name, amount, itemsell, itemsellAmount, bundle } } }`.

| Provider | Result |
|---|---|
| `jim-shops` | opened with the custom shop table (barter and `bundle` work) |
| `ox_inventory` | `RegisterBarter(shopKey, def, keys)` (server; `keys.ox_inventory` = shop type name) registers the shop with `currency = itemsell`, `price = itemsellAmount`, `count = amount`; `bundle` is not supported. Registered again after an ox_inventory restart |
| `qb-shops` | no barter support. With `keys['qb-shops']` it opens that qb-shops location. Without it (shop not in qb-shops' config) the bridge builds the shop in `qb-inventory` from the `RegisterBarter` definition and opens it; items are paid with money, `price = item.price` or `itemsellAmount` when there is no `price` |

`Shop.Provider()` (client) returns the provider in use.

## Bridge.Target: waiting for the target resource (client)

`Target.WaitReady(timeoutMs)` waits (in a thread) until `ox_target` or `qb-target` is running, at most `timeoutMs` (default 10000), and returns the provider name. Call it before registering interactions at start.

## Bridge.Optional: `call` returns every value

`handle.call('GetPlayerXp', src)` now returns **all** return values of the export (`xp, level`), not just the first.
