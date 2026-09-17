---
title: Pre-configuring an Orb at install time
shortTitle: Pre-configure at install
metaDescription: Link and configure an Orb sensor automatically on first start using a Deployment Token, with the exact config file to use for each platform.
section: Deploy & Configure
---

# Pre-configuring an Orb at install time

Pre-configuring means telling an Orb who it belongs to and how it should behave *before* it starts for the first time. When you do this, the Orb links itself to your Space on first start — nobody has to open an app, discover it on the LAN, or run a CLI command on the device.

This is the recommended way to deploy Orb sensors anywhere beyond a simple home network, and it is the only practical way to deploy many Orbs at once.

The mechanism is the same everywhere: Orb reads a [Deployment Token](/docs/deploy-and-configure/deployment-tokens) (and any other [configuration](/docs/deploy-and-configure/configuration)) from its environment at startup. What differs by platform is *where* you put that environment variable so the Orb service actually sees it — a service manager does not inherit your shell environment, so setting the variable in your terminal is not enough. This page covers the correct location for each platform.

:::tip
If you are setting up a single Orb on your own home network, you may not need any of this — see [Linking an Orb to your account](/docs/orb-app/linking-orb-to-account) for the simpler app-based options.
:::

## What you get

- **Automatic linking.** The Orb appears in your Space the first time it starts, already named and grouped by whatever Tags the token carries.
- **Consistent configuration.** The Configuration attached to the token is applied on link, so every Orb deployed with that token behaves identically.
- **Ongoing management.** Because the Orb is associated with the token's Configuration, you can change settings later from [Orchestration](https://cloud.orb.net/orchestration) and apply them to every Orb linked with that token. See [Remote Configuration](/docs/deploy-and-configure/configuration#remote-configuration).
- **No physical or network access required.** Useful for sensors shipped to remote sites, deployed by a field tech, or provisioned by an image or MDM.

## Step 1: Create a Deployment Token

