# Getting started

## Calling an export

```lua
-- both forms are the same
local zone = exports.rotd_zones:GetZoneAtCoords(vector3(215.0, -810.0, 30.0))
local zone = exports['rotd_zones']:GetZoneAtCoords(vector3(215.0, -810.0, 30.0))
```

- **Client** exports are called from client scripts, **server** exports from server scripts. Every page marks the side.
- Exports that need an outside resource to be running fail quietly (return `nil` / `false`) when it is not. Check `GetResourceState('rotd_zones') == 'started'` first if you must be sure.
- Tables returned by exports are copies unless the page says otherwise.

## Player identifiers

| Name | Meaning |
|---|---|
| `src` | server id of a player (number), server side only |
| `cid` | the character identifier (`citizenid` on QB/Qbox, `identifier` on ESX) |
| `serverId` | server id as seen from a client |

Each page says which one an export expects. Some resources accept both.

## Hooks that other resources provide (registration exports)

ROTD resources never depend on resources that are not shipped with the pack. When they need outside data they expose a **registration export** instead. Examples:

| You are | You call | Page |
|---|---|---|
| a zombie resource | `exports.rotd_zones:RegisterZombieLabels(map)` | [[rotd_zones]] |
| a disease / medical resource | `RegisterInfectionDetector`, `RegisterInfectionCure` | [[rotd_zones]] |
| anything reacting to coughs | `RegisterCoughHandler` | [[rotd_zones]] |

Register again inside the client event `rotd_zones:ready` (and the equivalent ready events) so a restart of the ROTD resource does not lose your registration.

## Optional cooperation between ROTD resources

When a ROTD resource can cooperate with another one that may not be running, it uses `Bridge.Optional`. If the partner is missing, that feature turns off and one console line tells the owner which resource to start. See [[rotd_bridge]].

## Examples in this wiki

Examples are meant to be pasted into your own resource. They use plain Lua, no framework calls, unless the page says otherwise.
