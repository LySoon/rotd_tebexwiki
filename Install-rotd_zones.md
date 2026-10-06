# Install: rotd_zones

Zones, radiation, safezones and guards.

> Developer documentation (exports, events, config format): [[rotd_zones]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected) |
| An inventory | optional (radiation resistance from items) |
| `rotd-hud` | optional (zone cards; the built-in UI is used without it) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_blips   # optional: no-build points around landmarks
ensure rotd_zones
```

## Items

No item is required. For radiation resistance from items, give your clothing / gear items the metadata key `radiationResistance` (a number, percent). Without it the `Config.RadiationResistance.clothing` table and `/setradcloth` work on any server.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.


## Database

None on QBCore and Qbox (the radiation dose is saved in character data). On ESX the table `rotd_player_data` is created by `rotd_bridge`.

## First-time checklist

- Edit `Config.Zones` (or build zones in game with the zone builder).
- Tune `Config.RadiationResistance`, `Config.RadiationUI` and the zone UI style.
- Add the worn clothing that protects from radiation: `/setradcloth` in game (admin).
- Players must **reconnect once** after the first start (NUI files).

## Test it

1. Walk into a radiation zone: the indicator appears and the dose rises; leave and it falls.
2. Relog: the dose is still there.
3. As admin run `/setradiation` to set a dose.
