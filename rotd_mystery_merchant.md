# rotd_mystery_merchant

A travelling merchant van that moves to a random spot every `Config.resettime` minutes. The merchant trades items through your shop resource and offers a dice game.

Needs `ox_lib` and `rotd_bridge`. Optional: `xsound` (music), `jim-shops` / `qb-shops` / `ox_inventory` (shop window), `ox_target` / `qb-target` (talk option; an [E] prompt is used without them).

## Server exports

#### `GetActiveVehicles()`

**Returns** `number[]`: `{ vehicle }` for the merchant's current van, or `{}` when none. `vehicle_spawner` uses it so its cleanup leaves the van alone (the van also carries the state bag `noCleanup`).

<details>
<summary>Example</summary>

```lua
-- keep other resources' vehicles out of your own cleanup
local keep = {}
for _, res in ipairs({ 'rotd_events', 'rotd_mystery_merchant' }) do
    if GetResourceState(res) == 'started' then
        for _, veh in ipairs(exports[res]:GetActiveVehicles()) do keep[veh] = true end
    end
end
```

</details>

## Events (internal)

These connect the resource's own client and server. They are not an API.

| Event | Side | Purpose |
|---|---|---|
| `mysterymerchant:requestMerchantData` | server | a client asks for the current merchant after loading; ignored while no merchant is chosen |
| `mysterymerchant:recievedata` | client | merchant data, vehicle network id and mods (the spelling is the real event name) |
| `mystery_merchant:rolldice` | server | start a dice round: `{ bet, dice, merchantNumber }`; one round at a time per player, values are checked on the server |
| `mystery_merchant:diceWin`, `mystery_merchant:diceLose` | client | result notifications |

## Commands

| Command | Does |
|---|---|
| `/dice <1-3>` | rolls that many dice and shows them above your head for nearby players |
| `/rps [1-3]` | shows rock, paper or scissors above your head; random without an argument |

## Config: `config.lua`

```lua
Config = { resettime = 30 }          -- minutes between merchant moves

Config.merchant = {
    [1] = {
        name = 'Merchant1',
        coords = vector4(x, y, z, heading),     -- where the van spawns
        model = 'ig_clay',                       -- the merchant NPC
        vehicleModel = 'speedo4',
        VehicleMods = {                          -- colour, neon, smoke, mods = { [slot] = index }
            colour = { 1, 2 }, neon = { 255, 0, 255 }, smoke = { 255, 255, 255 },
            mods = { [11] = 3, [17] = 1 },
        },
        SitData = { Offset = { x = 0.65, y = -0.065, z = 0.042 }, Heading = 310.0 },
        scenario = 'PROP_HUMAN_SEAT_DECKCHAIR',
        talkLabel = 'Talk to the Merchant',
        talkIcon = 'fas fa-comments',
        greeting = { distance = 10.0, sentences = { '...' } },
        shopKey = 'mysterymerchant',
        shopKeys = { ['qb-shops'] = '...', ox_inventory = '...' },   -- optional, see below
        products = {
            label = 'Mystery Merchant',
            items = {
                { name = 'weapon_smg', amount = 5, itemsell = 'dogtag', itemsellAmount = 15 },
                { name = 'pistol_ammo', amount = 5000, bundle = 15, itemsell = 'sodacap', itemsellAmount = 1 },
            },
        },
    },
}
```

An item is sold as `name`, with `amount` in stock, paid with `itemsellAmount` of the item `itemsell`. `bundle` is how many units one purchase gives. 20 merchants ship in the config; one is picked at random each cycle.

### Shop resources

The "Open Shop" option goes through `Bridge.Shop.OpenBarter` (see [[rotd_bridge]]):

| Shop resource | Result |
|---|---|
| `jim-shops` | opened with the merchant's own item table: barter and bundles work |
| `ox_inventory` | the shop is registered on the server (`shopKeys.ox_inventory` or `shopKey` is the shop type), items use `currency = itemsell`, `price = itemsellAmount`, `count = amount`; no bundles |
| `qb-shops` with `qb-inventory` | not a barter shop: the bridge builds the shop in `qb-inventory` from `products.items` and items are paid with money: `price` of the item, or `itemsellAmount` when there is no `price`. With `shopKeys['qb-shops']` the named qb-shops location is opened instead |

The item names must exist in your inventory's item list.

## Dice game

- Bet from 10 to 1000, 1 to 3 dice.
- Possible win = bet times 0.5 (one die), 1.0 (two dice), 1.5 (three dice), shown in a preview before the roll.
- The server asks the client for the dice values, adds them up and compares with the merchant's number.
- **The game does not move money:** the bet is not taken and the win is not paid, only notifications are sent. The merchant number is rolled on the client. Add payment (through `Bridge.Framework.AddMoney` / `RemoveMoney`) and roll the number on the server before using the game for real stakes.

## Optional integrations

| Partner | Used for | Without it |
|---|---|---|
| `xsound` | music at the van (15 m range) | no music; one console line says so |
| `jim-shops`, `qb-shops`, `ox_inventory` | shop window | no shop window; one console line says so |
| `ox_target`, `qb-target` | talk option on the merchant | an [E] prompt |
