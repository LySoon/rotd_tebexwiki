# rotd_recyclers

Scrapping stations: put items into an input stash, the machine breaks them down into materials, you collect them from the output stash. A second kind of station refines fuel (jerry cans) and a recipe file crafts weapon parts. The only export is a notification helper (**client side**).

Needs `ox_lib`, `oxmysql` and `rotd_bridge`. Works on QBCore, Qbox and ESX, with `core_inventory`, `ox_inventory` or `qb-inventory`, and `ox_target`, `qb-target` or `[E]` prompts. Installation: [[Install-rotd_recyclers]].

## Client exports

#### `ShowNotification(title, message, type, timeout)`

Shows a notification: in the ROTD HUD when it runs, otherwise an `ox_lib` notification.

| Parameter | Type | Description |
|---|---|---|
| `title` | `string` | Notification title. |
| `message` | `string` | Notification text. |
| `type` | `string?` | `'info'` (default), `'success'`, `'error'` or `'warning'`. |
| `timeout` | `number?` | Duration in milliseconds. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_recyclers:ShowNotification('Recycler', 'Output ready', 'success', 5000)
```

</details>

## Server exports

`LoadRecyclerOffsets` and `SaveRecyclerOffsets` are declared in the manifest (`server_exports`) for the offset editor of the resource itself. They are not meant to be called by other scripts.

## Commands

| Command | Who | Does |
|---|---|---|
| `/managerecycle` | admins | opens the manager: adjust the interaction points, particles and status text of a recycler |
| `/cleanuprecyclers` | restricted (ace `command.cleanuprecyclers`) | removes the recycler props and interaction points around you (for troubleshooting) |
| `/refreshfuel` | everyone | asks the server for the fuel refinery data again |

## How it works

1. Each recycler has an **input** stash and an **output** stash (`<recycler>_input`, `<recycler>_output`).
2. The player opens the input, puts items in, and starts the machine (or auto-start does).
3. The machine works through the items one unit at a time: the source item is removed and rewards are rolled from the recipe (`chance`, `min`, `max`, optional `metadata`) and placed in the output stash.
4. While a player has the input or output open, processing is paused; it resumes when the window closes.
5. The progress is shown above the machine; a full output stops the machine with a message.

A recipe reward that is not in your item list is skipped, and the server console prints a warning every time a machine tries to output it (and one summary of all missing reward items when the resource starts). Items without a recipe are ignored by the machine. On `core_inventory` the input window itself refuses them (the stash type `recycler_input`); on `ox_inventory` and `qb-inventory` the window accepts anything and the machine skips what it cannot scrap.

## Stash sizes per inventory

| Inventory | Size |
|---|---|
| `core_inventory` | from the stash types `recycler_input`, `recycler_fuel_input` and `stash` in core_inventory's own config |
| `ox_inventory`, `qb-inventory` | `Config.Stash`: `inputSlots` (30), `outputSlots` (50), `weight` in grams |

## Fuel refinery

`Config.FuelRefinery` and the recyclers with `allowFuel = true` refine jerry cans: the can is removed from the input and comes back in the output with the contaminated fuel burned off, plus byproducts. The can's fuel data (litres, contamination, serial) is **core_inventory** weapon-item metadata; on other inventories the refinery finds no matching can. The recycling of normal items works everywhere.

## Config: `configuration/config.lua`

| Key | Meaning |
|---|---|
| `Debug` | debug prints |
| `Stash` | sizes for ox_inventory / qb-inventory (above) |
| `Target` | `distance` of the interaction, `debug` draws the zones |
| `Sounds` | start and stop sounds |
| `Display3DTextRange` | distance of the 3D progress text above a machine |
| `Blips` | discovery blips: shown within `discoverRange`, with `label`, `sprite`, `color`, `scale`, `flash` |
| `FuelRefinery` | jerry can refining rules |
| `Recyclers` | one entry per machine: `label`, `coords`, `heading`, prop model, the `recipes` (item to rewards), `allowFuel`, speed |

`configuration/weapon_recipes.lua` holds the weapon crafting recipes (`requiredItem`, `requiredMetadata`, `outputs`).

## Database

`rotd_bridge` creates the table `recycler_offsets` from `sql/recycler_offsets.sql`: the interaction offsets, particle and status text settings saved by `/managerecycle`.

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| ROTD HUD | notifications | `ox_lib` notifications |
| `ox_target` / `qb-target` | interaction points | `[E]` prompts |
