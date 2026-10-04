# Small exports

## rotd_events

### Server exports

#### `GetActiveVehicles()`

Lists the vehicles the event system currently owns. Used by `vehicle_spawner` so its cleanup sweep leaves them alone.

**Returns** `number[]`: entity handles of the helicopter and ground vehicle the event system owns.

<details>
<summary>Example</summary>

```lua
local vehicles = exports.rotd_events:GetActiveVehicles()
```

</details>

## rotd_mystery_merchant

### Server exports

#### `GetActiveVehicles()`

**Returns** `table`: `{ vehicle }` for the merchant's current vehicle, or `{}` when none.

<details>
<summary>Example</summary>

```lua
-- keep other resources' vehicles out of your own cleanup
local keep = {}
for _, res in ipairs({ 'rotd_events', 'rotd_mystery_merchant' }) do
    if GetResourceState(res) == 'started' then
        for _, veh in ipairs(exports[res]:GetActiveVehicles()) do keep[veh] = true end
    end
end
```

</details>
