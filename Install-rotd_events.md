# Install: rotd_events

Server-run world events (helicopter assault) with crash loot.

> Developer documentation (exports, events, config format): [[rotd_events]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| An inventory | yes (loot crates are stashes) |
| `rotd_zones` | optional (night check for the searchlight) |
| `vehicle_spawner` | optional (leaves event vehicles alone) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_zones   # optional
ensure rotd_events
```

## Items

The loot crates give the items listed in `Config.Events`. Add the ones your server does not have, or remove them from the reward tables.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `antibiotic`, `army_crackers`, `army_mre`, `base_blueprint`, `battery`, `blowtorch`, `bottled_water`, `bullet_shell`, `cable`, `canned_beans`, `canned_fruit`, `canned_herring`, `canned_meat`, `canned_peas`, `canned_salmon`, `canned_saury`, `canned_soup`, `canned_sprats`, `canned_squash_spread`, `canned_tuna`, `chemicals`, `cloth`, `dogtag`, `dressing`, `dried_fruit`, `dried_meat`, `energy_bar`, `glue`, `granola_bar`, `gunpowder`, `infection_cure`, `instant_noodles`, `iron_parts`, `iron_pipe`, `iron_plate`, `iron_tank`, `keycard`, `medikit`, `metalscrap`, `money`, `nails`, `razor`, `rifle_ammo`, `rope`, `smg_ammo`, `steel_plate`, `syringe`, `tape`, `wallet`, `weapon_advancedrifle`, `weapon_assaultrifle`, `weapon_assaultshotgun`, `weapon_assaultsmg`, `weapon_carbinerifle`, `weapon_case`, `weapon_combatpistol`, `weapon_crowbar`, `weapon_heavypistol`, `weapon_heavysniper`, `weapon_knife`, `weapon_pistol`, `weapon_pistol50`, `weapon_pumpshotgun`, `weapon_smg`, `weapon_sniperrifle`, `weapon_snspistol`, `weapon_specialcarbine`, `wire`

## Database

None.

## First-time checklist

- **Set `Config.testmode = false`** in `config.lua`. With `true` events start back to back.
- Edit the `startlocations` and the vehicle models of the event.
- The Discord status code in `server/main.lua` is switched off. If you switch it on, put your own bot token there or in a convar; never publish a token.
- The APC and tank events are commented out in `Config.Events`; remove the comment to enable them.

## Test it

1. With `testmode = true`, an event starts a few seconds after start; join near a start location.
2. Type `/event` to see the event card.
3. Shoot the helicopter down and open a crate.
