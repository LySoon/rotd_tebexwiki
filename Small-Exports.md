# Small exports

## rotd_events

### `GetActiveVehicles()` (server)
- **Returns:** array of entity handles for the helicopter and ground vehicle the event system currently owns.
- Used by `vehicle_spawner` so its cleanup sweep leaves them alone.

## rotd_mystery_merchant

### `GetActiveVehicles()` (server)
- **Returns:** `{ vehicle }` for the merchant's current vehicle, or `{}`.

```lua
-- server: keep other resources' vehicles out of your own cleanup
local keep = {}
for _, res in ipairs({ 'rotd_events', 'rotd_mystery_merchant' }) do
    if GetResourceState(res) == 'started' then
        for _, veh in ipairs(exports[res]:GetActiveVehicles()) do keep[veh] = true end
    end
end
```
