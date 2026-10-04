# rotd_blips

Discoverable map blips and POIs. Its exports give **positions where building should be blocked**; `rotd_zones` uses them for its no-build gate. Called from the **client** (the config is shared, so server use also works).

Each point is a table describing a location (position, radius, reason) as built from `Config.Blips` and `Config.POIs`. A location can override its radius with `noBuildRadius`, or opt out with `noBuild = false`.

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
