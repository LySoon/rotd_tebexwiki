# Changelog

What changed in the exports and in these docs. Newest first. Add a line here whenever an export is added, renamed, changed or removed, so developers can see it.

## 2026-10

### Docs

- Every export now has its own card with parameters, return values and an example.
- Added data shapes (the exact fields of returned tables) and recipes to the resource pages.
- Added [[Export-Index]] and [[Common-Mistakes]].

### Known behaviour to be aware of

- `rotd_classystem`: `AddExperience` and `AddExperienceToClass` always return `false`. Class levels follow the HUD level (`SyncHudLevel`).
- `rotd_recyclers`: `ShowNotification` is registered in two files and the one loaded last answers. This will be unified during the multi-framework conversion.
- `rotd_zones`: the net event `rotd_zones:setradiation` from older versions is kept only for compatibility. Prefer `SetPlayerRadiation` / `AddPlayerRadiation`.
- Resources not yet converted to `rotd_bridge` may change their internals during the multi-framework conversion. Export signatures stay the same.

## How to add an entry

```text
## YYYY-MM

### rotd_zones
- Added `ExportName(args)`: what it does.
- Changed `ExportName`: what is different.
- Removed `ExportName`: use `OtherExport` instead.
```
