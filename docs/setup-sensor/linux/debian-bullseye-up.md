---
title: Install Orb on Debian Bullseye (11) and Up
shortTitle: Debian 11+
metaDescription: Set up the Orb sensor on modern Debian systems (Bullseye, Bookworm, and newer).
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Debian Bullseye (11) and Up

These instructions are for installing Orb on Debian version 11 (Bullseye) and newer releases.

Add Orb Forge's GPG Key

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.noarmor.gpg | sudo tee /usr/share/keyrings/orbforge-keyring.gpg >/dev/null
```

Add the Orb Repository

```bash
curl -fsSL https://pkgs.orb.net/stable/debian/debian.orbforge-keyring.list | sudo tee /etc/apt/sources.list.d/orb.list
```

Install Orb

```bash
sudo apt-get update && sudo apt-get install orb
```

Enable Auto-Update

```bash
sudo systemctl enable --now orb-update.timer
```
