# Install: rotd_needs

Food, drink and syringe items: hunger and thirst, effects, partly eaten items and the syringe.

> General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected). QBCore and Qbox keep hunger and thirst in player metadata, ESX uses `esx_status` |
| An inventory | yes: `core_inventory`, `ox_inventory` or `qb-inventory` |
| `rotd-hud` | optional (XP and effect bars) |
| `rotd-minigame` | optional (syringe minigame; a progress bar is used without it) |
| `wasabi_ambulance` | optional (infection: syringe cure, cure effects) |

## server.cfg

```
ensure rotd_bridge
ensure rotd-minigame   # optional
ensure rotd_needs
```

## Items

All 156 items of `Config.FoodItems` plus `syringe`, `infection_cure` and `heal_vaccine` must exist in your item list, or they cannot be given, found or used. Ready-to-paste definitions (names, labels, weights, descriptions) are generated for you:

| Inventory | Page | File in the resource folder |
|---|---|---|
| QBCore | [[Items-rotd_needs-QBCore]] | `install/qbcore_items.lua` |
| ox_inventory (and Qbox) | [[Items-rotd_needs-ox_inventory]] | `install/ox_items.lua` |
| ESX | [[Items-rotd_needs-ESX]] | `install/esx_items.sql` |
| core_inventory | uses the framework item list: paste the QBCore (or ESX) version | |

Then restart the framework (QBCore: `qb-core`) or `ox_inventory`. Add an image `<item name>.png` for every item to your inventory images.

**Food items and stacking:** a partly eaten item keeps what is left (`Config.Leftovers = true`).

- `ox_inventory`: items with different leftovers are separate stacks automatically.
- `qb-inventory`: only a **unique** item can carry its own leftovers, so the QBCore file marks the food items `unique = true` (one slot per item). If you prefer stacking, set `Config.Leftovers = false` and change `unique` to `false`: every use then takes the whole item.
- `core_inventory`: items keep their own metadata, as before.

**ox_inventory:** every food item needs `consume = 0` and `server = { export = 'rotd_needs.<item name>' }`; the generated file has both.

**Metadata:** an item that already carries `hunger`, `thirst` or `effects` in its metadata (core_inventory items do) uses those values; every other item takes them from `Config.FoodItems` in `config.lua`.

## Database

None.

## First-time checklist

- Add the items (above) and restart the framework / inventory.
- `Config.FoodItems`: change the hunger, thirst, eating time and effects of any item.
- `Config.XP`: XP per hunger / thirst point, given through the ROTD HUD. Without the HUD listen to the server event `rotd_needs:xpGranted` (`src`, `amount`, `reason`).
- `Config.Syringe`: the scenarios (cure, healing vaccine) and the minigame difficulty.
- On ESX the needs bars are the ones of `esx_status`; on QBCore / Qbox the hunger and thirst of player metadata (shown by `qb-hud` or the ROTD HUD).

## Test it

1. As admin run `/setneeds <id> both 20` to lower your needs.
2. Use a `bottled_water` or `canned_beans`: the progress bar runs and the bars rise.
3. Eat a food item that restores more than you need: the leftovers stay on the item (or the item is used up when leftovers are off).
4. Use a syringe with an `infection_cure` while infected (needs `wasabi_ambulance`) or with a `heal_vaccine`.
