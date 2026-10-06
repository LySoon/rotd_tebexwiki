# Install: rotd-minigame

18 skill-check minigames (lockpick, safe dial, wire splice and more) behind two exports.

> Developer documentation (exports, events, config format): [[rotd-minigame]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| An inventory | for tool requirements |
| `rotd-hud` | optional (XP orbs) |
| `npc_guide` | optional (quest progress) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd-minigame
```

## Items

Tool requirements in `Config.Items`. Change or remove them (`items = {}` or `'none'`) to match your server.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `lockpick`, `advancedlockpick`, `weapon_crowbar`, `weapon_wrench`, `screwdriverset`, `weapon_knife`, `weapon_dagger`, `weapon_bottle`, `weapon_machete`, `weapon_switchblade`, `weapon_battleaxe`, `syringe`

## Database

None.

## First-time checklist

- `shared/config.lua`: item requirements (`Config.Items`) and XP (`Config.XP`).
- Without `rotd-hud`, listen to the server event `minigames:xpGranted` to give XP with your own system.
- Admin test commands: add the ace permission `command.testminigame` if you are not a framework admin.
- Players must **reconnect once** after the first start (NUI files).

## Test it

1. As admin run `/testminigame lockpick 3`.
2. Run `/testminigame cutting 3` without a knife: it should refuse; with a knife it should start.
