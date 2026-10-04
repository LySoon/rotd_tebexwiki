# rotd_classystem

Classes, skills, XP and modifiers. Modifiers are multipliers (`1.0` = normal) such as `meleeDamage`. Skills carry **effects** with numeric or boolean values.

## Server exports

All server exports take the player's **server id** (`src`, `number`) first.

### Class information

#### `GetPlayerClass(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `string`: the class key, or `'none'`.

<details>
<summary>Example</summary>

```lua
if exports.rotd_classystem:GetPlayerClass(src) == 'medic' then
    -- medic only
end
```

</details>

#### `GetPlayerClassInfo(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `table | nil`:

| Field | Type | Description |
|---|---|---|
| `class` | `string` | Selected class key. |
| `level` | `number` | Class level. |
| `xp` | `number` | Class XP. |
| `allClasses` | `table` | Data of every class. |
| `modifiers` | `table` | Modifier values. |
| `effects` | `table` | Active skill effects. |
| `unlockedSkills` | `table` | Unlocked skills. |

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_classystem:GetPlayerClassInfo(src)
if info then print(info.class, info.level) end
```

</details>

#### `GetPlayerAllModifiers(src)`

**Returns** `table`: every modifier value of the player.

<details>
<summary>Example</summary>

```lua
local mods = exports.rotd_classystem:GetPlayerAllModifiers(src)
print(mods.meleeDamage)
```

</details>

### Modifiers and skill effects

#### `GetPlayerModifier(src, modifierName)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `modifierName` | `string` | Modifier name, e.g. `'meleeDamage'`. |

**Returns** `number`: the multiplier, `1.0` when unknown.

<details>
<summary>Example</summary>

```lua
local mult = exports.rotd_classystem:GetPlayerModifier(src, 'meleeDamage')
```

</details>

#### `HasMinimumModifier(src, modifierType, minimumValue)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `modifierType` | `string` | Modifier name. |
| `minimumValue` | `number?` | Minimum, default `1.0`. |

**Returns** `boolean`: `true` when the modifier is at least the minimum.

<details>
<summary>Example</summary>

```lua
if exports.rotd_classystem:HasMinimumModifier(src, 'runSpeed', 1.2) then
    -- fast runner
end
```

</details>

#### `HasSkillUnlocked(src, skillKey)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `skillKey` | `string` | Skill key in the form `branch::skill::tier`. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
local has = exports.rotd_classystem:HasSkillUnlocked(src, 'combat::brawler::1')
```

</details>

#### `GetSkillEffectValue(src, effectKey)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `effectKey` | `string` | Effect name. |

**Returns** `number`: the effect value, `0` when absent. Booleans count as `1` / `0`.

<details>
<summary>Example</summary>

```lua
local bonus = exports.rotd_classystem:GetSkillEffectValue(src, 'someSkillEffect')
```

</details>

#### `GetSkillEffectBool(src, effectKey)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `effectKey` | `string` | Effect name. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
local mult = exports.rotd_classystem:GetPlayerModifier(src, 'meleeDamage')
if exports.rotd_classystem:GetSkillEffectBool(src, 'someSkillEffect') then mult = mult * 1.1 end
```

</details>

#### `GetAllSkillEffects(src)`

**Returns** `table`: the player's active effects.

<details>
<summary>Example</summary>

```lua
for key, value in pairs(exports.rotd_classystem:GetAllSkillEffects(src)) do
    print(key, value)
end
```

</details>

#### `RefreshPlayerSkillCache(src, className)`

Rebuilds and stores the effect cache of a player.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `className` | `string?` | Class to rebuild for. Optional. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:RefreshPlayerSkillCache(src)
```

</details>

### XP and levels

Class levels mirror the HUD level 1:1 (class XP progression itself is disabled).

#### `GetPlayerExperience(src)`

**Returns** two values: `xp` (`number`) and `level` (`number`) of the selected class.

<details>
<summary>Example</summary>

