# rotd_squad

Squads, reputation, per-player stats and squad building access. Identifiers: some exports take a **server id (`src`)**, others a **character id (`cid`)**. Check each row.

## Server exports

### Squad lookups

| Export | Input | Returns |
|---|---|---|
| `GetConfig()` | none | the squad config table |
| `IsSquadMate(srcA, srcB)` | two server ids | `boolean` same squad |
| `GetSquadCitizenIds(src)` | server id | array of cids in that player's squad |
| `GetSquadLeaderCid(src)` | server id | leader cid or `nil` |
| `GetSquadByCid(cid)` | cid | squad table or `nil` (online players only) |
| `GetSquadIdForCid(cid)` | cid | squad id or `nil`. **Works offline** |
| `GetAllSquadCitizenIds()` | none | array of every cid in any squad |
| `AreCitizenIdsSquadMates(cidA, cidB)` | two cids | `boolean`. **Works offline**, same cid counts as mates |
| `IsInSquad(cid)` | cid | `boolean` |
| `GetSquadMembers(cid)` | cid | array of member entries, `{}` when none |
| `GetSquadStats(srcOrCid)` | server id (number) or cid (string) | aggregate squad stats, see below |

`GetSquadStats` returns `nil` or:

```lua
{
    squadId = 'abc', squadName = 'Wolves', memberCount = 4, online = 2, createdAt = 1730000000,
    avgRep = 520, avgLevel = 7.5,
    totals = { zombie_kills = 0, player_kills = 0, deaths = 0, headshots = 0, players_healed = 0, loot_gathered = 0,
               crafts_made = 0, missions_completed = 0, vehicles_destroyed = 0, structures_destroyed = 0,
               reputation_sum = 0, level_sum = 0 },
}
```

### Reputation and stats

| Export | Input | Effect |
|---|---|---|
| `GetPlayerReputation(cid)` | cid | reputation number (default when unknown) |
| `ModifyReputation(src, action, customAmount)` | server id, action key from the config, optional amount | changes reputation |
| `GetPlayerStats(cid)` | cid | stats table or `nil` |
| `GetPlayerFullData(cid)` | cid | the whole player record (reputation, stats, squad id, medals, ...) |
| `AddZombieKill(src, amount)` | amount default 1 | `zombie_kills` (throttled) |
| `AddPlayerKill(src)` | | `player_kills` |
| `AddHeadshot(src)` | | `headshots` |
| `AddHealedPlayer(src, amount)` | amount default 1 | `players_healed` |
| `AddLoot(src, amount)` | amount default 1 | `loot_gathered` |
| `AddCraft(src, amount)` | amount default 1 | `crafts_made` |
| `AddMissionComplete(src)` | | `missions_completed` |
| `AddVehicleDestroy(src)` | | `vehicles_destroyed` |
| `AddStructureDestroy(src)` | | `structures_destroyed` |
| `AddDeath(src)` | | `deaths` |
| `AddMedal(src, medal)` | medal key | awards a medal |
| `AddAchievement(src, achievement)` | achievement key | awards an achievement |
| `ShareXp(src, amount)` | | shares XP with squad mates, returns the shared result |

### Building access

`HasBuildingAccess(src, buildingId)` returns `boolean`: does the player's squad give access to that building.

```lua
-- server: count a loot for the player and check a squad-mate relation
exports.rotd_squad:AddLoot(src, 1)
if exports.rotd_squad:IsSquadMate(src, otherSrc) then
    -- friendly
end

-- base building owner check for an offline owner
if exports.rotd_squad:AreCitizenIdsSquadMates(ownerCid, builderCid) then
    -- allow
end
```

## Client exports

| Export | Returns |
|---|---|
| `GetSquadData()` | the player's squad table or `nil` |
| `IsInSquad()` | `boolean` |
| `GetSquadMembers()` | array of members (each has `source`) |
| `GetReputation()` | number |
| `IsSquadMate(serverId)` | `boolean` |
| `CheckBuildingAccess(buildingId, timeoutMs)` | **blocking** `boolean`: asks the server, `false` on timeout (default from config, 5000 ms). Call from a thread |
| `IsFriendlyFireBlocked()` | `boolean` |
| `PingAt(coord, pingType)` | `boolean`: sends a map ping to the squad (`pingType` default `'mark'`) |

```lua
-- client: do not allow raiding squad mates' base
CreateThread(function()
    if exports.rotd_squad:CheckBuildingAccess(buildingId) then
        print('squad has access')
    end
end)
```

## Optional integrations

`rotd_squad` shows data from other ROTD resources when they run: class from `rotd_classystem` (`GetPlayerClass`), zombie kills from `rotd_leaderboard` (`GetZombieKillsTotal`), HUD notifications and friends list from the ROTD HUD. Each missing partner only disables its own part.
