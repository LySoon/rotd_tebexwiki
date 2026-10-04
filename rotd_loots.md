# rotd_loots

Searchable loot props and containers, plus the "loot sense" scan.

## Client exports: loot sense

Loot sense outlines nearby lootable props for a while (default key `Z`, command `rotd_lootsense`).

#### `TriggerLootSense(silent)`

Triggers a scan. Respects the cooldown.

| Parameter | Type | Description |
|---|---|---|
| `silent` | `boolean?` | `true` suppresses the notification. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_loots:TriggerLootSense(true)
```

</details>

#### `SetLootSenseBonus(distanceBonus, durationBonus, cooldownScale)`

Changes loot sense for the local player, for example from a skill. Pass `nil` to leave a value unchanged.

| Parameter | Type | Description |
|---|---|---|
| `distanceBonus` | `number?` | **Added** to the configured scan distance (meters). |
| `durationBonus` | `number?` | **Added** to the configured duration (seconds). |
| `cooldownScale` | `number?` | **Multiplies** the cooldown. `0.5` = half. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
-- a skill that improves loot sense
exports.rotd_loots:SetLootSenseBonus(15.0, 4.0, 0.5)   -- +15 m, +4 s, half cooldown
-- remove the bonus
exports.rotd_loots:SetLootSenseBonus(0.0, 0.0, 1.0)
```

</details>

#### `GetLootSenseState()`

**Returns** `table`:

| Field | Type | Description |
|---|---|---|
| `active` | `boolean` | A scan is running. |
| `onCooldown` | `boolean` | Waiting for the cooldown. |
| `remaining` | `number` | Seconds left (of the scan or the cooldown). |
| `distance` | `number` | Current scan distance. |
| `duration` | `number` | Current scan duration. |
| `cooldown` | `number` | Current cooldown length. |

<details>
<summary>Example</summary>

```lua
local state = exports.rotd_loots:GetLootSenseState()
if not state.onCooldown then exports.rotd_loots:TriggerLootSense(true) end
```

</details>

## Shared export (client and server)

#### `GetAllLootProps()`

Every prop definition from `Config.AlwaysInteractableProps` and `Config.LootSpawns`. Handy for map tools or no-build rules that need every lootable prop position.

**Returns** `table[]`: array of prop definitions.

<details>
<summary>Example</summary>

```lua
local props = exports.rotd_loots:GetAllLootProps()
print(#props, 'lootable props')
```

</details>

## Optional integrations

Containers with a minigame requirement call `rotd-minigame` (`startMinigameSync`), see [[rotd-minigame]].

## Recipes

### Loot sense skill (client)

```lua
-- apply a bonus while the skill is active, remove it afterwards
local function setLootSenseSkill(active)
    if active then
        exports.rotd_loots:SetLootSenseBonus(15.0, 4.0, 0.5)     -- +15 m, +4 s, half the cooldown
    else
        exports.rotd_loots:SetLootSenseBonus(0.0, 0.0, 1.0)      -- back to the config values
    end
end

-- auto scan when a skill triggers it
local state = exports.rotd_loots:GetLootSenseState()
if not state.onCooldown and not state.active then
    exports.rotd_loots:TriggerLootSense(true)                    -- silent
else
    print(('loot sense ready in %d s'):format(state.remaining))
end
```

### Draw your own markers on every lootable prop

```lua
local props = exports.rotd_loots:GetAllLootProps()
print(('%d lootable props'):format(#props))
```
