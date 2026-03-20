<div align="center">

![MineDock Banner](https://img.shields.io/badge/GitHub+%2B+Minecraft+%2B+Docker-MineDock-0077D6?style=for-the-badge&logo=github&logoColor=white&labelColor=24292e)

# 🎮 MineDock

> A production-ready, containerized Minecraft 1.21.8 server with auto-scaling JVM, multi-dimension world support, and one-command deployment.

[![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://docker.com)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.8-brightgreen?logo=minecraft)](https://minecraft.net)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Cloud](https://img.shields.io/badge/Cloud-AWS%20%7C%20GCP%20%7C%20Azure-orange)](docs/CLOUD_DEPLOYMENT.md)

</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🚀 **One-Command Deploy** | `docker-compose up -d` and you're live |
| 🧠 **Auto-Scaling JVM** | Automatically adjusts memory based on container limits (60%-85%) |
| 🌍 **Multi-Dimension Support** | Separate volumes for Overworld, Nether, and The End |
| 🔌 **Plugin Ready** | Drop JARs into `data/plugins/` and restart |
| 💾 **Smart Backups** | Built-in backup script with cloud sync support |
| 🔒 **Secure by Default** | EULA accepted, configurable whitelist, ops management |
| ☁️ **Cloud Native** | Ready for AWS, GCP, Azure deployment |
| 🖥️ **Cross-Platform** | Works on Linux, macOS, and Windows (WSL2) |
| 🎯 **Production Ready** | Battle-tested configuration for SMP servers |

---

## 🚀 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Minecraft Server JAR](https://papermc.io/downloads) (1.21.8 recommended)
- **Minecraft Server JAR** (1.21.8 recommended) - [Download Paper](https://papermc.io/downloads) or [Vanilla](https://www.minecraft.net/en-us/download/server)

### 1. Clone & Download Server JAR

```bash
git clone https://github.com/swapnilsubhashpatil/minedock.git
cd minedock

# Download Minecraft 1.21.8 Paper server (recommended)
curl -L -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.8/builds/latest/downloads/paper-1.21.8.jar

# Or use the quick-start script which guides you through setup
chmod +x scripts/quick-start.sh
./scripts/quick-start.sh
```

### 2. Launch Server

```bash
# Build and start the server
docker-compose up -d --build

# Or use the quick-start script for guided setup
./scripts/quick-start.sh
```

### 3. Connect to Your Server

```
Server Address: localhost:25565
# Or your VM's public IP
```

### 4. Manage Your Server

```bash
# View logs
docker-compose logs -f

# Execute commands
docker-compose exec minecraft rcon-cli say Hello World

# Stop gracefully
docker-compose down
```

---

## 📁 Repository Structure

```
.
├── 📄 docker-compose.yml      # Service orchestration
├── 📄 Dockerfile              # Container image definition
├── 📄 backup_data.sh          # Backup automation script
├── 📄 README.md               # This file
├── 📂 data/
│   ├── 📂 SMP/                # Overworld world data
│   ├── 📂 SMP_nether/         # Nether dimension
│   ├── 📂 SMP_the_end/        # End dimension
│   ├── 📂 plugins/            # Server plugins (.jar files)
│   ├── 📄 server.properties   # Server configuration
│   ├── 📄 server-icon.png     # Server icon (64x64)
│   └── 📄 ops.json            # Server operators
└── 📂 docs/
    ├── 📄 CLOUD_DEPLOYMENT.md    # AWS/GCP/Azure guides
    ├── 📄 PLUGIN_GUIDE.md        # Plugin installation & management
    ├── 📄 WORLD_MANAGEMENT.md    # Import/create worlds
    ├── 📄 SERVER_PROPERTIES.md   # Configuration reference
    ├── 📄 BACKUP_GUIDE.md        # Backup strategies
    └── 📄 VERSION_GUIDE.md       # Minecraft version compatibility
```

---

## 🎯 Use Cases

### **For Server Owners**
- **Zero-downtime updates** - Pull new images without losing world data
- **Easy backups** - One script to backup everything
- **Plugin management** - Simple JAR drop-in system

### **For Developers**
- **Version control your config** - Track server.properties changes
- **Reproducible environments** - Same server everywhere
- **CI/CD ready** - Deploy with GitHub Actions

### **For Communities**
- **Multi-dimension support** - Separate worlds for different game modes
- **Scalable hosting** - Move from local to cloud seamlessly
- **Secure sharing** - No world corruption on crashes

---

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `JVM_INITIAL_RAM_PERCENT` | 60.0 | Initial heap as % of container memory |
| `JVM_MAX_RAM_PERCENT` | 85.0 | Max heap as % of container memory |

### Port Configuration

```yaml
ports:
  - "25565:25565"  # Minecraft server port
```

> 💡 **Custom Port?** See [CLOUD_DEPLOYMENT.md](docs/CLOUD_DEPLOYMENT.md) for network tag configuration.

---

## 📚 Documentation

| Guide | Description |
|-------|-------------|
| [☁️ Cloud Deployment](docs/CLOUD_DEPLOYMENT.md) | Deploy on AWS, GCP, or Azure with network tags |
| [🔌 Plugin Guide](docs/PLUGIN_GUIDE.md) | Install and manage plugins |
| [🌍 World Management](docs/WORLD_MANAGEMENT.md) | Import existing worlds or create new ones |
| [⚙️ Server Properties](docs/SERVER_PROPERTIES.md) | Complete configuration reference |
| [💾 Backup Guide](docs/BACKUP_GUIDE.md) | Local and cloud backup strategies |
| [📋 Version Guide](docs/VERSION_GUIDE.md) | Minecraft 1.21.8 compatibility and updates |

---

## 🐳 Why Docker for Minecraft?

### Traditional Server vs DockerCraft

| Aspect | Traditional | DockerCraft |
|--------|-------------|-------------|
| **Setup Time** | 30+ minutes | 2 minutes |
| **Portability** | Manual reconfiguration | `docker-compose up` anywhere |
| **Backups** | Complex scripts | Built-in automation |
| **Updates** | Risk of data loss | Immutable, versioned images |
| **Resource Usage** | Fixed allocation | Auto-scales with container |
| **Multi-server** | Complex | Simple compose profiles |

### Single Container Benefits

1. **🔄 Isolation** - Server crashes don't affect host system
2. **📦 Portability** - Run on laptop, server, or cloud identically
3. **⬆️ Easy Updates** - Update base image without touching world data
4. **🔧 Consistency** - Same Java version, same environment everywhere
5. **🚀 Quick Recovery** - New server up in seconds with existing data

---

## 🛡️ Security

- ✅ EULA automatically accepted (configurable)
- ✅ Online mode configurable (offline mode for LAN)
- ✅ Whitelist support for private servers
- ✅ Ops management via `ops.json`
- ✅ No root execution in container

---

## 🤝 Contributing

Contributions welcome! Please read our [Contributing Guide](CONTRIBUTING.md).

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

---

## 🌟 Star History

If this project helps you, please give it a ⭐!

[![Star History Chart](https://api.star-history.com/svg?repos=swapnilsubhashpatil/MineDock&type=Date)](https://star-history.com/#swapnilsubhashpatil/MineDock&Date)

---

<div align="center">

**Made with ❤️ for the Minecraft community**

[📖 Documentation](docs/) · [🐛 Issues](../../issues) · [💡 Discussions](../../discussions)

</div>
