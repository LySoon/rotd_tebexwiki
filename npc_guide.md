# npc_guide

Quest NPCs, quest progress, and the currency exchange market.

## Server exports: quests

All of these take the player's **server id** (`src`, `number`) first.

#### `GiveQuest(src, questId)`

Gives a quest to a player.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `questId` | `string` | Quest id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:GiveQuest(src, 'first_steps')
```

</details>

#### `UpdateQuestProgress(src, questId, objectiveId, amount)`

Advances one objective of one quest.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `questId` | `string` | Quest id. |
| `objectiveId` | `string` | Objective inside that quest. |
| `amount` | `number` | Progress to add. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:UpdateQuestProgress(src, 'tag_hunt', 'collect_tags', 1)
```

</details>

#### `TrackEvent(src, event, amount, meta)`

Advances **every active objective** that listens for that event. You do not need quest ids, which makes it the easiest way to feed quests from your own scripts.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `event` | `string` | Event name, e.g. `'scav_kill'`. |
| `amount` | `number` | How much to add. |
| `meta` | `table?` | Optional extra data, e.g. `{ type = 'lockpick' }`. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
-- count a kill for any quest that listens for 'scav_kill'
exports.npc_guide:TrackEvent(killerSrc, 'scav_kill', 1)
exports.npc_guide:TrackEvent(src, 'minigame', 1, { type = 'lockpick' })
```

</details>

#### `TracksEvent(src, event)`

Cheap guard: does the player have an active objective for that event? Skip heavy work when not.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `event` | `string` | Event name. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
if exports.npc_guide:TracksEvent(src, 'drive_distance') then
    -- report distance
end
```

</details>

#### `CompleteQuest(src, questId)`

Force-completes the objectives of a quest.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `questId` | `string` | Quest id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:CompleteQuest(src, 'first_steps')
```

</details>

#### `ClaimReward(src, questId)`

Claims the reward of a finished quest. The HUD calls this on the claim button.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `questId` | `string` | Quest id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:ClaimReward(src, 'first_steps')
```

</details>

#### `AbandonQuest(src, questId)`

Cancels a quest.

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |
| `questId` | `string` | Quest id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:AbandonQuest(src, 'first_steps')
```

</details>

#### `GetPlayerQuests(src)`

| Parameter | Type | Description |
|---|---|---|
| `src` | `number` | Server id. |

**Returns** `table`: `{ [questId] = snapshot }` for all known quests.

<details>
<summary>Example</summary>

```lua
for questId, snapshot in pairs(exports.npc_guide:GetPlayerQuests(src)) do
    print(questId, json.encode(snapshot))
end
```

</details>

## Client exports

#### `TrackMinigame(mtype, difficulty)`

Reports a **successful** minigame to the server (rate limited server side). Called by `rotd-minigame`.

| Parameter | Type | Description |
|---|---|---|
| `mtype` | `string` | Minigame type. |
| `difficulty` | `number` | Difficulty, `1` to `7`. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.npc_guide:TrackMinigame('lockpick', 4)
```

</details>

#### `HasShopkeeper(shopKey)`

| Parameter | Type | Description |
|---|---|---|
| `shopKey` | `string` | Shop key. |

**Returns** `string | nil`: the shopkeeper's display name, `nil` when no dialogue exists for that shop key.

<details>
<summary>Example</summary>

```lua
local name = exports.npc_guide:HasShopkeeper('currency')
if name then print('talk to', name) end
```

</details>

#### `OpenShopkeeper(shopKey, ped, shopNum)`

Opens the shopkeeper dialogue, then the shop.

| Parameter | Type | Description |
|---|---|---|
| `shopKey` | `string` | Shop key. |
| `ped` | `number` | The shopkeeper ped entity. |
| `shopNum` | `number` | Shop number. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.npc_guide:OpenShopkeeper('currency', ped, 1)
```

</details>

## Server exports: market

#### `ReportCurrencyFlow(name, units, shopKey)`

Tells the market that currency entered or left the economy. Positive units are supply and push the price down at the next settlement.

| Parameter | Type | Description |
|---|---|---|
| `name` | `string` | Currency name, e.g. `'dogtag'`. |
| `units` | `number` | `+` minted, `-` burned. |
| `shopKey` | `string?` | Optional shop. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
-- 40 dog tags entered the economy, 25 left it
exports.npc_guide:ReportCurrencyFlow('dogtag', 40)
exports.npc_guide:ReportCurrencyFlow('dogtag', -25)
```

