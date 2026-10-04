# rotd-minigame

Skill-check style minigames shown as a NUI: lockpick, keypad, safe dial, wire splice and more. **Client side only.**

Types: `lockpick`, `keypad_matrix`, `keypad_wave`, `safedial`, `wiresplice`, `crowbar`, `fusebox`, `lever`, `valve`, `floorboard`, `repairpanel`, `cablecut`, `nutsbolts`, `bite_dodge`, `struggle`, `syringe`, `hotwire`, `cutting`. Difficulty is `1` to `7`.

## `startMinigameSync(type, difficulty, timeLimit)`

Blocks the calling thread until the minigame ends.

- **Input:** `type` (string), `difficulty` (1 to 7), `timeLimit` (seconds, optional; omitted or 0 = no time limit)
- **Returns:** `success` (boolean), `reason` (string, e.g. `'timeout'`, `'died'`, `'failed'`, `'busy'`), `stage` (string or `nil`, the stage it ended on for multi-stage games)
- A game that is rejected because another one is active or the type is invalid returns `false, 'busy'`.
- **Must run in a thread** (`CreateThread`, a command handler, an event handler), never at the top level of a file.
- Dying or being downed during the game ends it as a loss (`'died'`, no fail lockout).

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

## `startMinigame(type, difficulty, timeLimit, callback)`

Non-blocking version.

- **Input:** same as above plus `callback(success, reason, stage)`. `(type, difficulty, callback)` also works.
- **Returns:** `boolean` accepted (`false` when busy or invalid). The callback fires later.

```lua
exports['rotd-minigame']:startMinigame('syringe', 3, 20, function(success, reason, stage)
    print(success, reason, stage)
end)
```

## Side effects worth knowing

- Items needed for a type (lockpicks, etc.) are consumed through the resource's own server events according to its config (`consumeOnFail`, `consumeOnFailChance`).
- On **success**, the resource reports the minigame to `npc_guide` (`TrackMinigame`) when that resource runs, and pays XP to the ROTD HUD when it runs. Both are optional.
