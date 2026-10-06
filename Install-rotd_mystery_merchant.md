# Install: rotd_mystery_merchant

A travelling merchant van that moves every 30 minutes and trades items; includes a dice game.

> Developer documentation (exports, events, config format): [[rotd_mystery_merchant]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| An inventory | yes |
| A shop resource: `jim-shops`, `qb-shops` or `ox_inventory` shops | recommended |
| A target resource | optional ([E] prompt without it) |
| `xsound` | optional (music) |
| `vehicle_spawner` | optional |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure xsound   # optional
ensure rotd_mystery_merchant
```

## Items

The merchant sells and takes the items below.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `at_suppressor_heavy`, `at_suppressor_light`, `dogtag`, `medal`, `pistol_ammo`, `rifle_ammo`, `shotgun_ammo`, `smg_ammo`, `sodacap`, `weapon_appistol`, `weapon_carbinerifle`, `weapon_smg`

## Database

None.

## First-time checklist

- `jim-shops`: barter works as designed (items are paid with other items).
- `ox_inventory`: the shop is registered for you; barter works, bundles are not supported.
- `qb-shops` / `qb-inventory`: the shop is built in `qb-inventory` and items are paid with **money**. Add a `price = 500` to each item in `config.lua`, or the price is the `itemsellAmount`.
- The dice game does not move money: it only shows messages.
- Edit the 20 spawn spots in `Config.merchant`, and `Config.resettime` (minutes between moves).

## Test it

1. Restart the resource: a van spawns at one spot. Walk within 300 m for the blip.
2. Walk up to the merchant: the doors open; use the target option or [E] to talk.
3. Open the shop and try the dice game.
