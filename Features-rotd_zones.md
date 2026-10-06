# rotd_zones features

**Zones, radiation, safezones and guards for survival servers.** Split your map into zones with their own rules, zombie settings and loot, add a full radiation system with resistance gear, and keep players safe in guarded safezones. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory and any HUD.

---

## Highlights

- **Zone system** with 9 zone types, per-zone rules (PvP, weapons, base building, raiding, blackout), zombie intensity, classes and loot, and clean overlap handling
- **Complete radiation system:** hot spots, 20 dose tiers with escalating debuffs and screen effects, damage, coughing, ragdoll, resistance from worn gear and temporary buffs
- **Modern radiation indicator** with rolling digits, gain/fade animations, damage flash and resistance display; two looks, fully optional
- **Built-in zone UI** with three styles (works without any HUD) that automatically steps aside when `rotd-hud` is running
- **Guarded safezones** with static and patrolling guard NPCs that also detect and cure infected players
- **In-game admin tools:** polygon zone builder on the pause map, water-mask baking, `/setradiation`, `/setradcloth`
- **Developer friendly:** 39 exports and 5 events for zones, radiation, resistance, infection, no-build and more
- **No dependency on zombie, medical, HUD or sound resources.** Everything outside is an optional hook

---

## Features in detail

### Zones

- 9 zone types: `red`, `orange`, `yellow`, `green` (safe), `radiation`, `death` (military), `white`, `gray`, `cyan`; each with its own colour in the UI and on the map
- Polygon zones of any shape and size
- **Rules per zone:** `baseBuilding`, `baseRaiding`, `PvP`, `Weapons`, `blackout`; add your own rule keys and read them from your scripts
- **Per-zone zombie settings:** spawn intensity, allowed zombie classes, damage / health multipliers, armor bonus, per-class ped models, sleep behaviour
- **Per-zone loot:** extra loot tables per zombie class with chance, min/max and item metadata. Loot is resolved on the server, so clients cannot touch it
- **Smart overlap rules:** priority first, then the smaller area; radiation is never switched off by a higher-priority zone inside it
- **Day / night ambient:** each zone can set its own timecycle look for day and for night
- **Blackout zones** with a faint interior light cone so players can still read dark interiors (strength, angle, distance, colour, shadows and dark adaptation are configurable); blackout is skipped inside garage interiors
- **Global weather layer:** map-wide timecycle and post-FX that your weather resource can drive; zone ambient wins over weather
- Map overlay: every zone is drawn on the minimap and the pause map, with a sharper texture for the zone under your cursor (opacity, texture sizes and build speed are configurable)

### Safezones (green zones)

- Membership is decided by the **server** and replicated, so every client agrees (no desyncs)
- Player damage protection and vehicle handling inside the zone
- **Prop protection:** petrol pumps and any model you list cannot be broken, so they never leak and chain-explode in a safezone
- Guards patrol and enforce the zone

### Guards

- **Static guards** (assault rifle, sniper) with custom ped models, weapons, accuracy, detection range and fixed positions
- **Patrol guards** that walk waypoints (cycle or ping-pong), wait at each point, and can be dispatched to escort an infected player
- **Speech system:** warnings, funny lines, dismissals and extended lines, all editable
- **Infection handling:** guards detect infected players, warn them, aim, escort, and can force a cure with an animation and a closing line (all timings, chances and lines are configurable)
- Friendly toward squad mates when `rotd_squad` is installed

### Radiation

- **Hot spots:** radiation zones define sources and a centre; the dose depends on how close you stand
- **20 tiers** from 50 up to 2000+ radiation, each with lower max health, a lower sprint stamina cap and, at some tiers, a different **screen effect** and **coughing**
- **Screen effects** cross-fade between tiers and fade out when the dose drops; they are cleaned up on logout and resource stop
- **Coughing** with an animation, a sound and an event your zombie system can use to hear the player
- **Ragdoll** collapses at extreme doses
- **Sprint debuff** while inside the zone
- **Natural decay** outside radiation zones
- **Login protection:** a configurable grace window and ramp so spawning in a zone never deals an unfair instant dose
- **Damage with scaling:** one setting scales how hard radiation hurts, without changing the dose
- **Saved per character** and synced to the server every few seconds, so quitting the game does not lose it (QB/Qbox store it in the character, ESX in its own table that the bridge creates)

### Radiation resistance

- **Worn clothing:** a clothing table lets you give any piece of clothing a resistance percentage (slot, drawable, optional texture, gender), **even if your server does not use clothing items**
- **Inventory items:** items with `radiationResistance` metadata count while worn (`core_inventory`, `ox_inventory`, `qb-inventory`)
- **Temporary modifiers:** other resources add buffs such as pills with one export
- Best piece per slot, slots add up, total capped (100% = immune)
- **Notification** when the total changes, listing the biggest pieces
- **`/setradcloth`** (admin): wear a piece and save it as radiation clothing in one command; works per slot or for the whole outfit, supports exact-texture matching and shows what you wear

