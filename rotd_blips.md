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
