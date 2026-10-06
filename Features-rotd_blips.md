# rotd_blips features

**A map you have to earn.** Dangerous locations and small points of interest start as mystery question marks, turn into named blips when a player gets close, and are remembered per character. Pause-map intel cards, ambient fire and smoke at ruined landmarks, and no-build points for base building. Works on QBCore, Qbox and ESX through the ROTD bridge.

---

## Highlights

- **Discovery system:** locations appear as "?" and become real, named blips when you arrive; progress is saved per character
- **Two kinds of locations:** big landmarks and small points of interest (fuel stations, markets, shops, power stations, ...) that stay off the map until you get close
- **Intel cards:** select a blip on the pause map to see a description, threat level in stars, loot type, loot grade, tags and a background picture
- **Atmosphere:** fire and smoke particles around burning and ruined landmarks, streamed only when you are near
- **Base building support:** every location can block base building around it, read by `rotd_zones`
- **Admin tool:** `/blipreveal` shows the whole map to staff for checking, without saving anything
- Needs only `ox_lib` and `rotd_bridge`; no other resource is required

---

## Features in detail

### Discovery

- Big locations (`Config.Blips`) show a "?" from the start and become real blips within a configurable distance (default 200 metres)
- Small points of interest (`Config.POIs`) have no blip at all until you are inside their reveal radius; they then show a "?" and are discovered at a short distance (default 20 metres)
- One definition can hold many positions (28 fuel stations, markets, ...); each position is discovered on its own
- Discovered locations are permanent for that character and survive relogs
- Settings for reveal distance, anti-flicker margin, icon, colour, name and size of the unknown marker, and of the discovered blip

### Intel card

- Opens when you select a blip on the pause map
- Fields: name, description, zone label, threat level (1 to 5 stars), loot type, loot grade (S, A, B, C, D), extra tags such as INFECTED, BOSS ZONE, RADIATION, ENDGAME, and a background image
- A compact card for small points of interest (name, zone, loot, grade and threat)
- Undiscovered locations show no card, so nothing is given away

### Shipped content

- 31 named landmarks: bases, factories, bars, bunkers, hideouts and stashes, each with its own threat, loot and grade
- 8 groups of small points of interest: fuel stations, markets, clothing stores, power stations, mechanic shops, Ammunation, pharmacy and a pier
- Fully editable: add your own locations in the config with a few lines

### Ambient effects

- Six particle sets (two fire types, factory white and dark smoke, two interior smoke types) placed at ruined landmarks
- Each effect starts when you come within its own distance and stops when you leave, so it costs nothing across the map
- Size and distance per position

### Base building

- Every location can carry a no-build radius, or opt out
- Three exports give the points to `rotd_zones` (and to your own scripts)

### Admin

- `/blipreveal [on|off]` (admins only): show every location on your own map; view only, nothing is saved

---

## Works with

| Resource | What you get |
|---|---|
| **rotd_zones** | base building is blocked around every landmark and point of interest |

The resource runs fully on its own; the row above is optional.

---

## For developers

- 3 client exports: `GetBigBlipNoBuildPoints`, `GetPoiNoBuildPoints`, `GetAllNoBuildPoints`
- Full documentation: [[rotd_blips]]

---

## Installation

See [[Install-rotd_blips]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_blips]] · Install: [[Install-rotd_blips]]
