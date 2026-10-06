# rotd_needs

Food, drink and syringe items. Using an item restores hunger and thirst, can add effects (regeneration, poison, stamina, speed, blindness, ...), keeps what is left of a partly eaten item, and gives XP. The resource has no exports; this page documents the config, the events and the rules.

Needs `ox_lib` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`. Installation and the item lists: [[Install-rotd_needs]].

## How it works

1. A player uses a food or drink item. The server reads the item the player used (not what the client says) and sends it to the client.
2. The client plays the animation and a progress bar (eating time of the item). The player can cancel it.
3. On completion the server adds the hunger and thirst, gives XP, and either keeps the leftovers on the item or uses it up.
4. The client plays the item's effects.

A player cannot eat more than they need: the amount is limited to the missing hunger and thirst, and "You are already full" is shown when nothing can be restored (items with effects still work).

## Where an item's values come from

- If the item already carries `hunger`, `thirst` or `effects` in its inventory **metadata** (core_inventory items do), those are used.
- Otherwise the values come from `Config.FoodItems[<item name>]`.

So the same item works on every inventory with no extra item metadata.

## Config: `config.lua`

```lua
Config.Leftovers = true      -- a partly eaten item keeps what is left; false = every use takes the whole item
```

#### `Config.FoodItems`

```lua
bottled_water = { food = 0, thirst = 60, consume_time_ms = 2300 },
nightshade    = { food = 10, thirst = 5, consume_time_ms = 8200,
                  effects = { poison = { damagePerSecond = 1, duration = 30, hpguard = 110 },
                              blurredVision = { duration = 30 } } },
```

| Field | Meaning |
|---|---|
| `food` | hunger points restored (negative = harms) |
| `thirst` | thirst points restored (negative = harms, e.g. sea water, alcohol) |
| `consume_time_ms` | eating time |
| `effects` | optional effects, below |

156 items ship. Every key becomes a usable item, so the names must exist in your item list.

#### Effects

| Effect | Fields |
|---|---|
| `regen` (or flat `healPerSecond` + `duration`) | `healPerSecond`, `duration` (s): heal over time |
| `stamina` | `perSecond`, `duration`: stamina over time |
| `staminaRecovery` | `amount` (percent): instant recovery |
| `staminaLoss` | `amount` (percent): instant loss |
| `speed` | `multiplier`, `duration`: run speed boost |
| `poison` | `damagePerSecond`, `duration`, `hpguard` (health it never drops below), optional `dict`, `name`, `colour`, `size` for the particle |
| `blurredVision`, `blindness` | `duration` |
| `ragdoll` | `duration` |
| `visual` | `postfx` (screen effect name), `duration` |
| `stopBleeding` | `true`: stops bleeding (needs wasabi_ambulance) |
| `cure` | `{ active = true }`: clears an infection (needs wasabi_ambulance) |
| `curedrop` | lowers the infection level by 2 (needs wasabi_ambulance) |

Eating also gives a short regeneration for food and stamina for drinks, scaled by the amount.

#### `Config.XP`

```lua
Config.XP = { enabled = true, xpPerFood = 0.175, xpPerThirst = 0.2, minXp = 1,
              reasons = { food = 'Ate Food', drink = 'Drank' } }
```

XP = `food used * xpPerFood + thirst used * xpPerThirst` (at least `minXp`), given by the server through the ROTD HUD. Negative items give none.

#### `Config.Syringe`

| Field | Meaning |
|---|---|
| `item` | the usable item (default `syringe`) |
| `minigame` | `{ enabled, difficulty (1 to 7), timeLimit }`: the `rotd-minigame` syringe game; a progress bar is used when the resource is missing or disabled |
| `scenarios` | checked top to bottom, the first match runs |

A scenario: `condition` (`'infected'`, `'not_infected'`, `'any'`), `requires` (items consumed on success), `action` (`'cure'`, `'curedrop'`, `'regen'`), plus `immunityDuration`, `amount`, `regen = { healPerSecond, duration }`, `label`, `notify`.

Outcome of the syringe: success uses the syringe and the required items and applies the effect; a fail or a cancel after the vein stage uses only the syringe; a cancel during the first stage uses nothing.

## Commands

| Command | Who | Does |
|---|---|---|
| `/setneeds <id> <hunger\|thirst\|both> <0-100>` | admins | sets a player's needs |
| `/eatcustom` | everyone | the next food or drink asks how much to consume (for partly eating) |

## Events and callbacks

| Name | Type | Side | Purpose |
|---|---|---|---|
| `rotd_needs:xpGranted` | server event | server | `src`, `amount`, `reason`: fires **only when the ROTD HUD is not running**, so your own XP system can give the XP |
| `rotd_needs:getNeeds` | `lib.callback` | server | returns `hunger, thirst` of the caller |

```lua
AddEventHandler('rotd_needs:xpGranted', function(src, amount, reason)
    -- give XP with your own system
end)
```

Internal events (not an API): `rotd_needs:useItem`, `useSyringe`, `applyRegen` (client) and `rotd_needs:applyNeeds`, `syringeResult` (server).

## Rules enforced by the server

- The item is the one the server saw being used; the item data and amounts sent by the client are limited to what that item holds, and each use is settled once.
- The syringe result is accepted only after a syringe was used, and the syringe must really be in the inventory.
- Needs, items, XP and infection are changed on the server only; the client only plays animations and effects.

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| `rotd-hud` | XP, effect bars | XP through `rotd_needs:xpGranted`; effects still work |
| `rotd-minigame` | syringe minigame | a progress bar |
| `wasabi_ambulance` | infection: syringe cure, `cure`, `curedrop`, `stopBleeding` | those effects do nothing; syringe scenarios for infected players never match |
