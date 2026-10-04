# rotd_loots

Searchable loot props and containers, plus the "loot sense" scan.

## Client exports: loot sense

Loot sense outlines nearby lootable props for a while (default key `Z`, command `rotd_lootsense`).

| Export | Input | Returns |
|---|---|---|
| `TriggerLootSense(silent)` | `silent` boolean | triggers a scan (respects the cooldown) |
| `SetLootSenseBonus(distanceBonus, durationBonus, cooldownScale)` | `distanceBonus` and `durationBonus` are **added** to the config values, `cooldownScale` **multiplies** the cooldown (0.5 = half). `nil` leaves a value unchanged | nothing |
| `GetLootSenseState()` | | `{ active, onCooldown, remaining, distance, duration, cooldown }` (`remaining` in seconds) |

```lua
-- client: a skill that improves loot sense
exports.rotd_loots:SetLootSenseBonus(15.0, 4.0, 0.5)   -- +15 m, +4 s, half cooldown
-- remove the bonus
exports.rotd_loots:SetLootSenseBonus(0.0, 0.0, 1.0)

local state = exports.rotd_loots:GetLootSenseState()
if not state.onCooldown then exports.rotd_loots:TriggerLootSense(true) end
```

## Shared export (client and server)

### `GetAllLootProps()`
- **Returns:** `table` array of every prop definition from `Config.AlwaysInteractableProps` and `Config.LootSpawns`.
- Handy for map tools or no-build rules that need every lootable prop position.

## Optional integrations

Containers with a minigame requirement call `rotd-minigame` (`startMinigameSync`), see [[rotd-minigame]].
