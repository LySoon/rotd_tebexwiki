# rotd_classystem

Classes, skills, XP and modifiers. Modifiers are multipliers (1.0 = normal) such as `meleeDamage`; skills carry **effects** with numeric or boolean values.

## Server exports

### Class information

| Export | Input | Returns |
|---|---|---|
| `GetPlayerClass(src)` | server id | class key or `'none'` |
| `GetPlayerClassInfo(src)` | server id | `{ class, level, xp, allClasses, modifiers, effects, unlockedSkills }` or `nil` |
| `GetPlayerAllModifiers(src)` | server id | table of every modifier value |

### Modifiers and skill effects

| Export | Input | Returns |
|---|---|---|
| `GetPlayerModifier(src, modifierName)` | | number (1.0 when unknown) |
| `HasMinimumModifier(src, modifierType, minimumValue)` | minimum default 1.0 | `boolean` |
| `HasSkillUnlocked(src, skillKey)` | skill key (`branch::skill::tier`) | `boolean` |
| `GetSkillEffectValue(src, effectKey)` | | number (0 when absent; booleans count as 1/0) |
| `GetSkillEffectBool(src, effectKey)` | | `boolean` |
| `GetAllSkillEffects(src)` | | table of active effects |
| `RefreshPlayerSkillCache(src, className)` | class optional | rebuilds and stores the effect cache |

### XP and levels

Class levels mirror the HUD level 1:1 (class XP progression itself is disabled).

| Export | Input | Returns |
|---|---|---|
| `GetPlayerExperience(src)` | | `xp, level` of the selected class |
| `GetClassExperience(src, className)` | | `xp, level` |
| `SyncHudLevel(src, hudLevel)` | | `boolean`: sets the selected class level to the HUD level (never lowers) |
| `AddExperience(src, amount)`, `AddExperienceToClass(src, className, amount)` | | currently always `false` (HUD-level mode) |
| `AddBonusSkillPoints(src, className, amount)` | | `boolean` |
| `AwardActionExperience(src, actionKey, context)` | | `boolean, reason` |

### Skill states

| Export | Input | Returns |
|---|---|---|
| `ActivatePlayerSkill(src, skillId, ...)` | | `boolean`: triggers an activatable skill on the server |
| `IsSkillStateActive(src, skillId)` | | `boolean` |

### Skill tree data (shared, client and server)

`GetSkillTreeData()`, `GetSkillDefinition(...)`, `GetSkillVisualConfig(...)` return the skill tree configuration tables.

### Who may call the mutating exports

`SyncHudLevel`, `AddExperience*`, `AddBonusSkillPoints`, `AwardActionExperience`, `ActivatePlayerSkill` are **authorised**: the calling resource must be in `Config.TrustedServerResources` (an empty list trusts everyone), and calls are rate limited per player. Other callers are logged as `UNAUTHORIZED_RESOURCE_CALL` and get `false`.

```lua
-- server: bonus damage only for players with the right skill
local mult = exports.rotd_classystem:GetPlayerModifier(src, 'meleeDamage')
if exports.rotd_classystem:GetSkillEffectBool(src, 'someSkillEffect') then mult = mult * 1.1 end

-- give a skill point
exports.rotd_classystem:AddBonusSkillPoints(src, 'medic', 1)
```

## Client exports

| Export | Returns |
|---|---|
| `OpenClassSelector(options)` | opens the class selector |
| `GetPlayerClass()` | class key or `'none'` |
| `GetPlayerClassLevel()` | number |
| `GetPlayerClassXP()` | number |
| `GetPlayerClassInfo()` | `{ class, level, xp, modifiers, effects, unlockedSkills }` |
| `GetPlayerModifier(modifierName)` | effective value (class base plus skill bonuses) |
| `GetPlayerAllModifiers()` | table |
| `HasMinimumModifier(modifierType, minimumValue)` | `boolean` |
| `GetEffectValue(effectKey)` | number (0 when absent) |
| `GetSkillEffectBool(effectKey)` | `boolean` |
| `GetAllSkillEffects()` | shallow copy of active effects |
| `IsSkillUnlocked(skillId)`, `IsSkillActive(skillId)`, `IsSkillOnCooldown(skillId)` | `boolean` |
| `GetSkillCooldownRemaining(skillId)` | seconds |
| `GetSkillEffectValue(skillId, effectKey)` | number |
| `ActivateSkill(skillId)` | triggers a skill |
| `PlaySkillVisualStage(skillId, stageName, context)` | plays a skill's visual stage |

```lua
-- client: run faster for runners
local speed = exports.rotd_classystem:GetPlayerModifier('runSpeed')
SetRunSprintMultiplierForPlayer(PlayerId(), math.min(1.49, speed))
```
