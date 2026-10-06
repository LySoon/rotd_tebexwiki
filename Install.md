# Install

How to install the ROTD resources. Every resource has its own page with requirements, items, database, convars and a test; a short `README[install].txt` inside each resource folder points here.

## Order

1. Install `ox_lib` and `oxmysql`.
2. Install your framework (`qb-core`, `qbx_core` or `es_extended`), then your inventory (`core_inventory`, `ox_inventory` or `qb-inventory`), target (`ox_target` or `qb-target`) and shop resource.
3. Install [[Install-rotd_bridge]] and start it **before every other ROTD resource**.
4. Install the ROTD resources you bought. They can start in any order after the bridge.
5. Add the items each resource needs to your item list, set the convars, edit the config and test.

Example `server.cfg`:

```
ensure ox_lib
ensure oxmysql
ensure qb-core
ensure core_inventory
ensure ox_target
ensure rotd_bridge
ensure rotd_blips
ensure rotd_zones
ensure rotd_events
ensure npc_guide
ensure rotd_mystery_merchant
ensure rotd_kits
ensure rotd_needs
ensure rotd_loots
ensure rotd_recyclers
ensure rotd_lockers
ensure rotd-minigame
ensure rotd_bike
ensure rotd_squad
```

Players must **reconnect once** after the first start of a resource with an interface (the NUI files are downloaded when joining).

## Pages

| Page | Resource |
|---|---|
| [[Install-rotd_bridge]] | rotd_bridge |
| [[Install-rotd_blips]] | rotd_blips |
| [[Install-rotd_zones]] | rotd_zones |
| [[Install-rotd_events]] | rotd_events |
| [[Install-npc_guide]] | npc_guide |
| [[Install-rotd_mystery_merchant]] | rotd_mystery_merchant |
| [[Install-rotd_kits]] | rotd_kits |
| [[Install-rotd_needs]] | rotd_needs |
| [[Install-rotd_loots]] | rotd_loots |
| [[Install-rotd_recyclers]] | rotd_recyclers |
| [[Install-rotd_lockers]] | rotd_lockers |
| [[Install-rotd-minigame]] | rotd-minigame |
| [[Install-rotd_bike]] | rotd_bike |
| [[Install-rotd_squad]] | rotd_squad |

## Optional resources

Every partner marked optional on a page can be missing. The feature that needs it switches off. The server console prints one summary line a few seconds after start; the list of what is off comes from `rotdbridge optional` in the server console or from `/rotd` in game ([[Admin-Panel]]). Nothing else stops.
