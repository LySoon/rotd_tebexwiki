# rotd_bike features

**Carry a bike in your inventory.** Use the item to put a bike on the ground, ride it, and pick it up again with its colours and condition saved in the item. Crashes and distance wear the bike down. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory and target resource.

---

## Highlights

- **A bike in your pocket:** place it, ride it, pick it up, all with one item
- **Remembers everything:** colours and condition travel with the item
- **Wear and tear:** distance and crashes lower the durability, and the bike's engine and body health follow it
- **Several bike models** (BMX, cruiser, fixter, scorcher, tri-bikes), configurable
- **Safezone friendly:** with `rotd_zones`, bikes cannot be placed in green zones and are picked up when you ride in
- **Fair and safe:** the server controls what a bike can be, so items cannot be turned into other vehicles or duplicated
- **Works with your setup:** `core_inventory`, `ox_inventory` or `qb-inventory`; `ox_target`, `qb-target` or a key prompt
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### Placing and picking up

- Use the `bike` item: an animation plays and the bike appears in front of you
- Not allowed while in a vehicle, with no room, with a broken bike (durability 0) or in a green zone
- "Pickup Bike" on a free bike (target option or [E]) with an animation; the item comes back with the current colours and durability
- Two players cannot pick up the same bike; a bike with a rider cannot be picked up
- A revived player's bike is picked up automatically

### Condition

- Durability from 0 to 100 percent, saved in the item
- Lost per metre ridden and per crash; engine and body health follow it
- All values (loss per metre, crash loss, crash pause, update speed) are configurable

### Protection

- The server remembers the item that was used and ignores what the client claims
- Only models from your allowed list can be placed or picked up
- A failed spawn gives the item back once, never more
- Pickups need the player to be close to the bike

---

## Works with

| Resource | What you get |
|---|---|
| **rotd_zones** | green zone rules: no placing inside, automatic pickup when riding in |
| **Your target resource** | "Pickup Bike" option; an [E] prompt without one |
| **Your ambulance system** | the bike of a revived player is picked up |

The resource runs fully on its own; every item in this table is optional.

---

## For developers

- No exports. Give a customised bike with `Bridge.Inventory.AddItem(src, 'bike', 1, { bikemodel, bikecolours, durability })`
- Full documentation: [[rotd_bike]]

---

## Installation

See [[Install-rotd_bike]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_bike]] · Install: [[Install-rotd_bike]]
