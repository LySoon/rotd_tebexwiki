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
exports.npc_guide:UpdateQuestProgress(src, 'first_steps', 'collect_wood', 1)
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
local name = exports.npc_guide:HasShopkeeper('exchange_downtown')
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
exports.npc_guide:OpenShopkeeper('exchange_downtown', ped, 1)
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
local board = exports.npc_guide:GetMarketSnapshot('exchange_downtown')
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
local candles = exports.npc_guide:GetMarketHistory('exchange_downtown', 'dogtag', 'daily')
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
local rows = exports.npc_guide:GetMarketBoard('exchange_downtown')
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
