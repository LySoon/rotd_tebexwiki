# Install: npc_guide

Talking NPCs, quests, shopkeepers, banking and the currency market.

> Developer documentation (exports, events, config format): [[npc_guide]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| oxmysql | yes |
| rotd_bridge | yes |
| An inventory | yes |
| A target resource | optional ([E] prompt without it) |
| A shop resource: `jim-shops`, `qb-shops` or `ox_inventory` shops | optional |
| `rotd-hud` | optional (quest tracker, XP) |
| `rotd_zones` | optional (zombie names in dialogue) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure ox_lib
ensure oxmysql
ensure rotd_bridge
ensure rotd_zones   # optional
ensure npc_guide
```

## Items

The market trades the currency items below (change them in `Config.ShopNPCs` and `Config.ExchangeRates`). Quest rewards and required items come from `shared/quests.lua`; check every `item =` there against your item list.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `money`, `sodacap`, `dogtag`, `medal`

## Database

Four tables are created automatically: `npc_guide_quests`, `npc_guide_exchange_rates`, `npc_guide_market_history`, `npc_guide_state` (`sql/install.sql`, created by `rotd_bridge` or on start). You can also import the file by hand.

## Convars (server.cfg)

| Convar | Meaning |
|---|---|
| `rotdbot_token` | Discord bot token for the market boards (keep it out of the config) |
| `rotdbot_market_channel` | Discord channel id for the market boards |

Example: `set rotdbot_token "value"`. Keep tokens and webhook URLs in convars, not in files you share.

## First-time checklist

- `Config.Inventory = 'auto'` follows the bridge; change it only to force an item-image path.
- `Config.Bank.cash`: set where cash lives on **your** server: `{ item = 'money' }` when cash is an inventory item, `{ account = 'cash' }` when it is a framework account.
- Shop keys: with `qb-shops` or `ox_inventory` shops, give each shopkeeper in `Config.ShopNPCs` a `model`, `coords` and `shopKeys` (see the npc_guide page).
- Discord market boards are optional: set `Config.MarketMonitor.Enabled = false` if you do not use them.
- Players must **reconnect once** after the first start (NUI files).

## Test it

1. Use `/npcpos` to read coordinates; walk up to The Veteran and talk to them.
2. Accept a quest, then check the quest list.
3. Open a shopkeeper and the currency exchange.
