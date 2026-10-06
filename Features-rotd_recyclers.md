# rotd_recyclers features

**Turn junk into materials.** Scrapping stations around the map break down weapons, electronics, parts and everyday items into the materials you need to craft and repair. A fuel refinery cleans contaminated jerry cans, and a recipe file breaks weapons down into parts. Works on QBCore, Qbox and ESX through the ROTD bridge, with `core_inventory`, `ox_inventory` or `qb-inventory`.

---

## Highlights

- **Scrapping stations** with an input stash and an output stash; put things in, collect materials out
- **Lots of recipes:** weapons, attachments, car parts, electronics and more, each with chances and amounts
- **Fuel refinery:** contaminated jerry cans come back clean, with the residue as materials (`core_inventory` jerry cans)
- **Weapon scrapping** into parts, from the same recipe system
- **Machines work in front of you:** progress above the machine, sounds, and a pause while a stash is open
- **Safe by design:** the machine skips items without a recipe and rewards that do not exist in your item list, with a console warning
- **Discoverable:** blips appear on the minimap only when you get close
- **Admin tools:** move the interaction points and tune the status text of every machine in game
- Needs only `ox_lib`, `oxmysql` and `rotd_bridge`

---

## Features in detail

### Recycling

- Each station has an input and an output stash, opened with the target option (or an [E] prompt)
- The machine works through the input one unit at a time: the source item is removed and rewards are rolled from its recipe
- Every recipe reward has a chance and an amount range; some carry item metadata
- Station speed is configurable per machine; the machine pauses while a player has its stash open
- A full output stops the machine with a message, instead of losing items

### Fuel refinery

- Stations with the fuel option clean jerry cans: the can is never consumed, it comes back holding the fuel that survived, with its contamination reset
- Part of the contaminated fuel burns off; the rest is paid out as byproducts (chemicals, plastic, sulfur, iron oxide) with chances and caps you set
- Cleaning time grows with how dirty the can is

### Weapon scrapping

- The weapon recipe file breaks weapons down into their parts, with chances for every part

### Admin tools

- `/managerecycle` (admins) opens the manager to adjust interaction points, particles and status text of a machine
- `/cleanuprecyclers` removes props and interaction points around you for troubleshooting
- A start-up check lists every recipe reward that is missing from your item list

### Stash sizes

- `ox_inventory` and `qb-inventory`: sizes from the config (input 30 slots, output 50 by default)
- `core_inventory`: sizes from its own stash types

---

## Works with

| Resource | What you get |
|---|---|
| **core_inventory** | jerry can refining (fuel and contamination live in the can's data) and input windows that refuse unrelated items |
| **ox_inventory / qb-inventory** | scrapping and weapon parts; the input window accepts anything and the machine skips what has no recipe |
| **Your target resource** | the interaction options on machines; an [E] prompt without one |
| **rotd-hud** | notifications through the HUD (ox_lib notifications without it) |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- Client export: `ShowNotification`; the offset editor exports are for the resource's own use
- Full documentation: [[rotd_recyclers]]; item list with ready-to-paste definitions: [[Items-rotd_recyclers]]

---

## Installation

See [[Install-rotd_recyclers]] for requirements, items, inventory setup, database and a test.

---

Developer documentation: [[rotd_recyclers]] · Install: [[Install-rotd_recyclers]]
