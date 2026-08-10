---
title: Install Orb on Alpine Linux
shortTitle: Alpine
metaDescription: Set up continuous network monitoring on Alpine Linux with the Orb sensor.
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

Pre-configure Orb (recommended)

Alpine runs Orb under OpenRC, which reads `/etc/conf.d/orb`. Creating this file before installing lets you set a [Deployment Token](/docs/deploy-and-configure/deployment-tokens) so the sensor links itself to your Orb Space on first start.

```bash
cat > /etc/conf.d/orb <<'EOF'
export ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
EOF
```

:::warning
OpenRC sources this file as a shell script, so each variable must be `export`ed or the Orb process will not see it. This differs from `/etc/default/orb` on systemd distributions, which takes bare `KEY=VALUE` lines.
:::

Any other [configuration](/docs/deploy-and-configure/configuration) option can go in the same file — see [Pre-configuring an Orb at install time](/docs/deploy-and-configure/preconfigure-at-install). If Orb is already installed, apply changes with `rc-service orb restart`.

Update package list and install Orb

```bash
apk update
apk add orb
```

Install Orb update service

```bash
/usr/bin/orb-update install
```
