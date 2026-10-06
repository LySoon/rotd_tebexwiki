# ROTD admin panel

A control room for everything ROTD, inside the game. It shows which ROTD resources run, which have errors, what the bridge detected on your server, which items are missing, and lets you change the most used settings without opening a file. It is part of [[rotd_bridge]]; there is nothing extra to install.

Open it in game with **`/rotd`**.

---

## Who can open it

Players with the ace permission `rotd.admin`, or anyone your framework treats as admin (QBCore / Qbox permission `admin` or `god`, an ESX group in `esxAdminGroups`, or the `command` ace that txAdmin gives its admins). Every click is checked again on the server, so the page cannot be used to do something the player is not allowed to do.

Give a group access in `server.cfg`:

```
add_ace group.admin rotd.admin allow
```

Set `panel.allowFrameworkAdmins = false` in `rotd_bridge/config.lua` to use the ace permission only. `panel.key = 'F10'` adds a default key; players can also set their own key in the game's key bindings ("Open the ROTD panel").

---

## The pages

### Overview

Counts of healthy, warning, error and stopped resources, the resources that need attention (click one to see why), the button to start stopped resources and a summary of the detected setup. **Restart all ROTD** restarts every running ROTD resource in dependency order; `rotd_bridge` itself stays up.

### Resources

Only ROTD resources are listed. Open a resource to see what it needs (and whether that is running), its optional partners and what you lose without them (the same partners are listed on each resource's features page under "Works with"), and the last warnings and errors from the server console that belong to it. Buttons: start, stop, restart, clear messages.

How health is decided:

| Health | Meaning |
|---|---|
| Healthy | running, no console warnings since it started |
| Warning | running, with a warning (for example an item that is not in your item list) |
| Error | running, but the console printed a script error attributed to it |
| Stopped | not running (the note says when a dependency is missing) |

A resource that restarts starts with a clean list of messages. Messages are kept in memory only.

### Detected setup

The framework, inventory, target, shop, weather, HUD and minigame resources the bridge found, what is missing, and what that changes for players. For framework, inventory, target and shop you can choose a specific one if you run two of the same kind. The choice is saved in `rotd_bridge/overrides.json` and applies after the ROTD resources restart. A `set rotd_inventory "..."` convar in `server.cfg` still wins over it.

### Items

Each ROTD resource that lists its items is compared with your item list. For the missing ones you get ready-to-paste definitions for QBCore / Qbox `items.lua`, `ox_inventory` `items.lua` or ESX SQL. Paste them, restart the inventory or framework, and add an image named after each item.

### Database

Every table that ROTD resources declare, with row counts and state. **Create missing tables** creates the tables that were not found (also for resources that are stopped).

### Settings

The settings people change most, in plain words: switches, numbers and choices. Saving edits **only those lines** of the resource's config file, keeps the previous file next to it as `<file>.bak`, checks that the edited file still loads, and restarts the resource. Long data (loot tables, spawn lists, kit contents) is not edited here.

### Support

One report with versions, the detected setup, resource states and recent errors. Discord webhook links and bot tokens are removed. Copy it into a support ticket.

---

## Starting resources

On **Overview**, **Start N stopped ROTD resources** shows what will start and what cannot start (a missing dependency), then starts them in dependency order after you confirm. On **Resources** every resource has its own Start, Stop and Restart button. Nothing starts by itself: the panel only acts when you click.

The panel starts, stops and restarts resources through the server, which needs these permissions in `server.cfg`:

```
add_ace resource.rotd_bridge command.start allow
add_ace resource.rotd_bridge command.stop allow
add_ace resource.rotd_bridge command.restart allow
add_ace resource.rotd_bridge command.refresh allow
```

Without them the server console prints "Access denied for command start" (or stop / restart / refresh).

---

## Settings for resource developers

A ROTD resource appears in **Items** and **Settings** when its `fxmanifest.lua` has these keys (all optional):

```lua
rotd_items 'install/items.json'
rotd_settings 'install/settings.json'
rotd_optional 'rotd_zones|Night check for the searchlight (without it: the game clock is used)'
```

`rotd_optional` takes one line per optional partner, written as `resource|what it adds`. The Resources page shows each one as running or not running. List them in the manifest rather than relying on `Bridge.Optional`: that call only runs while the resource is running.

If the resource uses `escrow_ignore`, add the `install/*.json` files and the config file to it.

`install/items.json`: the item names the resource uses, as names or as objects with a label and weight (used for the definitions):

```json
{ "items": [ { "name": "scrap_metal", "label": "Scrap Metal", "weight": 200 }, "iron_plate" ] }
```

`install/settings.json`: the config file and the fields to offer:

```json
{
  "file": "config/config.lua",
  "root": "Config",
  "fields": [
    { "k": "LootRespawnMinutes", "l": "Respawn time", "h": "Minutes until a looted chest renews.", "t": "num", "min": 1, "max": 1440 },
    { "k": "LootNotify.enabled", "l": "Show \"You received\" message", "h": "", "t": "bool" },
    { "k": "Notify.system", "l": "Notification style", "h": "", "t": "sel", "o": ["ox_lib", "qbcore"] }
  ]
}
```

| Field | Meaning |
|---|---|
| `k` | path in the config table, written with dots (`Kits.alphakit.cooldown`). Works for `Config.A.B = value` and for `Config = { A = { B = value } }` |
| `l`, `h` | the label and the help text shown to the admin |
| `t` | `bool`, `num` (with `min` and `max`) or `sel` (with the allowed values in `o`) |

The value on that line must be a plain `true` / `false`, number or quoted text. A line that holds an expression (`60 * 60`) or has been changed to a function call is not offered. The server only accepts keys that are in this file and values inside the allowed range, so the panel cannot write anything else.


---

## Troubleshooting

| Symptom | Cause and fix |
|---|---|
| `/rotd` does nothing | You are not admin: add the ace permission above, or check the group your framework gives you. |
| The panel opens but is empty | Open the F8 console and the server console: a Lua error in `rotd_bridge/server/panel.lua` is printed there. |
| A resource does not show a Settings page | It has no `rotd_settings` key, or the config file no longer has those lines as plain values. |
| Console errors are not listed | The server build has no `RegisterConsoleListener`, or the message does not name the resource (`@resource/file.lua`). |
| Fonts look different | The panel loads its fonts from Google Fonts; without internet it falls back to system fonts. |