1. Log in to Orb Cloud and open the [Orchestration](https://cloud.orb.net/orchestration) section.
2. Every Space has a "Default Token" you can use immediately. To create a separate token — for a site, a customer, or a group of Orbs that need different settings — click "+ Create new configuration", name it, and click "Create".
3. Copy the value in the "Token" column. It looks like `orb-dt1-yourdeploymenttoken678`.

Use different tokens for sets of Orbs that need different Tags or Configurations. See [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens) for full details on generating and managing tokens.

:::info
Every Space includes the Default Token. Generating *additional* tokens requires the Pro plan or a service contract.
:::

## Step 2: Choose how to deliver the token

There are three delivery mechanisms. Most platforms support the first; the table in [Step 3](#step-3-set-the-token-on-your-platform) tells you which to use.

| Mechanism | How it works | Best for |
| --------- | ------------ | -------- |
| **Environment variable** | Set `ORB_DEPLOYMENT_TOKEN` where the Orb *service* will read it — usually a service-specific config file, not your shell | Linux, OpenWrt, containers, Windows, network appliances |
| **Token file** | Place a `deployment_token.txt` file containing only the token in Orb's config directory | Platforms with no service environment file (FreeBSD, Homebrew on macOS), or when you'd rather ship a file than edit a service |
| **MDM configuration profile** | Push the token as a managed app setting | macOS and Windows fleets under Intune, Jamf Pro, or Mosyle |

:::warning
An Orb can only belong to one Space. If the Orb was already linked somewhere else, pre-configuring a token will not move it — unlink it first. See [Unlinking a sensor](/docs/orb-app/linking-orb-to-account#unlinking-a-sensor).
:::

## Step 3: Set the token on your platform

Each install guide has a pre-configuration section with the exact steps for that platform. Find yours below.

| Platform | Where the configuration goes | Guide |
| -------- | ---------------------------- | ----- |
| Ubuntu, Debian, RHEL, Fedora, CentOS, Arch | `/etc/default/orb` | [Linux](/docs/setup-sensor/linux#pre-configure-orb) |
| Raspberry Pi OS | `/etc/default/orb` | [Raspberry Pi](/docs/setup-sensor/raspberry-pi#step-4-pre-configure-orb-optional-) |
| Alpine and other OpenRC systems | `/etc/conf.d/orb` | [Alpine Linux](/docs/setup-sensor/linux/alpine#pre-configure-orb) |
| OpenWrt | `/etc/config/orb` | [OpenWrt](/docs/setup-sensor/linux/openwrt#step-2-pre-configure-orb-optional-) |
| GL.iNet Brume 2 | `/etc/config/orb` | [GL.iNet Brume 2](/docs/setup-sensor/gl-mt2500-standalone#step-1-create-your-openwrt-image) |
| Docker | `environment:` in `docker-compose.yml` | [Docker](/docs/setup-sensor/docker#pre-configure-orb-optional-) |
| Podman | `Environment=` in the quadlet | [Podman](/docs/setup-sensor/podman#pre-configure-orb-optional-) |
| Windows | Service registry key, installer flag, or `deployment_token.txt` | [Windows](/docs/setup-sensor/windows#using-deployment-tokens) |
| macOS | MDM profile for the app, `deployment_token.txt` for Homebrew | [macOS](/docs/setup-sensor/macos#linking-with-a-deployment-token) |
| FreeBSD | `deployment_token.txt` | [FreeBSD](/docs/setup-sensor/freebsd#using-deployment-tokens) |
| MikroTik RouterOS | App environment settings | [MikroTik](/docs/setup-sensor/mikrotik#step-4-install-and-configure-orb) |
| Cisco IOx | `package.yaml` | [Cisco IOx](/docs/setup-sensor/cisco/ioxclient#step-3-create-the-package-descriptor) |
| Synology NAS | Container environment variables | [Synology](/docs/setup-sensor/synology#pre-configure-orb-optional-) |
| QNAP NAS | Container environment variables | [QNAP](/docs/setup-sensor/qnap#pre-configure-orb-optional-) |
| Firewalla | `environment:` in `docker-compose.yml` | [Firewalla](/docs/setup-sensor/firewalla#step-3-install-orb-using-docker-compose) |
| Proxmox | `/etc/default/orb` | [Proxmox](/docs/setup-sensor/proxmox#pre-configure-orb-optional-) |
| UniFi routers | `/etc/default/orb` | [UniFi Routers](/docs/setup-sensor/unifi-routers#step-2-install-orb) |
| WLAN Pi | `/etc/default/orb` | [WLAN Pi](/docs/setup-sensor/wlan-pi#pre-configure-orb-optional-) |

Two rules apply everywhere, whatever the platform:

- **Set it before Orb first starts.** If Orb is already running, apply the change and restart the service — it links on the next start.
- **Your shell doesn't count.** Orb runs as a service, and service managers do not inherit your shell environment. Exporting the variable in your terminal or `.bashrc` will have no effect; it has to go in the file the service itself reads.

:::note
The [Home Assistant add-on](/docs/setup-sensor/home-assistant) does not currently expose a Deployment Token option. Link Home Assistant Orbs using [local network discovery](/docs/orb-app/linking-orb-to-account#link-from-the-orb-app-on-the-same-network) instead.
:::

## Step 4: Install and verify

1. Install Orb using the [guide for your platform](/docs/setup-sensor).
2. Open [Status](https://cloud.orb.net/status) in Orb Cloud. The new Orb should appear within a minute or two of first start, carrying the Tags from the token's Configuration.
3. Confirm the Orb is reporting data rather than sitting idle. An Orb linked in "View Only" mode will not collect data.

If the Orb does not appear, see [Troubleshooting](#troubleshooting) below.

## Setting other options at install time

Anything on the [Configuration](/docs/deploy-and-configure/configuration) page can be set the same way, in the same file, at the same time. The ones most worth setting before first start:

| Variable | When to set it |
| -------- | -------------- |
| `ORB_EPHEMERAL_MODE=1` | The device stores data on flash that is sensitive to repeated writes — SD cards, NAND on routers and single-board computers. Keeps measurement data in memory only. |
| `ORB_FIRSTHOP_DISABLED=1` | The device *is* the router. First-hop latency is not meaningful when there is no hop to measure. |
| `ORB_DEVICE_NAME_OVERRIDE=...` | You want the Orb to arrive in your Space already named, rather than renaming it by hand later. |
| `ORB_DATA_DIR=...` | Orb's default location is on constrained or volatile storage, and you want data on a different volume. |

Everything attached to the token's Configuration is also applied on link, and can be changed later from [Orchestration](https://cloud.orb.net/orchestration) without touching the device.

## Troubleshooting

**The Orb never appears in your Space.**

- Confirm the variable reached the service, not just your shell. On systemd: `sudo systemctl show orb --property=Environment`. In a container: `docker exec orb-sensor env | grep ORB_`.
- Check that you edited the file the service actually reads — a token in `~/.bashrc` or `/etc/environment` will not be seen by the Orb service on most platforms.
- Restart the service after any change. The token is only read at startup.

**The Orb starts but reports a linking error.**

- The Orb is most likely already linked to another Space. Unlink it first — see [Unlinking a sensor](/docs/orb-app/linking-orb-to-account#unlinking-a-sensor).
- Verify the token was copied whole, including the `orb-dt1-` prefix, with no trailing whitespace or newline.

**The Orb links but sends no data.** Check that "View Only" mode is disabled in the Orb app for that device.

## Related

- [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens) — creating and managing tokens
- [Configuration](/docs/deploy-and-configure/configuration) — every available environment variable and remote configuration
- [Linking an Orb to your account](/docs/orb-app/linking-orb-to-account) — all linking methods, including the app-based ones
- [MDM deployment](/docs/deploy-and-configure/mdm) — Intune, Jamf Pro, and Mosyle walkthroughs
- [Set up an Orb sensor](/docs/setup-sensor) — install guides for every platform
