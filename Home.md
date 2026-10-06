# ROTD Developer Wiki

Documentation for the exports, events and APIs of the ROTD resources, with examples.

**Pages**

| Page | What it covers |
|---|---|
| [[Install]] | installation of every ROTD resource: order, items, database, convars |
| [[Getting-Started]] | how exports, client/server sides and trust work, conventions used on every page |
| [[rotd_bridge]] | the shared bridge: framework / inventory / optional-resource API used by every ROTD resource |
| [[rotd_zones]] | zones, radiation, resistance, infection hooks, zombie names |
| [[rotd_squad]] | squads, reputation, stats, building access |
| [[rotd_classystem]] | classes, skills, modifiers, XP |
| [[npc_guide]] | quests, event tracking, currency market |
| [[rotd_leaderboard]] | daily and lifetime stat reads |
| [[rotd-minigame]] | minigames (lockpick, syringe, ...) |
| [[rotd_loots]] | chests, map props, loot sense, locations pack |
| [[rotd_recyclers]] | recycler notifications |
| [[rotd_scavs]] | give items / swap weapons on scavengers |
| [[rotd_blips]] | discovery map, no-build points |
| [[vehicle_spawner]] | vehicle protection, cleanup timer, damage hooks |
| [[rotd_events]] | world events, loot crates, event vehicles |
| [[rotd_mystery_merchant]] | travelling merchant, barter shop, dice game |
| [[rotd_kits]] | survival kits, commands, cooldowns, data file |
| [[rotd_needs]] | food, drink and syringe items, effects, leftovers |
| [[rotd_lockers]] | personal lockers, levels, stash size per inventory |
| [[rotd_bike]] | bike item, metadata, config, server rules |

> The wiki describes the exports as they are in the code today. Resources that are not converted to `rotd_bridge` yet may change their internals (never their export signatures) during the multi-framework conversion.

## Install guides and features

Each resource below has an install page (requirements, items, database, convars, test) and a features page (what it does, in plain words). The developer page has the exports.

| Resource | Features | Install | Developer docs |
|---|---|---|---|
| rotd_bridge | | [[Install-rotd_bridge]] | [[rotd_bridge]] |
| rotd_zones | [[Features-rotd_zones]] | [[Install-rotd_zones]] | [[rotd_zones]] |
| rotd_blips | [[Features-rotd_blips]] | [[Install-rotd_blips]] | [[rotd_blips]] |
| rotd_events | [[Features-rotd_events]] | [[Install-rotd_events]] | [[rotd_events]] |
| npc_guide | [[Features-npc_guide]] | [[Install-npc_guide]] | [[npc_guide]] |
| rotd_mystery_merchant | [[Features-rotd_mystery_merchant]] | [[Install-rotd_mystery_merchant]] | [[rotd_mystery_merchant]] |
| rotd_kits | [[Features-rotd_kits]] | [[Install-rotd_kits]] | [[rotd_kits]] |
| rotd-minigame | [[Features-rotd_minigame]] | [[Install-rotd-minigame]] | [[rotd-minigame]] |
| rotd_bike | [[Features-rotd_bike]] | [[Install-rotd_bike]] | [[rotd_bike]] |
| rotd_squad | [[Features-rotd_squad]] | [[Install-rotd_squad]] | [[rotd_squad]] |
| rotd_recyclers | [[Features-rotd_recyclers]] | [[Install-rotd_recyclers]] | [[rotd_recyclers]] |
| rotd_needs | [[Features-rotd_needs]] | [[Install-rotd_needs]] | [[rotd_needs]] |
| rotd_lockers | [[Features-rotd_lockers]] | [[Install-rotd_lockers]] | [[rotd_lockers]] |
| rotd_loots | [[Features-rotd_loots]] | [[Install-rotd_loots]] | [[rotd_loots]] |
