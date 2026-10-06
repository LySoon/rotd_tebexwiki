# Install: rotd_recyclers

Scrapping stations, fuel refinery and weapon part crafting.

> Developer documentation (exports, config, how it works): [[rotd_recyclers]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| oxmysql | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected) |
| An inventory | yes: `core_inventory`, `ox_inventory` or `qb-inventory` |
| `ox_target` / `qb-target` | optional (`[E]` prompts without them) |
| The ROTD HUD | optional (notifications) |

## server.cfg

```
ensure oxmysql
ensure rotd_bridge
ensure rotd_recyclers
```

## Items

The recipes use 107 item names, listed with ready-to-paste definitions on [[Items-rotd_recyclers]]. A reward item that does not exist is skipped with a console warning (the machine does not report a full output for it). Add the items to your item list: **QBCore / Qbox** `qb-core/shared/items.lua`, **ox_inventory** `data/items.lua`, **ESX** the `items` table. For the fuel refinery you need the jerry can item (`weapon_petrolcan`) with its fuel metadata (core_inventory feature).

## Inventory setup

- **core_inventory:** define the stash types `recycler_input` (restricted to the items of the recipes), `recycler_fuel_input` (the same plus the jerry can) and `stash` in core_inventory's config. Without them the machines open with its default size.
- **ox_inventory / qb-inventory:** nothing to define; sizes come from `Config.Stash`. The input window cannot refuse items, so the machine skips what has no recipe.

## Database

One table, `recycler_offsets`, created by `rotd_bridge` from `sql/recycler_offsets.sql` (or import the file by hand).

## First-time checklist

- Edit `Config.Recyclers`: place your machines (coords, heading, prop) and recipes.
- Admins can fine-tune the interaction points in game with `/managerecycle`.
- `Config.Stash`: stash sizes for ox_inventory / qb-inventory.
- Players must **reconnect once** after the first start (sound and NUI files).

## Test it

1. Walk to a recycler (its blip shows when you are close) and open the input.
2. Put an item with a recipe in and start the machine: the progress shows above it.
3. Open the output and take the materials.
