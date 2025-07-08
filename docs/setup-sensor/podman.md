---
title: Installing Orb using Podman Quadlet
shortTitle: Podman Quadlet
metaDescription: Run the Orb sensor as a Podman container managed by a systemd quadlet on any compatible system.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Installing Orb using Podman Quadlet

## Introduction

[Podman](https://podman.io/) is a daemonless container engine that runs containers in isolated environments. This guide shows you how to run the Orb sensor as a Podman container managed by a systemd quadlet, a declarative way to define and manage containers as system services. This method is ideal for Linux systems where systemd is available, such as servers, firewalls, routers, or personal computers with Podman installed.

This guide assumes you have Podman already installed and running on your host system. All commands assume being ran as the root user.

## Prerequisites

Before you begin, make sure you have:

- A Linux host machine with Podman installed (version 4.0 or later for quadlet support). See the official [Podman installation guides](https://podman.io/getting-started/installation).
  - Install on Fedora: `dnf install podman`
  - Install on Ubuntu: `apt-get install podman`
- Systemd installed and running (standard on most Linux distributions).
- Basic familiarity with using the command line or terminal on your host system.
- Your host machine must be connected to the network you wish to monitor.
- Rootful Podman, as the Orb sensor requires `CAP_NET_RAW` for network monitoring.

Verify Podman installation:

```bash
podman --version
```

## Quick install

If you'd like to run Orb with auto-updates and don't want to get into the details, run these commands:

```bash
mkdir -p /etc/containers/systemd
curl -fsSL https://orb.net/docs/scripts/podman/orb-sensor.container -o /etc/containers/systemd/orb-sensor.container
systemctl daemon-reload
systemctl enable --now podman-auto-update.timer
systemctl start orb-sensor
podman exec -it orb-sensor /app/orb link
```

The last command generates a link to register the Orb sensor with your account. Copy and paste the link into your browser to complete registration.

Otherwise, read on!

## Step 1: Prepare the Quadlet File

Quadlets are systemd unit files with a `.container` extension that define container configurations. We'll create a quadlet for the Orb sensor.

1. Create a directory for quadlet files if it doesn't exist:
   ```bash
   mkdir -p /etc/containers/systemd
   ```

2. Create a file named `orb-sensor.container` in `/etc/containers/systemd/` with the following content:

   ```ini
   [Unit]
   After=network-online.target
   Wants=network-online.target

   [Container]
   AutoUpdate=registry
   Image=docker.io/orbforge/orb:latest
   ContainerName=orb-sensor
   Network=host
   AddCapability=CAP_NET_RAW
   Volume=orb-data:/root/.config/orb:z

   [Service]
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

   **Explanation:**

   - `Image: docker.io/orbforge/orb:latest`: Uses the official Orb container image.
   - `Network=host`: **Crucial** for Orb to monitor network traffic directly from the host's network interfaces.
   - `Volume=orb-data:/root/.config/orb:z`: Stores Orb's configuration persistently in a Podman named volume (`orb-data`), automatically created by the quadlet.
   - `AddCapability=CAP_NET_RAW`: Grants permission to capture raw network packets.
   - `AutoUpdate=registry`: Enables automatic image updates when new versions are released.
   - `Restart=always`: Ensures the container restarts if it stops or on system reboot.

## Step 2: Start the Orb Container

1. Reload systemd to recognize the quadlet, enable auto updates, and start the Orb sensor service:

   ```bash
   systemctl daemon-reload
   systemctl enable --now podman-auto-update.timer
   systemctl start orb-sensor
   ```

2. Check the status to ensure it's running:

   ```bash
   systemctl status orb-sensor
   ```

3. Verify the container is running:

   ```bash
   podman ps
   ```

   You should see the `orb-sensor` container with status `Up`. View logs with:

   ```bash
   podman logs orb-sensor
   ```

## Step 3: Link your new Orb sensor

1. Once the Orb container is running, it should start broadcasting its presence on your network.
2. Open the Orb app on your phone or personal computer (which must be on the same network).
3. Your new Podman-based Orb sensor should be automatically detected and appear in the app, ready to be linked to your account. Follow the prompts in the app to link it.
4. **Alternatively**, run the command `podman exec -it orb-sensor /app/orb link` from your podman host. This command generates a link to register the Orb sensor with your account. Copy and paste the link into your browser to complete registration.

Congratulations! Your Orb sensor is now running as a Podman Quadlet, monitoring your network.

## Troubleshooting

- **Orb Not Detected:**
  - Ensure the container is running (`podman ps`).
  - Verify `Network=host` is set in the quadlet file. Without host networking, Orb cannot see network traffic or broadcast correctly.
  - Check container logs (`podman logs orb-sensor`) or systemd logs (`journalctl -u orb-sensor`) for errors.
  - Ensure your host machine's firewall is not blocking mDNS/Bonjour traffic (UDP port 5353).
  - Make sure the device running the Orb app is on the _exact same_ network/subnet as the Podman host.
- **Permission Errors:**
  - Ensure you're using rootful Podman (`podman`). Rootless Podman may not support `CAP_NET_RAW` or host networking.
  - Verify the `orb-data` volume exists (`podman volume ls`) and is accessible.
- **Container Fails to Start:**
  - Check systemd logs: `journalctl -u orb-sensor`.
  - Ensure the quadlet file is correctly formatted and located in `/etc/containers/systemd/`.
- **Registration Link Issues:**
  - Ensure the `podman exec -it orb-sensor /app/orb link` command runs successfully and outputs a valid URL.
  - Check container logs (`podman logs orb-sensor`) for errors related to the link command.
- **Stopping Orb Temporarily:**
  - Run `systemctl stop orb-sensor` to stop the service.
- **Deleting Orb:**
  - Run `rm /etc/containers/systemd/orb-sensor.container` to delete the orb service and prevent it from starting at boot time
- **Updating Orb Manually:**
  - Run `systemctl restart orb-sensor` to pull the latest image (if `AutoUpdate=registry` is set).
  - Alternatively, manually pull the image with `podman pull docker.io/orbforge/orb:latest` and restart the service.
