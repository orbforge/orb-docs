---
title: Install Orb on RPM-based Systems
shortTitle: RPM Systems
metaDescription: Install the Orb sensor on RPM-based Linux distributions (CentOS, Fedora, RHEL)
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
