# rotd_lockers features

**Personal storage lockers that players buy and upgrade.** Every character gets their own locker in an area, opens it at the locker points and grows it level by level at a Stashmaster NPC, paid with items. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory and target resource.

---

## Highlights

- **Personal, per-character storage** that follows your character, not your session
- **10 upgrade levels** from 100 to 600 slots, paid with items you choose
- **Stashmaster NPC** with a clear upgrade menu: current level, size, what you gain, what it costs and what you hold
- **Works with your inventory:** `core_inventory`, `ox_inventory` or `qb-inventory`, with the size set per level
- **Works with your target resource:** `ox_target`, `qb-target` or a key prompt
- **Cheat-proof:** levels, sizes and distances are decided by the server
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### Lockers

- One locker per character and area; as many areas as you configure, each with several locker points
- Open it at any locker point of the area; you cannot open it from far away
- Items inside stay when the locker is upgraded
- Level 0 players get a clear "you don't own a locker here" message

### Upgrades

- The Stashmaster shows level, slots, grid size, the next level's gain and the items it costs, with a tick for each item you already hold
- A progress bar runs while you stay near the Stashmaster
- Every upgrade goes up by exactly one level; costs are taken on the server; a maximum level ends the line
- Costs, slots, weight and time are all in the config

### Size per inventory

- `qb-inventory` and `ox_inventory`: slots and weight come from the level and change as soon as you upgrade
- `core_inventory`: uses its own stash types per level and moves your items to the new one

### Saved data

- The level is saved with the character: nothing to import, and QBCore players keep the level they already had

---

## Works with

| Resource | What you get |
|---|---|
| **Your inventory** | `core_inventory`, `ox_inventory` or `qb-inventory`, detected automatically |
| **ox_target / qb-target** | "Open Locker" and "Talk to the Stashmaster" options; an [E] prompt without them |

The resource runs fully on its own; the target resource is optional.

---

## For developers

- No exports; everything is configured in `config.lua`
- Full documentation: [[rotd_lockers]]

---

## Installation

See [[Install-rotd_lockers]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_lockers]] · Install: [[Install-rotd_lockers]]
