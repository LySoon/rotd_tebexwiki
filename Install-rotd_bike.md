# Install: rotd_bike

Bike item: use it to place a bike, pick it up again with the target option.

> Developer documentation (exports, events, config format): [[rotd_bike]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| rotd_bridge | yes |
| An inventory | yes |
| A target resource | optional ([E] prompt without it) |
| `rotd_zones` | optional (green zone rules) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_zones   # optional
ensure rotd_bike
```

## Items

One item, `bike`, with the definitions below.

Add each item to your item list. **QBCore / Qbox:** `qb-core/shared/items.lua`. **ox_inventory:** `data/items.lua`. **ESX:** the `items` table. **core_inventory** uses the framework item list. An item that does not exist cannot be given, found or used, so that part of the resource will not work.

Item names: `bike`

**QBCore / Qbox** (`qb-core/shared/items.lua`):

```lua
bike = {name = "bike", label = "Bike", weight = 1000, type = "item", image = "bike.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "A bike item with metadata"},
```

**ox_inventory** (`data/items.lua`): the item needs the export of this resource and must not be used up by ox itself:

```lua
['bike'] = {
    label = 'Bike', weight = 1000, stack = false, consume = 0, close = true,
    server = { export = 'rotd_bike.bike' },
},
```

**ESX:** add `bike` to the `items` table with `limit = 1`; the resource registers it as usable. Restart the framework resource (`qb-core` on QBCore) after changing the item list.

## Database

None.

## First-time checklist

- `Config.AllowedModels`: the bike models that can be spawned and picked up.
- Add a `bike.png` image to your inventory images, or the item shows a missing icon.

## Test it

1. Give yourself a `bike` and use it: a bike appears and the item is removed.
2. Pick it up with the target option (or [E]): the item comes back.
