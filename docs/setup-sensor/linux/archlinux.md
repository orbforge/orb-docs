---
title: Install Orb on Arch Linux
shortTitle: Arch Linux
metaDescription: Set up continuous network monitoring on Arch Linux with the Orb sensor.
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Arch Linux

These instructions are for installing Orb on Arch Linux.

Add Orb Forge's GPG key

```bash
curl -q https://pkgs.orb.net/stable/rpm/key.gpg | pacman-key -a -
pacman-key --lsign-key AC24C3F82F82BADB6868AE99C1968008BFF84DF5
```

Add the Orb repository

To enable updates through pacman, add the following to your `/etc/pacman.conf`:

```ini
[orb]
Server = https://pkgs.orb.net/stable/arch/$arch
```

Update the package database

After adding the Orb repository, update your package database to ensure the changes take effect:

```bash
pacman -Sy
```

Install Orb

```bash
pacman -S orb
```

Enable Orb service

```bash
systemctl enable --now orb
```

Enable ephemeral mode (optional)

:::info
[Ephemeral mode](/docs/deploy-and-configure/configuration) prevents writes to disk by storing the Orb data in memory rather than in a local database. This is useful in applications where the file system is on a physical medium sensitive to continous writes (e.g. SD card, NAND flash).
:::

```bash
echo 'ORB_EPHEMERAL_MODE=1' | sudo tee -a /etc/default/orb >/dev/null
sudo systemctl restart orb
```