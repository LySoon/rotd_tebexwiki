# npc_guide features

**Talking NPCs, quests and a living currency market.** Survivors with portraits and typewriter dialogue explain your server, hand out and track quests, run shops and banking desks, and trade currencies at prices that move with supply and demand. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory, shop and target resource.

---

## Highlights

- **Full dialogue UI:** portrait, typewriter text, animated option buttons, camera focus on the NPC
- **43 quests** with a progression ladder, level and prerequisite gating, multi-objective tracking and rewards
- **Quests report themselves:** other resources feed progress through one export, so adding a quest never needs gameplay code changes
- **Shopkeepers** that wrap your shop in a conversation with their own wiki and quests
- **Currency exchange with a real market:** prices move with trading volume, with a house cut, anti-manipulation damping and price history
- **Banking desk:** read your balance and move money between cash and bank
- **Discord market boards:** a daily and a weekly price board edited in place
- **Works with what you run:** `jim-shops`, `qb-shops` or `ox_inventory` shops, `ox_target`, `qb-target` or an [E] prompt, `core_inventory`, `ox_inventory` or `qb-inventory`
- Optional ROTD HUD integration: quest tracker, XP rewards and notifications

---

## Features in detail

### Dialogue and NPC types

- Custom NUI dialogue instead of plain menus, with portraits, typewriter text and keyboard friendly buttons
- Random greeting lines per NPC
- Built-in NPC types: **guide** (category, topic, answer wiki), **questgiver** (quests plus an optional wiki), **shopkeeper** (shop, quests, wiki, exchange, bank)
- Add your own NPC type in a few lines
- NPCs spawn with a model, scenario and blip, or are attached to shop peds spawned by `jim-shops`
- Zombie descriptions in dialogue use the names from `rotd_zones`, so renaming them changes the NPC's lines too

### Quests

- 43 quests across the Veteran's main line and the shopkeepers' lines: survival time, distance on foot, deliveries, kills, revives, minigames, purchases, spending and exchange
- Lifecycle: available, active, completed, claimed; claim at the NPC or from the HUD
- Locked quests are listed so players can see where the line goes (limit configurable)
- `requires` (earlier quests that must be claimed) and `minLevel` gating
- Rewards: money, items, XP or a custom server event
- Progress is saved in the database and survives restarts

### Objective tracking

- Objectives declare what they listen for (`track`), with optional filters such as zombie type or minigame type
- 16 built-in event types: deliveries, player kills, vehicle kills, scavenger kills, zombie kills, revives, minigames, playtime, distance on foot and driving, shop purchases and spending, backpack upgrades and repairs, exchange and bank transfers
- Any resource can report progress with one export; distance is measured by the client with teleport and respawn protection

### Shops

- "Open Shop" opens the shop of whichever shop resource runs: `jim-shops`, `qb-shops` or `ox_inventory`
- Without `jim-shops`, the shopkeeper is spawned by `npc_guide` itself from the config
- Per-shop names for each shop resource, so one definition works with all of them
- Ten shopkeepers shipped: medic, base supplier, weapons, utility, currency exchange, casino, bags, barber, food, mechanic

### Currency exchange and market

- Trade currency pairs in both directions; all rates come from one value per currency, so trades are reversible and arbitrage-proof
- Live prices re-settled on a timer: volume moves the price within a hard per-step cap, a house cut makes buying low and selling high pointless, idle prices drift back to base
- Damping so a single trader cannot move the market alone
- Other resources can report currency flow and total supply to move prices
- Hourly and daily price history (open, high, low, close, volume, traders)

### Banking desk

- Balance, deposit and withdraw with quick amounts and "everything"
- Every amount validated and every balance read on the server
- Cash can be an inventory item or an account; optional fee and limits

### Discord market boards

- Daily (24 hours) and weekly (7 days) boards posted once and edited in place
- Price board and trend line per currency; bot token kept in a server convar

### Admin and tools

- `/marketpush` forces the Discord boards to update
- `/npcpos` prints your position for placing NPCs

---

## Works with

| Resource | What you get |
|---|---|
| **rotd-hud** | quest tracker, XP rewards, HUD notifications |
| **rotd_zones** | zombie names in NPC dialogue |
| **jim-shops / qb-shops / ox_inventory** | shop window from the shopkeeper |
| **ox_target / qb-target** | talk option on every NPC; [E] prompt when neither runs |
| **Any ROTD resource** | reports quest progress through the tracking export |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- **8 server exports** for quests (give, progress, track, complete, claim, abandon, read) and **6** for the market (report flow, set supply, snapshot, history, board, push monitor); **3 client exports** (minigame tracking, shopkeeper check and open)
- Full documentation with parameter tables, data formats and recipes: [[npc_guide]]; event reference in `TRACKING.md`

---

## Installation

See [[Install-npc_guide]] for requirements, items, database, convars and a test.


---

Developer documentation: [[npc_guide]] · Install: [[Install-npc_guide]]
