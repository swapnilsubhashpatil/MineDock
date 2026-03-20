# 🌍 World Management Guide

> Complete guide for importing existing Minecraft worlds or creating new ones with DockerCraft SMP.

---

## 📋 Table of Contents

- [Understanding World Structure](#understanding-world-structure)
- [Creating a New World](#creating-a-new-world)
- [Importing an Existing World](#importing-an-existing-world)
- [Multi-Dimension Support](#multi-dimension-support)
- [World Configuration](#world-configuration)
- [Troubleshooting](#troubleshooting)

---

## Understanding World Structure

### Minecraft World Folders

A complete Minecraft world consists of **3 dimension folders**:

```
world/                    # Overworld (main world)
├── level.dat            # World metadata
├── session.lock         # Lock file
├── playerdata/          # Player inventories
├── region/              # Chunk data (.mca files)
├── data/                # Map data, scoreboards
├── entities/            # Entity data
├── poi/                 # Points of interest
├── advancements/        # Player advancements
└── stats/               # Player statistics

world_nether/            # Nether dimension
├── DIM-1/               # Nether region files
└── level.dat

world_the_end/           # End dimension
├── DIM1/                # End region files
└── level.dat
```

### DockerCraft Volume Mapping

```yaml
volumes:
  - ./data/SMP:/app/world           # Overworld
  - ./data/SMP_nether:/app/world_nether    # Nether
  - ./data/SMP_the_end:/app/world_the_end  # End
```

| Container Path | Host Path | Dimension |
|----------------|-----------|-----------|
| `/app/world` | `./data/SMP` | Overworld |
| `/app/world_nether` | `./data/SMP_nether` | Nether |
| `/app/world_the_end` | `./data/SMP_the_end` | The End |

---

## Creating a New World

### Step 1: Clean Start

If you want DockerCraft to generate a fresh world:

```bash
# Stop server
docker-compose down

# Remove existing world data (⚠️ BACKUP FIRST!)
rm -rf data/SMP data/SMP_nether data/SMP_the_end

# Start server - it will generate new worlds
docker-compose up -d
```

### Step 2: Configure World Generation

Edit `data/server.properties`:

```properties
# World name (must match folder name)
level-name=world

# Game mode
gamemode=survival          # survival, creative, adventure, spectator

# Difficulty
difficulty=easy            # peaceful, easy, normal, hard

# World type
level-type=minecraft:normal    # normal, flat, large_biomes, amplified

# Seed (leave empty for random)
level-seed=                # e.g., 123456789

# Generate structures
generate-structures=true   # villages, dungeons, strongholds

# World border
max-world-size=29999984    # Default is effectively infinite
```

### Step 3: Restart to Apply

```bash
docker-compose restart
```

### Step 4: Verify Generation

```bash
# Check world folder exists
ls -la data/SMP/

# Should see:
# level.dat, region/, playerdata/, etc.
```

---

## Importing an Existing World

### Prerequisites

- World folder(s) from another server
- **Minecraft 1.21.8** (or compatible version)
- Backup of existing data (if any)

> ⚠️ **Version Warning**: Worlds from different Minecraft versions may not be compatible. Always backup before upgrading. This server is configured for **Minecraft 1.21.8**.

### Step 1: Prepare Your World

Locate your existing world folders:

```
# From a vanilla server
/path/to/server/world/
/path/to/server/world_nether/
/path/to/server/world_the_end/

# From single player
%appdata%/.minecraft/saves/YourWorld/          # Windows
~/.minecraft/saves/YourWorld/                  # Linux/Mac
```

### Step 2: Stop DockerCraft Server

```bash
docker-compose down
```

### Step 3: Copy World Data

#### Method A: Direct Copy

```bash
# Copy overworld
cp -r /path/to/your/world/* data/SMP/

# Copy nether (if exists)
cp -r /path/to/your/world_nether/* data/SMP_nether/

# Copy end (if exists)
cp -r /path/to/your/world_the_end/* data/SMP_the_end/
```

#### Method B: Using SCP (Remote Server)

```bash
# From your local machine to cloud server
scp -r ./YourWorld/* user@server-ip:~/dockercraft-smp/data/SMP/
scp -r ./YourWorld/DIM-1/* user@server-ip:~/dockercraft-smp/data/SMP_nether/
scp -r ./YourWorld/DIM1/* user@server-ip:~/dockercraft-smp/data/SMP_the_end/
```

#### Method C: Using FTP/SFTP

Use FileZilla or similar to transfer world folders to `data/SMP/`.

### Step 4: Update server.properties

```properties
# Match your world's level.dat name
# If your world folder is "MyAwesomeWorld", use:
level-name=world

# Note: DockerCraft always uses "world" internally
# The actual folder name on host is "SMP"
```

### Step 5: Fix Permissions

```bash
# Ensure Docker can read the files
sudo chown -R $USER:$USER data/SMP data/SMP_nether data/SMP_the_end

# Or if using Docker as different user:
sudo chown -R 1000:1000 data/SMP*
```

### Step 6: Start Server

```bash
docker-compose up -d

# Watch logs
docker-compose logs -f
```

### Step 7: Verify Import

```bash
# Check server recognizes the world
docker-compose logs | grep -i "level"

# Should show:
# Preparing level "world"
# Preparing start region for dimension minecraft:overworld
```

---

## Multi-Dimension Support

### Understanding Dimension Mapping

DockerCraft separates dimensions into individual volumes for:

- **Better backup control** - Backup only overworld if needed
- **Easy dimension management** - Reset Nether without affecting Overworld
- **Performance** - Separate I/O for each dimension

### Importing Worlds with Different Structures

#### Vanilla Server Structure

```
server/
├── world/              → data/SMP/
├── world_nether/       → data/SMP_nether/
└── world_the_end/      → data/SMP_the_end/
```

#### Single Player Structure

```
saves/YourWorld/
├── level.dat           → data/SMP/
├── region/             → data/SMP/region/
├── DIM-1/              → data/SMP_nether/DIM-1/
└── DIM1/               → data/SMP_the_end/DIM1/
```

### Converting Single Player to Server

```bash
# 1. Copy main world
cp -r ~/.minecraft/saves/YourWorld/* data/SMP/

# 2. Move dimensions to separate folders
mkdir -p data/SMP_nether data/SMP_the_end

# Move Nether data
mv data/SMP/DIM-1 data/SMP_nether/

# Move End data
mv data/SMP/DIM1 data/SMP_the_end/

# 3. Start server
docker-compose up -d
```

---

## World Configuration

### server.properties Reference

```properties
# ============================================
# WORLD CONFIGURATION
# ============================================

# World name (internal name, not folder name)
level-name=world

# Game mode for new players
gamemode=survival

# Server difficulty
difficulty=easy

# World generation settings
level-type=minecraft:normal
generate-structures=true
level-seed=

# World limits
max-world-size=29999984
spawn-protection=16

# Spawn settings
spawn-monsters=true
spawn-animals=true
spawn-npcs=true

# Player settings
force-gamemode=false
hardcore=false
pvp=true

# View distance (chunks)
view-distance=8
simulation-distance=6
```

### bukkit.yml (Advanced)

Create `data/bukkit.yml` for Bukkit-specific settings:

```yaml
settings:
  allow-end: true
  warn-on-overload: true
  spawn-radius: 16

worlds:
  world:
    generator: VoidWorld  # Custom generator plugin
  world_nether:
    generator: NetherGenerator
```

### paper-world.yml (Paper Optimizations)

Create `data/paper-world.yml` for Paper-specific optimizations:

```yaml
_world:
  optimize-explosions: true
  mob-spawner-tick-rate: 2
  container-update-tick-rate: 3
  grass-spread-tick-rate: 4

world_nether:
  optimize-explosions: true
```

---

## World Management Commands

### In-Game Commands (with EssentialsX)

```bash
# World teleportation
/world world           # Go to overworld
/world world_nether    # Go to nether
/world world_the_end   # Go to end

# World management
/seed                  # Show world seed
/timings report        # Performance report
```

### Console Commands

```bash
# Access console
docker-compose exec minecraft rcon-cli

# Save world
save-all

# Stop gracefully
stop
```

---

## Troubleshooting

### World Not Loading

```bash
# Check level.dat exists
ls -la data/SMP/level.dat

# Verify file isn't corrupted
file data/SMP/level.dat

# Check logs for errors
docker-compose logs | grep -i error
```

### Spawn Point Issues

```bash
# Set new spawn point (in console)
setworldspawn 0 64 0

# Or in-game (op required)
/setspawn
/setworldspawn
```

### Nether/End Not Working

```bash
# Check dimension folders exist
ls -la data/SMP_nether/
ls -la data/SMP_the_end/

# Check server.properties
allow-nether=true
```

### Corrupted World Recovery

```bash
# 1. Stop server
docker-compose down

# 2. Backup corrupted world
mv data/SMP data/SMP_corrupted_backup

# 3. Try region file repair
# Use external tools like:
# - MCEdit
# - Region Fixer
# - Chunky (can skip corrupted chunks)

# 4. Or restore from backup
unzip backup.zip
```

### Version Mismatch

```bash
# Check world version in level.dat
# Use NBT editor or:

# If world is newer than server:
# - Update server JAR

# If world is older:
# - Should auto-convert
# - Backup first!
```

---

## Best Practices

### ✅ Do's

- **Always backup** before importing worlds
- **Test locally** before uploading to cloud
- **Keep original** world files as backup
- **Use same version** or compatible versions
- **Check permissions** after copying files

### ❌ Don'ts

- **Don't copy while server is running**
- **Don't mix modded and vanilla worlds**
- **Don't delete level.dat** (contains critical data)
- **Don't ignore errors** in logs

---

## Advanced: Multiple Worlds

### Using Multiverse-Core Plugin

```bash
# 1. Install Multiverse-Core
# Download from: https://dev.bukkit.org/projects/multiverse-core

# 2. Place in plugins folder
cp Multiverse-Core.jar data/plugins/

# 3. Restart
docker-compose restart

# 4. Import additional worlds
mv create world2 normal
mv import /path/to/world3 normal world3

# 5. Teleport between worlds
mv tp world2
mv tp world3
```

### Docker Compose for Multiple Servers

```yaml
# docker-compose.multiple.yml
version: '3.8'
services:
  smp:
    build: .
    ports:
      - "25565:25565"
    volumes:
      - ./data/SMP:/app/world
      - ./data/SMP_nether:/app/world_nether
      - ./data/SMP_the_end:/app/world_the_end
      - ./data/server.properties:/app/server.properties

  creative:
    build: .
    ports:
      - "25566:25565"
    volumes:
      - ./data/Creative:/app/world
      - ./data/Creative_nether:/app/world_nether
      - ./data/Creative_the_end:/app/world_the_end
      - ./data/creative.properties:/app/server.properties
```

---

## Next Steps

- [🔌 Plugin Installation](PLUGIN_GUIDE.md)
- [💾 Backup Your World](BACKUP_GUIDE.md)
- [☁️ Deploy to Cloud](CLOUD_DEPLOYMENT.md)
