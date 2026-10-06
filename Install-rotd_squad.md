# Install: rotd_squad

Squads, pings, shared blips, reputation and a squad panel.

> Developer documentation (exports, events, config format): [[rotd_squad]]. General order of installation for all ROTD resources: [[Install]].

## Requirements

| Resource | Needed |
|---|---|
| ox_lib | yes |
| oxmysql | yes |
| rotd_bridge | yes |
| A target resource | optional ([E] prompt without it) |
| `rotd_classystem` | optional (class of each member) |
| `rotd_leaderboard` | optional (permanent zombie kill count) |
| `rotd-hud` | optional (HUD notifications, chat friends) |
| `wasabi_ambulance` | optional (infection level of members) |
| `hrs_base_building` | optional (shared base access) |
| `interact-sound` | optional (sounds) |

## server.cfg

Start order (lines in this order, other resources of yours around them):

```
ensure rotd_bridge
ensure rotd_classystem   # optional
ensure rotd_leaderboard  # optional
ensure rotd_squad
```

Players must **reconnect once** after the first start (the panel files are downloaded when joining).

## Items

None.

## Database

One table, `rotd_squads`, created by `rotd_bridge` a few seconds after the server starts (`rotd_sql` in the manifest). You do not need to run `sql/schema.sql` yourself, and nothing is added to your `players` table.

Player stats (reputation, kills, medals, ...) are stored with the character: in the **metadata** of the character on QBCore and Qbox (the same place the earlier version used, so existing values are kept) and in the `rotd_player_data` table of the bridge on ESX. The manifest already asks the bridge to prepare that table on ESX.

Older installs from before friendly fire existed: run `ALTER TABLE rotd_squads ADD COLUMN IF NOT EXISTS friendly_fire TINYINT(1) NOT NULL DEFAULT 0;` once (the bridge reports "MISSING COLUMNS" if it is needed).

## Controls

| Key | Action |
|---|---|
| F5 | squad panel |
| G | SOS |
| Middle mouse (hold) | ping wheel |
| Left Alt (hold) | reputation of nearby players |

Players can change every key in the game's key bindings. Command alternatives: `/squadinvite <id>`, `/squadsettings`.

## First-time checklist

- `MaxSquadMembers`, `InviteRadius` and the reputation values in `config.lua`.
- `AllowClientStatEvents`: leave `true` if a client-side resource (for example your zombie resource) reports kills and loot to the squad. Set it to `false` if only your server scripts call the exports, so a cheater cannot send those events.
- `FriendlyFireDefault`: the start state of friendly fire in new squads.
- Admins: `add_ace group.admin rotd_squad.debug allow` allows the debug toggle (optional). `/setreputation <id> <amount>` needs the framework admin permission.

## Test it

1. Join with two characters, create a squad with one and invite the other: the panel shows both.
2. Move apart: the mate stays on your map and a name shows above them when near.
3. Hold the middle mouse button and ping: both players see the marker.
4. Restart the resource: the squad is still there after you reconnect.