```lua
local xp, level = exports.rotd_classystem:GetPlayerExperience(src)
```

</details>

#### `GetClassExperience(src, className)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `className` | `string` | Class key. |

**Returns** two values: `xp` (`number`) and `level` (`number`).

<details>
<summary>Example</summary>

```lua
local xp, level = exports.rotd_classystem:GetClassExperience(src, 'medic')
```

</details>

#### `SyncHudLevel(src, hudLevel)`

Sets the selected class level to the HUD level. Never lowers it. **Authorised**, see the note below.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `hudLevel` | `number` | The HUD level. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:SyncHudLevel(src, 12)
```

</details>

#### `AddExperience(src, amount)` / `AddExperienceToClass(src, className, amount)`

Currently always returns `false` (HUD-level mode). **Authorised.**

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `className` | `string` | Class key (`AddExperienceToClass` only). |
| `amount` | `number` | XP to add. |

**Returns** `boolean`: always `false` for now.

#### `AddBonusSkillPoints(src, className, amount)`

Gives skill points. **Authorised.**

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `className` | `string` | Class key. |
| `amount` | `number` | Points to add. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:AddBonusSkillPoints(src, 'medic', 1)
```

</details>

#### `AwardActionExperience(src, actionKey, context)`

Awards XP for a configured action. **Authorised.**

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `actionKey` | `string` | Action key from the config. |
| `context` | `table?` | Extra context for the action. |

**Returns** two values: `boolean` success and `string` reason.

<details>
<summary>Example</summary>

```lua
local ok, reason = exports.rotd_classystem:AwardActionExperience(src, 'craft_item', { item = 'bandage' })
```

</details>

### Skill states

#### `ActivatePlayerSkill(src, skillId, ...)`

Triggers an activatable skill on the server. **Authorised.**

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `skillId` | `string` | Skill id. |
| `...` | `any` | Skill-specific arguments. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:ActivatePlayerSkill(src, 'adrenaline_rush')
```

</details>

#### `IsSkillStateActive(src, skillId)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `skillId` | `string` | Skill id. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if exports.rotd_classystem:IsSkillStateActive(src, 'adrenaline_rush') then
    -- skill running
end
```

</details>

### Skill tree data (shared)

`GetSkillTreeData()`, `GetSkillDefinition(...)` and `GetSkillVisualConfig(...)` return the skill tree configuration tables. They work on both client and server.

### Who may call the mutating exports

`SyncHudLevel`, `AddExperience*`, `AddBonusSkillPoints`, `AwardActionExperience` and `ActivatePlayerSkill` are **authorised**: the calling resource must be in `Config.TrustedServerResources` (an empty list trusts everyone), and calls are rate limited per player. Other callers are logged as `UNAUTHORIZED_RESOURCE_CALL` and get `false`.

## Client exports

#### `OpenClassSelector(options)`

Opens the class selector.

| Parameter | Type | Description |
|---|---|---|
| `options` | `table?` | Selector options. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:OpenClassSelector()
```

</details>

#### `GetPlayerClass()`

**Returns** `string`: the class key, or `'none'`.

<details>
<summary>Example</summary>

```lua
local class = exports.rotd_classystem:GetPlayerClass()
```

</details>

#### `GetPlayerClassLevel()`

**Returns** `number`: the class level.

<details>
<summary>Example</summary>

```lua
local level = exports.rotd_classystem:GetPlayerClassLevel()
```

</details>

#### `GetPlayerClassXP()`

**Returns** `number`: the class XP.

<details>
<summary>Example</summary>

```lua
local xp = exports.rotd_classystem:GetPlayerClassXP()
```

</details>

#### `GetPlayerClassInfo()`

**Returns** `table`: `{ class, level, xp, modifiers, effects, unlockedSkills }`.

<details>
<summary>Example</summary>

```lua
local info = exports.rotd_classystem:GetPlayerClassInfo()
print(info.class, info.level)
```

</details>

