# Changelog

What changed in the exports and in these docs. Newest first.

## 2026-10

### Panel data and pages

- New [[Features-rotd_recyclers]] page.
- [[Admin-Panel]]: item lists (`rotd_items`) added for [[rotd_bike]], [[rotd_kits]], [[rotd_mystery_merchant]] and [[npc_guide]]; editable settings (`rotd_settings`) added for [[npc_guide]], [[rotd_blips]], [[rotd_mystery_merchant]], [[rotd_zones]] and [[rotd_squad]].

### Conversion to rotd_bridge (earlier in 2026-10)

These resources now run on QBCore, Qbox and ESX through [[rotd_bridge]]; their hard dependencies are `ox_lib`, `oxmysql` where they use the database, and `rotd_bridge`. Export names and signatures did not change.

- [[npc_guide]]: any inventory, target and shop resource; the report of travelled distance is rate limited.
- [[rotd-minigame]]: inventory checks go through the bridge.
- [[rotd_blips]]: discovered blips are saved through the bridge, so they also persist on ESX.
- [[rotd_events]]: server events that any client could trigger are now checked on the server (stopping an event is admin only).
- [[rotd_kits]]: kits are given through the bridge inventory layer.
- [[rotd_mystery_merchant]]: shop window through `jim-shops`, `qb-shops` or `ox_inventory`.
- [[rotd_zones]]: framework calls replaced by the bridge; HUD, zombie and ambulance partners are optional.

### rotd_bridge: quieter console

- Optional partners no longer print one console line each. The bridge prints one summary line; `rotdbridge optional` (server console) or `/rotd` (in game) lists them. The old lines return with `set rotd_bridge_debug true`.

### rotd_squad 1.1.0: multi-framework

- Works on QBCore, Qbox and ESX through [[rotd_bridge]]; hard dependencies are now `ox_lib`, `oxmysql` and `rotd_bridge`.
- New install and features pages: [[Install-rotd_squad]], [[Features-rotd_squad]].
- New `Config.AllowClientStatEvents` and a throttle on `ShareExp`.
- `sql/schema.sql` no longer touches the `players` table; stats stay in the character's metadata.
- [[rotd_bridge]]: new `Bridge.Framework.GetMeta / SetMeta / GetJobName / OnServerPlayerLoaded / OnServerPlayerUnloaded` and `Bridge.Target.AddGlobalPlayer`.

### rotd_bridge 0.2.0: admin panel

- New in-game admin panel, **`/rotd`**: health of every ROTD resource with console errors per resource, detected framework / inventory / target / shop, missing items with ready-to-paste definitions, database tables, plain-words settings editing (with backup), and a support report. See [[Admin-Panel]].
- Start, stop and restart ROTD resources from the panel (needs `command.start / stop / restart / refresh` aces for `resource.rotd_bridge`). There is no automatic start and the panel does not read `server.cfg`.
- New manifest keys `rotd_items` and `rotd_settings`; new convars `rotd_target`, `rotd_shop`; new file `overrides.json`; new export `GetPanelSnapshot`.

### Docs

- Every export now has its own card with parameters, return values and an example.
- Added data shapes (the exact fields of returned tables) and recipes to the resource pages.
- Added [[Export-Index]] and [[Common-Mistakes]].

### New resources and pages

- New developer pages: [[rotd_needs]], [[rotd_lockers]], [[rotd_bike]]; [[rotd_loots]] rewritten with a config reference and the locations pack.
- New install pages: [[Install-rotd_needs]], [[Install-rotd_lockers]], [[Install-rotd_loots]], with item lists in [[Items-rotd_needs-QBCore]], [[Items-rotd_needs-ox_inventory]], [[Items-rotd_needs-ESX]] and [[Items-rotd_loots]].
- New features pages: [[Features-rotd_needs]], [[Features-rotd_lockers]], [[Features-rotd_bike]], [[Features-rotd_loots]].
- [[rotd_bridge]]: new `Bridge.Inventory.RegisterUsableItem`, `SetItemMetadata`, `RemoveUsedItem`, `ItemExists`, `HasAny`, `Stash.Move`, `Bridge.Framework.GetNeed / SetNeed`, `Bridge.Target.AddGlobalVehicle / GetProvider`, `Bridge.Medical.OnRevive`.

### Known behaviour to be aware of

- `rotd_classystem`: `AddExperience` and `AddExperienceToClass` always return `false`. Class levels follow the HUD level (`SyncHudLevel`).
- `rotd_recyclers`: `ShowNotification` is registered in two files and the one loaded last answers. This will be unified during the multi-framework conversion.
- `rotd_zones`: the net event `rotd_zones:setradiation` from older versions is kept only for compatibility. Prefer `SetPlayerRadiation` / `AddPlayerRadiation`.
- Resources not yet converted to `rotd_bridge` may change their internals during the multi-framework conversion. Export signatures stay the same.
