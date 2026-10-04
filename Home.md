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

> [!NOTE]
> The wiki describes the exports as they are in the code today. Resources that are not converted to `rotd_bridge` yet may change their internals (never their export signatures) during the multi-framework conversion.

## Using an AI assistant?

If you write or fix your FiveM server with an AI (Claude, ChatGPT, Cursor, Copilot, ...), give it these plain-text files. An AI cannot run this website's JavaScript, but it can read these without problems:

| File | Use it for |
|---|---|
| https://lysoon.github.io/rotd_tebexwiki/llms-full.txt | the **whole wiki in one file**. Best choice, hand this one to your AI |
| https://lysoon.github.io/rotd_tebexwiki/llms.txt | a short index of every page |
| https://lysoon.github.io/rotd_tebexwiki/Export-Index.md | every export, A to Z, with its side and a one-line description |

Paste this to your AI before you ask for code:

```text
Read https://lysoon.github.io/rotd_tebexwiki/llms-full.txt first.
It is the API documentation of the ROTD FiveM resource pack.
Only use exports that are listed there and never invent one.
Respect the SERVER / CLIENT / SHARED side of every export.
src is a server id (number), cid is a character id (string).
Handle nil / false returns, and run blocking exports inside CreateThread.
If something you need is not documented, say so instead of guessing.
```

Every page of the website also has these links in its footer.
