---
title: Install Orb on FreeBSD
shortTitle: FreeBSD
metaDescription: Set up continuous network monitoring on FreeBSD with the Orb sensor.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Install the Orb Sensor on FreeBSD

Orb supports FreeBSD 13, 14, and 15. These instructions install Orb with the `pkg` package manager; run the commands below as `root`.

## Add the Orb repository and key

Create the directories used by `pkg` and download the Orb repository configuration and public key:

```bash
mkdir -p /usr/local/etc/pkg/repos /usr/local/share/keys
fetch -o /usr/local/etc/pkg/repos/Orb.conf https://pkgs.orb.net/stable/freebsd/Orb.conf
fetch -o /usr/local/share/keys/orb-repo.pub https://pkgs.orb.net/stable/freebsd/repo.pub
```

## Install Orb

Force-refresh the package catalogue, then install Orb:

```bash
pkg update -f
pkg install orb
```

The package installs the Orb service script at `/usr/local/etc/rc.d/orb`.

## Enable and start Orb

Enable Orb at boot and start the service:

```bash
sysrc orb_enable=YES
service orb start
```

Confirm that Orb is running:

```bash
service orb status
```

## FreeBSD-specific Configuration

### Measure router responsiveness (optional)

By default, the Orb service runs as the unprivileged `orb` user. With these permissions, Orb cannot measure responsiveness to your router.

:::warning
Running Orb as `root` gives the service full system privileges. Only make this change if measuring router responsiveness is required and you accept the additional security risk.
:::

To run Orb as `root`, set the service user and restart Orb:

```bash
sysrc orb_user=root
service orb restart
```

### Environment variables (optional)

To configure the Orb service with [environment variables](/docs/deploy-and-configure/configuration), create `/usr/local/etc/orb.env`. Each variable must be written as a shell export. For example, to enable ephemeral mode:

```bash
export ORB_EPHEMERAL_MODE=1
```

:::info
[Ephemeral mode](/docs/deploy-and-configure/configuration) stores measurement data in memory instead of a local database. This prevents frequent disk writes, but the locally stored measurement data is lost whenever Orb stops or restarts.
:::

Restart Orb after creating or changing the environment file:

```bash
service orb restart
```

Your FreeBSD system is now running an Orb sensor. See [Linking an Orb to your account](/docs/orb-app/linking-orb-to-account.md) to connect it to your Orb account.
