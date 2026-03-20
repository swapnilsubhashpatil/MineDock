# 💾 Backup Guide

> Complete backup strategies for DockerCraft SMP - from local backups to cloud synchronization.

---

## 📋 Table of Contents

- [Quick Backup](#quick-backup)
- [Built-in Backup Script](#built-in-backup-script)
- [Local Backup Strategies](#local-backup-strategies)
- [Cloud Backup Solutions](#cloud-backup-solutions)
- [Automated Backups](#automated-backups)
- [Restoring from Backup](#restoring-from-backup)
- [Best Practices](#best-practices)

---

## Quick Backup

### One-Line Backup

```bash
# Using the built-in script
./backup_data.sh

# Output: data.zip created in project root
```

### Manual Backup

```bash
# Stop server (recommended for consistent backup)
docker-compose down

# Create backup
zip -r backup-$(date +%Y%m%d-%H%M%S).zip data/

# Start server
docker-compose up -d
```

---

## Built-in Backup Script

The `backup_data.sh` script provides **cross-platform backup** functionality:

### Features

- ✅ **Cross-platform**: Works on Linux, macOS, Windows (WSL/PowerShell)
- ✅ **Safe**: Creates temporary file first, then moves (atomic operation)
- ✅ **Fast**: Uses native tools (zip, PowerShell, or tar)
- ✅ **Simple**: One command to backup everything

### Usage

```bash
# Make executable (Linux/Mac)
chmod +x backup_data.sh

# Run backup
./backup_data.sh

# Output:
# Backup created: /path/to/project/data.zip
```

### Script Details

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
OUTPUT_ZIP="$SCRIPT_DIR/data.zip"
TMP_ZIP="$SCRIPT_DIR/.data.tmp.zip"

# Check data directory exists
# Remove old temp file
# Create archive (zip/powershell/tar)
# Atomic move to final location
```

### What Gets Backed Up?

```
data.zip
├── SMP/                    # Overworld world data
├── SMP_nether/             # Nether dimension
├── SMP_the_end/            # End dimension
├── plugins/                # Plugin configurations
│   ├── PluginName/
│   │   ├── config.yml
│   │   └── data/
├── server.properties       # Server configuration
├── server-icon.png         # Server icon
└── ops.json                # Operator list
```

### What Doesn't Get Backed Up?

Per `.gitignore`, these are excluded:

- `data/plugins/*.jar` - Plugin JARs (redownloadable)
- `data/plugins/**/logs/` - Plugin logs
- `data/plugins/**/*.db` - Temporary databases
- `data/plugins/**/userdata/` - Plugin cache data

---

## Local Backup Strategies

### Strategy 1: Simple Timestamped Backups

```bash
#!/bin/bash
# backup-rotation.sh

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d-%H%M%S)
KEEP_DAYS=7

# Create backup dir
mkdir -p "$BACKUP_DIR"

# Stop server
docker-compose down

# Create backup
cp -r data "$BACKUP_DIR/data-$DATE"
zip -r "$BACKUP_DIR/backup-$DATE.zip" data/

# Start server
docker-compose up -d

# Delete old backups (older than 7 days)
find "$BACKUP_DIR" -name "backup-*.zip" -mtime +$KEEP_DAYS -delete

echo "Backup complete: backup-$DATE.zip"
```

### Strategy 2: Incremental Backups with rsync

```bash
#!/bin/bash
# incremental-backup.sh

BACKUP_DIR="./backups"
LATEST="$BACKUP_DIR/latest"
DATE=$(date +%Y%m%d-%H%M%S)

# Create hard-link backup (space efficient)
rsync -av --link-dest="$LATEST" data/ "$BACKUP_DIR/$DATE/"

# Update latest symlink
rm -f "$LATEST"
ln -s "$DATE" "$LATEST"

# Keep only last 10 backups
ls -t "$BACKUP_DIR" | tail -n +11 | xargs -r rm -rf
```

### Strategy 3: Split Backups (World vs Config)

```bash
#!/bin/bash
# split-backup.sh

DATE=$(date +%Y%m%d-%H%M%S)
mkdir -p "backups/$DATE"

docker-compose down

# Backup worlds (large)
zip -r "backups/$DATE/worlds.zip" \
  data/SMP/ \
  data/SMP_nether/ \
  data/SMP_the_end/

# Backup configs (small)
zip -r "backups/$DATE/configs.zip" \
  data/server.properties \
  data/ops.json \
  data/server-icon.png \
  data/plugins/

docker-compose up -d

echo "Backup in backups/$DATE/"
```

---

## Cloud Backup Solutions

### Solution 1: AWS S3 Backup

#### Setup

```bash
# Install AWS CLI
pip install awscli

# Configure credentials
aws configure
# Enter: Access Key ID, Secret Access Key, region
```

#### Backup Script

```bash
#!/bin/bash
# aws-backup.sh

BUCKET="minecraft-server-backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="minecraft-backup-$DATE.zip"

docker-compose down

# Create local backup
zip -r "$BACKUP_FILE" data/

# Upload to S3
aws s3 cp "$BACKUP_FILE" "s3://$BUCKET/backups/"

# Cleanup local file
rm "$BACKUP_FILE"

docker-compose up -d

# Delete old S3 backups (keep last 30)
aws s3 ls "s3://$BUCKET/backups/" | \
  sort | \
  head -n -30 | \
  awk '{print $4}' | \
  xargs -I {} aws s3 rm "s3://$BUCKET/backups/{}"

echo "Backup uploaded to s3://$BUCKET/backups/$BACKUP_FILE"
```

#### S3 Lifecycle Policy

```json
{
  "Rules": [
    {
      "ID": "MinecraftBackups",
      "Status": "Enabled",
      "Filter": {
        "Prefix": "backups/"
      },
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

### Solution 2: Google Cloud Storage

```bash
#!/bin/bash
# gcp-backup.sh

BUCKET="minecraft-server-backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="minecraft-backup-$DATE.zip"

docker-compose down

# Create backup
zip -r "$BACKUP_FILE" data/

# Upload to GCS
gsutil cp "$BACKUP_FILE" "gs://$BUCKET/backups/"

# Cleanup
rm "$BACKUP_FILE"

docker-compose up -d

# Set lifecycle (auto-delete after 90 days)
gsutil lifecycle set lifecycle.json "gs://$BUCKET"
```

### Solution 3: Dropbox/OneDrive Sync

```bash
#!/bin/bash
# cloud-sync-backup.sh

# Using rclone (supports Dropbox, OneDrive, Google Drive, etc.)
# Install: https://rclone.org/install/

BACKUP_DIR="~/Dropbox/MinecraftBackups"
DATE=$(date +%Y%m%d)

docker-compose down

# Create dated backup folder
mkdir -p "$BACKUP_DIR/$DATE"

# Copy data
cp -r data "$BACKUP_DIR/$DATE/"

# Sync with rclone
rclone sync "$BACKUP_DIR" remote:MinecraftBackups

docker-compose up -d
```

### Solution 4: GitHub/GitLab (Config Only)

```bash
#!/bin/bash
# git-backup.sh

# Backup only config files to Git
# World data is too large for Git

CONFIG_DIR="config-backup"
mkdir -p "$CONFIG_DIR"

docker-compose down

# Copy config files
cp data/server.properties "$CONFIG_DIR/"
cp data/ops.json "$CONFIG_DIR/"
cp -r data/plugins "$CONFIG_DIR/plugins"

# Remove plugin JARs and runtime data
find "$CONFIG_DIR/plugins" -name "*.jar" -delete
find "$CONFIG_DIR/plugins" -name "logs" -type d -exec rm -rf {} + 2>/dev/null || true

# Git commit
cd "$CONFIG_DIR"
git add .
git commit -m "Config backup $(date +%Y%m%d-%H%M%S)"
git push

docker-compose up -d
```

---

## Automated Backups

### Using Cron (Linux/Mac)

```bash
# Edit crontab
crontab -e

# Every 6 hours
0 */6 * * * cd /path/to/dockercraft-smp && ./backup_data.sh

# Daily at 3 AM
0 3 * * * cd /path/to/dockercraft-smp && ./backup_data.sh && aws s3 cp data.zip s3://your-bucket/

# Weekly on Sundays
0 0 * * 0 cd /path/to/dockercraft-smp && ./scripts/weekly-backup.sh
```

### Using Systemd Timer (Linux)

```ini
# /etc/systemd/system/minecraft-backup.service
[Unit]
Description=Minecraft Server Backup
After=docker.service

[Service]
Type=oneshot
WorkingDirectory=/path/to/dockercraft-smp
ExecStart=/path/to/dockercraft-smp/backup_data.sh
User=minecraft
```

```ini
# /etc/systemd/system/minecraft-backup.timer
[Unit]
Description=Run Minecraft backup every 6 hours

[Timer]
OnCalendar=*:0/6
Persistent=true

[Install]
WantedBy=timers.target
```

Enable:

```bash
sudo systemctl daemon-reload
sudo systemctl enable minecraft-backup.timer
sudo systemctl start minecraft-backup.timer
```

### Using Windows Task Scheduler

```powershell
# Create scheduled task for backup
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\path\to\backup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
$settings = New-ScheduledTaskSettingsSet
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MinecraftBackup" -Settings $settings
```

### Docker-Based Backup (Sidecar Container)

```yaml
# docker-compose.backup.yml
version: '3.8'

services:
  minecraft:
    # ... main service

  backup:
    image: offen/docker-volume-backup:latest
    volumes:
      - ./data:/backup/data:ro
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - BACKUP_CRON_EXPRESSION=0 3 * * *
      - BACKUP_RETENTION_DAYS=30
      - BACKUP_FILENAME=minecraft-backup-%Y-%m-%dT%H-%M-%S.tar.gz
      - AWS_S3_BUCKET_NAME=your-bucket
      - AWS_ACCESS_KEY_ID=your-key
      - AWS_SECRET_ACCESS_KEY=your-secret
    restart: unless-stopped
```

---

## Restoring from Backup

### Full Restore

```bash
# 1. Stop server
docker-compose down

# 2. Backup current state (just in case)
mv data data-corrupted-$(date +%Y%m%d)

# 3. Extract backup
unzip backup-20240320-120000.zip

# 4. Restore data folder
# (backup contains 'data/' folder)

# 5. Start server
docker-compose up -d

# 6. Verify
docker-compose logs | grep -i "done"
```

### Selective Restore (Single World)

```bash
# Restore only the Nether from backup
docker-compose down

# Extract specific folder
unzip backup-20240320.zip "data/SMP_nether/*" -d temp/
mv temp/data/SMP_nether data/
rm -rf temp

docker-compose up -d
```

### Cloud Restore

```bash
# Download from S3
aws s3 cp s3://your-bucket/backups/backup-20240320.zip ./

# Or from GCS
gsutil cp gs://your-bucket/backups/backup-20240320.zip ./

# Then follow full restore steps
```

---

## Backup Verification

### Automated Verification Script

```bash
#!/bin/bash
# verify-backup.sh

BACKUP_FILE="$1"

# Check file exists
if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "ERROR: Backup file not found"
    exit 1
fi

# Check file size
SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat -c%s "$BACKUP_FILE")
if [[ $SIZE -lt 1000 ]]; then
    echo "ERROR: Backup file too small"
    exit 1
fi

# Test zip integrity
if ! unzip -t "$BACKUP_FILE" >/devdev/null 2>&1; then
    echo "ERROR: Backup file corrupted"
    exit 1
fi

# Check for essential files
if ! unzip -l "$BACKUP_FILE" | grep -q "SMP/level.dat"; then
    echo "ERROR: Missing essential world files"
    exit 1
fi

echo "✅ Backup verified successfully"
```

---

## Best Practices

### ✅ Do's

- **Backup before updates** - Plugin, server, or Docker image updates
- **Test restores** - Verify backups work before you need them
- **Multiple locations** - Local + cloud (3-2-1 rule)
- **Automate** - Set up scheduled backups
- **Monitor** - Check backup success/failure
- **Encrypt** - Encrypt cloud backups if sensitive

### ❌ Don'ts

- **Don't backup while running** - Risk of corruption
- **Don't keep only one backup** - Rotate multiple versions
- **Don't ignore errors** - Failed backups are worse than none
- **Don't backup JARs** - Redownloadable, save space
- **Don't forget plugins** - Config is as important as world

### Backup Schedule Recommendations

| Server Type | Frequency | Retention |
|-------------|-----------|-----------|
| **Development** | Before major changes | Last 5 versions |
| **Small Community** | Daily | 7 days local, 30 days cloud |
| **Large Public** | Every 6 hours | 30 days local, 1 year cloud |
| **Hardcore Server** | Every hour | 90 days |

### Storage Size Estimates

| World Size | Backup Size (zipped) |
|------------|---------------------|
| 100 MB | 20-30 MB |
| 1 GB | 200-400 MB |
| 10 GB | 2-4 GB |
| 50 GB | 10-20 GB |

---

## Troubleshooting

### "Permission denied" when restoring

```bash
# Fix ownership
sudo chown -R $USER:$USER data/
# Or
docker-compose exec minecraft chown -R 1000:1000 /app/world
```

### "Corrupted world" after restore

```bash
# Check backup integrity
unzip -t backup.zip

# Try extracting with different tool
tar -xzf backup.tar.gz
```

### Backup too large

```bash
# Exclude large files
zip -r backup.zip data/ -x "*.jar" -x "*/logs/*" -x "*/cache/*"

# Use 7zip for better compression
7z a backup.7z data/
```

### Backup script fails

```bash
# Check disk space
df -h

# Check permissions
ls -la data/

# Run with debug
bash -x backup_data.sh
```

---

## Next Steps

- [☁️ Cloud Deployment](CLOUD_DEPLOYMENT.md)
- [🌍 World Management](WORLD_MANAGEMENT.md)
- [⚙️ Server Configuration](SERVER_PROPERTIES.md)
- [🔌 Plugin Guide](PLUGIN_GUIDE.md)
