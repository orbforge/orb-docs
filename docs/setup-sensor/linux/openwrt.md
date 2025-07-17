---
title: Installing Orb on OpenWrt
shortTitle: OpenWrt
metaDescription: Install the Orb sensor on your OpenWrt device using a simple command.
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/openwrt.png
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Installing Orb on OpenWrt

## Introduction

[OpenWrt](https://openwrt.org/) is a popular open-source Linux operating system for embedded devices like routers. If you have a device running OpenWrt that is already configured and connected to your network, you can easily install the Orb sensor on it to monitor your network's performance.

This guide assumes your OpenWrt device is already set up, connected to your network, and has internet access. We will connect to the device using SSH and run a simple command to install Orb.

## Prerequisites

Before you begin, make sure you have:

- An OpenWrt device (router, access point, etc.) already configured and connected to your network with internet access.
- SSH access enabled on your OpenWrt device. (This is often enabled by default but may need configuration under System > Administration > SSH Access in the LuCI web interface).
- The IP address of your OpenWrt device. You can usually find this in your main router's DHCP client list or by logging into the OpenWrt LuCI web interface. Alternatively, you can use the device's hostname if avahi-daemon is installed on the OpenWrt device.
- The root password for your OpenWrt device.
- A computer on the same network as the OpenWrt device.
- Orb requires approximately 5MB of storage space to install the sensor. In addition, Orb needs about 35MB of additional space to store your data locally. By default, this guide will set up Orb to write data to `/root/.config/orb`. Should you wish Orb to write to another location, for example, an attached USB thumb drive, modify the symlink for `/root/.config/orb` to point to a different location (e.g. `ln -s /mylocation/orb /root/.config/orb`) after setup and restart Orb.

## Step 1: Connect to your OpenWrt device via SSH

1. Open a terminal or command prompt on your computer.
    - **macOS/Linux:** Use the Terminal application.
    - **Windows:** Use PowerShell or Command Prompt.
2. Connect to your OpenWrt device using the following command, replacing `<your-OpenWrt-ip-address>` with the actual IP address:

    ```bash
    ssh root@<your-OpenWrt-ip-address>
    ```

3. If prompted about the authenticity of the host, type `yes` and press Enter.
4. Enter the root password for your OpenWrt device when prompted. You should now have a command prompt logged into your OpenWrt device.

## Step 2: Install Orb

1. At the OpenWrt command prompt, run the following command exactly as shown:

    ```bash
    wget -qO- https://pkgs.orb.net/install.sh | sh
    ```

2. This command downloads the Orb setup script and executes it. The script will:
    - Detect the device's architecture.
    - Add the Orb package repository.
    - Install the Orb package (`orb`) and its dependencies.
    - Start the Orb Sensor service.
    - Enable auto-updates to keep Orb up-to-date.
3. Wait for the script to complete. You should see output indicating the progress of the installation.

## Step 3: Link your new Orb Sensor

1. Once the installation script finishes, the Orb Sensor should be running on your OpenWrt device.
2. Open the Orb app on your phone or personal computer.
3. Your new Orb Sensor should be automatically detected on your network and appear in the app, ready to be linked to your account. Follow the prompts in the app to link it.

Congratulations! Your OpenWrt device is now running as an Orb Sensor, monitoring your network.

## Troubleshooting

- **Installation Fails:**
  - Ensure your OpenWrt device has a working internet connection. Try pinging an external address like `ping google.com` from the SSH session.
  - Check if `wget` is installed. If not, run `opkg update && opkg install wget`.
  - Look for errors in the installation script output.
- **Orb Not Detected:**
  - Verify the Orb service is running on the OpenWrt device: `ps | grep orb` or `/etc/init.d/orb status`.
  - Check the Orb logs for errors: `logread | grep orb`.
  - Ensure your phone/computer running the Orb app is on the same network as the OpenWrt device.
  - Check firewall settings on the OpenWrt device (System > Firewall in LuCI) to ensure they aren't blocking discovery (mDNS/Bonjour, UDP port 5353). The default OpenWrt firewall settings usually allow this on the LAN side.
- **General OpenWrt Issues:** Refer to the official [OpenWrt Documentation](https://openwrt.org/docs/start).

## Manual Installation

These instructions provide the manual steps for installing Orb on OpenWrt.

Add the Orb package feed

```bash
ARCHITECTURE=$(opkg info busybox | awk '$1 == "Architecture:" {print $2; exit}')
echo "src/gz orb_packages https://pkgs.orb.net/stable/openwrt/$ARCHITECTURE" | tee -a /etc/opkg/customfeeds.conf
```

Add the Orb public key

```bash
curl https://pkgs.orb.net/stable/openwrt/key.pub | tee /etc/opkg/keys/744a82bfef3c5690
```

Install Orb

```bash
opkg update
opkg install orb
```

Install Orb update service

```bash
/usr/bin/orb-update install
```
