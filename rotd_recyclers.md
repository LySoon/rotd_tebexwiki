# rotd_recyclers

Scrapping stations. The only exports are notification helpers (**client side**).

> The resource currently registers `ShowNotification` in two files (`client/client.lua` routes it to the ROTD HUD, `client/notifications.lua` uses `lib.notify`). The one loaded last answers. This will be unified during the multi-framework conversion.

## Client exports

#### `ShowNotification(title, message, type, timeout)`

Shows a notification.

| Parameter | Type | Description |
|---|---|---|
| `title` | `string` | Notification title. |
| `message` | `string` | Notification text. |
| `type` | `string?` | Notification type. Defaults to `'info'`. |
| `timeout` | `number?` | Duration in milliseconds. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_recyclers:ShowNotification('Recycler', 'Output ready', 'success', 5000)
```

</details>

#### `RemoveNotification(id)`

Removes one custom notification.

| Parameter | Type | Description |
|---|---|---|
| `id` | `string \| number` | Notification id. |

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_recyclers:RemoveNotification(id)
```

</details>

#### `ClearNotifications()`

Clears all custom notifications.

**Returns** nothing.

<details>
<summary>Example</summary>

```lua
exports.rotd_recyclers:ClearNotifications()
```

</details>

## Recipes

```lua
-- client: tell the player something in the recycler style
exports.rotd_recyclers:ShowNotification('Recycler', 'Output ready', 'success', 5000)    -- title, message, type, timeout in ms
exports.rotd_recyclers:ShowNotification('Recycler', 'Out of fuel', 'error')              -- default timeout

-- clear all of them (leaving a recycler)
exports.rotd_recyclers:ClearNotifications()
```
