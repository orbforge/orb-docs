---
title: Installing the Orb Sensor on a Raspberry Pi
shortTitle: Raspberry Pi
metaDescription: Set up a Raspberry Pi with Raspberry Pi OS to act as a standalone Orb sensor for monitoring your network.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/raspberry-pi.png
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Installing the Orb Sensor on a Raspberry Pi

## Introduction

This guide walks you through setting up a Raspberry Pi with Raspberry Pi OS to act as a standalone Orb sensor to monitor your network via a WiFi or Ethernet connection. If you already have a Raspberry Pi set up and running Raspberry Pi OS and wish to install Orb, simply see the [Linux install guide](/docs/setup-sensor/linux).

## Equipment Needed

- **Raspberry Pi** (Compatible with Raspberry Pi 3, 4, 5)
- **Personal Computer** (Windows, macOS, or Linux)
- **SD Card** (Minimum 8GB, recommended 16GB)
- **SD Card Reader**

## Step 1: Download and Install Raspberry Pi OS

1. Download **Raspberry Pi Imager** from [the official website](https://www.raspberrypi.com/software/).
2. Insert your SD card into your computer (directly or via USB adapter).

:::warning
This will erase all data on the SD card!
:::

3. Open Raspberry Pi Imager and click **"CHOOSE DEVICE"**.
4. Select your Raspberry Pi model (e.g., **"Raspberry Pi 5"**).
5. Click **"CHOOSE OS"** and select **"Raspberry Pi OS (Other)"**.
6. Select **Raspberry Pi OS Lite (64-bit)**
7. Click **"CHOOSE STORAGE"**, then select your SD card.
8. Click **"NEXT"**.

## Step 2: Customize the OS

When prompted with **"Use OS customization?"**, click **"EDIT SETTINGS"** and configure the following:

### General Settings

- **Enable "Set hostname"** → Change it to `raspberrypi-orb`.
- **Enable "Set username and password"** → Set the username to **`orb`** and choose a password.
- **WiFi Setup (Optional, for wireless connection)**:
  - Enable **"Configure wireless LAN"** and enter your WiFi **SSID** and **password**.
  - ⚠️ **Important!** Set the correct **two-letter country code** (e.g., `US` for the United States).
- **Enable "Set locale settings"** → Select your **time zone**.

### Services

- **Enable "Enable SSH"** → Select **"Use password authentication"**.

### Final Steps

1. Click **"Save"** → **"Yes"** → **"Yes"**.
2. Approve any system prompts to allow writing to your SD card.
3. Once completed, eject the SD card and insert it into the Raspberry Pi.

## Step 3: Power On and Connect to the Raspberry Pi

1. **For a wired connection**, plug an **Ethernet cable** into the Raspberry Pi and connect it to your router or switch. [See this guide on Orb placement for different use cases](/docs/setup-sensor).
2. **Power on** your Raspberry Pi.
3. Open a terminal on your computer:
   - **Windows**: Open **PowerShell**.
   - **macOS/Linux**: Open **Terminal**.
4. Connect to the Raspberry Pi using SSH: `ssh orb@raspberrypi-orb.local`
5. If prompted about authenticity, type yes and press Enter.
6. Enter your password and press Enter (the cursor will not move as you type).
7. You are now connected when you see: `orb@raspberrypi-orb:~$`

## Step 4: Pre-configure Orb (Optional)

The Orb service on Raspberry Pi OS reads its environment from `/etc/default/orb`. Creating this file before you install lets you set a [Deployment Token](/docs/deploy-and-configure/deployment-tokens) — so the sensor links itself to your Orb Space on first start, with no discovery or manual linking needed — along with any other settings you want applied from the beginning.

```bash
sudo tee /etc/default/orb >/dev/null <<'EOF'
ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
ORB_EPHEMERAL_MODE=1
EOF
```

Replace the token with the one from the [Orchestration](https://cloud.orb.net/orchestration) section of Orb Cloud, or leave that line out if you'd rather link from the Orb app in Step 6.

:::info
If you are using an SD card as instructed in this guide (rather than using an M.2 hat), it is recommended you run your Orb in [ephemeral mode](/docs/deploy-and-configure/configuration) to preserve the life of your SD card and prevent your Orb sensor from failing. That's the `ORB_EPHEMERAL_MODE=1` line above.
:::

:::tip
`/etc/default/orb` is a systemd environment file — use plain `KEY=VALUE` lines, with no `export` and no quotes. The same file works on Ubuntu, Debian, RHEL, Fedora, CentOS, and Arch. See [Pre-configuring an Orb at install time](/docs/deploy-and-configure/preconfigure-at-install) for the equivalent on every other platform, and for the full list of options worth setting here.
:::

If Orb is already installed when you create or edit this file, apply it with `sudo systemctl restart orb`.

## Step 5: Install the Orb Service

```bash
curl -fsSL https://pkgs.orb.net/install.sh | sh
```

## Step 6: Link to your Orb account

If you set a Deployment Token in Step 4, your Orb has already linked itself — check the [Status](https://cloud.orb.net/status) page in Orb Cloud, or open the Orb app, and you're done.

Otherwise:

1. Once the installation script finishes, the Orb sensor should be running on your Raspberry Pi device.
2. Open the Orb app on your phone or personal computer, on the same network.
3. Your new Orb sensor should be automatically detected on your network and appear in the app, ready to be linked to your account. Follow the prompts in the app to link it.

For other linking options, see [Linking an Orb to your account](/docs/orb-app/linking-orb-to-account).

Congratulations! Your Raspberry Pi is now running as an Orb sensor, monitoring your network.
