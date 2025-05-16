---
title: Install Orb on Ubuntu before 20.04
shortTitle: Ubuntu < 20.04
metaDescription: Install the Orb sensor on Ubuntu versions prior to 20.04
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Ubuntu before 20.04

These instructions are for installing Orb on Ubuntu versions prior to 20.04 (Focal Fossa).

Add Orb Forge's GPG key

```bash
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.asc | sudo apt-key add -
```

Add the orb repository

```bash
curl -fsSL https://pkgs.orb.net/stable/ubuntu/ubuntu.list | sudo tee /etc/apt/sources.list.d/orb.list
```

Install Orb

```bash
sudo apt-get update && sudo apt-get install orb
```

Enable auto-update

```bash
sudo systemctl enable --now orb-update.timer
```
