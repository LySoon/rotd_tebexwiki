# rotd_bike

A bike as an inventory item: use it to put a bike on the ground, pick it up again with the target option, with the bike's colour and condition kept in the item. The resource has no exports; this page documents the item data, the config and the events.

Needs `ox_lib` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`. Installation and the item definitions: [[Install-rotd_bike]].

## How it works

1. A player **uses** the `bike` item. The server remembers which item (slot and data) was used.
2. The server removes the item, the client places the bike in front of the player with the colours and condition from the item.
3. The bike loses durability with distance and crashes (`Config`), and its engine and body health follow the durability.
4. **Picking up:** the "Pickup Bike" target option (or [E]) on a free bike gives the item back with the current colours and durability.
5. In a green zone (with `rotd_zones`) a bike cannot be placed, and a rider who enters one has the bike picked up automatically. A revived player's bike is picked up too.

## Item data (metadata)

| Key | Type | Meaning |
|---|---|---|
| `bikemodel` | `string` | one of `Config.AllowedModels` (default `bmx`) |
| `bikecolours` | `table` | `{ colour1, colour2 }`, numbers 0 to 160 |
| `durability` | `number` | 0 to 100 percent; 0 cannot be spawned |

```lua
{ bikemodel = 'bmx', bikecolours = { colour1 = 1, colour2 = 0 }, durability = 85.0 }
```

Give a custom bike from another script (server side):

```lua
Bridge.Inventory.AddItem(src, 'bike', 1, { bikemodel = 'scorcher', bikecolours = { colour1 = 12, colour2 = 0 }, durability = 100.0 })
```

The server cleans the data whenever it comes back from a client: an unknown model becomes the default model, colours and durability are clamped.

## Config: `config.lua`

| Key | Default | Meaning |
|---|---|---|
| `DefaultBikeModel` | `'bmx'` | model when the item has none; must be in `AllowedModels` |
| `AllowedModels` | `bmx, cruiser, fixter, scorcher, tribike, tribike2, tribike3` | bikes that can be spawned from the item and picked up |
| `DefaultColours` | `{ colour1 = 0, colour2 = 0 }` | colours when the item has none |
| `DefaultDurability`, `MinDurability`, `MaxDurability` | `100.0`, `0.0`, `100.0` | durability values (percent) |
| `SpawnDistance` | `1.0` | metres in front of the player where the bike is placed |
| `PickupMaxDistance` | `10.0` | server check: how close to the bike a pickup must be |
| `PendingSpawnSeconds` | `20` | how long a removed item is kept ready to be returned when the spawn fails |
| `PlaceAnimDict`, `PlaceAnimName`, `PickupAnimDict`, `PickupAnimName` | | animations |
| `DurabilityLossPerMeter` | `0.0001` | durability lost per metre ridden |
| `CollisionDurabilityLoss`, `CollisionCooldownMs` | `2.5`, `1000` | loss per crash and the pause between two counted crashes |
| `DurabilityTickMs` | `500` | how often durability is updated |

## Rules enforced by the server

- Only the item the server saw being used can be turned into a bike; the data the client sends with the request is ignored.
- A removed item is returned only once, and only after a spawn that failed.
- Pickup needs: an allowed bike model, the player within `PickupMaxDistance`, no rider on the seat, and a lock so two players cannot pick up the same bike.
- Known limit: the bike's data lives in an entity state bag set by the client, so the server cannot prove a bike came from the item. The model, distance and data checks limit this to allowed bikes.

## Events

Not an API.

| Event | Side | Purpose |
|---|---|---|
| `rotd_bike:client:useBikeItem` | client | the server tells the client which item was used |
| `rotd_bike:client:doSpawnBike` | client | place the bike (data from the server) |
| `rotd_bike:server:spawnBike`, `spawnConfirmed`, `returnBikeItem` | server | start a spawn, confirm it, return the item after a failed spawn |
| `rotd_bike:server:requestPickupLock`, `releasePickupLock`, `pickupBike` | server | the pickup flow |
| `rotd_bike:client:pickupLockResult` | client | answer to the lock request |

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| `rotd_zones` | green zone rules (no placing inside, automatic pickup when riding in) | bikes work in every area; one console line says so |
| `ox_target` / `qb-target` | "Pickup Bike" on every bike | an [E] prompt next to the bike |
| your ambulance resource | picks up a revived player's bike | picked up when the death state ends |
