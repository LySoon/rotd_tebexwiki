# vehicle_spawner

World vehicles, damage and parts. Exports for event scripts, garages and zombie systems.

## Server exports

#### `ProtectVehicle(vehOrNetId, protect)`

Marks a vehicle as protected from the cleanup sweep. Same as setting the protection state bag, without needing to know its name.

| Parameter | Type | Description |
|---|---|---|
| `vehOrNetId` | `number` | Entity handle **or** network id. |
| `protect` | `boolean` | `true` protects, `false` releases. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.vehicle_spawner:ProtectVehicle(vehicle, true)    -- event vehicle: keep it
exports.vehicle_spawner:ProtectVehicle(vehicle, false)   -- release it
```

</details>

#### `GetNextCleanup()`

**Returns** `number | nil`: seconds until the next cleanup sweep, `nil` when none is scheduled.

<details>
<summary>Example</summary>

```lua
local secs = exports.vehicle_spawner:GetNextCleanup()
if secs and secs < 60 then print('cleanup soon') end
```

</details>

#### `PersistVehicleParts(netId, plate)`

Writes the in-memory parts of an **owned** vehicle (battery, ecu, transmission, ...) to the database. Call it right **before** a garage deletes a stored vehicle so the latest durability is not lost.

| Parameter | Type | Description |
|---|---|---|
| `netId` | `number` | Network id of the vehicle. |
| `plate` | `string` | Vehicle plate. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.vehicle_spawner:PersistVehicleParts(netId, plate)
DeleteEntity(NetworkGetEntityFromNetworkId(netId))
```

</details>

#### `RestoreVehiclePartsFull(netId, plate)`

Resets every part to installed and 100% and persists it (a garage "full repair"). Live entities are updated immediately.

| Parameter | Type | Description |
|---|---|---|
| `netId` | `number` | Network id of the vehicle. |
| `plate` | `string` | Vehicle plate. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.vehicle_spawner:RestoreVehiclePartsFull(netId, plate)
```

</details>

## Client exports

#### `zombieAttackedVehicle(netId)`

Tells `vehicle_spawner` that a zombie just hit a vehicle body, so the health drop is not treated as a player crash. Call it from the zombie resource.

| Parameter | Type | Description |
|---|---|---|
| `netId` | `number` | Network id of the vehicle. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.vehicle_spawner:zombieAttackedVehicle(NetworkGetNetworkIdFromEntity(veh))
```

</details>

#### `GetContamDebugText(veh)`

The contaminated-fuel effect lines for a vehicle. Used by a fuel script's debug overlay.

| Parameter | Type | Description |
|---|---|---|
| `veh` | `number` | Vehicle entity handle. |

**Returns** `string | nil`: the effect lines, `nil` if the fuel is clean.

<details>
<summary>Example</summary>

```lua
local text = exports.vehicle_spawner:GetContamDebugText(veh)
if text then print(text) end
```

</details>

## Shared exports

#### `GetVehicleBuildBlockPoints()`

Every coordinate a vehicle **can** spawn at: the full static pool, not just the vehicles spawned now. Base building can be blocked there without a legally placed base becoming illegal later.

**Returns** `vector3[]`: array of coordinates.

<details>
<summary>Example</summary>

```lua
for _, pos in ipairs(exports.vehicle_spawner:GetVehicleBuildBlockPoints()) do
    -- keep bases away from pos
end
```

</details>

## Other resources' vehicles

Vehicles owned by other ROTD resources are left alone by the cleanup: `rotd_events` and `rotd_mystery_merchant` export `GetActiveVehicles()`, see [[Small-Exports]].
