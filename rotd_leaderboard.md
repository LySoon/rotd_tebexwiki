# rotd_leaderboard

Read-only stat lookups from the `player_stats` table. All exports are **server side** and take a **cid** (character id, `string`). Unknown players return `0`.

> Stats are written by the resource's own events (`rotd_leaderboard:updateZombieKill` and similar). Other resources should not write them directly.

## Server exports

### Daily stats

#### `GetZombieKillsPerDay(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: zombie kills today.

<details>
<summary>Example</summary>

```lua
local today = exports.rotd_leaderboard:GetZombieKillsPerDay(cid)
```

</details>

#### `GetDogTagsCollected(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: dog tags collected today.

<details>
<summary>Example</summary>

```lua
local tags = exports.rotd_leaderboard:GetDogTagsCollected(cid)
```

</details>

#### `GetLongestSurvivalStreak(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: the longest survival streak, in days.

<details>
<summary>Example</summary>

```lua
local days = exports.rotd_leaderboard:GetLongestSurvivalStreak(cid)
```

</details>

### Lifetime stats

#### `GetZombieKillsTotal(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: lifetime zombie kills.

<details>
<summary>Example</summary>

```lua
local kills = exports.rotd_leaderboard:GetZombieKillsTotal(cid)
if kills >= 1000 then print(cid, 'is a veteran') end
```

</details>

#### `GetPvpKillsRedzone(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: lifetime PvP kills in red zones.

<details>
<summary>Example</summary>

```lua
local pvp = exports.rotd_leaderboard:GetPvpKillsRedzone(cid)
```

</details>

#### `GetPlayerDistanceTravel(cid)`

| Parameter | Type | Description |
|---|---|---|
| `cid` | `string` | Character id. |

**Returns** `number`: lifetime distance travelled, rounded to 2 decimals.

<details>
<summary>Example</summary>

```lua
local dist = exports.rotd_leaderboard:GetPlayerDistanceTravel(cid)
```

</details>
