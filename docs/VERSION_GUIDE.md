# 📋 Version Guide

> Minecraft version compatibility and server JAR download instructions.

---

## Current Version

**Minecraft Server Version: 1.21.8**

This repository is configured and tested for Minecraft **1.21.8**.

---

## Download Server JAR

### Option 1: Paper (Recommended)

Paper is a high-performance fork of Spigot with optimization patches.

```bash
# Download Paper 1.21.8
curl -L -o server.jar \
  https://api.papermc.io/v2/projects/paper/versions/1.21.8/builds/latest/downloads/paper-1.21.8.jar
```

**Why Paper?**
- Better performance than vanilla
- Plugin compatibility (Bukkit/Spigot/Paper)
- Built-in optimizations
- Active development

### Option 2: Vanilla

Official Minecraft server from Mojang.

```bash
# Download Vanilla 1.21.8 (check Mojang website for current URL)
curl -L -o server.jar \
  https://piston-data.mojang.com/v1/objects/.../server.jar
```

**Why Vanilla?**
- Pure Minecraft experience
- No plugin modifications
- Smaller file size

### Option 3: Spigot

Spigot is the base for Paper with some optimizations.

```bash
# Build Spigot using BuildTools
# Download from: https://www.spigotmc.org/
```

---

## Version Compatibility

### Supported Versions

| Version | Status | Notes |
|---------|--------|-------|
| 1.21.8 | ✅ Recommended | Primary target version |
| 1.21.x | ✅ Compatible | Should work fine |
| 1.20.x | ⚠️ Test | May require plugin updates |
| < 1.20 | ❌ Unsupported | Not tested |

### Plugin Compatibility

Pre-installed plugins support 1.21.8:

| Plugin | Version | Compatible |
|--------|---------|------------|
| LuckPerms | 5.5.17 | ✅ 1.21.8 |
| EssentialsX | 2.21.2 | ✅ 1.21.8 |
| CoreProtect | 23.1 | ✅ 1.21.8 |
| Chunky | 1.4.40 | ✅ 1.21.8 |

---

## Updating Server Version

### Step 1: Backup Current World

```bash
./backup_data.sh
```

### Step 2: Stop Server

```bash
docker-compose down
```

### Step 3: Download New JAR

```bash
# Example: Updating to 1.21.9
curl -L -o server.jar \
  https://api.papermc.io/v2/projects/paper/versions/1.21.9/builds/latest/downloads/paper-1.21.9.jar
```

### Step 4: Update Plugins (if needed)

Check for plugin updates compatible with new version:

```bash
# Download updated plugin JARs to data/plugins/
# Remove old versions
# Restart server
```

### Step 5: Restart Server

```bash
docker-compose up -d --build
```

### Step 6: Verify

```bash
# Check server version in logs
docker-compose logs | grep -i "version"

# Or in-game
/version
```

---

## Troubleshooting Version Issues

### "Unsupported class file version"

Your server JAR requires a newer Java version.

```bash
# Update Dockerfile to use newer Java
FROM eclipse-temurin:21-jre  # or 22-jre
```

### Plugin errors after update

1. Check plugin compatibility list
2. Update plugins to latest versions
3. Check plugin config files for deprecated options

### World conversion issues

```bash
# Force upgrade world (add to docker-compose.yml)
services:
  minecraft:
    environment:
      - JVM_OPTS=-DforceUpgrade=true
```

---

## Related Documentation

- [🌍 World Management](WORLD_MANAGEMENT.md)
- [🔌 Plugin Guide](PLUGIN_GUIDE.md)
- [💾 Backup Guide](BACKUP_GUIDE.md)
