# rotd_squad features

**Play together.** Form a squad, see your mates on the map and above their heads, ping what you see, call for help and share the load. Every character carries a reputation that shows how they treat other survivors. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory and target resource.

---

## Highlights

- **Persistent squads:** squads survive quitting, crashes and character switches
- **Live squad panel:** name, level, class, health, infection, ping and reputation of every member
- **Apex-style pings:** hold one key, pick Mark, Danger, Enemy or Loot, release
- **Shared map blips and overhead names** with a colour and icon each member picks
- **SOS and low-health alerts** that tell the squad when someone needs help
- **Friendly fire switch** for the leader, enforced on every client
- **Reputation:** helping raises it, killing players lowers it, everyone nearby can read it
- **Squad stats dashboard** with kills, deaths, loot, missions and averages
- Needs only `ox_lib`, `oxmysql` and `rotd_bridge`

---

## Features in detail

### Squads

- Create a squad, invite nearby players (target option on a player, the panel list or `/squadinvite <id>`), accept or decline within 60 seconds
- Leader can kick; when the leader leaves, the next member takes over; an empty squad is deleted
- Up to 8 members (configurable); invites need the player to be close
- Squads and their settings are saved in the database

### Seeing your squad

- Squad panel (default **F5**) with every member's health, infection, distance and reputation
- Names and icons above squad mates' heads; far away they shrink to a dot with the distance
- Squad mates on the minimap, also when they are out of sight
- Each member picks a name colour and an icon

### Calling for help

- **SOS** (default **G**): every online squad mate gets a minimap blip and an alert
- Low-health alert when a mate drops under a set health
- A blip marks where a mate died, for a few minutes
- Click a mate in the panel to set a waypoint to them
- The leader can set one shared squad waypoint with a beam in the world

### Pings

- Hold the middle mouse button, move toward Mark, Danger, Enemy or Loot, release
- Everyone in the squad sees the marker, the map blip and a notification
- Ping types, colours and the key are configurable

### Reputation and stats

- Reputation runs from Demon to Saint with colours, starting at Neutral
- Healing, looting, crafting, missions and kills of zombies raise it; killing players, destroying vehicles and bases lower it
- Hold **Left Alt** to read the reputation and main stats of players near you
- Squad dashboard: total kills, deaths, headshots, loot, missions, average level and reputation
- Admins can set a reputation with `/setreputation`

### Friendly fire

- Off by default; the leader switches it on or off for the whole squad
- Damage between squad mates is blocked in three layers so one-shot damage cannot slip through

### Sharing XP

- Experience can be shared with squad mates within a radius (50 m by default); the ratio is configurable

---

## Works with

| Resource | What you get |
|---|---|
| **rotd_classystem** | each member's class (Mercenary, Medic, Engineer, ...) in the list; XP sharing goes to it |
| **rotd_leaderboard** | the permanent zombie kill count on the stat card |
| **rotd-hud** | HUD notifications and chat friends highlighted on the player card |
| **wasabi_ambulance** | the infection level of each member |
| **hrs_base_building** | squad mates share access to bases |
| **interact-sound** | sounds for invites, SOS, pings, deaths |
| **Your target resource** | "Invite to Squad" on a player; an [E] prompt without one |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- Server exports: squad lookups (also for offline players), reputation, stat counters, `HasBuildingAccess`, `ShareXp`
- Client exports: squad data, friendly fire state, `PingAt`, `CheckBuildingAccess`
- Full documentation: [[rotd_squad]]

---

## Installation

See [[Install-rotd_squad]] for requirements, database, controls and a test.

---

Developer documentation: [[rotd_squad]] · Install: [[Install-rotd_squad]]
