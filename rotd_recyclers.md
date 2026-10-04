# rotd_recyclers

Scrapping stations. The only exports are notification helpers (**client side**).

| Export | Input | Effect |
|---|---|---|
| `ShowNotification(title, message, type, timeout)` | `type` defaults to `'info'`, `timeout` in milliseconds | shows a notification |
| `RemoveNotification(id)` | notification id | removes one custom notification |
| `ClearNotifications()` | | clears all custom notifications |

```lua
exports.rotd_recyclers:ShowNotification('Recycler', 'Output ready', 'success', 5000)
```

> The resource currently registers `ShowNotification` in two files (`client/client.lua` routes it to the ROTD HUD, `client/notifications.lua` uses `lib.notify`). The one loaded last answers. This will be unified during the multi-framework conversion.
