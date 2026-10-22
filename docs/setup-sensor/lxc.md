---
title: Install Orb in an LXC Container
shortTitle: LXC
metaDescription: Run the Orb sensor in a ready-made LXC container on routers, gateways, and Linux hosts.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/linux.png
subtitle: 'Difficulty: Advanced 🧑‍🔬'
---

# Install Orb in an LXC Container

## Introduction

Orb publishes ready-made [LXC](https://linuxcontainers.org/lxc/) container images for the Orb sensor. They are designed for routers, gateways, and other devices that run applications in LXC containers. They also work on any Linux host with LXC installed.

Each image is a minimal [Alpine Linux](https://alpinelinux.org/) system with the Orb sensor preinstalled. Orb updates itself automatically every day from Orb's Alpine package repository.

:::info
On Proxmox VE, Incus, or a host that runs Docker or Podman, you can also run Orb from its container image on Docker Hub, `orbforge/orb`. See [Docker](/docs/setup-sensor/docker.md) or [Podman](/docs/setup-sensor/podman.md).
:::

## Prerequisites

- A Linux device or host with LXC 2.1 or newer, and root access to it.
- At least 64 MB of free storage. The container uses about 35 MB, and updates need extra space temporarily.
- At least 128 MB of memory for the container.
- Internet access from the container to `pkgs.orb.net` and the Alpine package mirror `dl-cdn.alpinelinux.org`, for updates.
- The Orb app installed on your phone or computer (see [Install Orb](/docs/install-orb)), or a [deployment token](/docs/deploy-and-configure/deployment-tokens) to link the Orb automatically.

## Choose your image

Images are published at `https://pkgs.orb.net/stable/lxc/` for three architectures. Pick the one that matches your device:

| Device architecture (`uname -m`) | Image architecture | `lxc.arch` |
|---|---|---|
| `x86_64` | `amd64` | `amd64` |
| `aarch64` | `arm64` | `arm64` |
| `armv7l` | `armv7` | `armhf` |

Each architecture has two files:

| File | Contents |
|---|---|
| `orb-lxc-<arch>-rootfs.tar.gz` | The container's root filesystem |
| `orb-lxc-<arch>-meta.tar.gz` | Container settings for `lxc-create` |

These names always point at the latest release. Each file has a matching `.sha256` checksum, and versioned copies such as `orb-lxc-1.6.5-arm64-rootfs.tar.gz` are kept alongside them.

To set the architecture automatically, run:

```bash
case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  armv7*) ARCH=armv7 ;;
  *) echo "Unsupported architecture: $(uname -m)" ;;
esac
```

## Network setup

Attach the container directly to your LAN, the same way a physical device would be. It then gets its own address from your router, and the Orb app can discover it on your network.

To do this, connect the container to a bridge that contains your LAN interface (`lxc.net.0.link`). A NAT bridge such as `lxcbr0` also works, but the Orb app cannot discover the sensor automatically. To link it, use the `orb link` command or a deployment token instead.

By default, the container gets its address with DHCP. To use a static address, see [Configuration](#configuration).

## Install with lxc-create

Use these steps with LXC 3.0 or newer. The `xz` tool must also be installed on the host. For older LXC versions, or devices without `lxc-create`, see [Manual installation](#manual-installation).

1. Download the image:

    ```bash
    curl -fsSLO https://pkgs.orb.net/stable/lxc/orb-lxc-$ARCH-meta.tar.gz
    curl -fsSLO https://pkgs.orb.net/stable/lxc/orb-lxc-$ARCH-rootfs.tar.gz
    ```

2. Create the container:

    ```bash
    lxc-create -n orb -t local -- \
      --metadata orb-lxc-$ARCH-meta.tar.gz \
      --fstree orb-lxc-$ARCH-rootfs.tar.gz
    ```

    The container uses the network and ID mapping settings in your LXC default configuration (`/etc/lxc/default.conf`, or `~/.config/lxc/default.conf` for unprivileged users). We recommend unprivileged containers. When you create the container as root, add `lxc.idmap` entries to `/etc/lxc/default.conf` first.

3. Optional: to link the Orb automatically, add your deployment token. The default container path is `/var/lib/lxc`:

    ```bash
    echo 'export ORB_DEPLOYMENT_TOKEN=<your-deployment-token>' >> /var/lib/lxc/orb/rootfs/etc/conf.d/orb
    ```

4. Start the container:

    ```bash
    lxc-start -n orb
    ```

5. If you did not add a deployment token, [link your Orb](#link-your-orb).

## Manual installation

Use these steps on devices with LXC 2.1 or newer that don't have `lxc-create -t local`, or to manage the container's configuration yourself.

1. Extract the root filesystem. For an unprivileged container (recommended), extract it inside the container's ID range so that every file gets the right owner. This must match the `lxc.idmap` lines in the next step and an allocation for root in `/etc/subuid` and `/etc/subgid`, such as `root:100000:65536`:

    ```bash
    mkdir -p /var/lib/lxc/orb/rootfs
    chown 100000:100000 /var/lib/lxc/orb/rootfs
    lxc-usernsexec -m b:0:100000:65536 -- \
      tar -xpzf orb-lxc-$ARCH-rootfs.tar.gz --numeric-owner -C /var/lib/lxc/orb/rootfs
    ```

    For a privileged container, extract it directly and leave out the `lxc.idmap` lines:

    ```bash
    mkdir -p /var/lib/lxc/orb/rootfs
    tar -xpzf orb-lxc-$ARCH-rootfs.tar.gz --numeric-owner -C /var/lib/lxc/orb/rootfs
    ```

2. Create `/var/lib/lxc/orb/config`. Set `lxc.arch` from the [table above](#choose-your-image), and `lxc.net.0.link` to a bridge on your LAN:

    ```ini
    lxc.uts.name = orb
    lxc.arch = arm64
    lxc.rootfs.path = /var/lib/lxc/orb/rootfs

    # No login consoles. lxc.pty.max must stay above 0 or boot messages are lost.
    lxc.tty.max = 0
    lxc.pty.max = 4
    lxc.console.logfile = /var/lib/lxc/orb/console.log

    lxc.autodev = 1
    lxc.mount.auto = proc:mixed sys:mixed cgroup:mixed
    lxc.cap.drop = mac_admin mac_override sys_time sys_module sys_rawio

    # Unprivileged: container IDs 0-65535 map to host IDs 100000-165535.
    lxc.idmap = u 0 100000 65536
    lxc.idmap = g 0 100000 65536

    lxc.net.0.type = veth
    lxc.net.0.link = br-lan
    lxc.net.0.flags = up
    lxc.net.0.name = eth0

    lxc.start.auto = 1
    ```

3. Optional: add a deployment token, as in step 3 of [Install with lxc-create](#install-with-lxc-create).

4. Start the container with `lxc-start -n orb`.

## Link your Orb

If you did not use a deployment token, link the Orb to your account in one of two ways:

- **With the Orb app:** if the container is attached to your LAN, open the Orb app on a device on the same network. The new Orb appears automatically. Follow the prompts to link it.
- **From the command line:** run `orb link` as the container's `orb` user, then open the link it prints or scan the QR code:

    ```bash
    lxc-attach -n orb -- su orb -s /bin/sh -c 'orb link'
    ```

To add a deployment token after the container has started, add it to `/etc/conf.d/orb` and restart the sensor. The token is applied when the sensor starts, as long as the Orb is not already linked.

## Configuration

The sensor's settings are in `/etc/conf.d/orb` inside the container. Each setting must start with `export`. After editing the file, restart the sensor:

```bash
lxc-attach -n orb -- vi /etc/conf.d/orb
lxc-attach -n orb -- rc-service orb restart
```

You can use any Orb setting from the [configuration guide](/docs/deploy-and-configure/configuration). Some common ones:

| Setting | Purpose |
|---|---|
| `ORB_DEPLOYMENT_TOKEN` | Link to your Orb Space automatically. |
| `ORB_DEVICE_NAME_OVERRIDE` | The name shown in the Orb apps. Defaults to the container's hostname. |

### Measurement history

To protect the router's flash storage, the sensor keeps its measurement history in memory (`export ORB_EPHEMERAL_MODE=1` in `/etc/conf.d/orb`). Measurements are still sent to Orb Cloud. Only the history stored on the Orb itself is lost when it restarts. To store history on disk instead, remove that line and restart the sensor.

### First-hop measurement

The image assumes the container runs on your router. The router is then the first hop, so first-hop measurement is turned off with `export ORB_FIRSTHOP_DISABLED=1` in `/etc/conf.d/orb`.

If the container runs on another device, turn first-hop measurement on to measure the connection to your router. In `/etc/conf.d/orb`:

1. Remove the `export ORB_FIRSTHOP_DISABLED=1` line.
2. Uncomment `capabilities="^cap_net_raw"`. The sensor needs this permission to send the pings it uses to measure the first hop.

Then restart the sensor with `lxc-attach -n orb -- rc-service orb restart`.

### Static IP address

The container's network is configured in `/etc/network/interfaces`, as on any Alpine Linux system. To use a static address, replace the `eth0` section:

```
auto eth0
iface eth0 inet static
    address 192.168.1.50/24
    gateway 192.168.1.1
```

Then set your DNS servers in `/etc/resolv.conf`, such as `nameserver 192.168.1.1`, and restart the container.

:::warning
Orb's identity is stored in `/home/orb/.config/orb` inside the container. Keep it on persistent storage. If you delete or recreate the container, it registers as a new Orb and needs to be linked again.

Do not make an image from a container that has already started, and do not clone one. Every copy would share the same Orb identity.
:::

## Updates

Orb checks for a new version every day at 2:00 AM (container time) and installs it automatically. It is the same update service used by Orb's [Alpine package](/docs/setup-sensor/linux/alpine.md).

- **Update now:** `lxc-attach -n orb -- orb-update`
- **Turn off automatic updates:** `lxc-attach -n orb -- orb-update uninstall`
- **Turn them back on:** `lxc-attach -n orb -- orb-update install`
- **Check the version:** `lxc-attach -n orb -- orb version`

The automatic update only updates Orb. To also update the container's Alpine Linux packages, run `lxc-attach -n orb -- apk -U upgrade`.

## Troubleshooting

### Viewing the sensor's log

The sensor logs to the container's in-memory system log:

```bash
lxc-attach -n orb -- logread       # show the log
lxc-attach -n orb -- logread -f    # follow it
```

Boot messages, such as network and service startup, are written to `/var/lib/lxc/orb/console.log` on the host.

For more detail, add `export ORB_LOG_CONSOLE_LEVEL=debug` to `/etc/conf.d/orb` and restart the sensor.

### Checking that the sensor is running

```bash
lxc-attach -n orb -- rc-status
```

`orb` should be listed as `started`. If it isn't, run `lxc-attach -n orb -- rc-service orb start` and check the log.

### The container has no network connection

- Check that the container has an address: `lxc-attach -n orb -- ip addr`.
- If it has no address, check `lxc.net.0.link` in the container's config and that your network has a DHCP server, or set a [static address](#static-ip-address).
- Check DNS with `lxc-attach -n orb -- nslookup orb.net`.

### The Orb app does not find the Orb

The container is probably behind a NAT bridge. Attach it to your LAN as described in [Network setup](#network-setup), or [link it from the command line](#link-your-orb).

### The Orb appears as a new device after a restart

`/home/orb/.config/orb` inside the container was lost or replaced. Make sure the container's storage is persistent, and don't recreate the container.