#### `GetPlayerModifier(modifierName)`

| Parameter | Type | Description |
|---|---|---|
| `modifierName` | `string` | Modifier name. |

**Returns** `number`: the effective value (class base plus skill bonuses).

<details>
<summary>Example</summary>

```lua
-- run faster for runners
local speed = exports.rotd_classystem:GetPlayerModifier('runSpeed')
SetRunSprintMultiplierForPlayer(PlayerId(), math.min(1.49, speed))
```

</details>

#### `GetPlayerAllModifiers()`

**Returns** `table`: every modifier value.

<details>
<summary>Example</summary>

```lua
local mods = exports.rotd_classystem:GetPlayerAllModifiers()
```

</details>

#### `HasMinimumModifier(modifierType, minimumValue)`

| Parameter | Type | Description |
|---|---|---|
| `modifierType` | `string` | Modifier name. |
| `minimumValue` | `number?` | Minimum, default `1.0`. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
local fast = exports.rotd_classystem:HasMinimumModifier('runSpeed', 1.2)
```

</details>

#### `GetEffectValue(effectKey)`

| Parameter | Type | Description |
|---|---|---|
| `effectKey` | `string` | Effect name. |

**Returns** `number`: the effect value, `0` when absent.

<details>
<summary>Example</summary>

```lua
local v = exports.rotd_classystem:GetEffectValue('someSkillEffect')
```

</details>

#### `GetSkillEffectBool(effectKey)`

| Parameter | Type | Description |
|---|---|---|
| `effectKey` | `string` | Effect name. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if exports.rotd_classystem:GetSkillEffectBool('someSkillEffect') then
    -- effect is on
end
```

</details>

#### `GetAllSkillEffects()`

**Returns** `table`: a shallow copy of the active effects.

<details>
<summary>Example</summary>

```lua
local effects = exports.rotd_classystem:GetAllSkillEffects()
```

</details>

#### `IsSkillUnlocked(skillId)` / `IsSkillActive(skillId)` / `IsSkillOnCooldown(skillId)`

| Parameter | Type | Description |
|---|---|---|
| `skillId` | `string` | Skill id. |

**Returns** `boolean`: unlocked, currently active, or on cooldown (depending on the export).

<details>
<summary>Example</summary>

```lua
if exports.rotd_classystem:IsSkillUnlocked('adrenaline_rush')
   and not exports.rotd_classystem:IsSkillOnCooldown('adrenaline_rush') then
    exports.rotd_classystem:ActivateSkill('adrenaline_rush')
end
```

</details>

#### `GetSkillCooldownRemaining(skillId)`

| Parameter | Type | Description |
|---|---|---|
| `skillId` | `string` | Skill id. |

**Returns** `number`: seconds left on the cooldown.

<details>
<summary>Example</summary>

```lua
local left = exports.rotd_classystem:GetSkillCooldownRemaining('adrenaline_rush')
```

</details>

#### `GetSkillEffectValue(skillId, effectKey)`

| Parameter | Type | Description |
|---|---|---|
| `skillId` | `string` | Skill id. |
| `effectKey` | `string` | Effect name. |

**Returns** `number`: the value of that effect for that skill.

<details>
<summary>Example</summary>

```lua
local v = exports.rotd_classystem:GetSkillEffectValue('adrenaline_rush', 'speedBonus')
```

</details>

#### `ActivateSkill(skillId)`

Triggers a skill.

| Parameter | Type | Description |
|---|---|---|
| `skillId` | `string` | Skill id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:ActivateSkill('adrenaline_rush')
```

</details>

#### `PlaySkillVisualStage(skillId, stageName, context)`

Plays a visual stage of a skill.

| Parameter | Type | Description |
|---|---|---|
| `skillId` | `string` | Skill id. |
| `stageName` | `string` | Stage to play. |
| `context` | `table?` | Extra context. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_classystem:PlaySkillVisualStage('adrenaline_rush', 'start')
```

</details>
