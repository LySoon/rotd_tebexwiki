# rotd_scavs

AI scavenger squads that loot corpses and stashes. Two **server** exports let other systems change what a scav carries. A scav is identified by its **network id** (`netId`, `number`).

## Server exports

#### `GiveToScav(netId, item, amount, metadata)`

Puts an item into a live scav's inventory.

| Parameter | Type | Description |
|---|---|---|
| `netId` | `number` | Network id of the scav ped. |
| `item` | `string` | Item name. |
| `amount` | `number?` | Amount. Defaults to `1`. |
| `metadata` | `table?` | Item metadata. |

**Returns** `boolean`: `false` when the netId is not a scav or its stash cannot be created.

<details>
<summary>Example</summary>

```lua
exports.rotd_scavs:GiveToScav(netId, 'bandage', 2)
```

</details>

#### `SwapScavWeapon(netId, newWeapon, newAmmo, newMeta)`

Gives a scav a new weapon and moves its old weapon into its inventory. The squad's controlling client is told to re-arm the ped.

| Parameter | Type | Description |
|---|---|---|
| `netId` | `number` | Network id of the scav ped. |
| `newWeapon` | `string` | Weapon name. |
| `newAmmo` | `number` | Ammo for the new weapon. |
| `newMeta` | `table` | The **original item metadata**: attachments, durability, serial, tint, so a suppressed scoped rifle stays one. |

**Returns** `string | nil`: the old weapon name, or `nil`.

<details>
<summary>Example</summary>

```lua
local old = exports.rotd_scavs:SwapScavWeapon(netId, 'weapon_carbinerifle', 120, { serial = 'X123' })
```

</details>

## Optional integrations

`npc_guide` (kill tracking), the ROTD HUD (notifications) and a zombie resource (`ScavLootedZombie`) are used when running. Each missing partner only disables its own part.
