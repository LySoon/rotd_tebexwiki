# rotd_mystery_merchant features

**A travelling black-market trader that parks somewhere new every half hour.** An armed merchant van appears at one of 20 hidden spots, opens its back doors as you approach, and trades rare weapons and ammo for items instead of money. Includes a luck-based dice game. Works on QBCore, Qbox and ESX through the ROTD bridge.

---

## Highlights

- **One merchant at a time, moving every 30 minutes** to a random location from a list of 20 spots (all editable)
- **Living scene:** a custom van with an armed driver, a merchant sitting in a deck chair at the back, doors that open when you walk up
- **Barter trading:** weapons, suppressors and ammo are paid for with items such as dog tags, medals and soda caps
- **Dice game** with the merchant: choose a bet and 1 to 3 dice, see the odds first, everyone nearby sees the dice
- **Works with the shop you already run:** `jim-shops`, `qb-shops` or `ox_inventory` shops, and `ox_target`, `qb-target` or an [E] prompt
- **Optional merchant music** through `xsound`
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### The merchant

- Random spawn from `Config.merchant`; a new one every `resettime` minutes (default 30); the old van is removed first
- Van model, colours, tuning (engine, brakes, armour, turbo), neon and tyre smoke are all configurable per spawn
- Armed driver guards the van; the van is invulnerable and frozen in place
- The merchant NPC sits in a deck chair behind the van; seat position and heading are configurable
- Back doors open smoothly when the closest player walks up and close when everyone leaves
- A map blip appears when you are within 300 metres, with a one-time "Merchant Nearby" notification
- Spawns for a player only when they are close, so it costs nothing across the map; players who join late are synced
- Merchant vans are never swept by `vehicle_spawner` cleanup

### Trading

- "Talk to the Merchant" through your target resource, a menu with **Open Shop** and **Dice Game**
- Each item has a stock amount and a price in another item (`itemsell`, `itemsellAmount`) and an optional bundle size
- Shops on `jim-shops` keep barter and bundles; on `ox_inventory` the shop is registered for you; on `qb-shops` / `qb-inventory` the items are sold for money

### Dice game

- Bet 10 to 1000, roll 1 to 3 dice
- A preview shows the merchant's number, your dice, the bet and the possible win before you confirm
- Payout multiplier: 0.5x for one die, 1x for two, 1.5x for three
- Dice are shown above the player for everyone within 10 metres; also available as the `/dice` and `/rps` commands

---

## Works with

| Resource | What you get |
|---|---|
| **jim-shops** | full barter shop with bundles |
| **qb-shops / qb-inventory** | merchant shop opened in the inventory, items sold for money |
| **ox_inventory** | merchant shop registered automatically (barter, no bundles) |
| **ox_target / qb-target** | talk option on the merchant; [E] prompt when neither runs |
| **xsound** | music playing at the van |
| **vehicle_spawner** | the van is left alone by its cleanup |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- Export `GetActiveVehicles()` (server) returns the merchant van
- Full documentation: [[rotd_mystery_merchant]]

---

## Installation

See [[Install-rotd_mystery_merchant]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_mystery_merchant]] · Install: [[Install-rotd_mystery_merchant]]
