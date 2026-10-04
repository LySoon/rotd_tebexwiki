# npc_guide

Quest NPCs, quest progress, and the currency exchange market.

## Server exports: quests

| Export | Input | Returns |
|---|---|---|
| `GiveQuest(src, questId)` | | gives a quest to a player |
| `UpdateQuestProgress(src, questId, objectiveId, amount)` | | advances one objective |
| `TrackEvent(src, event, amount, meta)` | event name, amount, optional meta table | advances **every active objective** listening for that event. You do not need quest ids |
| `TracksEvent(src, event)` | | `boolean`: does the player have an active objective for that event (skip work when not) |
| `CompleteQuest(src, questId)` | | force-completes the objectives |
| `ClaimReward(src, questId)` | | claims the reward (the HUD calls this on the claim button) |
| `AbandonQuest(src, questId)` | | cancels a quest |
| `GetPlayerQuests(src)` | | `{ [questId] = snapshot }` for all known quests |

```lua
-- server: count a kill for any quest that listens for 'scav_kill'
exports.npc_guide:TrackEvent(killerSrc, 'scav_kill', 1)
exports.npc_guide:TrackEvent(src, 'minigame', 1, { type = 'lockpick' })

-- cheap guard before heavy work
if exports.npc_guide:TracksEvent(src, 'drive_distance') then
    -- report distance
end
```

## Client exports

| Export | Returns |
|---|---|
| `TrackMinigame(mtype, difficulty)` | reports a **successful** minigame to the server (rate limited server side). Called by `rotd-minigame` |
| `HasShopkeeper(shopKey)` | the shopkeeper's display name, `nil` when no dialogue exists for that shop key |
| `OpenShopkeeper(shopKey, ped, shopNum)` | `boolean`: opens the shopkeeper dialogue (then the shop) |

## Server exports: market

| Export | Input | Returns |
|---|---|---|
| `ReportCurrencyFlow(name, units, shopKey)` | currency name, units (`+` minted, `-` burned), optional shop | `boolean`. Positive units are supply and push the price down at the next settlement |
| `SetCurrencySupply(name, units, shopKey)` | how much of the currency exists in the world | `boolean`. Only used when `Config.ExchangeRates.circulationLiquidity > 0` |
| `GetMarketSnapshot(shopKey)` | | `{ [name] = { value, base, min, max, circulation, netThisWindow, volumeThisWindow, tradersThisWindow, settleIn } }` or `nil` |
| `GetMarketHistory(shopKey, name, span, sinceSeconds)` | `span` = `'hourly'` or `'daily'` | candles, oldest first: `{ bucket, open, high, low, close, volume, net, mint, traders }` |
| `GetMarketBoard(shopKey)` | | the rows the exchange dialogue shows |
| `PushMarketMonitor(monitor)` | `'daily'` or `'weekly'` | `boolean`: posts/updates the Discord monitor |

```lua
-- server: 40 dog tags entered the economy, 25 left it
exports.npc_guide:ReportCurrencyFlow('dogtag', 40)
exports.npc_guide:ReportCurrencyFlow('dogtag', -25)

local board = exports.npc_guide:GetMarketSnapshot('exchange_downtown')
```
