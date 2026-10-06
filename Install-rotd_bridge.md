# Install: rotd_bridge

The shared layer every ROTD resource uses for framework, inventory, target, shop, HUD and database access. Install it first.

> Developer documentation (exports, events, config format): [[rotd_bridge]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| oxmysql | yes |
| A framework: QBCore, Qbox (`qbx_core`) or ESX (`es_extended`) | yes |
| An inventory: `core_inventory`, `ox_inventory` or `qb-inventory` | recommended |
| A target resource: `ox_target` or `qb-target` | optional ([E] prompt without it) |
| A shop resource: `jim-shops`, `qb-shops` or `ox_inventory` shops | optional |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure ox_lib
ensure oxmysql
# your framework, inventory, target and shop resources here
ensure rotd_bridge
# every other ROTD resource after this line
```

## Database

The bridge checks the database **once**, shortly after start. It scans the running ROTD resources, creates missing tables declared with `rotd_sql` in their manifest (and the `rotd_player_data` table on ESX when a resource asks for it) and prints a table report. Run it again from the server console with `rotdbridge db`. Turn creation off with `dbAutoCreate = false` in `rotd_bridge/config.lua`.

## Convars (server.cfg)

| Convar | Meaning |
|---|---|
| `rotd_framework` | force `qb`, `qbox` or `esx` instead of auto-detect |
| `rotd_inventory` | force `core_inventory`, `ox_inventory` or `qb-inventory` |
| `rotd_target` | force `ox_target` or `qb-target` |
| `rotd_shop` | force `jim-shops`, `qb-shops` or `ox_inventory` |
| `rotd_bridge_debug` | `true` for debug lines |

Example: `set rotd_framework "value"`. Keep tokens and webhook URLs in convars, not in files you share.

## Admin panel

`/rotd` opens the ROTD admin panel in game: resource health, detected setup, missing items, database, settings and a support report. Give your admins access:

```
add_ace group.admin rotd.admin allow
```

Framework admins (and txAdmin admins with the `command` ace) can open it without that line. Everything about it is on [[Admin-Panel]]. To let the panel start, stop and restart resources, add:

```
add_ace resource.rotd_bridge command.start allow
add_ace resource.rotd_bridge command.stop allow
add_ace resource.rotd_bridge command.restart allow
add_ace resource.rotd_bridge command.refresh allow
```

## First-time checklist

- Leave `framework`, `inventory`, `target` and `shop` on `auto` unless you run several of the same kind.
- Check `inventory` priority if you have more than one inventory resource installed.
- Server using `core_inventory` clothing holders: fill `coreHolderRefs` (see the comments in `config.lua`).

## Test it

1. Start the server and read the console: the bridge prints the framework, inventory, target and shop it found.
2. Run `rotdbridge db` in the console to see the database report.
3. Join the server and type `/rotd` (see [[Admin-Panel]]).
