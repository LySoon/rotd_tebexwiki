# rotd_kits

Claimable item kits, one chat command per kit, each with its own cooldown. Kits are defined in `config.lua`. The resource has no exports; this page documents the commands, the config and the data file.

Needs `ox_lib` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`.

## Commands

| Command | Who | Does |
|---|---|---|
| one per kit, e.g. `/alphakit`, `/medkit`, `/dailykit` | everyone (admins only when the kit has `admin = true`) | claims the kit |
| `/kits` (`Config.ListCommand`) | everyone | opens a menu with every kit and its status (`Ready`, `Ready in 1h 20m`, `Already claimed`); choosing a ready kit claims it. Admin kits show only for admins |
| `/alphakitlog` (`Config.LogCommand`) | admins | claim statistics per player, with a count per kit |

Set `Config.ListCommand` or `Config.LogCommand` to `''` to turn that command off.

## Config: `config.lua`

#### Global settings

```lua
Config.ListCommand = 'kits'
Config.LogCommand = 'alphakitlog'
Config.PersistCooldowns = true   -- save cooldowns in alphakit_claims.json; false = memory only (reset on restart)
Config.Webhook = 'changeme'      -- Discord log; 'changeme' or '' = no log
```

The webhook can also come from the server convar `rotd_kits_webhook` (used first when set), which keeps the URL out of the file:

```
set rotd_kits_webhook "https://discord.com/api/webhooks/..."
```

#### Kit definition (`Config.Kits[<key>]`)

| Field | Type | Meaning |
|---|---|---|
| `command` | `string` | chat command; default is the key. Must be unique: a duplicate kit is skipped and the console says so |
| `label` | `string` | name in menus, notifications and the log |
| `cooldown` | `number` | seconds between claims; `0` or `nil` = none |
| `once` | `boolean` | one claim per player, ever (the cooldown is ignored) |
| `admin` | `boolean` | admins only |
| `webhook` | `string` | log webhook for this kit only |
| `items` | `table[]` | `{ name = 'medikit', amount = 2, metadata = {} }`; `metadata` is optional |

```lua
Config.Kits = {
    medkit = {
        command = 'medkit',
        label = 'Medical Kit',
        cooldown = 7200,
        items = {
            { name = 'medikit', amount = 2 },
            { name = 'dressing', amount = 5 },
        },
    },
    starterkit = { command = 'starterkit', label = 'Starter Kit', once = true, items = { ... } },
    staffkit   = { command = 'staffkit', label = 'Staff Kit', admin = true, items = { ... } },
}
```

Item names must exist in your inventory's item list. Shipped kits: `alphakit` (1 hour), `medkit` (2 hours), `foodkit` (3 hours), `dailykit` (24 hours), `starterkit` (once), `staffkit` (admins).

## Rules when claiming

- The identifier is the character: the citizen id on QBCore and Qbox, the identifier on ESX.
- A kit on cooldown, or a `once` kit already claimed, is refused with a message.
- Only items that were really added are listed. If none could be added (for example a full inventory) the claim fails and **no cooldown starts**.
- A second claim of the same kit while the first is still being processed is ignored.

## Data file: `alphakit_claims.json`

Written by the resource in its own folder:

```json
{
  "LJR75943": {
    "total": 3,
    "name": "Kami",
    "kits": { "alphakit": 2, "medkit": 1 },
    "last": { "alphakit": 1759650000, "medkit": 1759640000 }
  }
}
```

`last` holds the Unix time of the last claim per kit (used for the cooldown when `PersistCooldowns` is on). Files from older versions only have `total` and `name`; the other fields are added at the next claim.

## Internal events

Not an API.

| Name | Side | Purpose |
|---|---|---|
| `rotd_kits:list` | `lib.callback` (server) | the data for the `/kits` menu |
| `alphakit:openKits`, `alphakit:openMenu` | client events | open the kit menu / the statistics menu |

## Optional integrations

None. `rotd_kits` needs only `ox_lib` and `rotd_bridge`; without the ROTD HUD, notifications use ox_lib.
