# ☁️ Cloud Deployment Guide

> Deploy your DockerCraft SMP server on AWS, Google Cloud, or Azure with proper firewall rules and custom ports.

---

## 📋 Table of Contents

- [AWS Deployment](#aws-deployment)
- [Google Cloud Deployment](#google-cloud-deployment)
- [Azure Deployment](#azure-deployment)
- [Custom Port Configuration](#custom-port-configuration)
- [Domain Setup](#domain-setup)

---

## AWS Deployment

### Step 1: Create EC2 Instance

1. **Login to AWS Console** → Navigate to EC2
2. **Launch Instance**
   - **Name**: `minecraft-server`
   - **AMI**: Ubuntu Server 22.04 LTS (Free Tier eligible)
   - **Instance Type**: `t3.medium` (2 vCPU, 4GB RAM) minimum for 10-20 players
   - For larger servers: `t3.large` (2 vCPU, 8GB RAM)

3. **Key Pair**: Create or select existing key pair

4. **Network Settings**:
   - VPC: Default
   - Auto-assign public IP: Enable
   - **Firewall (Security Group)**: Create security group

### Step 2: Configure Security Group (Network Tags)

| Type | Protocol | Port Range | Source | Description |
|------|----------|------------|--------|-------------|
| SSH | TCP | 22 | Your IP | Admin access |
| Custom TCP | TCP | 25565 | 0.0.0.0/0 | Minecraft server |
| Custom TCP | TCP | 25575 | Your IP | RCON (optional) |

> ⚠️ **Security**: Replace `0.0.0.0/0` with your specific IP (`x.x.x.x/32`) for RCON access.

### Step 3: Launch and Connect

```bash
# SSH into your instance
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo apt install docker-compose -y
```

### Step 4: Deploy Minecraft Server

```bash
# Clone repository
git clone https://github.com/yourusername/dockercraft-smp.git
cd dockercraft-smp

# Start server
docker-compose up -d

# Check logs
docker-compose logs -f
```

### Step 5: Connect

```
Server Address: YOUR_EC2_PUBLIC_IP:25565
```

### AWS Cost Optimization

```bash
# Use Spot Instances for 70% savings
# Set up auto-shutdown script for development

# Create shutdown script
cat > /home/ubuntu/auto-shutdown.sh << 'EOF'
#!/bin/bash
# Shutdown if no players for 30 minutes
while true; do
  PLAYERS=$(docker-compose logs --tail=100 | grep -c "joined the game" || true)
  if [ "$PLAYERS" -eq 0 ]; then
    sleep 1800  # 30 minutes
    # Add shutdown logic here if needed
  fi
  sleep 60
done
EOF
```

---

## Google Cloud Deployment

### Step 1: Create VM Instance

1. **Navigate to Compute Engine** → VM instances
2. **Create Instance**:
   - **Name**: `minecraft-server`
   - **Region**: Choose closest to your players
   - **Machine Type**: `e2-medium` (2 vCPU, 4GB) or `e2-standard-2` (2 vCPU, 8GB)
   - **Boot Disk**: Ubuntu 22.04 LTS, 20GB SSD

### Step 2: Configure Firewall Rules (Network Tags)

1. **VPC Network** → **Firewall**
2. **Create Firewall Rule**:

```yaml
Name: allow-minecraft
Target tags: minecraft-server
Source IP ranges: 0.0.0.0/0
Protocols and ports: tcp:25565
```

3. **Create RCON Rule** (Optional):
```yaml
Name: allow-minecraft-rcon
Target tags: minecraft-server-rcon
Source IP ranges: YOUR_IP/32
Protocols and ports: tcp:25575
```

### Step 3: Assign Network Tags

1. Go to your VM instance → **Edit**
2. Under **Network Tags**, add:
   - `minecraft-server`
   - `minecraft-server-rcon` (if using RCON)
3. **Save**

### Step 4: Deploy

```bash
# SSH via browser or gcloud
gcloud compute ssh minecraft-server

# Install Docker and Compose (same as AWS)
# ...

# Clone and run
git clone https://github.com/yourusername/dockercraft-smp.git
cd dockercraft-smp
docker-compose up -d
```

### Step 5: Static IP (Recommended)

```bash
# Reserve static external IP
gcloud compute addresses create minecraft-ip --region=YOUR_REGION

# Assign to VM
gcloud compute instances delete-access-config minecraft-server --access-config-name="External NAT"
gcloud compute instances add-access-config minecraft-server --access-config-name="External NAT" --address=YOUR_RESERVED_IP
```

---

## Azure Deployment

### Step 1: Create Virtual Machine

1. **Azure Portal** → Virtual Machines → Create
2. **Basics**:
   - **Subscription**: Your subscription
   - **Resource Group**: Create new `minecraft-rg`
   - **VM Name**: `minecraft-server`
   - **Region**: Closest to players
   - **Image**: Ubuntu Server 22.04 LTS
   - **Size**: `Standard_B2s` (2 vCPU, 4GB) or `Standard_B2ms` (2 vCPU, 8GB)

3. **Administrator Account**: SSH public key

4. **Inbound Port Rules**:
   - Allow selected ports
   - SSH (22)
   - **Add Port**: 25565 (Minecraft)

### Step 2: Network Security Group

1. Go to your VM → **Networking**
2. **Add Inbound Port Rule**:

```yaml
Source: Any
Source port ranges: *
Destination: Any
Service: Custom
Destination port ranges: 25565
Protocol: TCP
Action: Allow
Priority: 100
Name: AllowMinecraft
```

### Step 3: Deploy

```bash
# Connect
ssh -i ~/.ssh/your_key azureuser@YOUR_VM_IP

# Install Docker
sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Run server
git clone https://github.com/yourusername/dockercraft-smp.git
cd dockercraft-smp
sudo docker-compose up -d
```

---

## Custom Port Configuration

### Why Use a Custom Port?

- **Avoid conflicts** with other services
- **Security through obscurity** (not recommended alone)
- **Multiple servers** on one host

### Docker Compose Configuration

```yaml
services:
  minecraft:
    build: .
    ports:
      - "25566:25565"  # Host:Container - Custom port 25566
    environment:
      - JVM_INITIAL_RAM_PERCENT=60.0
      - JVM_MAX_RAM_PERCENT=85.0
    volumes:
      - ./data/SMP:/app/world
      - ./data/SMP_nether:/app/world_nether
      - ./data/SMP_the_end:/app/world_the_end
      - ./data/server.properties:/app/server.properties
      - ./data/plugins:/app/plugins
    restart: unless-stopped
```

### Update server.properties

```bash
# In data/server.properties
server-port=25565        # Keep container port same
query.port=25565         # Keep container port same

# Don't change these - the container internally uses 25565
# Only change the HOST port in docker-compose.yml
```

### Update Cloud Firewall

| Provider | Action |
|----------|--------|
| **AWS** | Update Security Group: Custom TCP 25566 |
| **GCP** | Update Firewall Rule: tcp:25566 |
| **Azure** | Update NSG: Destination port 25566 |

### Connect with Custom Port

```
Server Address: YOUR_IP:25566
```

---

## Domain Setup

### Using a Subdomain

1. **Create A Record**:
```
Type: A
Name: mc (or minecraft)
Value: YOUR_SERVER_IP
TTL: 300
```

2. **Players connect to**: `mc.yourdomain.com`

### SRV Record for Port Redirection

If using a custom port, add SRV record:

```
Type: SRV
Name: _minecraft._tcp.mc
Priority: 0
Weight: 0
Port: 25566
Target: mc.yourdomain.com
TTL: 300
```

Now players can use: `mc.yourdomain.com` (no port needed!)

---

## Performance Tuning

### AWS

```bash
# Use gp3 SSD for better I/O
# Enable EBS optimization

# Instance sizing guide:
# 1-5 players:   t3.small (2GB RAM)
# 5-15 players:  t3.medium (4GB RAM)
# 15-30 players: t3.large (8GB RAM)
# 30+ players:   t3.xlarge (16GB RAM)
```

### GCP

```bash
# Use SSD persistent disks
# Enable automatic restart

# Instance sizing:
# 1-5 players:   e2-small (2GB RAM)
# 5-15 players:  e2-medium (4GB RAM)
# 15-30 players: e2-standard-2 (8GB RAM)
```

### Azure

```bash
# Use Premium SSD
# Enable accelerated networking

# Instance sizing:
# 1-5 players:   Standard_B1ms (2GB RAM)
# 5-15 players:  Standard_B2s (4GB RAM)
# 15-30 players: Standard_B2ms (8GB RAM)
```

---

## Troubleshooting

### Connection Refused

```bash
# Check if container is running
docker ps

# Check logs
docker-compose logs

# Verify firewall rules
# AWS: Check Security Group
# GCP: Check Firewall Rules
# Azure: Check NSG
```

### High Latency

```bash
# Choose region closer to players
# Check network latency
ping YOUR_SERVER_IP

# Use CDN for resource packs if applicable
```

### Out of Memory

```bash
# Upgrade instance size
# Or adjust JVM percentages in docker-compose.yml
environment:
  - JVM_INITIAL_RAM_PERCENT=50.0
  - JVM_MAX_RAM_PERCENT=75.0
```

---

## Next Steps

- [🔌 Install Plugins](PLUGIN_GUIDE.md)
- [💾 Setup Backups](BACKUP_GUIDE.md)
- [🌍 Import Existing World](WORLD_MANAGEMENT.md)
