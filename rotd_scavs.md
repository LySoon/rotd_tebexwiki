# rotd_scavs

AI scavenger squads that loot corpses and stashes. Two **server** exports let other systems change what a scav carries. A scav is identified by its **network id** (`netId`).

## `GiveToScav(netId, item, amount, metadata)`

Puts an item into a live scav's inventory.

- **Input:** `netId` (number), `item` (string), `amount` (default 1), `metadata` (table, optional)
- **Returns:** `boolean` (`false` when the netId is not a scav or its stash cannot be created)

## `SwapScavWeapon(netId, newWeapon, newAmmo, newMeta)`

Gives a scav a new weapon and moves its old weapon into its inventory.

- **Input:** `newWeapon` (weapon name), `newAmmo` (number), `newMeta` (the **original item metadata**: attachments, durability, serial, tint, so a suppressed scoped rifle stays one)
- **Returns:** the old weapon name, or `nil`. The squad's controlling client is told to re-arm the ped.

```lua
-- server: hand a scav a bandage and a better weapon
exports.rotd_scavs:GiveToScav(netId, 'bandage', 2)
local old = exports.rotd_scavs:SwapScavWeapon(netId, 'weapon_carbinerifle', 120, { serial = 'X123' })
```

## Optional integrations

`npc_guide` (kill tracking), the ROTD HUD (notifications) and a zombie resource (`ScavLootedZombie`) are used when running; each missing partner only disables its own part.
