---
title: Install Orb on UniFi Routers
shortTitle: UniFi Routers
metaDescription: Monitor network performance directly from your UniFi Dream Machine, Dream Router, or other UniFi routers.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Install Orb on UniFi Routers with UniFi OS >= 4.2.0

## Introduction

This guide walks you through installing the Orb sensor on UniFi Routers, including the Dream Machine and Dream Router. This will allow you to monitor your network connectivity right on your router, and access the information from anywhere within or outside the network using the Orb app.

:::note
These instructions have been tested on the Dream Machine Pro, but should work on other UniFi OS routers as well.**
:::

## Step 1: Enable SSH

In order to install Orb on your UniFi Router, you'll need enable SSH access. If you already have SSH access enabled, skip ahead to Step 2.

1. Browse to your UniFi Router control interface.
2. Go to Settings -> Control Plane -> Console.
3. Enable the SSH option and click 'Confirm'.
4. Optional: Generate a new password if you have lost it.

## Step 2: Install Orb

You can now login to your UniFi Router over ssh, so we can install the Orb sensor:

1. Open your terminal and type `ssh root@[router-ip]`. It will ask for the password.

2. Create Orb install script:

```
mkdir -p /mnt/data/on_boot.d/ && cat <<'EOF' > /mnt/data/on_boot.d/orb.sh && chmod +x /mnt/data/on_boot.d/orb.sh
#!/bin/bash

# install the Orb keyring
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.noarmor.gpg | sudo tee /usr/share/keyrings/orbforge-keyring.gpg >/dev/null

# add the Orb repository
curl -fsSL https://pkgs.orb.net/stable/ubuntu/ubuntu.orbforge-keyring.list | sudo tee /etc/apt/sources.list.d/orb.list

# disable mdns discovery, as it collides with Protect ports
cat <<'EOD' > /etc/default/orb
ORB_ZEROCONF_BROWSE=0
ORB_ZEROCONF_PUBLISH=0
ORB_FIRSTHOP_DISABLED=1
ORB_EPHEMERAL_MODE=1
EOD

# install Orb (no-op if already installed)
sudo apt-get update && sudo apt-get install orb

# enable auto-update
sudo systemctl enable --now orb-update.timer
EOF
```

3. Run the just created Orb installer:

```
/mnt/data/on_boot.d/orb.sh
```

4. Link the orb install to your account. Run this command and copy the link in your browser

```bash
sudo -u orb orb link
```

5. Done
