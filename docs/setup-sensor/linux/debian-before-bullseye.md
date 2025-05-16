---
title: Install Orb on Debian before Bullseye (11)
shortTitle: Debian < 11
metaDescription: Install the Orb sensor on Debian versions prior to Bullseye (11)
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Debian before Bullseye (11)

These instructions are for installing Orb on Debian versions prior to 11 (Bullseye).

Add Orb Forge's GPG key

```bash
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.asc | sudo apt-key add -
```

Add the orb repository

```bash
curl -fsSL https://pkgs.orb.net/stable/debian/debian.list | sudo tee /etc/apt/sources.list.d/orb.list
```

Install Orb

```bash
sudo apt-get update && sudo apt-get install orb
```

Enable auto-update

```bash
sudo systemctl enable --now orb-update.timer
```
