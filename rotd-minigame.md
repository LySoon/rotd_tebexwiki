# rotd-minigame

Skill-check style minigames shown as a NUI: lockpick, keypad, safe dial, wire splice and more. The exports are **client side**; the server handles item use, XP and noise.

Needs `ox_lib` and `rotd_bridge`. Optional: the ROTD HUD (XP), `npc_guide` (quest progress), your ambulance system (dead / downed check).

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
| 2 | `string` | `reason`: `'completed'`, `'failed'`, `'timeout'`, `'escaped'` (the player pressed ESC), `'died'`, `'busy'` or `'noitem'` (the required item is missing). |
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

## Events

| Event | Side | Payload | Notes |
|---|---|---|---|
| `minigames:xpGranted` | server | `src`, `amount`, `reason` | fires on a successful minigame **only when the ROTD HUD is not running**, so your own XP system can give the XP. Listen with `AddEventHandler` |
| `minigames:hearNoise` | client | `{ source, type, coords = {x,y,z} }` | sent to every player within 50 m when a noisy minigame (crowbar) makes noise. The resource itself does nothing with it: use it to alert zombies, police or a dispatch |

```lua
-- client: react to noise nearby
RegisterNetEvent('minigames:hearNoise', function(data)
    print(('noise from player %d at %.0f %.0f'):format(data.source, data.coords.x, data.coords.y))
end)
```

The other events (`minigames:noiseMade`, `minigames:server:awardXp`, `minigames:server:consumeItem`, `minigames:checkHeldItem`, `minigames:requestLockpickSwitch`, `minigames:runTest`) connect the resource's own client and server and are checked on the server. They are not an API.

## Admin commands

| Command | Does |
|---|---|
| `/testminigame <type> <1-7> [seconds]` | runs one minigame for you and prints the result. Admins only (framework admin or the ace `command.testminigame`) |
| `/testminigamemenu` | opens a menu of every type, asks for difficulty and time limit, then runs it. Admins only |

## Side effects worth knowing

- Items needed for a type (lockpicks, etc.) are consumed through the resource's own server events according to its config (`consumeOnFail`, `consumeOnFailChance`).
- Item checks (do you hold a lockpick, crowbar, knife...) and consumption happen on the **server** through `rotd_bridge`, so `core_inventory`, `ox_inventory` and `qb-inventory` all work. With `core_inventory` equipped weapons are found in the weapon holder inventories.
- On **success**, the resource reports the minigame to `npc_guide` (`TrackMinigame`) when that resource runs. Optional.
- On **success**, the **server** works out the XP from its own `Config.XP` (type base times difficulty multiplier) and gives it through the ROTD HUD when it runs. Without the HUD it fires the server event `minigames:xpGranted` (`src`, `amount`, `reason`) so your own XP system can listen:

```lua
AddEventHandler('minigames:xpGranted', function(src, amount, reason)
    -- give XP with your own system
end)
```

- After a genuine **fail or timeout** the electronic types (`keypad_matrix`, `keypad_wave`, `fusebox`, `wiresplice`, `repairpanel`, `cablecut`, `hotwire`) lock for 5 seconds (difficulty 1) up to 20 seconds (difficulty 7). Mechanical types can be retried at once. ESC and success never lock.
- The "dead or downed" check uses your ambulance system through the bridge (`wasabi_ambulance` when it runs, otherwise player state and health).

Needs `ox_lib` and `rotd_bridge`. Optional: the ROTD HUD (XP), `npc_guide` (quest progress).

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

## Config

#### `Config.XP` (`shared/config.lua`)

```lua
Config.XP = {
    enabled = true,
    difficultyMultiplier = { [1] = 1.0, [2] = 1.25, ..., [7] = 2.5 },
    perType = { lockpick = { base = 25, reason = 'Lockpick' }, ... },
    default = { base = 20, reason = 'Minigame' },
}
```

XP = `round(base * difficultyMultiplier[difficulty])`, only on success. The **server** reads this table, so a client cannot choose the amount.

#### `Config.Items`

Items a player must hold to start a type, and when they are used up:

| Field | Meaning |
|---|---|
| `items` | list of item names; holding **any one** passes. `'none'` or `{}` = no item needed |
| `label` | name shown in "You need a ..." |
| `consumeOnFail` | remove one on a failed or timed-out game |
| `consumeOnFailChance` | `0.0` to `1.0`, rolled on the server (default `1.0`) |
| `consumeOnSuccess` | remove one on success |

```lua
Config.Items.perType.lockpick = { items = { 'lockpick', 'advancedlockpick' }, label = 'lockpick',
                                  consumeOnFail = true, consumeOnFailChance = 0.5 }
```

Item names must match your inventory's item list: an item that does not exist can never be held and blocks that type. `enabled = false` turns all item checks off. Difficulty tables per type (zone sizes, speeds, time limits) are in `client/cl_minigames.lua`.
