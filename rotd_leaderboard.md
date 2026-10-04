# rotd_leaderboard

Read-only stat lookups from the `player_stats` table. All exports are **server side** and take a **cid** (character id). Unknown players return `0`.

| Export | Returns | Period |
|---|---|---|
| `GetZombieKillsPerDay(cid)` | number | daily |
| `GetDogTagsCollected(cid)` | number | daily |
| `GetLongestSurvivalStreak(cid)` | days | daily |
| `GetZombieKillsTotal(cid)` | number | lifetime |
| `GetPvpKillsRedzone(cid)` | number | lifetime |
| `GetPlayerDistanceTravel(cid)` | number (2 decimals) | lifetime |

```lua
-- server
local kills = exports.rotd_leaderboard:GetZombieKillsTotal(cid)
if kills >= 1000 then print(cid, 'is a veteran') end
```

Stats are written by the resource's own events (`rotd_leaderboard:updateZombieKill` and similar); other resources should not write them directly.
