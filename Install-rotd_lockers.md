# Install: rotd_lockers

Personal lockers with upgrade levels.

> Developer documentation (config, saved data, events): [[rotd_lockers]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected) |
| An inventory | yes: `core_inventory`, `ox_inventory` or `qb-inventory` |
| A target resource | optional (`ox_target` / `qb-target`; an [E] prompt without it) |

## server.cfg

```
ensure rotd_bridge
ensure rotd_lockers
```

## Items

Upgrades are paid with the items below (change them in `Config.UpgradeRequirements`).

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list.

Item names: `sodacap`, `dogtag`

## Inventory setup

- **qb-inventory / ox_inventory:** nothing to set up; the size comes from `stats.slots` of each level (and `stats.weight`, or `Config.WeightPerSlot`).
- **core_inventory:** define the stash types `personal_stash_level_1` ... `personal_stash_level_10` in core_inventory's own config with the size of each level. Without them the lockers open with the default stash size.

## Database

None. On QBCore and Qbox the levels are saved in character data. On ESX the table `rotd_player_data` is created by `rotd_bridge` (the manifest asks for it).

## First-time checklist

- Edit `Config.Areas`: your locker points and the Stashmaster. Never rename an area after players own lockers (the name is saved with the level).
- Edit `Config.UpgradeRequirements`: costs and sizes. The last level has no items: add some if the final upgrade should not be free.
- On `qb-target` the locker points are invisible props: change `qbZoneProp` in `rotd_bridge/config.lua` if one is too big or small.

## Test it

1. Walk to the Stashmaster and choose "Buy a locker" (level 1).
2. Open the locker at a locker point and put an item in.
3. Upgrade it and check the slot count grew and the item is still inside.
