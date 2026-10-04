# rotd_squad

Squads, reputation, per-player stats and squad building access.

> [!NOTE]
> **Identifiers.** Some exports take a **server id** (`src`, a `number`), others a **character id** (`cid`, a `string`). The parameter table of every export says which one it wants.

## Server exports

### Squad lookups

#### `GetConfig()`

Returns the squad configuration table the resource is running with.

**Returns** `table`: the squad config.

<details>
<summary>Example</summary>

```lua
local cfg = exports.rotd_squad:GetConfig()
print(json.encode(cfg))
```

</details>

#### `IsSquadMate(srcA, srcB)`

Checks whether two online players are in the same squad.

| Parameter | Type | Description |
|---|---|---|
| `srcA` | `number` | Server id of the first player. |
| `srcB` | `number` | Server id of the second player. |

**Returns** `boolean`: `true` when both players are in the same squad.

<details>
<summary>Example</summary>

```lua
if exports.rotd_squad:IsSquadMate(src, otherSrc) then
    -- friendly: skip the damage / do not flag as an enemy
end
```

</details>

#### `GetSquadCitizenIds(src)`

Lists the character ids of everyone in the squad of the given player.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of a player in the squad. |

**Returns** `string[]`: array of cids in that player's squad.

<details>
<summary>Example</summary>

```lua
for _, cid in ipairs(exports.rotd_squad:GetSquadCitizenIds(src)) do
    print('squad member', cid)
end
```

</details>

#### `GetSquadLeaderCid(src)`

Finds the leader of the player's squad.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of a player in the squad. |

**Returns** `string | nil`: the leader's cid, or `nil` when the player has no squad.

<details>
<summary>Example</summary>

```lua
local leader = exports.rotd_squad:GetSquadLeaderCid(src)
if leader then print('leader is', leader) end
```

</details>

#### `GetSquadByCid(cid)`

Returns the full squad table for a character. Only works while the squad is loaded, so **online players only**.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `table | nil`: the squad table, or `nil` when the character has no loaded squad.

<details>
<summary>Example</summary>

```lua
local squad = exports.rotd_squad:GetSquadByCid(cid)
if squad then print(squad.squadName) end
```

</details>

#### `GetSquadIdForCid(cid)`

Returns the squad id a character belongs to. **Works offline.**

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `string | nil`: the squad id, or `nil` when the character is in no squad.

<details>
<summary>Example</summary>

```lua
local squadId = exports.rotd_squad:GetSquadIdForCid(ownerCid)
```

</details>

#### `GetAllSquadCitizenIds()`

Lists every character that is in any squad.

**Returns** `string[]`: array of every cid in any squad.

<details>
<summary>Example</summary>

```lua
local all = exports.rotd_squad:GetAllSquadCitizenIds()
print(('%d players are in a squad'):format(#all))
```

</details>

#### `AreCitizenIdsSquadMates(cidA, cidB)`

Cid based version of `IsSquadMate`. **Works offline.** The same cid twice counts as mates.

| Parameter | Type | Description |
|---|---|---|
| `cidA` | `string` | First character id. |
| `cidB` | `string` | Second character id. |

**Returns** `boolean`: `true` when both are in the same squad.

<details>
<summary>Example</summary>

```lua
-- base building owner check for an offline owner
if exports.rotd_squad:AreCitizenIdsSquadMates(ownerCid, builderCid) then
    -- allow
end
```

</details>

#### `IsInSquad(cid)`

Checks whether a character is in any squad.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if not exports.rotd_squad:IsInSquad(cid) then
    -- solo player
