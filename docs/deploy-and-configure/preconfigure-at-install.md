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

All three are read at startup, so set them **before you first start Orb**. If Orb is already running, apply the change and restart the service — it will link on the next start.

:::warning
An Orb can only belong to one Space. If the Orb was already linked somewhere else, pre-configuring a token will not move it — unlink it first. See [Unlinking a sensor](/docs/orb-app/linking-orb-to-account#unlinking-a-sensor).
:::

## Step 3: Set the token on your platform

| Platform | Where the configuration goes |
| -------- | ---------------------------- |
| Ubuntu, Debian, Raspberry Pi OS, RHEL/Fedora/CentOS, Arch | [`/etc/default/orb`](#linux-with-systemd) |
| Alpine Linux and other OpenRC systems | [`/etc/conf.d/orb`](#alpine-linux-and-other-openrc-systems) |
| OpenWrt, GL.iNet | [`/etc/config/orb`](#openwrt) |
| Docker | [`environment:` in `docker-compose.yml`](#docker) |
| Podman | [`Environment=` in the quadlet](#podman) |
| Windows (service) | [Service registry key](#windows) or `deployment_token.txt` |
| Windows (app, at scale) | [Installer flag or Intune](#windows) |
| macOS (app) | [MDM configuration profile](#macos) |
| macOS (Homebrew CLI) | [`deployment_token.txt`](#macos) |
| FreeBSD | [`deployment_token.txt`](#freebsd) |
| MikroTik RouterOS | [App environment settings](#mikrotik-routeros) |
| Cisco IOx | [`package.yaml`](#cisco-iox) |
| Synology, QNAP, Firewalla, Proxmox | [Container environment variables](#nas-and-appliance-platforms) |

### Linux with systemd

This covers Ubuntu, Debian, Raspberry Pi OS, RHEL, Fedora, CentOS, Arch, and most other mainstream distributions installed via `https://pkgs.orb.net/install.sh`.

The `orb` systemd service reads `/etc/default/orb`. Create it before installing, or create it and restart the service afterwards:

```bash
sudo tee /etc/default/orb >/dev/null <<'EOF'
ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
EOF
```

If Orb is already installed, apply it with:

```bash
sudo systemctl restart orb
```

:::note
`/etc/default/orb` is a systemd environment file, not a shell script. Use plain `KEY=VALUE` lines — no `export`, no quotes, and no shell expansion (`$OTHER_VAR` will not be substituted).
:::

Related install guides: [Linux](/docs/setup-sensor/linux), [Raspberry Pi](/docs/setup-sensor/raspberry-pi), [UniFi Routers](/docs/setup-sensor/unifi-routers).

### Alpine Linux and other OpenRC systems

The OpenRC service reads `/etc/conf.d/orb`. Unlike systemd, OpenRC sources this file as a shell script, so the variables **must be exported** to reach the Orb process:

```bash
cat > /etc/conf.d/orb <<'EOF'
export ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
EOF
```

If Orb is already installed:

```bash
rc-service orb restart
```

Related install guide: [Alpine Linux](/docs/setup-sensor/linux/alpine).

### OpenWrt

OpenWrt uses a UCI config file at `/etc/config/orb`, with one `list env` entry per variable:

```bash
cat << EOF > /etc/config/orb
config orb 'orb'
    list env 'ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678'
    list env 'ORB_DATA_DIR=/root'
    list env 'ORB_EPHEMERAL_MODE=1'
    list env 'ORB_LOG_CONSOLE_FORMAT=syslog'
EOF
```

Create this file **before** running the install script — the Orb service starts as soon as the package is installed. If Orb is already running:

```bash
/etc/init.d/orb restart
```

Related install guides: [OpenWrt](/docs/setup-sensor/linux/openwrt#step-2-pre-configure-orb-recommended-), [GL.iNet Brume 2](/docs/setup-sensor/gl-mt2500-standalone).

### Docker

Add the variable to the `environment:` section of your `docker-compose.yml`:

```yaml
services:
  orb-docker:
    image: orbforge/orb:latest
    container_name: orb-sensor
    network_mode: host
    volumes:
      - orb-data:/root/.config/orb
    restart: always
    environment:
      - ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
```

Then `docker compose up -d`. If the container is already running, `docker compose up -d` recreates it with the new environment.

Related install guides: [Docker](/docs/setup-sensor/docker), [Docker Multi-WAN](/docs/setup-sensor/docker-multiple-interfaces).

### Podman

Add an `Environment=` line to the `[Container]` section of your quadlet at `/etc/containers/systemd/orb-sensor.container`:

```ini
[Container]
AutoUpdate=registry
Image=docker.io/orbforge/orb:latest
ContainerName=orb-sensor
Network=host
AddCapability=CAP_NET_RAW
Volume=orb-data:/root/.config/orb:z
Environment=ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
```

Then reload and restart:

```bash
systemctl daemon-reload
systemctl restart orb-sensor
```

Related install guide: [Podman Quadlet](/docs/setup-sensor/podman).

### Windows

**Running the sensor as a Windows service:** the service reads environment variables from its own registry key. Set them with PowerShell, then restart the service:

```powershell
New-ItemProperty `
  -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Orb" `
  -Name "Environment" `
  -PropertyType MultiString `
  -Value @("ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678")

Restart-Service -Name "Orb"
```

Alternatively, drop a token file into the Orb configuration directory:

```cmd
echo orb-dt1-yourdeploymenttoken678 > C:\ProgramData\Orb\deployment_token.txt
```

**Deploying the Windows app at scale:** pass the token to the installer directly, which is how the Intune guide provisions machines:

```
Orb-installer.exe /S /LAUNCH_AT_STARTUP=1 /START_IN_BACKGROUND=1 /ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678
```

Related guides: [Windows sensor](/docs/setup-sensor/windows#using-deployment-tokens), [Microsoft Intune](/docs/deploy-and-configure/mdm/intune).

### macOS

**The macOS app** runs in a restricted sandbox and has no access to your shell environment, so environment variables do not work. Deliver the token as a managed app setting through an MDM configuration profile — see the [Jamf Pro](/docs/deploy-and-configure/mdm/jamf-pro) or [Mosyle](/docs/deploy-and-configure/mdm/mosyle) guides. For a one-off machine, you can instead paste the token into the app directly (see [Using the apps](/docs/deploy-and-configure/deployment-tokens#using-the-apps)).

**The Homebrew CLI sensor** does read environment variables, but `brew services` generates its own launchd plist, so the reliable way to pre-configure it is the token file:

```bash
mkdir -p ~/.config/orb
echo "orb-dt1-yourdeploymenttoken678" > ~/.config/orb/deployment_token.txt
brew services restart orbforge/orb/orb
```

If you run the sensor in the foreground yourself, the environment variable works as expected:

```bash
ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678 orb sensor
```

Related install guide: [macOS sensor](/docs/setup-sensor/macos).

### FreeBSD

The FreeBSD rc.d service does not source an environment file, so use the token file in the config directory of the user the service runs as. With the rc.d script from the install guide, that user is `root`:

```bash
mkdir -p /root/.config/orb
echo "orb-dt1-yourdeploymenttoken678" > /root/.config/orb/deployment_token.txt
service orb restart
```

Related install guide: [FreeBSD](/docs/setup-sensor/freebsd#using-deployment-tokens).

### MikroTik RouterOS

Set the token under the app's **Environment** settings in WebFig before enabling the app, or from the terminal — note that values must be prefixed with the service name `orb:`:

```routeros
/app/set [find name=orb-sensor] network=lan use-https=no auto-update=yes environment="orb:ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678,orb:ORB_FIRSTHOP_DISABLED=1"
/app/enable [find name=orb-sensor]
```

Related install guide: [MikroTik](/docs/setup-sensor/mikrotik).

### Cisco IOx

The token is baked into the IOx package at build time, in the `env` section of `package.yaml`:

```yaml
    ORB_DEPLOYMENT_TOKEN: orb-dt1-yourdeploymenttoken678
```

Because the token travels with the package, every device you deploy that package to links itself automatically — and the configuration survives updates. Build one package per token if you need to separate deployments.

Related install guides: [Cisco IOx overview](/docs/setup-sensor/cisco), [Building the IOx package](/docs/setup-sensor/cisco/ioxclient#building-the-iox-package).

### NAS and appliance platforms

Synology (Container Manager), QNAP (Container Station), Firewalla, and Proxmox all run Orb as a container. Set `ORB_DEPLOYMENT_TOKEN` wherever that platform exposes container environment variables — the "Environment" tab of the container's settings, or the `environment:` section of the `docker-compose.yml` you deploy. See [Docker](#docker) above for the syntax.

:::note
The Home Assistant add-on does not currently expose a Deployment Token option. Link Home Assistant Orbs using [local network discovery](/docs/orb-app/linking-orb-to-account#link-from-the-orb-app-on-the-same-network) instead.
:::

Related install guides: [Synology](/docs/setup-sensor/synology), [QNAP](/docs/setup-sensor/qnap), [Firewalla](/docs/setup-sensor/firewalla), [Proxmox](/docs/setup-sensor/proxmox).

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
