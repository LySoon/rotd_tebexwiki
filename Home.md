# ROTD Developer Wiki

Documentation for the exports, events and APIs of the ROTD resources, with examples.

**Pages**

| Page | What it covers |
|---|---|
| [[Getting-Started]] | how exports, client/server sides and trust work, conventions used on every page |
| [[rotd_bridge]] | the shared bridge: framework / inventory / optional-resource API used by every ROTD resource |
| [[rotd_zones]] | zones, radiation, resistance, infection hooks, zombie names |
| [[rotd_squad]] | squads, reputation, stats, building access |
| [[rotd_classystem]] | classes, skills, modifiers, XP |
| [[npc_guide]] | quests, event tracking, currency market |
| [[rotd_leaderboard]] | daily and lifetime stat reads |
| [[rotd-minigame]] | minigames (lockpick, syringe, ...) |
| [[rotd_loots]] | loot sense and loot props |
| [[rotd_recyclers]] | recycler notifications |
| [[rotd_scavs]] | give items / swap weapons on scavengers |
| [[rotd_blips]] | no-build points |
| [[vehicle_spawner]] | vehicle protection, cleanup timer, damage hooks |
| [[Small-Exports]] | rotd_events and rotd_mystery_merchant |

> The wiki describes the exports as they are in the code today. Resources that are not converted to `rotd_bridge` yet may change their internals (never their export signatures) during the multi-framework conversion.

**Publishing this wiki:** this folder is in GitHub-wiki format. Clone `https://github.com/<you>/<repo>.wiki.git`, copy these `.md` files in, commit and push. `[[Page-Name]]` links and `_Sidebar.md` work as they are.
