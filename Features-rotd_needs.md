# rotd_needs features

**Food, drink and healing items that feel alive.** Eat and drink with animations and progress bars, restore hunger and thirst, get effects from herbs and potions, keep what is left of a half-eaten ration, and treat infection with a syringe minigame. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory.

---

## Highlights

- **156 ready-made items:** water, drinks, snacks, bread, pasta, meats, canned foods, herbs and potions, each with its own hunger, thirst and eating time
- **Item effects:** regeneration, stamina, speed, poison, blindness, blurred vision, ragdoll, screen effects, stop bleeding and infection cure
- **Partly eaten items:** eat half a ration and keep the rest, with its own leftovers
- **Syringe:** inject a cure or a healing vaccine, with a steady-hand minigame
- **XP for eating and drinking** through the ROTD HUD, or into your own system
- **Safe by design:** the server controls the amounts, so no one can fake a meal for free hunger, thirst or XP
- **Works with your setup:** `core_inventory`, `ox_inventory` or `qb-inventory`; QBCore, Qbox or ESX needs
- **Install in minutes:** ready-to-paste item lists for QBCore, ox_inventory and ESX
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### Eating and drinking

- Use an item: animation (eat or drink), progress bar, slowed movement, cancel at any time
- Hunger and thirst restored up to full; "You are already full" when there is nothing to restore
- Alcohol, dirty water and raw meat can cost thirst or hunger (negative values)
- `/eatcustom` lets a player consume only part of an item
- Eating time per item

### Effects

- Heal over time, stamina over time, instant stamina recovery or loss, run speed boost
- Poison with damage over time (it never kills below a health guard) and a particle cloud
- Blindness, blurred vision, ragdoll and screen effects
- Stop bleeding and infection cure or reduction (with `wasabi_ambulance`)
- A short regeneration after food and a stamina boost after drinks, scaled by the amount
- Effect bars in the ROTD HUD

### Leftovers

- A partly eaten item keeps what is left and can be finished later
- Switch it off to make every use take the whole item (stackable items)

### Syringe

- Cure when infected and holding an infection cure; healing vaccine when healthy
- Optional steady-hand minigame (`rotd-minigame`) or a progress bar
- The syringe is used up on a fail; nothing is lost if you cancel early
- Scenarios are configurable: condition, required items, action, message

### Admin and developers

- `/setneeds <id> <hunger|thirst|both> <0-100>`
- Server event `rotd_needs:xpGranted` when you use your own XP system
- Every item, value and effect lives in `config.lua`

---

## Works with

| Resource | What you get |
|---|---|
| **rotd-hud** | XP for eating and drinking, effect bars |
| **rotd-minigame** | the syringe minigame |
| **wasabi_ambulance** | infection cure and reduction, stop bleeding |
| **Your inventory** | `core_inventory`, `ox_inventory` or `qb-inventory`, detected automatically |

The resource runs fully on its own; every item in this table is optional.

---

## Installation

See [[Install-rotd_needs]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_needs]] · Install: [[Install-rotd_needs]]
