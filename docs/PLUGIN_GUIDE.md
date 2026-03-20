# 🔌 Plugin Guide

> Complete guide to installing, configuring, and managing Minecraft server plugins with DockerCraft SMP.

---

## 📋 Table of Contents

- [Plugin Basics](#plugin-basics)
- [Finding Plugins](#finding-plugins)
- [Installation](#installation)
- [Pre-installed Plugins](#pre-installed-plugins)
- [Popular Plugins](#popular-plugins)
- [Plugin Configuration](#plugin-configuration)
- [Troubleshooting](#troubleshooting)

---

## Plugin Basics

### What Are Plugins?

Plugins are Java JAR files that extend Minecraft server functionality without modifying the game client. They can:

- Add economy systems
- Provide grief protection
- Enable teleportation commands
- Add minigames
- Manage permissions
- Log block changes

### Plugin Compatibility

DockerCraft SMP uses **Paper 1.21.8** (high-performance Spigot fork):

| Server Type | Compatible? |
|-------------|-------------|
| Bukkit | ✅ Yes |
| Spigot | ✅ Yes |
| Paper | ✅ Yes (recommended) |
| Forge | ❌ No (use mods) |
| Fabric | ❌ No (use mods) |

---

## Finding Plugins

### Official Sources

| Source | URL | Description |
|--------|-----|-------------|
| **Hangar** | https://hangar.papermc.io | Paper's official plugin repository |
| **SpigotMC** | https://spigotmc.org/resources | Largest plugin community |
| **Bukkit Dev** | https://dev.bukkit.org | Legacy Bukkit plugins |
| **Modrinth** | https://modrinth.com/plugins | Modern, fast platform |

### Plugin Selection Tips

✅ **Good Signs:**
- Recently updated (within last 3 months)
- High download count
- Active developer responses
- Open source (GitHub link)

❌ **Red Flags:**
- Last updated 1+ years ago
- Low download count (<100)
- Many unresolved bug reports
- "Abandoned" comments

---

## Installation

### Method 1: Direct Download (Recommended)

```bash
# Navigate to plugins folder
cd data/plugins

# Download plugin (example: EssentialsX)
curl -O https://github.com/EssentialsX/Essentials/releases/download/2.21.2/EssentialsX-2.21.2.jar

# Restart server
cd ../..
docker-compose restart
```

### Method 2: SCP/SFTP Upload

```bash
# From your local machine
scp plugin-name.jar user@server-ip:/path/to/dockercraft-smp/data/plugins/

# Then restart
docker-compose restart
```

### Method 3: Docker Volume Mount

```yaml
# docker-compose.yml
volumes:
  - ./data/plugins:/app/plugins
```

Just drop JARs into `data/plugins/` and restart.

### Installation Steps

1. **Stop the server** (optional but recommended):
   ```bash
   docker-compose stop
   ```

2. **Download plugin** to `data/plugins/`

3. **Start server**:
   ```bash
   docker-compose up -d
   ```

4. **Verify installation**:
   ```bash
   docker-compose logs | grep -i "plugin"
   ```

---

## Pre-installed Plugins

Your DockerCraft SMP comes with essential plugins:

### 1. **LuckPerms** (v5.5.17)
- **Purpose**: Advanced permissions management
- **Use**: Create groups, assign permissions, manage player ranks
- **Config**: `data/plugins/LuckPerms/`

```bash
# In-game commands
/lp user PLAYERNAME info          # Check player permissions
/lp user PLAYERNAME parent set admin  # Make player admin
/lp creategroup vip               # Create VIP group
/lp group vip permission set essentials.fly true  # Grant fly permission
```

### 2. **EssentialsX** (v2.21.2)
- **Purpose**: Essential commands for server management
- **Use**: Teleportation, homes, warps, economy basics
- **Config**: `data/plugins/Essentials/`

```bash
# Common commands
/sethome home1           # Set home location
/home home1              # Teleport home
/tpa PLAYERNAME          # Request teleport to player
/tpaccept                # Accept teleport request
/spawn                   # Return to spawn
/warp SPAWN              # Warp to location
/gamemode creative       # Change gamemode
/god                     # Toggle god mode
```

### 3. **CoreProtect** (v23.1)
- **Purpose**: Block logging and rollback
- **Use**: Check who griefed, rollback changes
- **Config**: `data/plugins/CoreProtect/`

```bash
# Investigation commands
/co inspect              # Toggle inspector mode (right-click blocks)
/co lookup radius:10     # Check actions in 10 block radius
/co rollback r:10 t:1h   # Rollback last hour in 10 block radius
/co restore r:10 t:1h    # Restore rolled back changes
```

### 4. **Chunky** (v1.4.40)
- **Purpose**: World pre-generation
- **Use**: Pre-generate world to reduce lag
- **Config**: `data/plugins/Chunky/config.yml`

```bash
# Pre-generate chunks
chunky start            # Start pre-generation
chunky pause            # Pause generation
chunky continue         # Resume generation
chunky cancel           # Stop generation
chunky world world      # Select world
chunky radius 1000      # Set radius
```

---

## Popular Plugins

### 🛡️ Protection

| Plugin | Purpose | Download |
|--------|---------|----------|
| **WorldGuard** | Region protection | https://dev.bukkit.org/projects/worldguard |
| **GriefPrevention** | Claim-based protection | https://dev.bukkit.org/projects/grief-prevention |
| **Towny** | Town management | https://townyadvanced.github.io |

### 💰 Economy

| Plugin | Purpose | Download |
|--------|---------|----------|
| **Vault** | Economy API (required by many) | https://github.com/milkbowl/Vault |
| **EssentialsX Economy** | Basic economy | Included with EssentialsX |
| **PlayerPoints** | Point system | https://www.spigotmc.org/resources/playerpoints/ |

### 🎮 Gameplay

| Plugin | Purpose | Download |
|--------|---------|----------|
| **mcMMO** | RPG skills | https://mcmmo.org |
| **Quests** | Quest system | https://github.com/LMBishop/Quests |
| **Citizens** | NPCs | https://wiki.citizensnpcs.co |

### 🔧 Administration

| Plugin | Purpose | Download |
|--------|---------|----------|
| **WorldEdit** | Building tool | https://enginehub.org/worldedit |
| **Dynmap** | Live web map | https://github.com/webbukkit/dynmap |
| **DiscordSRV** | Discord integration | https://github.com/DiscordSRV/DiscordSRV |

### 📊 Performance

| Plugin | Purpose | Download |
|--------|---------|----------|
| **Spark** | Performance profiler | https://spark.lucko.me |
| **ClearLag** | Entity cleanup | https://www.spigotmc.org/resources/clearlagg |

---

## Plugin Configuration

### Configuration Files

After first run, plugins create config folders:

```
data/plugins/
├── PluginName/
│   ├── config.yml          # Main configuration
│   ├── data/               # Plugin data
│   └── lang/               # Language files
└── AnotherPlugin/
    └── config.yml
```

### Editing Configuration

1. **Stop the server** (for safe editing):
   ```bash
   docker-compose stop
   ```

2. **Edit config file**:
   ```bash
   nano data/plugins/Essentials/config.yml
   ```

3. **Start server**:
   ```bash
   docker-compose up -d
   ```

### Hot Reload (Some Plugins)

```bash
# Some plugins support reload without restart
# In server console:
reload confirm

# Or specific plugin reload
/essentials reload
```

> ⚠️ **Warning**: `reload` can cause memory leaks. Full restart is safer.

---

## Essential Plugin Setup

### Setting Up LuckPerms

```bash
# 1. Open console
docker-compose exec minecraft sh

# 2. Run LuckPerms commands
# Or in-game with /lp

# Create groups
lp creategroup default
lp creategroup vip
lp creategroup moderator
lp creategroup admin

# Set group weights (higher = more powerful)
lp group vip setweight 100
lp group moderator setweight 200
lp group admin setweight 1000

# Set default group
lp group default setdisplayname Member
lp group default permission set essentials.sethome true

# Inheritance (VIP gets default permissions)
lp group vip parent add default
```

### Setting Up EssentialsX

Edit `data/plugins/Essentials/config.yml`:

```yaml
# Key settings
spawnpoint: world
respawn-at-home: true
teleport-cooldown: 0
teleport-delay: 0

# Economy (optional)
economy:
  use-bukkit-api: false
  min-money: 0
  max-money: 1000000
  starting-balance: 100

# MOTD (join message)
join-message: "§6Welcome §7{PLAYER} §6to the server!"
```

### Setting Up CoreProtect

Edit `data/plugins/CoreProtect/config.yml`:

```yaml
# Configure logging
mysql:
  enabled: false  # Use SQLite for simplicity

logging:
  block-place: true
  block-break: true
  container-transactions: true
  entity-kills: true
  player-commands: true
  player-messages: false  # Set true to log chat

# Purge old data
purge:
  enabled: true
  days: 30  # Keep 30 days of logs
```

---

## Troubleshooting

### Plugin Not Loading

```bash
# Check server logs
docker-compose logs | grep -i error

# Common issues:
# 1. Wrong server version
# 2. Missing dependencies (like Vault)
# 3. Corrupted JAR file
```

### Plugin Conflicts

```bash
# Isolate problematic plugin:
# 1. Stop server
# 2. Move half of plugins out
# 3. Start and test
# 4. Continue until you find the conflict
```

### Permission Issues

```bash
# Debug permissions with LuckPerms
/lp verbose on PLAYERNAME

# Check effective permissions
/lp user PLAYERNAME permission info
```

### Reset Plugin Config

```bash
# Delete config folder and restart
docker-compose stop
rm -rf data/plugins/PluginName/
docker-compose up -d
# Plugin will regenerate default config
```

---

## Best Practices

### ✅ Do's

- **Test plugins locally** before adding to production
- **Backup before major changes**
- **Read documentation** for each plugin
- **Keep plugins updated** (security + bug fixes)
- **Use LuckPerms** for permission management
- **Limit admin plugins** to reduce attack surface

### ❌ Don'ts

- **Don't install 50+ plugins** (performance impact)
- **Don't use cracked/pirated plugins**
- **Don't ignore console errors**
- **Don't reload constantly** (use restart)
- **Don't give * permission** to regular players

---

## Recommended Plugin Combinations

### 🏠 Vanilla Survival Server
- LuckPerms
- EssentialsX
- CoreProtect
- GriefPrevention or WorldGuard

### 🏰 RPG Server
- LuckPerms
- EssentialsX
- mcMMO
- Quests
- Citizens
- CoreProtect

### 🏗️ Creative Server
- LuckPerms
- WorldEdit
- WorldGuard
- PlotSquared
- CoreProtect

### 🎉 Minigame Server
- LuckPerms
- EssentialsX
- Multiple minigame plugins
- Stat tracking plugin

---

## Next Steps

- [🌍 World Management Guide](WORLD_MANAGEMENT.md)
- [💾 Backup Strategies](BACKUP_GUIDE.md)
- [☁️ Cloud Deployment](CLOUD_DEPLOYMENT.md)
