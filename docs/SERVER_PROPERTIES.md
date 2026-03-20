# ⚙️ Server Properties Reference

> Complete guide to configuring your Minecraft server through `server.properties`.

---

## 📋 Table of Contents

- [Quick Reference](#quick-reference)
- [Network Settings](#network-settings)
- [Gameplay Settings](#gameplay-settings)
- [World Settings](#world-settings)
- [Security Settings](#security-settings)
- [Performance Settings](#performance-settings)
- [Advanced Settings](#advanced-settings)

---

## Quick Reference

### Essential Settings

```properties
# These are the most commonly changed settings
server-port=25565
gamemode=survival
difficulty=easy
max-players=20
motd=§6§lSMP Realm§r\n§eA server made by Swappy
online-mode=false
white-list=false
```

### Full Configuration Example

```properties
# DockerCraft SMP - server.properties
# Lines starting with # are comments

# ============================================
# NETWORK
# ============================================
server-ip=
server-port=25565
query.port=25565
enable-query=false
enable-status=true

# ============================================
# GAMEPLAY
# ============================================
gamemode=survival
force-gamemode=false
difficulty=easy
hardcore=false
pvp=true
max-players=20

# ============================================
# WORLD
# ============================================
level-name=world
level-seed=
level-type=minecraft\:normal
generate-structures=true
allow-nether=true

# ============================================
# SECURITY
# ============================================
online-mode=false
white-list=false
enforce-whitelist=false
enforce-secure-profile=true
prevent-proxy-connections=true

# ============================================
# PERFORMANCE
# ============================================
view-distance=8
simulation-distance=6
max-world-size=29999984
entity-broadcast-range-percentage=100
network-compression-threshold=256
```

---

## Network Settings

### server-ip

```properties
server-ip=
```

- **Default**: (empty)
- **Description**: IP address to bind to
- **Usage**: Leave empty to bind to all interfaces
- **Docker Note**: Always leave empty in Docker; binding is handled by compose

### server-port

```properties
server-port=25565
```

- **Default**: 25565
- **Range**: 1-65535
- **Description**: Port the server listens on (inside container)
- **Important**: This is the **container** port. Change the **host** port in docker-compose.yml

```yaml
# docker-compose.yml
ports:
  - "25566:25565"  # Host:Container
```

### enable-status

```properties
enable-status=true
```

- **Default**: true
- **Description**: Shows server in server list (MOTD + player count)
- **Values**: `true` | `false`

### enable-query

```properties
enable-query=false
query.port=25565
```

- **Default**: false
- **Description**: Enables GameSpy4 protocol for server querying
- **Usage**: Required by some server list websites

### network-compression-threshold

```properties
network-compression-threshold=256
```

- **Default**: 256
- **Range**: -1 to 2097152
- **Description**: Bytes threshold for packet compression
- **Tuning**:
  - Lower = More CPU, less bandwidth
  - Higher = Less CPU, more bandwidth
  - -1 = Disable compression

---

## Gameplay Settings

### gamemode

```properties
gamemode=survival
```

- **Default**: survival
- **Values**:
  - `survival` - Health, hunger, crafting
  - `creative` - Unlimited blocks, flying
  - `adventure` - No block breaking/placing
  - `spectator` - Fly through blocks, invisible

### force-gamemode

```properties
force-gamemode=false
```

- **Default**: false
- **Description**: Forces gamemode on join (overrides player saved gamemode)
- **Values**: `true` | `false`

### difficulty

```properties
difficulty=easy
```

- **Default**: easy
- **Values**:
  - `peaceful` - No hostile mobs, instant health regen
  - `easy` - Hostile mobs, reduced damage
  - `normal` - Standard gameplay
  - `hard` - Increased damage, effects last longer

### hardcore

```properties
hardcore=false
```

- **Default**: false
- **Description**: Permadeath (ban on death)
- **Note**: Automatically sets difficulty to hard

### pvp

```properties
pvp=true
```

- **Default**: true
- **Description**: Player vs Player damage
- **Values**: `true` | `false`

### max-players

```properties
max-players=20
```

- **Default**: 20
- **Range**: 1-Integer.MAX_VALUE
- **Description**: Maximum concurrent players
- **Note**: More players = More RAM/CPU needed

### player-idle-timeout

```properties
player-idle-timeout=0
```

- **Default**: 0
- **Range**: 0 (disabled) or minutes
- **Description**: Kick idle players after X minutes

### spawn-protection

```properties
spawn-protection=16
```

- **Default**: 16
- **Range**: 0 to 32767
- **Description**: Radius (blocks) around spawn only ops can edit
- **Set to 0**: Disable protection

---

## World Settings

### level-name

```properties
level-name=world
```

- **Default**: world
- **Description**: Name of world folder (and displayed name)
- **Docker Note**: DockerCraft uses `world` internally, maps to `SMP` folder

### level-seed

```properties
level-seed=
```

- **Default**: (empty - random seed)
- **Description**: Seed for world generation
- **Usage**: Use same seed for identical worlds

### level-type

```properties
level-type=minecraft\:normal
```

- **Default**: minecraft:normal
- **Values**:
  - `minecraft:normal` - Standard terrain
  - `minecraft:flat` - Flat world
  - `minecraft:large_biomes` - 4x biome size
  - `minecraft:amplified` - Extreme terrain

### generate-structures

```properties
generate-structures=true
```

- **Default**: true
- **Description**: Generate villages, dungeons, strongholds, etc.
- **Values**: `true` | `false`

### allow-nether

```properties
allow-nether=true
```

- **Default**: true
- **Description**: Enable Nether dimension
- **Values**: `true` | `false`

### max-world-size

```properties
max-world-size=29999984
```

- **Default**: 29999984
- **Range**: 1 to 29999984
- **Description**: Max radius (blocks) of world border

### view-distance

```properties
view-distance=8
```

- **Default**: 8
- **Range**: 3-32
- **Description**: Chunks sent to players (radius)
- **Impact**: Higher = More RAM, more CPU, more bandwidth
- **Recommendation**: 8-10 for most servers

### simulation-distance

```properties
simulation-distance=6
```

- **Default**: 10 (Java 1.18+), 10 (before)
- **Range**: 3-32
- **Description**: Chunks where entities/tile entities tick
- **Impact**: Higher = More CPU usage
- **Optimization**: Can be lower than view-distance

---

## Security Settings

### online-mode

```properties
online-mode=false
```

- **Default**: true (in vanilla), false (in DockerCraft)
- **Description**: Verify players with Mojang/Microsoft servers
- **Values**:
  - `true` - Online accounts only (recommended)
  - `false` - Allow offline/cracked (LAN play)
- **Warning**: false allows name spoofing without additional plugins

### white-list

```properties
white-list=false
```

- **Default**: false
- **Description**: Only allow whitelisted players
- **Values**: `true` | `false`

### enforce-whitelist

```properties
enforce-whitelist=false
```

- **Default**: false
- **Description**: Kick non-whitelisted players immediately
- **Note**: When false, whitelist checked at login only

### enforce-secure-profile

```properties
enforce-secure-profile=true
```

- **Default**: true
- **Description**: Require signed chat messages
- **Values**: `true` | `false`

### prevent-proxy-connections

```properties
prevent-proxy-connections=true
```

- **Default**: false
- **Description**: Block connections through VPN/proxy
- **Values**: `true` | `false`

### op-permission-level

```properties
op-permission-level=4
```

- **Default**: 4
- **Range**: 0-4
- **Description**: Permission level for ops
- **Levels**:
  - 0 - No permissions
  - 1 - Bypass spawn protection
  - 2 - Singleplayer commands + 1
  - 3 - Multiplayer commands + 2
  - 4 - All commands + 3

### function-permission-level

```properties
function-permission-level=2
```

- **Default**: 2
- **Range**: 0-4
- **Description**: Permission level for datapack functions

### hide-online-players

```properties
hide-online-players=false
```

- **Default**: false
- **Description**: Hide player list from server ping
- **Values**: `true` | `false`

---

## Performance Settings

### max-tick-time

```properties
max-tick-time=60000
```

- **Default**: 60000
- **Range**: -1 (disabled) or milliseconds
- **Description**: Watchdog - crash if tick takes longer
- **Note**: -1 to disable (not recommended for production)

### entity-broadcast-range-percentage

```properties
entity-broadcast-range-percentage=100
```

- **Default**: 100
- **Range**: 10-1000
- **Description**: Entity tracking range multiplier
- **Lower**: Less entities sent, better performance

### sync-chunk-writes

```properties
sync-chunk-writes=true
```

- **Default**: true
- **Description**: Synchronous chunk writes to disk
- **Values**: `true` | `false`
- **Note**: false = Better performance, risk of corruption on crash

### use-native-transport

```properties
use-native-transport=true
```

- **Default**: true
- **Description**: Use optimized Linux networking
- **Note**: Only works on Linux, auto-disabled on others

### pause-when-empty-seconds

```properties
pause-when-empty-seconds=60
```

- **Default**: 60
- **Description**: Pause tick loop when empty for X seconds
- **Values**: -1 (never), 0 (always), seconds

---

## Server Messaging

### motd

```properties
motd=§6§lSMP Realm§r\n§eA server made by Swappy
```

- **Default**: A Minecraft Server
- **Description**: Message displayed in server list
- **Formatting**:
  - `§0-§f` - Colors
  - `§l` - Bold
  - `§m` - Strikethrough
  - `§n` - Underline
  - `§o` - Italic
  - `§r` - Reset
  - `\n` - New line

**Color Codes:**

| Code | Color | Code | Color |
|------|-------|------|-------|
| §0 | Black | §8 | Dark Gray |
| §1 | Dark Blue | §9 | Blue |
| §2 | Dark Green | §a | Green |
| §3 | Dark Aqua | §b | Aqua |
| §4 | Dark Red | §c | Red |
| §5 | Dark Purple | §d | Light Purple |
| §6 | Gold | §e | Yellow |
| §7 | Gray | §f | White |

### allow-flight

```properties
allow-flight=false
```

- **Default**: false
- **Description**: Allow survival flight (kick if flying too long)
- **Note**: Set true if using mods/plugins with flight

### resource-pack

```properties
resource-pack=
resource-pack-id=
resource-pack-sha1=
resource-pack-prompt=
require-resource-pack=false
```

- **Description**: Force server resource pack
- **resource-pack**: Direct download URL
- **resource-pack-sha1**: SHA1 hash for caching
- **require-resource-pack**: Kick players who decline

---

## Remote Console (RCON)

### RCON Settings

```properties
enable-rcon=false
rcon.port=25575
rcon.password=your_secure_password_here
broadcast-rcon-to-ops=true
```

- **enable-rcon**: Enable remote console access
- **rcon.port**: RCON port (usually 25575)
- **rcon.password**: **Required** - Set strong password!
- **broadcast-rcon-to-ops**: Show RCON commands to ops

### Using RCON

```bash
# Connect via rcon-cli
docker-compose exec minecraft rcon-cli

# Or external tool (mcrcon)
mcrcon -H your-server-ip -P 25575 -p yourpassword
```

---

## Debug Settings

### debug

```properties
debug=false
```

- **Default**: false
- **Description**: Enable debug logging
- **Values**: `true` | `false`

### enable-jmx-monitoring

```properties
enable-jmx-monitoring=false
```

- **Default**: false
- **Description**: Enable JMX profiling
- **Usage**: Connect with VisualVM or similar tools

### log-ips

```properties
log-ips=true
```

- **Default**: true
- **Description**: Log player IP addresses
- **Values**: `true` | `false`
- **Note**: false for GDPR compliance

### accepts-transfers

```properties
accepts-transfers=false
```

- **Default**: false
- **Description**: Accept transfer requests from other servers

---

## Application to DockerCraft

### Hot Reload

```bash
# Edit server.properties
nano data/server.properties

# Restart to apply
docker-compose restart
```

### Persistent Configuration

The `server.properties` is volume-mounted:

```yaml
volumes:
  - ./data/server.properties:/app/server.properties
```

Changes persist across container restarts.

### Environment Variables

Some settings can be overridden via Docker environment:

```yaml
environment:
  - JVM_OPTS=-Xms2G -Xmx4G
```

### Custom Properties File

For multiple servers, use different property files:

```yaml
# docker-compose.yml
services:
  survival:
    volumes:
      - ./data/survival.properties:/app/server.properties

  creative:
    volumes:
      - ./data/creative.properties:/app/server.properties
```

---

## Configuration Checklist

Before going live:

- [ ] Set appropriate `max-players` for your hardware
- [ ] Configure `motd` with your server name
- [ ] Set `online-mode` appropriately
- [ ] Enable `white-list` if private server
- [ ] Adjust `view-distance` based on performance
- [ ] Set strong `rcon.password` if using RCON
- [ ] Configure `difficulty` for your play style
- [ ] Set `level-seed` for specific world generation
- [ ] Adjust `spawn-protection` if needed
- [ ] Enable `enable-query` for server lists

---

## Related Documentation

- [🌍 World Management](WORLD_MANAGEMENT.md)
- [🔌 Plugin Guide](PLUGIN_GUIDE.md)
- [💾 Backup Guide](BACKUP_GUIDE.md)
- [☁️ Cloud Deployment](CLOUD_DEPLOYMENT.md)
