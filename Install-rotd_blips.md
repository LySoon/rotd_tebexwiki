# Install: rotd_blips

Discovery map blips, intel cards and no-build points.

> Developer documentation (exports, events, config format): [[rotd_blips]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| A framework | yes (auto-detected) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_blips
```

## Database

None on QBCore and Qbox (discovery is saved in character data). On ESX the table `rotd_player_data` is created by `rotd_bridge`.

## First-time checklist

- Edit `config.lua`: your locations, intel cards and discovery distances.
- Never reorder or delete positions of a multi-position POI after players found them; add new ones at the end.

## Test it

1. Join, walk near a location: the "?" turns into a named blip.
2. As admin run `/blipreveal on` to see every location, `/blipreveal off` to return.
3. Players must **reconnect once** after the first start (NUI files).
