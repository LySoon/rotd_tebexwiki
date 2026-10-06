# rotd_blips

Discoverable map blips and POIs. Its exports give **positions where building should be blocked**; `rotd_zones` uses them for its no-build gate. Called from the **client** (the config is shared, so server use also works).

Each point is a flat table `{ x, y, z, id, name, radius }`, see Data shapes below.

> To ask "can I build here?", use `rotd_zones:CanBuildAtCoords` instead, see [[rotd_zones]].

## Client exports

#### `GetBigBlipNoBuildPoints()`

**Returns** `table[]`: points of the big (always shown) blips.

<details>
<summary>Example</summary>

```lua
local points = exports.rotd_blips:GetBigBlipNoBuildPoints()
```

</details>

#### `GetPoiNoBuildPoints()`

Points of the small discover-on-approach POIs, **one per location**. A definition with 28 fuel stations gives 28 points.

**Returns** `table[]`: the POI points.

<details>
<summary>Example</summary>

```lua
print(#exports.rotd_blips:GetPoiNoBuildPoints(), 'poi points')
```

</details>

#### `GetAllNoBuildPoints()`

**Returns** `table[]`: both sets together.

<details>
<summary>Example</summary>

```lua
for _, p in ipairs(exports.rotd_blips:GetAllNoBuildPoints()) do
    -- p holds the position and radius to keep clear
end
```

</details>

## Discovery and saving

Locations start as a "?" (big locations) or not on the map at all (small POIs) and become real, named blips when the player gets close. Discovered ids are saved per character under the key `blipdata` through `rotd_bridge` (QBCore and Qbox: player metadata; ESX: the `rotd_player_data` table that the bridge creates).

| Name | Type | Side | Purpose |
|---|---|---|---|
| `blipDiscovery:getDiscovered` | `lib.callback` | server | returns the player's discovered ids as `{ [id] = true }` |
| `blipDiscovery:saveDiscovered` | net event | server | the client reports a discovery; the server ignores ids that are not in the config |

Both belong to the resource's own client; they are listed so you can read the data, not to write it.

## Config: `config.lua`

Global settings:

```lua
Config.DiscoverDistance    = 200.0   -- big locations: distance at which the "?" turns into the real blip
Config.POIShowDistance     = 500.0   -- POIs: distance at which the "?" appears
Config.POIDiscoverDistance = 20.0    -- POIs: distance at which it is discovered
Config.POIHideMargin       = 1.15    -- the "?" is removed past showDistance * this (anti-flicker)
Config.POIUnknownSprite, POIUnknownColor, POIUnknownName, POIUnknownScale   -- the "?" look
Config.POIScale            = 0.7     -- size once discovered
Config.POICompactCard      = true    -- POIs use the short intel card
```

A big location (`Config.Blips`):

```lua
{
    id = 'military_base', coords = vector3(-1603.51, 2809.91, 17.38),
    sprite = 750, color = 25, name = 'Military Base',
    description = '...', zone = 'STRAIGHT TO HELL',
    threat = 5,                       -- 1 to 5 stars (halves allowed, 4.5)
    loot = 'Military', grade = 'X',   -- grade letter shown on the card (S, A, B, C, D styled)
    tags = { 'ELITE', 'BOSS ZONE' },
    image = 'humane.png',             -- file in ui/images/
    noBuildRadius = 80.0,             -- optional
    noBuild = false,                  -- optional: block nothing
}
```

A small POI (`Config.POIs`) uses the same fields, plus `showDistance` and `discoverDistance` for itself and a **list** of positions in `coords`. Discovery ids become `<id>_1`, `<id>_2`, ... in list order: never reorder or delete positions once players found them, add new ones at the end. Ids must be unique across both lists.

Ambient effects live in `particles.lua`: named sets (`fire`, `fire2`, `factory_whitesmoke`, `factory_darksmoke`, `interior_smoke`, `interior_smoke2`), each with `dict`, `name`, optional `zoffset` and a list of `{ pos, size, distance }`. An effect runs only while the player is within its `distance`.

## Admin command

`/blipreveal [on|off]` (admin): shows every location on your own map for checking. Nothing is saved.

## Data shapes

Every point returned by the three exports is a flat table:

```lua
{
    x = 215.0, y = -810.0, z = 30.0,   -- position
    id = 'poi_fuel_3',                 -- blip id; POIs with several locations get one id per location
    name = 'Fuel Station',             -- display name from the config
    radius = 80.0,                     -- metres from `noBuildRadius`, or nil = "use the radius of my source"
}
```

`radius = nil` means rotd_zones applies the radius configured for that source in `Config.NoBuild`. A location with `noBuild = false` in its config is not returned at all.

## Recipes

### Keep your own system away from landmarks (client or server)

```lua
local DEFAULT_RADIUS = 40.0
local points = exports.rotd_blips:GetAllNoBuildPoints()

local function nearLandmark(coords)
    for _, p in ipairs(points) do
        local r = p.radius or DEFAULT_RADIUS
        if #(coords - vector3(p.x, p.y, p.z)) < r then
            return true, p.name
        end
    end
    return false
end

local blocked, name = nearLandmark(GetEntityCoords(PlayerPedId()))
```

### Let rotd_zones decide (it already uses these points and the configured radii)

```lua
local ok, reason, distance = exports.rotd_zones:CanBuildAtCoords(coords)
if not ok then print(exports.rotd_zones:GetNoBuildMessage(reason), distance) end
```
