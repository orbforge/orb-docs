---
title: Install Orb on Alpine Linux
shortTitle: Alpine
metaDescription: Install the Orb sensor on Alpine Linux
section: setup-sensor
layout: guides
imageUrl: ../../../images/devices/linux.png
---

# Install Orb on Alpine Linux

These instructions are for installing Orb on Alpine Linux.

Add the Orb repository and key

```bash
echo https://pkgs.orb.net/stable/alpine | tee -a /etc/apk/repositories
wget -O /etc/apk/keys/packages@orb.net.rsa.pub https://pkgs.orb.net/stable/alpine/orb.pub
```

Update package list and install Orb

```bash
apk update
apk install orb
```

Install Orb update service

```bash
/usr/bin/orb-update install
```