### Radiation indicator

- Small indicator at the bottom edge of the screen, two styles: **glow** and **strip**
- **Rolling-digit** number, `+N` / `−N` popups, level names (Trace to Critical), rising and falling effects, level-change pop, alarm at critical, "Clear" at zero
- **Resistance line** inside radiation zones
- **Damage feedback:** red screen-edge flash, indicator flash, camera shake, all scaled by the size of the hit
- Position, size and visibility are configurable, or turn it off entirely if you use your own HUD

### Zone UI

- **Chip** (zone name, type, radiation) and a **detail card** on a key hold: zombie intensity, zombie types with your own names, zombie stats, rule tiles, radiation
- Zone colour is shown in words ("Red zone · High danger") and tints the whole UI
- **Three built-in styles:** tactical (corner brackets and scan line), accent bar, hex badge
- **Shows nothing you do not enable:** every field has an on/off option
- Works **without any HUD**; when `rotd-hud` is running its own cards are used, and the switch happens live

### Base-building limits

- Base building is blocked near map landmarks and points of interest supplied by `rotd_blips` (radius per source, per-location overrides, or opt out)
- Zone rules (`baseBuilding`) can be read by your base-building script on the server and the client

### Admin tools

- **Zone builder:** draw a zone on the big pause map with the mouse; get a ready-to-paste config block
- **Water bake:** one command bakes the sea/land mask for all zones
- `/setradiation [id] <level>`, `/setradcloth ...`, debug commands for zones, safezones, ambient, guards and the map overlay

### Sound

- Built-in sound player, no extra sound resource: Geiger loop with positional hot spots, coughs; one switch to silence everything

---

## Customisable options

| Area | What you can configure |
|---|---|
| Zones | every zone: name, type, priority, polygon, rules, zombie intensity / classes / multipliers / ped models, loot per class, day / night ambient |
| Radiation | login grace and ramp, damage scale, sync interval, tiers (health, stamina, screen effects, cough, ragdoll), hot spots and centre per zone |
| Resistance | clothing table, item metadata key, cap, refresh time, notification on/off, item and table sources on/off |
| Radiation UI | on/off, style, position, size, update rate, resistance line (zone / always / off) |
| Damage feedback | master switch, vignette, indicator jolt, camera shake, strength curve |
| Zone UI | every card field on/off, built-in on/off, style, key-cap hint |
| Zombie names | names for every zombie class (config or other resources) |
| Safezones | protected prop models, scan intervals and radius |
| Guards | models, weapons, accuracy, ranges, patrol routes, speech lines, infection behaviour and timings |
| Map | overlay opacity, texture quality, build speed |
| Lighting | blackout interior light (angle, distance, intensity, falloff, colour, shadows, dark adaptation) |
| Sound | on/off |
| Framework / inventory | auto-detected, or forced in the bridge config |

---

## Compatibility

| | Supported |
|---|---|
| **Frameworks** | QBCore, Qbox, ESX (auto-detected through `rotd_bridge`) |
| **Inventories** | `core_inventory` (default), `ox_inventory`, `qb-inventory` (and its ps / lj forks) |
| **HUD** | `rotd-hud` (optional), otherwise the built-in zone UI |
| **Garages** | `qb-garages` (optional, used to skip blackout in garage interiors) |
| **Weather** | any weather resource that can call the weather exports / events |
| **Medical / disease** | any, through the infection hooks (example for `wasabi_ambulance` included) |
| **Zombie systems** | any, through the zone data, loot, name and cough exports |
| **Needs** | `ox_lib`, `rotd_bridge`, OneSync |

---

## Extra features with other ROTD resources

| With | You get |
|---|---|
| **rotd-hud** | zone cards are drawn by the HUD's own UI instead of the built-in one |
| **rotd_blips** | base-building limits around every landmark and POI |
| **rotd_events** | events know when it is night (helicopter behaviour) |
| **rotd_bike** | bike rules per zone type |
| **rotd_squad** | guards and safezones treat squad mates as friendly |
| **vehicle_spawner**, **rotd_loots** | their spawn and prop positions can be added as no-build sources |
| **Your zombie resource** (any) | zone spawn data, per-zone loot, zombie names on the cards and cough noise through exports |
| **Your disease resource** (any) | guards detect and cure infected players |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- **39 exports** (client and server): zone lookups, rules, spawn info, loot, no-build checks, radiation dose and info, resistance modifiers, server-side radiation, infection hooks, zombie names, cough hook, night check, weather layers, overlay rebuild
- **Events:** `rotd_zones:ready`, `enteredZone`, `exitedZone`, `cough`, `infectionCured`
- Full documentation with parameter tables, data formats and copy-paste recipes: [[rotd_zones]]

---

## Installation

See [[Install-rotd_zones]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_zones]] · Install: [[Install-rotd_zones]]
