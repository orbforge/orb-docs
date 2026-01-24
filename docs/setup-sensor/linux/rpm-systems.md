---
title: Install Orb on RPM-based Systems
shortTitle: RPM Systems
metaDescription: Set up the Orb sensor on CentOS, Fedora, Red Hat Enterprise Linux, and other RPM-based systems.
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on RPM-based Systems (CentOS, Fedora, RHEL)

These instructions are for installing Orb on RPM-based Linux distributions like CentOS, Fedora, and Red Hat Enterprise Linux (RHEL).

```bash
sudo dnf config-manager addrepo --from-repofile=https://pkgs.orb.net/stable/rpm/orb.repo
```

Install Orb

```bash
sudo dnf install orb
```

Start Orb

```bash
sudo systemctl enable --now orb
```

Enable auto-updates

```bash
sudo systemctl enable --now orb-update.timer
```

Enable ephemeral mode (optional)

:::info
[Ephemeral mode](/docs/deploy-and-configure/configuration) prevents writes to disk by storing the Orb data in memory rather than in a local database. This is useful in applications where the file system is on a physical medium sensitive to continous writes (e.g. SD card, NAND flash).
:::

```bash
echo 'ORB_EPHEMERAL_MODE=1' | sudo tee -a /etc/default/orb >/dev/null
sudo systemctl restart orb
```