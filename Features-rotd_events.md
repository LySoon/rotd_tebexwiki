# rotd_events features

**Server-run world events with armoured enemies and crash loot.** On a schedule the server starts an event, a hostile armoured vehicle patrols the map with a real crew, players fight or evade it, and a destroyed vehicle drops themed loot crates. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory.

---

## Highlights

- **Helicopter Assault event** ready to run: a hostile helicopter with door gunners, rockets, a hunting searchlight and a crash site full of loot
- **Armoured ground events** (APC "Armoured Column", tank "Armour Patrol") built in and switched on from the config
- **Fully scheduled:** events start on 10-minute real-time marks, with a cooldown between events, and one event at a time
- **Fair fights:** every shot checks line of sight, vehicles slowly repair, crews are not healed, and the event never lands or gets stuck
- **Themed loot crates** (weapons, medical, crafting, metal, food, valuables) with per-item chance and amounts, rolled on the server
- **Every system tunable** in one config file: health, speed, damage, accuracy, ranges, cooldowns, searchlight, repair, blips
- **Works with any inventory:** `core_inventory`, `ox_inventory` or `qb-inventory`
- Needs only `ox_lib` and `rotd_bridge`; the night check from `rotd_zones` is optional

---

## Features in detail

### Event system

- Events are defined in `Config.Events`: label, description, tips, duration, start locations and the vehicle pool
- A random event is picked when a slot opens; start locations are chosen when a player is close enough to stream the vehicle in, so nothing spawns on an empty map
- Start marks every 10 real-time minutes; a configurable cooldown after an event and a shorter one after a cancelled event (a spawn that failed is retried sooner, not instantly)
- Every player is notified when an event starts, late joiners are synced into the running event, and `/event` shows the event card (name, details, tips, time left)
- An admin can stop the running event; vehicles, crew and loot are cleaned up
- `testmode` starts events back to back for testing

### Helicopter Assault

- Four helicopter models in the pool (Valkyrie, Annihilator, Savage, Buzzard), each with its own health, armour, speed, colour, crew and loot
- Marine door gunners with their own health and armour
- **Door guns against players:** each gunner picks its own target, so two players can be engaged at once; ranges, burst size, accuracy and damage are configurable
- **Suppressing fire on zombies only:** the crew works the horde with visible tracers; damage is applied straight to the zombie so players and scavengers under the flight line are never hit
- **Rockets** with a long, random cooldown, fired only with a clear line of sight (no shots through walls, bridges or interiors)
- **Retaliation:** a player who actually shoots the helicopter gets answered
- **Searchlight** that sweeps and bobs as if hunting, and locks on to whatever the helicopter is shooting at; drawn for every nearby player; works at night only or all the time
- **Flight that holds up:** cruises at a set height above the ground under its destination, never lands on purpose, recovers if it ends up on the ground and cannot kill itself on scenery (players still can)
- **Slow self-repair** between fights so a long event is not decided by an early chip of damage; destroyed vehicles are never repaired and the crew is never healed
- **Gunfire is heard by everyone nearby** (configurable range), not only by the player running the AI
- Map blip for the helicopter and a search area circle

### Crash site and loot

- Explosion, smoke and a beacon flare while loot remains
- Six themed crates by default: Weapons, Medical, Crafting, Metal and Engineering, Food, Valuables
- Each crate has a reward table: item, chance, min and max amount, optional item metadata (weapon ammo and durability)
- Loot is rolled and checked on the server; opening a crate needs you to stand near it; crates stay until emptied
- Opening uses a shared stash on any supported inventory

### Armoured ground events (APC and tank)

- Scripted turret that out-ranges players, with line-of-sight checks on every round of a burst
- Patrols around its spawn point, avoids obstacles, cannot follow players indoors, recovers when stuck
- Own blip with a heading cone, wreck loot like the helicopter
- APC (Armoured Column) and tank (Armour Patrol) are defined in the config and shipped switched off; enable them by removing the comment block

---

## Works with

| Resource | What you get |
|---|---|
| **rotd_zones** | the searchlight can follow the zone night definition |
| **vehicle_spawner** | event vehicles are never swept by its cleanup |
| **Any ROTD or custom zombie resource** | the helicopter crew engages the zombies near the flight line |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- Export `GetActiveVehicles()` (server) lists the vehicles the event system owns, for cleanup scripts
- Events and a callback for syncing the active event to your own UI
- Full documentation with data formats: [[rotd_events]]

---

## Installation

See [[Install-rotd_events]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_events]] · Install: [[Install-rotd_events]]
