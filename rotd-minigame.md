# rotd-minigame

Skill-check style minigames shown as a NUI: lockpick, keypad, safe dial, wire splice and more. **Client side only.**

**Types:** `lockpick`, `keypad_matrix`, `keypad_wave`, `safedial`, `wiresplice`, `crowbar`, `fusebox`, `lever`, `valve`, `floorboard`, `repairpanel`, `cablecut`, `nutsbolts`, `bite_dodge`, `struggle`, `syringe`, `hotwire`, `cutting`.

**Difficulty** is `1` to `7`.

## Client exports

#### `startMinigameSync(type, difficulty, timeLimit)`

Blocks the calling thread until the minigame ends.

> **Must run in a thread** (`CreateThread`, a command handler, an event handler), never at the top level of a file.

| Parameter | Type | Description |
|---|---|---|
| `type` | `string` | One of the types above. |
| `difficulty` | `number` | `1` to `7`. |
| `timeLimit` | `number?` | Seconds. Omitted or `0` means no time limit. |

**Returns** three values:

| Position | Type | Description |
|---|---|---|
| 1 | `boolean` | `success`. |
| 2 | `string` | `reason`, e.g. `'timeout'`, `'died'`, `'failed'`, `'busy'`. |
| 3 | `string \| nil` | `stage`: the stage it ended on, for multi-stage games. |

A game rejected because another one is active, or because the type is invalid, returns `false, 'busy'`. Dying or being downed during the game ends it as a loss (`'died'`, no fail lockout).

<details>
<summary>Example</summary>

```lua
CreateThread(function()
    local ok, reason = exports['rotd-minigame']:startMinigameSync('lockpick', 4, 30)
    if ok then
        print('door open')
    else
        print('failed:', reason)
    end
end)
```

</details>

#### `startMinigame(type, difficulty, timeLimit, callback)`

Non-blocking version. `(type, difficulty, callback)` also works.

| Parameter | Type | Description |
|---|---|---|
| `type` | `string` | One of the types above. |
| `difficulty` | `number` | `1` to `7`. |
| `timeLimit` | `number?` | Seconds. Omitted or `0` means no time limit. |
| `callback` | `function` | `callback(success, reason, stage)`, fires when the game ends. |

**Returns** `boolean`: `true` when accepted, `false` when busy or invalid. The callback fires later.

<details>
<summary>Example</summary>

```lua
exports['rotd-minigame']:startMinigame('syringe', 3, 20, function(success, reason, stage)
    print(success, reason, stage)
end)
```

</details>

## Side effects worth knowing

- Items needed for a type (lockpicks, etc.) are consumed through the resource's own server events according to its config (`consumeOnFail`, `consumeOnFailChance`).
- On **success**, the resource reports the minigame to `npc_guide` (`TrackMinigame`) when that resource runs, and pays XP to the ROTD HUD when it runs. Both are optional.

## Recipes

### A lock that needs a lockpick minigame (client)

```lua
local function tryOpenDoor(doorId)
    CreateThread(function()
        local ok, reason = exports['rotd-minigame']:startMinigameSync('lockpick', 4, 30)
        if ok then
            TriggerServerEvent('mydoors:server:unlock', doorId)
        elseif reason == 'busy' then
            lib.notify({ description = 'Finish what you are doing first', type = 'error' })
        elseif reason == 'timeout' then
            lib.notify({ description = 'Too slow', type = 'error' })
        else
            lib.notify({ description = 'The lock held', type = 'error' })   -- 'failed', 'died', ...
        end
    end)
end
```

### Several stages in a row (client)

```lua
CreateThread(function()
    local ok = exports['rotd-minigame']:startMinigameSync('wiresplice', 3)        -- no time limit
    if not ok then return end
    ok = exports['rotd-minigame']:startMinigameSync('keypad_matrix', 4, 25)
    if ok then print('vault open') end
end)
```

### Callback style, no thread needed (client)

```lua
exports['rotd-minigame']:startMinigame('syringe', 3, 20, function(success, reason, stage)
    if success then print('injected') else print('failed at', stage or '?', reason) end
end)
```
