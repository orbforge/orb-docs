---
title: Install Orb on UDM (Pro)
shortTitle: UDM (Pro)
metaDescription: Install the Orb sensor on your UDM (Pro)
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Install Orb on UDM (Pro) with UniFi OS >= 4.2.0

## Introduction

This guide walks you through installing the Orb sensor on your UDM (Pro). This will allow you to monitor your network connectivity right on your router, and access the information from anywhere within or outside the network.

## Step 1: Enable SSH

In order to install Orb on your UDM (Pro), we'll need enable SSH access. If you already have SSH access enabled, skip ahead to Step 2.

1. Browse to your UDM control interface
2. Go to Settings -> Control Plane -> Console.
3. Enable the SSH option and click 'Confirm'.
4. Optional: Generate a new password if you have lost it.

## Step 2: Install Orb

You can now login to your UDM device over ssh, so we can install the Orb sensor:

1. Open your terminal and type `ssh root@[udm-ip]`. It will ask for the password.

2. Add Orb Forge's GPG key

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.noarmor.gpg | sudo tee /usr/share/keyrings/orbforge-keyring.gpg >/dev/null
```

3. Add the Orb repository

```bash
curl -fsSL https://pkgs.orb.net/stable/ubuntu/ubuntu.orbforge-keyring.list | sudo tee /etc/apt/sources.list.d/orb.list
```

4. Install Orb

```bash
sudo apt-get update && sudo apt-get install orb
```

5. Enable auto-update

```bash
sudo systemctl enable --now orb-update.timer
```

6. Link the orb install to your account. Run this command and copy the link in your browser

```bash
sudo -u orb orb link
```

7. Done