# vehicle_spawner

World vehicles, damage and parts. Exports for event scripts, garages and zombie systems.

## Server exports

### `ProtectVehicle(vehOrNetId, protect)`
Marks a vehicle as protected from the cleanup sweep (the same as setting the protection state bag, without needing to know its name).

- **Input:** entity handle **or** network id, `protect` boolean
- **Returns:** `boolean`

```lua
exports.vehicle_spawner:ProtectVehicle(vehicle, true)    -- event vehicle: keep it
exports.vehicle_spawner:ProtectVehicle(vehicle, false)   -- release it
```

### `GetNextCleanup()`
- **Returns:** `number|nil` seconds until the next cleanup sweep, `nil` when none is scheduled.

### `PersistVehicleParts(netId, plate)`
Writes the in-memory parts of an **owned** vehicle (battery, ecu, transmission, ...) to the database. Call it right **before** a garage deletes a stored vehicle so the latest durability is not lost.

- **Returns:** `boolean`

### `RestoreVehiclePartsFull(netId, plate)`
Resets every part to installed and 100% and persists it (a garage "full repair"). Live entities are updated immediately.

- **Returns:** `boolean`

## Client exports

### `zombieAttackedVehicle(netId)`
Tells `vehicle_spawner` that a zombie just hit a vehicle body, so the health drop is not treated as a player crash. Call it from the zombie resource.

```lua
exports.vehicle_spawner:zombieAttackedVehicle(NetworkGetNetworkIdFromEntity(veh))
```

### `GetContamDebugText(veh)`
- **Returns:** `string|nil` the contaminated-fuel effect lines for a vehicle (`nil` if clean). Used by a fuel script's debug overlay.

## Shared / other

### `GetVehicleBuildBlockPoints()`
- **Returns:** array of `vector3`, every coordinate a vehicle **can** spawn at (the full static pool, not just the vehicles spawned now), so base building can be blocked there without a legally placed base becoming illegal later.

## Other resources' vehicles

Vehicles owned by other ROTD resources are left alone by the cleanup: `rotd_events` and `rotd_mystery_merchant` export `GetActiveVehicles()`, see [[Small-Exports]].
