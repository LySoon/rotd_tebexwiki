# Export index

Every export in the pack, A to Z. **173 exports** across **14 pages**. On the website press Ctrl+K to search this list.

| Export | Side | Resource | What it does |
|---|---|---|---|
| `AbandonQuest(src, questId)` | server | [npc_guide](npc_guide) | Cancels a quest. |
| `ActivatePlayerSkill(src, skillId, ...)` | server | [rotd_classystem](rotd_classystem) | Triggers an activatable skill on the server. Authorised. |
| `ActivateSkill(skillId)` | client | [rotd_classystem](rotd_classystem) | Triggers a skill. |
| `AddAchievement(src, achievement)` | server | [rotd_squad](rotd_squad) | Awards an achievement to a player. |
| `AddBonusSkillPoints(src, className, amount)` | server | [rotd_classystem](rotd_classystem) | Gives skill points. Authorised. |
| `AddExperience(src, amount)` | server | [rotd_classystem](rotd_classystem) | Currently always returns false (HUD-level mode). Authorised. |
| `AddExperienceToClass(src, className, amount)` | server | [rotd_classystem](rotd_classystem) | Currently always returns false (HUD-level mode). Authorised. |
| `AddMedal(src, medal)` | server | [rotd_squad](rotd_squad) | Awards a medal to a player. |
| `AddPlayerRadiation(src, amount, applyResistance, pierce)` | server | [rotd_zones](rotd_zones) | Adds a dose to a player. Resistance is applied unless applyResistance == false. |
| `AddRadiation(amount, applyResist, pierce)` | client | [rotd_zones](rotd_zones) | Adds a dose. Use this for doses coming from other resources: it applies resistance for you and is safe next to the zo... |
| `AddResistanceModifier(id, percent, label)` | client | [rotd_zones](rotd_zones) | Adds a temporary resistance bonus. It counts like a clothing slot: summed with the rest and capped. |
| `AreCitizenIdsSquadMates(cidA, cidB)` | server | [rotd_squad](rotd_squad) | Cid based version of IsSquadMate. Works offline. The same cid twice counts as mates. |
| `AwardActionExperience(src, actionKey, context)` | server | [rotd_classystem](rotd_classystem) | Awards XP for a configured action. Authorised. |
| `Bridge.Framework.GetCharValue(key)` | client | [rotd_bridge](rotd_bridge) | Persistent per-character value of the local player. |
| `Bridge.Framework.GetCharValue(src, key)` | server | [rotd_bridge](rotd_bridge) | Reads a persistent per-character value (charinfo on QB/Qbox, rotd_player_data on ESX). |
| `Bridge.Framework.GetGender()` | client | [rotd_bridge](rotd_bridge) | Returns number: 0 male, 1 female. |
| `Bridge.Framework.GetIdentifier(src)` | server | [rotd_bridge](rotd_bridge) | Returns string: the citizenid on QB/Qbox, the identifier on ESX. |
| `Bridge.Framework.GetName(src)` | server | [rotd_bridge](rotd_bridge) | Returns string: first and last name of the character. |
| `Bridge.Framework.GetPlayer(src)` | server | [rotd_bridge](rotd_bridge) | Returns table: the framework's own player object. |
| `Bridge.Framework.GetPlayerData()` | client | [rotd_bridge](rotd_bridge) | Returns table: the framework's local player data. |
| `Bridge.Framework.IsAdmin(src)` | server | [rotd_bridge](rotd_bridge) | Checks the framework permission, the ESX group, or the ACE command permission. The console counts as admin. |
| `Bridge.Framework.IsLoggedIn()` | client | [rotd_bridge](rotd_bridge) | Returns boolean |
| `Bridge.Framework.OnPlayerLoaded(cb)` | client | [rotd_bridge](rotd_bridge) | Runs a callback on every login, and once immediately when the player is already logged in. |
| `Bridge.Framework.OnPlayerUnloaded(cb)` | client | [rotd_bridge](rotd_bridge) | Returns nothing. |
| `Bridge.Framework.RegisterCommand(name, help, params, fn, opts)` | server | [rotd_bridge](rotd_bridge) | Registers a command that works on any framework. |
| `Bridge.Framework.SetCharValue(src, key, value, opts)` | server | [rotd_bridge](rotd_bridge) | Stores a persistent per-character value. |
| `Bridge.Garage.IsInGarage()` | client | [rotd_bridge](rotd_bridge) | qb-garages is supported. |
| `Bridge.Hud.Export(name, ...)` | any | [rotd_bridge](rotd_bridge) | Calls an export of the HUD, skipped while the HUD is not running. |
| `Bridge.Hud.Init(feature, fallback)` | any | [rotd_bridge](rotd_bridge) | Returns nothing. |
| `Bridge.Hud.IsReady()` | any | [rotd_bridge](rotd_bridge) | Returns boolean: whether the HUD is running and ready. |
| `Bridge.Inventory.GetItems(src)` | server | [rotd_bridge](rotd_bridge) | Lists a player's items in one format, whichever inventory runs (core_inventory, ox_inventory, qb-inventory). |
| `Bridge.Log.info / warn / error / debug(fmt, ...)` | any | [rotd_bridge](rotd_bridge) | Prints a log line prefixed with [rotd_bridge]. |
| `Bridge.Medical.Infection(feature)` | any | [rotd_bridge](rotd_bridge) | Handle for a medical resource that has an infection system. See rotd_zones for the infection exports that replace it... |
| `Bridge.Medical.IsDead()` | any | [rotd_bridge](rotd_bridge) | Works with any medical resource (falls back to player state and health). |
| `Bridge.Optional(resource, meta)` | any | [rotd_bridge](rotd_bridge) | Cooperation with a resource that may not run. Returns a handle you use instead of calling the resource directly. |
| `CanBuildAtCoords(coords)` | client | [rotd_zones](rotd_zones) | Checks whether building is allowed at a position. |
| `CheckBuildingAccess(buildingId, timeoutMs)` | client | [rotd_squad](rotd_squad) | Asks the server whether the local player's squad has access to a building. |
| `CheckCoordsZoneType(ped)` | client | [rotd_zones](rotd_zones) | Zone type for a ped. |
| `CheckCoordsZoneTypeCoords(coords)` | client | [rotd_zones](rotd_zones) | Short zone summary at a position. |
| `CheckCoordsZoneTypeCoordsRules(coords)` | shared | [rotd_zones](rotd_zones) | The rules that apply at a position, or the defaults outside any zone. |
| `ClaimReward(src, questId)` | server | [npc_guide](npc_guide) | Claims the reward of a finished quest. The HUD calls this on the claim button. |
| `CompleteQuest(src, questId)` | server | [npc_guide](npc_guide) | Force-completes the objectives of a quest. |
| `GetActiveVehicles()` | server | [rotd_events](rotd_events) | Lists the vehicles the event system currently owns. vehicle_spawner uses it so its cleanup sweep leaves them alone. |
| `GetActiveVehicles()` | server | [rotd_mystery_merchant](rotd_mystery_merchant) | Returns number[]: { vehicle } for the merchant's current van, or {} when none. vehicle_spawner uses it so its cleanup... |
| `GetAllLootProps()` | shared | [rotd_loots](rotd_loots) | Every prop definition from Config.AlwaysInteractableProps and Config.LootSpawns. Handy for map tools or no-build rule... |
| `GetAllNoBuildPoints()` | client | [rotd_blips](rotd_blips) | Returns table[]: both sets together. |
| `GetAllSkillEffects()` | client | [rotd_classystem](rotd_classystem) | Returns table: a shallow copy of the active effects. |
| `GetAllSkillEffects(src)` | server | [rotd_classystem](rotd_classystem) | Returns table: the player's active effects. |
| `GetAllSquadCitizenIds()` | server | [rotd_squad](rotd_squad) | Lists every character that is in any squad. |
| `GetBigBlipNoBuildPoints()` | client | [rotd_blips](rotd_blips) | Returns table[]: points of the big (always shown) blips. |
| `GetClassExperience(src, className)` | server | [rotd_classystem](rotd_classystem) | Returns two values: xp (number) and level (number). |
| `GetConfig()` | server | [rotd_squad](rotd_squad) | Returns the squad configuration table the resource is running with. |
| `GetContamDebugText(veh)` | client | [vehicle_spawner](vehicle_spawner) | The contaminated-fuel effect lines for a vehicle. Used by a fuel script's debug overlay. |
| `GetCurrentZone()` | client | [rotd_zones](rotd_zones) | The data the zone card displays for the current zone. |
| `GetDbHealth()` | server | [rotd_bridge](rotd_bridge) | Returns table: the result of the last database check, per table. |
| `GetDogTagsCollected(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: dog tags collected today. |
| `GetEffectValue(effectKey)` | client | [rotd_classystem](rotd_classystem) | Returns number: the effect value, 0 when absent. |
| `GetLongestSurvivalStreak(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: the longest survival streak, in days. |
| `GetLootSenseState()` | client | [rotd_loots](rotd_loots) | Returns table: |
| `GetMarketBoard(shopKey)` | server | [npc_guide](npc_guide) | Returns table: the rows the exchange dialogue shows. |
| `GetMarketHistory(shopKey, name, span, sinceSeconds)` | server | [npc_guide](npc_guide) | Price history as candles. |
| `GetMarketSnapshot(shopKey)` | server | [npc_guide](npc_guide) | Returns table / nil: { [name] = row }, where every row has: |
| `GetNextCleanup()` | server | [vehicle_spawner](vehicle_spawner) | Returns number / nil: seconds until the next cleanup sweep, nil when none is scheduled. |
| `GetNoBuildInfo(coords)` | client | [rotd_zones](rotd_zones) | Everything about the no-build check in one table. |
| `GetNoBuildMessage(reason)` | client | [rotd_zones](rotd_zones) | Player-facing text for a block reason. |
| `GetPanelSnapshot()` | server | [rotd_bridge](rotd_bridge) | Returns table: what the admin panel shows right now: resources (state, dependencies, optional partners, recent consol... |
| `GetPlayerAllModifiers()` | client | [rotd_classystem](rotd_classystem) | Returns table: every modifier value. |
| `GetPlayerAllModifiers(src)` | server | [rotd_classystem](rotd_classystem) | Returns table: every modifier value of the player. |
| `GetPlayerClass(src)` | server | [rotd_classystem](rotd_classystem) | Returns string: the class key, or 'none'. |
| `GetPlayerClass()` | client | [rotd_classystem](rotd_classystem) | Returns string: the class key, or 'none'. |
| `GetPlayerClassInfo(src)` | server | [rotd_classystem](rotd_classystem) | Returns table / nil: |
| `GetPlayerClassInfo()` | client | [rotd_classystem](rotd_classystem) | Returns table: { class, level, xp, modifiers, effects, unlockedSkills }. |
| `GetPlayerClassLevel()` | client | [rotd_classystem](rotd_classystem) | Returns number: the class level. |
| `GetPlayerClassXP()` | client | [rotd_classystem](rotd_classystem) | Returns number: the class XP. |
| `GetPlayerDistanceTravel(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: lifetime distance travelled, rounded to 2 decimals. |
| `GetPlayerExperience(src)` | server | [rotd_classystem](rotd_classystem) | Returns two values: xp (number) and level (number) of the selected class. |
| `GetPlayerFullData(cid)` | server | [rotd_squad](rotd_squad) | Reads the complete player record. |
| `GetPlayerModifier(src, modifierName)` | server | [rotd_classystem](rotd_classystem) | Returns number: the multiplier, 1.0 when unknown. |
| `GetPlayerModifier(modifierName)` | client | [rotd_classystem](rotd_classystem) | Returns number: the effective value (class base plus skill bonuses). |
| `GetPlayerQuests(src)` | server | [npc_guide](npc_guide) | Returns table: { [questId] = snapshot } for all known quests. |
| `GetPlayerRadiation(src)` | server | [rotd_zones](rotd_zones) | The last dose the client saved. It is saved every few minutes, on logout and on resource stop, so it can lag behind.... |
| `GetPlayerReputation(cid)` | server | [rotd_squad](rotd_squad) | Reads a character's reputation. |
| `GetPlayerStats(cid)` | server | [rotd_squad](rotd_squad) | Reads the stat counters of a character. |
| `GetPlayerValue(identifier, key)` | server | [rotd_bridge](rotd_bridge) | Reads from the ESX store (rotd_player_data). |
| `GetPoiNoBuildPoints()` | client | [rotd_blips](rotd_blips) | Points of the small discover-on-approach POIs, one per location. A definition with 28 fuel stations gives 28 points. |
| `GetPvpKillsRedzone(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: lifetime PvP kills in red zones. |
| `GetRadiationDebuffs()` | client | [rotd_zones](rotd_zones) | Returns table: { maxhealth, maxstamina }, the limits of the current radiation tier. |
| `GetRadiationInfo()` | client | [rotd_zones](rotd_zones) | Returns table: { dose, resistance, inRadiationZone, maxHealth, maxStamina }. |
| `GetRadiationResistance()` | client | [rotd_zones](rotd_zones) | Resistance is a percentage (0 to 100). It comes from worn clothing (Config.RadiationResistance.clothing, entries save... |
| `GetReputation()` | client | [rotd_squad](rotd_squad) | Returns number: the local player's reputation. |
| `GetSkillCooldownRemaining(skillId)` | client | [rotd_classystem](rotd_classystem) | Returns number: seconds left on the cooldown. |
| `GetSkillEffectBool(effectKey)` | client | [rotd_classystem](rotd_classystem) | Returns boolean |
| `GetSkillEffectBool(src, effectKey)` | server | [rotd_classystem](rotd_classystem) | Returns boolean |
| `GetSkillEffectValue(skillId, effectKey)` | client | [rotd_classystem](rotd_classystem) | Returns number: the value of that effect for that skill. |
| `GetSkillEffectValue(src, effectKey)` | server | [rotd_classystem](rotd_classystem) | Returns number: the effect value, 0 when absent. Booleans count as 1 / 0. |
| `GetSquadByCid(cid)` | server | [rotd_squad](rotd_squad) | Returns the full squad table for a character. Only works while the squad is loaded, so online players only. |
| `GetSquadCitizenIds(src)` | server | [rotd_squad](rotd_squad) | Lists the character ids of everyone in the squad of the given player. |
| `GetSquadData()` | client | [rotd_squad](rotd_squad) | The squad of the local player. |
| `GetSquadIdForCid(cid)` | server | [rotd_squad](rotd_squad) | Returns the squad id a character belongs to. Works offline. |
| `GetSquadLeaderCid(src)` | server | [rotd_squad](rotd_squad) | Finds the leader of the player's squad. |
| `GetSquadMembers(cid)` | server | [rotd_squad](rotd_squad) | Returns the member entries of the squad a character belongs to. |
| `GetSquadMembers()` | client | [rotd_squad](rotd_squad) | Returns table[]: array of members. Each entry has a source field (server id). |
| `GetSquadStats(srcOrCid)` | server | [rotd_squad](rotd_squad) | Aggregated statistics of a whole squad. Accepts a server id or a cid. |
| `GetSufferedRadiation()` | client | [rotd_zones](rotd_zones) | Returns number: the current dose. |
| `GetVehicleBuildBlockPoints()` | shared | [vehicle_spawner](vehicle_spawner) | Every coordinate a vehicle can spawn at: the full static pool, not just the vehicles spawned now. Base building can b... |
| `GetZombieKillsPerDay(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: zombie kills today. |
| `GetZombieKillsTotal(cid)` | server | [rotd_leaderboard](rotd_leaderboard) | Returns number: lifetime zombie kills. |
| `GetZombieLabels()` | client | [rotd_zones](rotd_zones) | Returns table: a copy of the label table. |
| `GetZoneAtCoords(coords)` | shared | [rotd_zones](rotd_zones) | Finds the zone at a position. When zones overlap, the one with the highest priority wins. |
| `GetZoneExtraLoot(zoneKey, class)` | server | [rotd_zones](rotd_zones) | Extra loot a zombie class drops in a zone. Server only so clients cannot touch loot. |
| `GetZoneInfoAtCoords(coords)` | shared | [rotd_zones](rotd_zones) | Full zone info including the polygon data. The returned fields differ per side. |
| `GetZonePlayerin()` | client | [rotd_zones](rotd_zones) | The zone the local player is standing in right now. |
| `GetZones()` | client | [rotd_zones](rotd_zones) | Lists every zone that was created. The objects are internal and read only. |
| `GetZoneSpawnInfoAtCoords(coords)` | client | [rotd_zones](rotd_zones) | Spawn information for a zombie spawner: which classes may spawn and which ped models each class uses. Loot is deliber... |
| `GiveQuest(src, questId)` | server | [npc_guide](npc_guide) | Gives a quest to a player. |
| `GiveToScav(netId, item, amount, metadata)` | server | [rotd_scavs](rotd_scavs) | Puts an item into a live scav's inventory. |
| `HasBuildingAccess(src, buildingId)` | server | [rotd_squad](rotd_squad) | Checks whether the player's squad gives them access to a building. |
| `HasMinimumModifier(modifierType, minimumValue)` | client | [rotd_classystem](rotd_classystem) | Returns boolean |
| `HasMinimumModifier(src, modifierType, minimumValue)` | server | [rotd_classystem](rotd_classystem) | Returns boolean: true when the modifier is at least the minimum. |
| `HasShopkeeper(shopKey)` | client | [npc_guide](npc_guide) | Returns string / nil: the shopkeeper's display name, nil when no dialogue exists for that shop key. |
| `HasSkillUnlocked(src, skillKey)` | server | [rotd_classystem](rotd_classystem) | Returns boolean |
| `IsBaseBuildingAllowedAtCoords(coords)` | server | [rotd_zones](rotd_zones) | Whether the zone at a position allows base building. |
| `IsCoordsInGreenZone(coords)` | server | [rotd_zones](rotd_zones) | Safezone test. |
| `IsFriendlyFireBlocked()` | client | [rotd_squad](rotd_squad) | Returns boolean: true when friendly fire between squad mates is blocked. |
| `IsInSquad()` | client | [rotd_squad](rotd_squad) | Returns boolean: whether the local player is in a squad. |
| `IsInSquad(cid)` | server | [rotd_squad](rotd_squad) | Checks whether a character is in any squad. |
| `IsNightTime()` | client | [rotd_zones](rotd_zones) | Returns boolean: true from 20:00 to 06:00 game time. |
| `IsNoBuildReady()` | client | [rotd_zones](rotd_zones) | Returns boolean: true once the point index is built. Wait for it before relying on the other no-build exports. |
| `IsSkillActive(skillId)` | client | [rotd_classystem](rotd_classystem) | Returns boolean: unlocked, currently active, or on cooldown (depending on the export). |
| `IsSkillOnCooldown(skillId)` | client | [rotd_classystem](rotd_classystem) | Returns boolean: unlocked, currently active, or on cooldown (depending on the export). |
| `IsSkillStateActive(src, skillId)` | server | [rotd_classystem](rotd_classystem) | Returns boolean |
| `IsSkillUnlocked(skillId)` | client | [rotd_classystem](rotd_classystem) | Returns boolean: unlocked, currently active, or on cooldown (depending on the export). |
| `IsSquadMate(srcA, srcB)` | server | [rotd_squad](rotd_squad) | Checks whether two online players are in the same squad. |
| `IsSquadMate(serverId)` | client | [rotd_squad](rotd_squad) | Checks whether another player is in the local player's squad. |
| `ModifyReputation(src, action, customAmount)` | server | [rotd_squad](rotd_squad) | Changes a player's reputation using an action key from the config. |
| `OpenClassSelector(options)` | client | [rotd_classystem](rotd_classystem) | Opens the class selector. |
| `OpenShopkeeper(shopKey, ped, shopNum)` | client | [npc_guide](npc_guide) | Opens the shopkeeper dialogue, then the shop. |
| `PersistVehicleParts(netId, plate)` | server | [vehicle_spawner](vehicle_spawner) | Writes the in-memory parts of an owned vehicle (battery, ecu, transmission, ...) to the database. Call it right befor... |
| `PingAt(coord, pingType)` | client | [rotd_squad](rotd_squad) | Sends a map ping to the whole squad. |
| `PlaySkillVisualStage(skillId, stageName, context)` | client | [rotd_classystem](rotd_classystem) | Plays a visual stage of a skill. |
| `ProtectVehicle(vehOrNetId, protect)` | server | [vehicle_spawner](vehicle_spawner) | Marks a vehicle as protected from the cleanup sweep. Same as setting the protection state bag, without needing to kno... |
| `PushMarketMonitor(monitor)` | server | [npc_guide](npc_guide) | Posts or updates the Discord monitor. |
| `RadiationZone(inside, zonedata)` | client | [rotd_zones](rotd_zones) | Returns nothing. |
| `RebuildMapOverlays()` | client | [rotd_zones](rotd_zones) | Redraws every zone's map overlay from Config.Zones. Call it after changing zones at runtime. |
| `RefreshPlayerSkillCache(src, className)` | server | [rotd_classystem](rotd_classystem) | Rebuilds and stores the effect cache of a player. |
| `RegisterCoughHandler(callback)` | client | [rotd_zones](rotd_zones) | Returns number: how many handlers are registered. |
| `RegisterInfectionCure(fn)` | server | [rotd_zones](rotd_zones) | Registers the handler that runs when a guard finishes curing a player. Requests are limited to one per 20 seconds per... |
| `RegisterInfectionDetector(fn)` | client | [rotd_zones](rotd_zones) | Registers a function that is called about once a second. Errors inside fn are ignored. |
| `RegisterZombieLabel(class, label)` | client | [rotd_zones](rotd_zones) | Returns boolean |
| `RegisterZombieLabels(map)` | client | [rotd_zones](rotd_zones) | Registers many names at once. Existing keys are overwritten, others kept. |
| `RemoveResistanceModifier(id)` | client | [rotd_zones](rotd_zones) | Returns boolean |
| `ReportCurrencyFlow(name, units, shopKey)` | server | [npc_guide](npc_guide) | Tells the market that currency entered or left the economy. Positive units are supply and push the price down at the... |
| `RestoreVehiclePartsFull(netId, plate)` | server | [vehicle_spawner](vehicle_spawner) | Resets every part to installed and 100% and persists it (a garage "full repair"). Live entities are updated immediately. |
| `SetCurrencySupply(name, units, shopKey)` | server | [npc_guide](npc_guide) | Sets how much of the currency exists in the world. Only used when Config.ExchangeRates.circulationLiquidity > 0. |
| `SetGlobalWeatherAmbient(mod, instant)` | client | [rotd_zones](rotd_zones) | Sets the map-wide timecycle layer. A zone's own ambient wins over it. |
| `SetGlobalWeatherPostFX(list)` | client | [rotd_zones](rotd_zones) | Replaces the map-wide post FX set. Effects no longer listed are stopped. Radiation effects are never touched. |
| `SetInfectionState(state)` | client | [rotd_zones](rotd_zones) | Push-style alternative: send the same table whenever it changes. |
| `SetLootSenseBonus(distanceBonus, durationBonus, cooldownScale)` | client | [rotd_loots](rotd_loots) | Changes loot sense for the local player, for example from a skill. Pass nil to leave a value unchanged. |
| `SetPlayerRadiation(src, value)` | server | [rotd_zones](rotd_zones) | Sets the dose on that player's client. |
| `SetPlayerValue(identifier, key, value)` | server | [rotd_bridge](rotd_bridge) | Writes to the ESX store. |
| `SetRadiation(value)` | client | [rotd_zones](rotd_zones) | Sets the absolute dose. For cures and admin tools. |
| `ShareXp(src, amount)` | server | [rotd_squad](rotd_squad) | Shares an XP amount with the player's squad mates. |
| `ShowNotification(title, message, type, timeout)` | client | [rotd_recyclers](rotd_recyclers) | Shows a notification: in the ROTD HUD when it runs, otherwise an ox_lib notification. |
| `startMinigame(type, difficulty, timeLimit, callback)` | client | [rotd-minigame](rotd-minigame) | Non-blocking version. (type, difficulty, callback) also works. |
| `startMinigameSync(type, difficulty, timeLimit)` | client | [rotd-minigame](rotd-minigame) | Blocks the calling thread until the minigame ends. |
| `SwapScavWeapon(netId, newWeapon, newAmmo, newMeta)` | server | [rotd_scavs](rotd_scavs) | Gives a scav a new weapon and moves its old weapon into its inventory. The squad's controlling client is told to re-a... |
| `SyncHudLevel(src, hudLevel)` | server | [rotd_classystem](rotd_classystem) | Sets the selected class level to the HUD level. Never lowers it. Authorised, see the note below. |
| `TrackEvent(src, event, amount, meta)` | server | [npc_guide](npc_guide) | Advances every active objective that listens for that event. You do not need quest ids, which makes it the easiest wa... |
| `TrackMinigame(mtype, difficulty)` | client | [npc_guide](npc_guide) | Reports a successful minigame to the server (rate limited server side). Called by rotd-minigame. |
| `TracksEvent(src, event)` | server | [npc_guide](npc_guide) | Cheap guard: does the player have an active objective for that event? Skip heavy work when not. |
| `TriggerLootSense(silent)` | client | [rotd_loots](rotd_loots) | Triggers a scan. Respects the cooldown. |
| `UpdateQuestProgress(src, questId, objectiveId, amount)` | server | [npc_guide](npc_guide) | Advances one objective of one quest. |
| `zombieAttackedVehicle(netId)` | client | [vehicle_spawner](vehicle_spawner) | Tells vehicle_spawner that a zombie just hit a vehicle body, so the health drop is not treated as a player crash. Cal... |
