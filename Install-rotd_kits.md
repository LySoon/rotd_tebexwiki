# Install: rotd_kits

Claimable item kits with a cooldown for each kit.

> Developer documentation (exports, events, config format): [[rotd_kits]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| An inventory | yes |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_kits
```

## Items

The shipped example kits give the items below. Change the kits in `config.lua` to items your server has.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `at_flashlight`, `at_suppressor_light`, `bike`, `canned_beef_stew_large`, `canned_corn`, `canned_soup`, `cola_can`, `dressing`, `flare_ammo`, `infection_cure`, `lockpick`, `medikit`, `noodle_pack`, `pistol_ammo`, `soda_can`, `syringe`, `weapon_flaregun`, `weapon_pabat3`, `weapon_pistol`

## Database

None. Claims and cooldowns are saved in `alphakit_claims.json` inside the resource folder.

## Convars (server.cfg)

| Convar | Meaning |
|---|---|
| `rotd_kits_webhook` | Discord webhook URL for the claim log (leave unset for no log) |

Example: `set rotd_kits_webhook "value"`. Keep tokens and webhook URLs in convars, not in files you share.

## First-time checklist

- Edit `Config.Kits`: command, label, cooldown, items. A kit item that does not exist is skipped.
- `Config.PersistCooldowns = true` keeps cooldowns across restarts.
- The resource folder must be writable (the claim file is saved there).

## Test it

1. Run `/kits` to see the kits and their status.
2. Run `/alphakit`, then run it again to see the cooldown message.
