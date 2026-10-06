# rotd_kits features

**Claimable survival kits with a cooldown for each one.** Give players a starter kit, a daily supply drop, a medical or food kit and staff kits, each with its own command, items and cooldown, all from one config file. Works on QBCore, Qbox and ESX through the ROTD bridge, with any inventory.

---

## Highlights

- **As many kits as you like:** every kit is one config entry with its own chat command
- **Per-kit cooldowns:** minutes, hours or days, saved so they survive restarts and relogs
- **Kit types:** repeating kits, once-per-player kits (starter kits) and admin-only kits
- **Kit menu:** `/kits` shows every kit with a live "ready in 1h 20m" status and claims a ready kit with one click
- **Claim log:** optional Discord log per kit, plus an admin statistics menu with claims per player and per kit
- **Safe by design:** a full inventory never wastes your cooldown, and double-claims are blocked
- **Works with any setup:** `core_inventory`, `ox_inventory` or `qb-inventory`; item pop-ups on `qb-inventory`
- Needs only `ox_lib` and `rotd_bridge`

---

## Features in detail

### Kits

- Defined in `Config.Kits`: command, label, cooldown, items, optional item metadata
- Six kits shipped as examples: Alpha Survival Kit, Medical Kit, Food Kit, Daily Supply Kit, Starter Kit (once), Staff Kit (admins)
- Items are checked one by one; the player is told exactly what they received
- Duplicate commands are detected and reported in the console

### Cooldowns

- Per player and per kit; the character is identified by citizen id (QBCore, Qbox) or identifier (ESX)
- Saved to disk, so a restart does not reset them (can be switched to memory only)
- "Once" kits can be claimed one time per character, ever
- Clear messages: time left, or "can only be claimed once"
- If no item could be given (full inventory), the claim fails and no cooldown starts

### Menu and admin tools

- `/kits`: list of kits you may use, status, item count and command; ready kits can be claimed from the menu
- Admin-only kits are shown only to admins
- `/alphakitlog` (admins): claims per player with a count per kit
- Optional Discord log with item list, per kit or global; the webhook can live in a server convar so it stays out of the config

---

## Works with

| Resource | What you get |
|---|---|
| **rotd-hud** | claim and cooldown notifications in the HUD |
| **Your inventory** | `core_inventory`, `ox_inventory` or `qb-inventory`, detected automatically |

The resource runs fully on its own; the HUD is optional (ox_lib notifications are used without it).

---

## For developers

- No exports; everything is configured in `config.lua`
- Full documentation: [[rotd_kits]]

---

## Installation

See [[Install-rotd_kits]] for requirements, items, database, convars and a test.


---

Developer documentation: [[rotd_kits]] · Install: [[Install-rotd_kits]]
