---
title: Install Orb on Debian Bullseye (11) and up
shortTitle: Debian 11+
metaDescription: Install the Orb sensor on Debian Bullseye (11) and newer releases
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Debian Bullseye (11) and up

These instructions are for installing Orb on Debian version 11 (Bullseye) and newer releases.

Add Orb Forge's GPG key

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.noarmor.gpg | sudo tee /usr/share/keyrings/orbforge-keyring.gpg >/dev/null
```

Add the orb repository

```bash
curl -fsSL https://pkgs.orb.net/stable/debian/debian.orbforge-keyring.list | sudo tee /etc/apt/sources.list.d/orb.list
```

Install Orb

```bash
sudo apt-get update && sudo apt-get install orb
```

Enable auto-update

```bash
sudo systemctl enable --now orb-update.timer
```
