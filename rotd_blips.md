# rotd_blips

Discoverable map blips and POIs. Its exports give **positions where building should be blocked**; `rotd_zones` uses them for its no-build gate. Called from the **client** (the config is shared, so server use also works).

Each point is a table describing a location (position, radius, reason) as built from `Config.Blips` and `Config.POIs`. A location can override its radius with `noBuildRadius`, or opt out with `noBuild = false`.

| Export | Returns |
|---|---|
| `GetBigBlipNoBuildPoints()` | points of the big (always shown) blips |
| `GetPoiNoBuildPoints()` | points of the small discover-on-approach POIs, **one per location** (a definition with 28 fuel stations gives 28 points) |
| `GetAllNoBuildPoints()` | both sets together |

```lua
for _, p in ipairs(exports.rotd_blips:GetAllNoBuildPoints()) do
    -- p holds the position and radius to keep clear
end
```

To ask "can I build here?", use `rotd_zones:CanBuildAtCoords` instead, see [[rotd_zones]].

## Admin command

`/blipreveal [on|off]` (admin): shows every location on your own map for checking. Nothing is saved.