end
```

</details>

#### `GetSquadMembers(cid)`

Returns the member entries of the squad a character belongs to.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `table[]`: array of member entries, `{}` when the character has no squad.

<details>
<summary>Example</summary>

```lua
local members = exports.rotd_squad:GetSquadMembers(cid)
print(('squad size: %d'):format(#members))
```

</details>

#### `GetSquadStats(srcOrCid)`

Aggregated statistics of a whole squad. Accepts a server id **or** a cid.

| Parameter | Type | Description |
|---|---|---|
| `srcOrCid` | `number \| string` | Server id (number) or cid (string) of a squad member. |

**Returns** `table | nil`: `nil` when the player has no squad, otherwise:

| Field | Type | Description |
|---|---|---|
| `squadId` | `string` | Squad id. |
| `squadName` | `string` | Display name of the squad. |
| `memberCount` | `number` | Members in the squad. |
| `online` | `number` | Members currently online. |
| `createdAt` | `number` | Unix timestamp the squad was created. |
| `avgRep` | `number` | Average reputation of the members. |
| `avgLevel` | `number` | Average class level of the members. |
| `totals` | `table` | Summed stats: `zombie_kills`, `player_kills`, `deaths`, `headshots`, `players_healed`, `loot_gathered`, `crafts_made`, `missions_completed`, `vehicles_destroyed`, `structures_destroyed`, `reputation_sum`, `level_sum`. |

<details>
<summary>Example</summary>

```lua
local stats = exports.rotd_squad:GetSquadStats(src)
if stats then
    print(stats.squadName, stats.online .. '/' .. stats.memberCount, stats.totals.zombie_kills)
    -- Wolves  2/4  1280
end
```

</details>

### Reputation and stats

#### `GetPlayerReputation(cid)`

Reads a character's reputation.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: the reputation, or the configured default when unknown.

<details>
<summary>Example</summary>

```lua
local rep = exports.rotd_squad:GetPlayerReputation(cid)
```

</details>

#### `ModifyReputation(src, action, customAmount)`

Changes a player's reputation using an action key from the config.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of the player. |
| `action` | `string` | Action key defined in the squad config. |
| `customAmount` | `number?` | Optional amount that overrides the configured one. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_squad:ModifyReputation(src, 'help_player')
exports.rotd_squad:ModifyReputation(src, 'help_player', 25) -- custom amount
```

</details>

#### `GetPlayerStats(cid)`

Reads the stat counters of a character.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `table | nil`: the stats table, or `nil` when none exist.

<details>
<summary>Example</summary>

```lua
local stats = exports.rotd_squad:GetPlayerStats(cid)
if stats then print(stats.zombie_kills) end
```

</details>

#### `GetPlayerFullData(cid)`

Reads the complete player record.

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `table`: the whole record (reputation, stats, squad id, medals, ...).

<details>
<summary>Example</summary>

```lua
local data = exports.rotd_squad:GetPlayerFullData(cid)
```

</details>

#### Stat counters

All of these add to one counter of the player. Pick the one that matches what happened.

| Export | Counter | Notes |
|---|---|---|
| `AddZombieKill(src, amount)` | `zombie_kills` | `amount` defaults to `1`. Throttled. |
| `AddPlayerKill(src)` | `player_kills` | |
| `AddHeadshot(src)` | `headshots` | |
| `AddHealedPlayer(src, amount)` | `players_healed` | `amount` defaults to `1`. |
| `AddLoot(src, amount)` | `loot_gathered` | `amount` defaults to `1`. |
| `AddCraft(src, amount)` | `crafts_made` | `amount` defaults to `1`. |
| `AddMissionComplete(src)` | `missions_completed` | |
| `AddVehicleDestroy(src)` | `vehicles_destroyed` | |
| `AddStructureDestroy(src)` | `structures_destroyed` | |
| `AddDeath(src)` | `deaths` | |

`src` is always the player's **server id** (`number`). `amount` is an optional `number`.

<details>
<summary>Example</summary>

```lua
exports.rotd_squad:AddZombieKill(src)      -- +1
exports.rotd_squad:AddLoot(src, 3)         -- +3
exports.rotd_squad:AddHeadshot(src)
```

</details>

#### `AddMedal(src, medal)`

Awards a medal to a player.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of the player. |
| `medal` | `string` | Medal key. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_squad:AddMedal(src, 'first_blood')
```

</details>

#### `AddAchievement(src, achievement)`

Awards an achievement to a player.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of the player. |
| `achievement` | `string` | Achievement key. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_squad:AddAchievement(src, 'survivor')
```

</details>

#### `ShareXp(src, amount)`

Shares an XP amount with the player's squad mates.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of the player who earned the XP. |
| `amount` | `number` | XP to share. |

**Returns** `table`: the shared result.

<details>
<summary>Example</summary>

```lua
local result = exports.rotd_squad:ShareXp(src, 50)
```

</details>

### Building access

#### `HasBuildingAccess(src, buildingId)`

Checks whether the player's squad gives them access to a building.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id of the player. |
| `buildingId` | `string \| number` | Id of the building. |

**Returns** `boolean`: `true` when the squad grants access.

<details>
<summary>Example</summary>

```lua
if exports.rotd_squad:HasBuildingAccess(src, buildingId) then
    -- let them in
end
```

</details>

## Client exports

#### `GetSquadData()`

The squad of the local player.

**Returns** `table | nil`: the squad table, `nil` when not in a squad.

<details>
<summary>Example</summary>

```lua
local squad = exports.rotd_squad:GetSquadData()
```

</details>

#### `IsInSquad()`

**Returns** `boolean`: whether the local player is in a squad.

<details>
<summary>Example</summary>

```lua
if exports.rotd_squad:IsInSquad() then
    -- show squad UI
end
```

</details>

#### `GetSquadMembers()`

**Returns** `table[]`: array of members. Each entry has a `source` field (server id).

<details>
<summary>Example</summary>

```lua
for _, m in ipairs(exports.rotd_squad:GetSquadMembers()) do
    print('member', m.source)
end
```

</details>

#### `GetReputation()`

**Returns** `number`: the local player's reputation.

<details>
<summary>Example</summary>

```lua
local rep = exports.rotd_squad:GetReputation()
```

</details>

#### `IsSquadMate(serverId)`

Checks whether another player is in the local player's squad.

| Parameter | Type | Description |
|---|---|---|
| `serverId` | `number` | Server id of the other player. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if exports.rotd_squad:IsSquadMate(GetPlayerServerId(ped)) then
    -- do not target squad mates
end
```

</details>

#### `CheckBuildingAccess(buildingId, timeoutMs)`

Asks the server whether the local player's squad has access to a building.

> [!WARNING]
> **Blocking.** Call it from a thread, never from the main frame.

| Parameter | Type | Description |
|---|---|---|
| `buildingId` | `string \| number` | Id of the building. |
| `timeoutMs` | `number?` | How long to wait for the server. Defaults to the config value (5000 ms). |

**Returns** `boolean`: `true` when access is granted, `false` when denied **or** when the request timed out.

<details>
<summary>Example</summary>

```lua
-- client: do not allow raiding squad mates' base
CreateThread(function()
    if exports.rotd_squad:CheckBuildingAccess(buildingId) then
        print('squad has access')
    end
end)
```

</details>

#### `IsFriendlyFireBlocked()`

**Returns** `boolean`: `true` when friendly fire between squad mates is blocked.

<details>
<summary>Example</summary>

```lua
if exports.rotd_squad:IsFriendlyFireBlocked() then
    -- cancel damage between squad mates
end
```

</details>

#### `PingAt(coord, pingType)`

Sends a map ping to the whole squad.

| Parameter | Type | Description |
|---|---|---|
| `coord` | `vector3` | World position to ping. |
| `pingType` | `string?` | Ping type. Defaults to `'mark'`. |

**Returns** `boolean`: whether the ping was sent.

<details>
<summary>Example</summary>

```lua
exports.rotd_squad:PingAt(GetEntityCoords(PlayerPedId()), 'mark')
```

</details>

## Optional integrations

`rotd_squad` shows data from other ROTD resources when they run: class from `rotd_classystem` (`GetPlayerClass`), zombie kills from `rotd_leaderboard` (`GetZombieKillsTotal`), HUD notifications and friends list from the ROTD HUD. Each missing partner only disables its own part.

## Data shapes

### Squad table (`GetSquadByCid`)

```lua
{
    id = 'squad_1730000000_4821',
    leader = 'ABC12345',                 -- cid of the leader
    name = 'Squad 4821',
    created = 1730000000,                -- os.time()
    friendlyFire = false,
    members = {                          -- stored members
        { citizenid = 'ABC12345', name = 'John Doe', level = 12, class = 'medic',
          isLeader = true, joined = 1730000000, reputation = 520 },
    },
}
```

### Member list entry (`GetSquadMembers`, server and client)

```lua
{
    citizenid = 'ABC12345',
    name = 'John Doe',
    level = 12,
    class = 'medic',
    isLeader = true,
    online = true,
    source = 14,                         -- server id, nil when offline
    health = 187,                        -- 0 when offline
    ping = 32,
    infection = 0,                       -- 0..11
    isMedic = true,
    reputation = 520,
    reputationColor = '#9ACD32',         -- hex, from the reputation scale
    color = '#00FF88',                   -- name colour the player chose, nil = default
    colorRgb = { 0, 255, 136 },
    icon = nil,                          -- chosen emoji, nil = class icon
    coords = { x = 215.0, y = -810.0, z = 30.0 },   -- nil when offline
}
```

### Stats (`GetPlayerStats`)

```lua
{
    zombie_kills = 0, player_kills = 0, deaths = 0, headshots = 0,
    players_healed = 0, loot_gathered = 0, crafts_made = 0,
    missions_completed = 0, vehicles_destroyed = 0, structures_destroyed = 0,
    time_played = 0, distance_traveled = 0, survival_days = 0,
    medals = {},          -- array of medal keys
    achievements = {},    -- array of achievement keys
}
```

### Reputation

Reputation is a number from `-10000` to `10000`, new players start at `500`. `ModifyReputation(src, action, customAmount)` takes one of these action keys (amounts are in the squad config):

| Action | Change | Action | Change |
|---|---|---|---|
| `heal` | +10 | `playerKill` | -100 |
| `help` | +5 | `vehicleDestroy` | -30 |
| `zombieKill` | +1 | `baseDestroy` | -100 |
| `pveAction` | +1 | `baseDamage` | -20 |
| `loot` | +1 | `steal` | -25 |
| `craft` | +2 | `manual` | `customAmount` (a number) |
| `missionComplete` | +10 | | |
| `achievement` | +15 | | |

Reputation names by value: Saint (9000+), Legend, Hero, Guardian, Sentinel, Protector, Samaritan, Trusted, Friendly (600+), **Neutral (400+, default)**, Suspicious, Shady, Untrusted (0+), Troublemaker, Aggressive, Violent, Hostile, Killer, Butcher, Monster, Demon (-9000 and below).

### `GetPlayerFullData(cid)`

The whole player record: `{ source, citizenid, name, level, class, reputation, stats, squadid, health, isMedic, ... }`. Treat unknown fields as internal.

## Recipes

### No damage between squad mates (server)

```lua
AddEventHandler('weaponDamageEvent', function(sender, data)
    local attacker = tonumber(sender)
    if not attacker or data.hitGlobalId == nil then return end

    local victimEntity = NetworkGetEntityFromNetworkId(data.hitGlobalId)
    if victimEntity == 0 or not IsPedAPlayer(victimEntity) then return end
    local victim = NetworkGetEntityOwner(victimEntity)

    if exports.rotd_squad:IsSquadMate(attacker, victim) then
        CancelEvent()       -- friendly fire off (use the squad's friendlyFire flag if you want it optional)
    end
end)
```

### Reward the whole squad for a mission (server)

```lua
local function rewardSquad(src)
    for _, cid in ipairs(exports.rotd_squad:GetSquadCitizenIds(src)) do
        local member = GetSourceByCid(cid)         -- your own cid -> src lookup
        if member then
            exports.rotd_squad:AddMissionComplete(member)
            exports.rotd_squad:ModifyReputation(member, 'missionComplete')
        end
    end
end
```

### Penalise griefing (server)

```lua
AddEventHandler('mybase:server:structureDestroyed', function(destroyerSrc, ownerCid)
    local destroyerCid = GetCidBySource(destroyerSrc)   -- your own lookup
    exports.rotd_squad:AddStructureDestroy(destroyerSrc)
    exports.rotd_squad:ModifyReputation(destroyerSrc, 'baseDestroy')

    -- squad mates of the owner are allowed, even when the owner is offline
    if exports.rotd_squad:AreCitizenIdsSquadMates(destroyerCid, ownerCid) then
        exports.rotd_squad:ModifyReputation(destroyerSrc, 'manual', 100)   -- undo the penalty
    end
end)
```

### Door that squad mates may open (server + client)

```lua
-- server: authoritative
RegisterNetEvent('mydoors:server:open', function(doorId)
    local src = source
    if exports.rotd_squad:HasBuildingAccess(src, doorId) then
        TriggerClientEvent('mydoors:client:open', src, doorId)
    end
end)

-- client: ask first, the export waits for the server (use a thread)
CreateThread(function()
    if exports.rotd_squad:CheckBuildingAccess(doorId, 3000) then
        TriggerServerEvent('mydoors:server:open', doorId)
    else
        lib.notify({ description = 'No access', type = 'error' })
    end
end)
```

### Show squad mates on your own HUD (client)

```lua
CreateThread(function()
    while true do
        Wait(1000)
        if exports.rotd_squad:IsInSquad() then
            for _, m in ipairs(exports.rotd_squad:GetSquadMembers()) do
                if m.online and m.coords then
                    print(m.name, m.health, m.reputationColor)
                end
            end
        end
    end
end)

-- ping a location for the squad
exports.rotd_squad:PingAt(GetEntityCoords(PlayerPedId()), 'mark')
```

### Read a leaderboard-style summary (server)

```lua
local stats = exports.rotd_squad:GetSquadStats(src)      -- src (number) or cid (string)
if stats then
    print(stats.squadName, stats.memberCount, stats.online, stats.totals.zombie_kills)
end
```