</details>

#### `SetCurrencySupply(name, units, shopKey)`

Sets how much of the currency exists in the world. Only used when `Config.ExchangeRates.circulationLiquidity > 0`.

| Parameter | Type | Description |
|---|---|---|
| `name` | `string` | Currency name. |
| `units` | `number` | Amount that exists in the world. |
| `shopKey` | `string?` | Optional shop. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.npc_guide:SetCurrencySupply('dogtag', 5000)
```

</details>

#### `GetMarketSnapshot(shopKey)`

| Parameter | Type | Description |
|---|---|---|
| `shopKey` | `string` | Shop key. |

**Returns** `table | nil`: `{ [name] = row }`, where every row has:

| Field | Type | Description |
|---|---|---|
| `value` | `number` | Current price. |
| `base` | `number` | Base price. |
| `min` / `max` | `number` | Price limits. |
| `circulation` | `number` | Units in circulation. |
| `netThisWindow` | `number` | Net flow in the current window. |
| `volumeThisWindow` | `number` | Traded volume in the current window. |
| `tradersThisWindow` | `number` | Traders in the current window. |
| `settleIn` | `number` | Time until the next settlement. |

<details>
<summary>Example</summary>

```lua
local board = exports.npc_guide:GetMarketSnapshot('currency')
if board and board.dogtag then print(board.dogtag.value) end
```

</details>

#### `GetMarketHistory(shopKey, name, span, sinceSeconds)`

Price history as candles.

| Parameter | Type | Description |
|---|---|---|
| `shopKey` | `string` | Shop key. |
| `name` | `string` | Currency name. |
| `span` | `string` | `'hourly'` or `'daily'`. |
| `sinceSeconds` | `number?` | Only return candles newer than this many seconds. |

**Returns** `table[]`: candles, oldest first: `{ bucket, open, high, low, close, volume, net, mint, traders }`.

<details>
<summary>Example</summary>

```lua
local candles = exports.npc_guide:GetMarketHistory('currency', 'dogtag', 'daily')
```

</details>

#### `GetMarketBoard(shopKey)`

| Parameter | Type | Description |
|---|---|---|
| `shopKey` | `string` | Shop key. |

**Returns** `table`: the rows the exchange dialogue shows.

<details>
<summary>Example</summary>

```lua
local rows = exports.npc_guide:GetMarketBoard('currency')
```

</details>

#### `PushMarketMonitor(monitor)`

Posts or updates the Discord monitor.

| Parameter | Type | Description |
|---|---|---|
| `monitor` | `string` | `'daily'` or `'weekly'`. |

**Returns** `boolean`

<details>
<summary>Example</summary>

```lua
exports.npc_guide:PushMarketMonitor('daily')
```

</details>

## Data shapes

### Quest definition (`shared/quests.lua`)

```lua
Quests['tag_hunt'] = {
    id = 'tag_hunt',
    title = 'Tag Hunt',
    description = 'Bring me dog tags.',
    objectives = {
        { id = 'collect_tags', label = 'Deliver Dog Tags', count = 5,
          track = 'deliver', item = 'dogtag', itemLabel = 'Dog Tag' },
        { id = 'kill_scavs', label = 'Kill scavengers', count = 10, track = 'scav_kill' },
        { id = 'pick_locks', label = 'Pick locks', count = 5, track = 'minigame', filter = { type = 'lockpick' } },
    },
    rewards = { { type = 'money' }, { type = 'item' }, { type = 'xp' }, { type = 'custom' } },   -- list, each has a type
    requires = { 'first_steps' },        -- quest ids that must be CLAIMED first
    minLevel = 5,                        -- rotd-hud level (an unknown level never blocks)
    repeatable = false,
    cooldown = 0,                        -- seconds before a repeatable quest can be retaken
    autoComplete = false,                -- true = reward is granted without a claim step
}
```

### Quest status values

`'available'` (not taken), `'active'`, `'completed'` (objectives done, reward not claimed), `'claimed'` (finished).

### Snapshot (`GetPlayerQuests`)

```lua
{
    id = 'tag_hunt',
    title = 'Tag Hunt',
    description = 'Bring me dog tags.',
    status = 'active',
    objectives = {
        { id = 'collect_tags', label = 'Deliver Dog Tags', current = 2, total = 5 },
    },
    rewards = { ... },
    repeatable = false,
}
```

### Event names for `TrackEvent`

| Event | What `amount` counts | `meta` |
|---|---|---|
| `deliver` | handed in at the NPC (not a passive counter) | |
| `player_kill` | kills | |
| `vehicle_destroy` | vehicles | |
| `scav_kill` | scavenger kills | |
| `zombie_kill` | kills (killing blow only) | `type`, `base`, `melee`, `weapon`, `zone`, `variant` |
| `revive` | revives | `kind` = `'defib'` or `'stabilize'` |
| `minigame` | successful minigames | `type`, `difficulty` |
| `playtime` | **seconds** | |
| `run_distance` | **metres** on foot | |
| `drive_distance` | **metres** as the driver | |
| `shop_purchase` | items received | `shop`, `item` |
| `shop_spend` | money spent | `shop`, `billType` |
| `backpack_upgrade` | upgrades | `level` (the new level) |
| `backpack_repair` | repairs | |
| `exchange` | trades | `from`, `to` (currency item names) |
| `bank_transfer` | the **amount** moved | `action` = `'deposit'` or `'withdraw'` |

Any other string is allowed: define an objective with `track = 'my_event'` and report it with `TrackEvent(src, 'my_event', 1, meta)`. A `filter` on the objective must match every key of the reported `meta`.

### Real keys used in examples

Quests: `first_steps` (objective `survive_start`, 600 s of `playtime`), `tag_hunt` (objective `collect_tags`), `on_foot` (objective `run_far`, `run_distance`). Shop keys (jim-shops locations): `medicshop`, `baseshop`, `weaponSHOP`, `utilityShop`, `currency`, `casinoshop`, `bagshop`, `barber`, `foodshop`, `mechanic`. Currencies traded at the `currency` desk: `money`, `sodacap`, `dogtag`, `medal`.

## Recipes

### Quest progress from your own system (server)

```lua
-- a bounty script: every completed bounty counts for quests that listen for 'bounty_done'
RegisterNetEvent('mybounty:server:done', function(bountyId)
    local src = source
    if exports.npc_guide:TracksEvent(src, 'bounty_done') then
        exports.npc_guide:TrackEvent(src, 'bounty_done', 1, { bounty = bountyId })
    end
end)
```

### Show a player's quest list (server)

```lua
RegisterCommand('myquests', function(src)
    for questId, q in pairs(exports.npc_guide:GetPlayerQuests(src)) do
        if q.status == 'active' then
            for _, o in ipairs(q.objectives) do
                print(('%s: %s %d/%d'):format(q.title, o.label, o.current, o.total))
            end
        end
    end
end, false)
```

### Give a quest from a mission script (server)

```lua
RegisterNetEvent('mymission:server:accepted', function()
    local src = source
    exports.npc_guide:GiveQuest(src, 'first_steps')
end)
```

### Keep the exchange market honest (server)

```lua
-- your crafting recipe burns dog tags: report the sink so the price reacts
local function craftWithTags(src, tags)
    -- ... remove the tags from the player ...
    exports.npc_guide:ReportCurrencyFlow('dogtag', -tags)
end

-- once per 10 minutes tell the market how many tags exist (needs Config.ExchangeRates.circulationLiquidity > 0)
CreateThread(function()
    while true do
        Wait(10 * 60000)
        exports.npc_guide:SetCurrencySupply('dogtag', CountAllDogTags())     -- your own count
    end
end)
```

### Read the live price board (server)

```lua
local snapshot = exports.npc_guide:GetMarketSnapshot('currency')
if snapshot then
    for name, row in pairs(snapshot) do
        print(name, row.value, ('range %s-%s'):format(row.min, row.max), 'settles in', row.settleIn)
    end
end

-- last 24 hourly candles of dog tags
local candles = exports.npc_guide:GetMarketHistory('currency', 'dogtag', 'hourly', 86400)
for _, c in ipairs(candles) do print(c.bucket, c.open, c.high, c.low, c.close) end
```

### Report a successful minigame (client)

```lua
-- rotd-minigame already does this on success; use it only for your own minigame
exports.npc_guide:TrackMinigame('lockpick', 4)
```
