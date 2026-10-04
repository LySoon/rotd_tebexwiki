# Common mistakes

The errors that come up most when calling ROTD exports. Each one shows the wrong way, the right way and why.

## Calling the wrong side

Every export is **server**, **client** or **shared**. A client export called from a server script (or the other way round) does not exist there and errors or returns `nil`.

```lua
-- WRONG: IsInSquad() with no argument is the CLIENT export
-- server script
if exports.rotd_squad:IsInSquad() then end

-- RIGHT: the server version takes a cid
if exports.rotd_squad:IsInSquad(cid) then end
```

Check the badge on the export card before you copy it.

## Mixing up `src` and `cid`

`src` is a **server id** (`number`). `cid` is a **character id** (`string`). Passing the wrong one returns `nil`, `0` or `false` without an error.

```lua
-- WRONG
local rep = exports.rotd_squad:GetPlayerReputation(src)

-- RIGHT: this export wants a cid
local cid = Bridge.Framework.GetIdentifier(src)
local rep = exports.rotd_squad:GetPlayerReputation(cid)
```

Some exports accept both, for example `GetSquadStats(srcOrCid)`. The parameter table says so.

## Blocking exports outside a thread

`startMinigameSync` and `CheckBuildingAccess` **wait** for a result. They must run inside a thread, an event handler or a command handler, never at the top level of a file.

```lua
-- WRONG: top level of a client file
local ok = exports['rotd-minigame']:startMinigameSync('lockpick', 4, 30)

-- RIGHT
CreateThread(function()
    local ok = exports['rotd-minigame']:startMinigameSync('lockpick', 4, 30)
end)
```

If you do not want a thread, use the callback version `startMinigame(...)`.

## Not handling `nil`

Many exports return `nil` when there is nothing to return. The **Returns** row on every card says when.

```lua
-- WRONG: errors when the player has no squad
local leader = exports.rotd_squad:GetSquadLeaderCid(src)
print(leader:upper())

-- RIGHT
local leader = exports.rotd_squad:GetSquadLeaderCid(src)
if leader then print(leader) end
```

## Using an online-only export for an offline player

`GetSquadByCid` only works while the squad is loaded (**online players only**). For an offline owner use the exports marked **Works offline**.

```lua
-- WRONG: offline base owner, returns nil
local squad = exports.rotd_squad:GetSquadByCid(ownerCid)

-- RIGHT
local squadId = exports.rotd_squad:GetSquadIdForCid(ownerCid)
local mates   = exports.rotd_squad:AreCitizenIdsSquadMates(ownerCid, builderCid)
```

## Registration lost after a restart

Registration exports (`RegisterInfectionDetector`, `RegisterZombieLabels`, `RegisterCoughHandler`, ...) are stored in memory. If `rotd_zones` restarts, your registration is gone. Register again in the ready event:

```lua
local function register()
    exports.rotd_zones:RegisterZombieLabels({ normal = 'Walker' })
end

register()
AddEventHandler('rotd_zones:ready', register)   -- runs again after a restart
```

## A resource name with a dash

`exports.rotd-minigame` is read by Lua as `exports.rotd - minigame`. Use the bracket form:

```lua
-- WRONG
exports.rotd-minigame:startMinigameSync('lockpick', 4)

-- RIGHT
exports['rotd-minigame']:startMinigameSync('lockpick', 4)
```

## Calling an authorised export from an untrusted resource

`SyncHudLevel`, `AddExperience*`, `AddBonusSkillPoints`, `AwardActionExperience` and `ActivatePlayerSkill` only work when **your** resource is listed in `Config.TrustedServerResources` of `rotd_classystem`. Otherwise they return `false` and the server logs `UNAUTHORIZED_RESOURCE_CALL`.

## `SetRadiation` instead of `AddRadiation`

`SetRadiation` **overwrites** the dose. For damage from a source (a grenade, a bite) use `AddRadiation`: it adds a delta and applies clothing resistance.

```lua
-- WRONG: wipes the dose the player already had
exports.rotd_zones:SetRadiation(25.0)

-- RIGHT
exports.rotd_zones:AddRadiation(25.0)
```

## Trusting `GetPlayerRadiation` as live data

`GetPlayerRadiation(src)` (server) is the **last saved** dose. It is saved every few minutes, on logout and on resource stop, so it can lag behind. The live value is on the client: `GetSufferedRadiation()`.

## The old radiation net event

The net event `rotd_zones:setradiation` from older versions still exists and lets **any client** set another player's radiation. Do not trigger it. Use `SetPlayerRadiation` / `AddPlayerRadiation` from server code.

## Handle or network id

Vehicle and scav exports differ in what they take:

| Export | Takes |
|---|---|
| `ProtectVehicle` | entity handle **or** network id |
| `PersistVehicleParts`, `RestoreVehiclePartsFull`, `zombieAttackedVehicle` | network id |
| `GiveToScav`, `SwapScavWeapon` | network id of the scav |

```lua
local netId = NetworkGetNetworkIdFromEntity(vehicle)
exports.vehicle_spawner:PersistVehicleParts(netId, plate)
```

## Start order

`rotd_bridge` must start **after** your framework, inventory and `ox_lib`, and **before** the ROTD resources.

```cfg
ensure ox_lib
ensure qb-core          # or your framework
ensure core_inventory   # or your inventory
ensure rotd_bridge
ensure rotd_zones
```
