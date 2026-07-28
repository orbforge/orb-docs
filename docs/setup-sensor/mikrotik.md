---
title: Install Orb on MikroTik RouterOS
shortTitle: MikroTik
metaDescription: Monitor network performance directly from your MikroTik RouterOS device.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Advanced 🧑‍🚀'
---

# Install Orb on MikroTik RouterOS

## Introduction

This guide will walk you through the process of setting up the Orb sensor on your MikroTik RouterOS device. Installing the Orb sensor allows you to monitor the responsiveness and reliability of your network from anywhere in the world using your mobile device or computer.

With the Orb sensor running on your MikroTik device, you can:

- Monitor your internet experience from your MikroTik routers, switches, and access points to determine where a network issue exists.
- Track network reliability and responsiveness over time without impacting other services.
- Receive push notifications on your Android or iOS device when your MikroTik device experiences connectivity issues.

## Compatibility

Orb on MikroTik leverages the RouterOS Container package, which requires RouterOS v7.x and is supported on ARM, ARM64, and AMD64 architectures. We recommend devices with at least 128MB of built-in flash storage or expanded USB/SD-Card storage.

The following table shows MikroTik device compatibility:

| Device | Supported | Validated | Notes |
|--------|-----------|-----------|-------|
| RouterOS on AMD64 | ✓ | | |
| hEX refresh | ✓ | ✓ | ARMv5 (EN7562CT CPU) — Apps menu unavailable, see [Manual /container setup](#manual-container-setup)¹ |
| hEX S (2025) | ✓ | ✓ | ARMv5 (EN7562CT CPU) — Apps menu unavailable, see [Manual /container setup](#manual-container-setup)¹ |
| L009UiGS-RM | ✓ | | Consider disabling bandwidth tests¹ |
| RB4011iGS+RM | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| RB5009UG+S+IN | ✓ | ✓ | |
| RB5009UPr+S+IN | ✓ | ✓ | |
| RB5009UPr+S+OUT | ✓ | ✓ | |
| RB1100AHx4 | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| RB1100AHx4 Dude Edition | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| CCR2004-16G-2S+PC | ✓ | | |
| CCR2004-16G-2S+ | ✓ | | |
| CCR2004-1G-12S+2XS | ✓ | | |
| CCR2004-1G-2XS-PCIe | ✓ | | |
| CCR2116-12G-4S+ | ✓ | | |
| ROSE Data server (RDS) | ✓ | | |
| CCR2216-1G-12XS-2XQ | ✓ | | |
| CRS520-4XS-16XQ-RM | ✓ | | |
| CRS418-8P-8G-2S+RM | ✓ | | |
| CRS418-8P-8G-2S+5axQ2axQ-RM | ✓ | | |
| CRS812 DDQ | ✓ | | |
| CRS804 DDQ | ✓ | | |
| SXTsq 5 ax | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| LHG-5axD | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| NetBox 5 ax | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| LHG XL 5 ax | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| NetMetal ax | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| mANTBox ax 15s | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| hAP ax lite | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| wAP ax | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| hAP ax² | ✓ | | |
| hAP ax lite LTE6 | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| hAP ac³ | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| cAP ax | ✓ | | |
| L009UiGS-2HaxD-IN | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| hAP ax³ | ✓ | | |
| hAP be³ Media | ✓ | | |
| Chateau LTE6 | ✓ | | Requires USB storage; ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| Audience | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| Chateau PRO ax | ✓ | | |
| RB4011iGS+5HacQ2HnD-IN | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| L11UG-5HaxD | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| L23UGSR-5HaxD2HaxD | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| RB450Gx4 | ✓ | | ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |
| Chateau LTE6 ax | ✓ | | |
| Chateau LTE7 ax | ✓ | | |
| cAP LTE12 ax | ✓ | | |
| Chateau LTE18 ax | ✓ | | |
| Chateau 5G R17 ax | ✓ | | |
| Chateau 5G R16 | ✓ | | Requires USB storage; ARM 32-bit — Apps menu unavailable, see [Manual /container setup](#manual-container-setup) |

¹ ARMv5 devices have limited CPU performance. If using these devices for routing without hardware offload, disable bandwidth tests using `ORB_BANDWIDTH_DISABLED=1` to prevent CPU spikes.

:::note
These instructions assume you will run Orb with `ORB_EPHEMERAL_MODE=1`, disabling local storage of Orb telemetry to disk. Disabling ephemeral mode will require you to increase the size of the app data partition to accommodate local storage. This is only recommended for add-on storage (e.g. via USB).
:::

## Recommended: Install via the Apps menu

Starting with RouterOS v7.22, the `/app` menu provides a catalog-based way to deploy containerized apps in a couple of clicks, with networking, storage, and firewall rules configured automatically. This is now the easiest way to get Orb running on a supported MikroTik device — no manual bridge, veth, or NAT configuration required.

:::note
The `/app` system requires **arm64 or x86** architecture. Devices with a 32-bit **ARM** processor (e.g. **hEX Refresh**, **hEX S (2025)**, and other ARM-based MikroTik models — see the [Compatibility](#compatibility) table) are not supported and must use the [manual /container setup](#manual-container-setup) below instead.
:::

### Requirements

- A MikroTik device with **arm64 or x86** architecture, running **RouterOS v7.22+**
- Physical access to your device (required once, for the device-mode confirmation when enabling containers)
- The `container` package installed

:::note
The unpacked Orb sensor image needs roughly 20MB. Extraction itself briefly needs more headroom than that, so we recommend a dedicated **scratch disk** for extraction (set via `/container/config/set tmpdir=...`) separate from the app disk — see [Step 2](#step-2-configure-app-storage) below for the exact sizes and commands we validated (25MB app disk + 20MB scratch disk).
:::

### Step 1: Enable container support

1. Connect to your device via WebFig.
2. Select the **Advanced** tab in the top-right.
3. Navigate to **System > Packages**.
4. Click **Check for Updates**, and update RouterOS if a newer version is available (recommended — v7.22+ is required).
5. Once on v7.22+, install the **container** package if it isn't already installed, then **Apply Changes**.
6. Select the **Terminal** tab and run:

   ```routeros
   /system/device-mode/update container=yes
   ```

7. Press the physical reset or mode button on your device within the 5-minute countdown as instructed, or power-cycle the device. If nothing happens within 5 minutes, the change is cancelled and you'll need to re-run the command.

### Step 2: Configure app storage

If your device has an external USB/NVMe/SATA drive attached, RouterOS will detect it automatically — select it under **System > Disks** and format it with `ext4` or `btrfs` if needed.

If you don't have external storage, you can create small file-backed virtual disks directly on internal flash. We recommend **two** disks: one for the app itself, and one dedicated **scratch disk** used only during image download/extraction. Separating these matters — image extraction briefly needs more space than the final installed app, and giving that transient overhead its own disk lets the main app disk be sized much closer to the app's real footprint:

```routeros
/disk/add type=file file-path=orb-appdisk file-size=25M
/disk/format file-orb-appdisk file-system=ext4

/disk/add type=file file-path=orb-scratch file-size=20M
/disk/format file-orb-scratch file-system=ext4
```

Point the Apps system at the app disk, and point the container extraction directory (`tmpdir`) at the scratch disk:

```routeros
/app/settings/set disk=file-orb-appdisk
/container/config/set tmpdir=file-orb-scratch/tmp
```

:::note
`tmpdir` is a global `/container` setting, separate from the `disk`/`media-path`/`download-path` settings under `/app settings` — it controls where container image layers are extracted, regardless of which app triggers the extraction. Without a separate `tmpdir`, extraction and final storage compete for space on the same disk, and the app disk needs to be considerably larger (**40MB+** in our testing) to have enough transient headroom. With `tmpdir` on its own disk, **25MB** is sufficient for the app disk (with a 20MB scratch disk, which is barely touched — extraction is fast and cleans up after itself).
:::

### Step 3: Add the Orb app store

Add the Orb custom app store:

```routeros
/app/settings/set app-store-urls=https://orb.net/docs/scripts/mikrotik/orb-app-store.yml
```

:::note
The custom app-store catalog is only refreshed **at boot** — it won't appear in the Apps list right away. **Reboot your device once** after setting `app-store-urls` for the first time.
:::

After rebooting, open WebFig, navigate to **Apps**, and you should see **orb-sensor** available in the catalog alongside MikroTik's official apps.

### Step 4: Install and configure Orb

1. Select **orb-sensor** from the catalog and click **Install**.
2. Before enabling, set the **Network** to `lan` if appropriate for your network topology so the sensor gets a real address on your LAN (rather than being NATed behind the router), matching how a normal Orb sensor would see your network.
3. Add your deployment token as an environment variable so the sensor links to your account automatically on first boot — under the app's **Environment** settings, add:
   - `ORB_DEPLOYMENT_TOKEN` = *your deployment token* (see [Configuration](https://orb.net/docs/deploy-and-configure/configuration) for how to generate one)
4. If this device is also routing traffic (rather than just observing it), consider also adding:
   - `ORB_FIRSTHOP_DISABLED=1` — disables first-hop monitoring, appropriate for router deployments.
5. Since **use-https** defaults to on and expects the app to expose a web UI (Orb doesn't), disable it so the app doesn't stall waiting on a reverse-proxy certificate.
6. Optionally, enable **Auto Update** so the app pulls newer Orb image versions on its own, without you needing to click **Update** manually (see [Updating the Container](#updating-the-container) below for how this compares to a manual update).
7. Click **Enable**. The app will download and extract the image, then start automatically.

Once running, your MikroTik device should appear in your Orb dashboard within a minute or two.

#### Equivalent via terminal

Steps 2–7 above can also be done from the **Terminal** tab. Note that `environment` values must be prefixed with the service name (`orb:`, matching the `services.orb` key in the app's YAML):

```routeros
/app/set [find name=orb-sensor] network=lan use-https=no auto-update=yes environment="orb:ORB_EPHEMERAL_MODE=1,orb:ORB_DEPLOYMENT_TOKEN=your-deployment-token"
/app/enable [find name=orb-sensor]
```

Drop `auto-update=yes` from the command above if you'd rather update manually (see below).

## Manual /container setup

:::note
This method is reserved for devices with a 32-bit **ARM** processor (e.g. **hEX Refresh**, **hEX S (2025)**, and other ARM-based MikroTik models — see the [Compatibility](#compatibility) table), which do not support the `/app` system at all. If your device supports `/app` (see [Compatibility](#compatibility)), use the [Apps menu method](#recommended-install-via-the-apps-menu) above instead — it's simpler and handles networking/storage automatically.
:::

### Prerequisites

Before you begin, make sure you have:

- A compatible MikroTik device running RouterOS v7.x
- Physical access to your MikroTik device (required for device mode update)
- Access to your MikroTik device via WebFig
- Basic familiarity with RouterOS configuration

### Step 1: Enable Container Support

First, you need to install and enable the container package:

1. Connect to your device via WebFig.
2. Select the **Advanced** tab in the top-right.
3. Navigate to **System > Packages**.
4. Click **Check for Updates**.
5. Update RouterOS if available (recommended).
6. Once completed, click **Check for Updates** again.
7. Select the **container** package and click **Enable**, then **Apply Changes**.

Next, update the device mode to enable container support:

1. Select the **Terminal** tab in the top-right.
2. Enter the following command:

   ```routeros
   /system/device-mode/update container=yes
   ```

3. Press the physical reset or mode button on your device within the 5-minute countdown as instructed.

### Step 2: Configure Container Networking

Create a dedicated network for the Orb container:

#### Create Container Bridge

Navigate to **Bridge > New**.
   - Name: `containers`
   - Click **OK**.

#### Create Virtual Ethernet Interface

Navigate to **Interfaces > New > VETH**.
   - Name: `veth-orb`
   - Click the **+** next to **Address**.
   - Enter IP: `172.19.0.2/24` (or alternate if this network is in use).
   - Gateway: `172.19.0.1`.
   - Click **OK**.

#### Add Interface to Bridge

Navigate to **Bridge > Ports > New**.
   - Interface: `veth-orb`.
   - Bridge: `containers`.
   - Click **OK**.

### Step 3: Configure Container Storage and Environment

#### Create Data Mount

Navigate to **Container > Mounts > New**.
   - Name: `MOUNT_ORB_DATA`.
   - Src: `/orb-data`.
   - Dst: `/root/.config/orb`.
   - Click **OK**.

#### Configure Environment Variables

Enable ephemeral mode to prevent writing to flash:

Navigate to **Container > Envs > New**.
   - Name: `ENV_ORB`.
   - Key: `ORB_EPHEMERAL_MODE`.
   - Value: `1`.
   - Click **OK**.

For router deployments, disable first-hop monitoring:

Navigate to **Container > Envs > New**.
   - Name: `ENV_ORB`.
   - Key: `ORB_FIRSTHOP_DISABLED`.
   - Value: `1`.
   - Click **OK**.

For devices with limited CPU (ARMv5), also disable bandwidth tests:

Navigate to **Container > Envs > New**.
   - Name: `ENV_ORB`.
   - Key: `ORB_BANDWIDTH_DISABLED`.
   - Value: `1`.
   - Click **OK**.

### Step 4: Deploy the Orb Container

#### Add Container

1. Navigate to **Container > Container > New**.
2. Click the **+** next to **Remote Image** and enter:

   ```bash
   registry.hub.docker.com/orbforge/orb-busybox:latest
   ```

3. Configure the following settings:
   - Interface: `veth-orb`.
   - Envlist: `ENV_ORB`.
   - Workdir: `/app`.
   - Mounts: `MOUNT_ORB_DATA`.
   - Logging: **enabled**.
   - Start On Boot: **enabled**.
4. Click **Apply**.
5. Click **Start**.

#### Configure NAT for Outbound Traffic

1. Select the **Terminal** tab.
2. Enter the following command:

   ```routeros
   /ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.19.0.0/24
   ```

### Step 5: Link Your Orb to Your Account

The final step is to link your new Orb sensor to your account:

1. In the RouterOS terminal, connect to the container:

   ```routeros
   /container shell [find where name~"orb-busybox:latest"]
   ```

2. Run the link command:

   ```bash
   /app/orb link
   ```

3. Follow the instructions provided to complete the linking process.
4. Once linked, your MikroTik Orb will appear in your Orb dashboard.

## Troubleshooting

### orb-sensor Doesn't Appear in the Apps Catalog

If you've set `app-store-urls` but don't see **orb-sensor** in the Apps list:

- The custom app-store catalog is only refreshed at boot, not live. **Reboot the device once** after setting `app-store-urls` for the first time.
- Confirm the setting was saved: **Apps > Configuration > Settings**, check the **App Store Urls** field.
- Check the view filter next to the item count (top-right of the Apps list) — it may be set to a specific view that hides store-sourced entries.

:::note
If the terminal commands in [Step 4](#step-4-install-and-configure-orb) (`/app/set [find name=orb-sensor] ...`, `/app/enable [find name=orb-sensor] ...`) run with **no output and no error**, that doesn't mean they succeeded — `[find name=orb-sensor]` silently resolves to nothing if the app isn't in the catalog yet, and RouterOS doesn't warn you when a command's target matches zero items. Before troubleshooting further, confirm the app actually exists first: `/app print where name=orb-sensor` should show one row. If it shows nothing, the catalog issue above hasn't been resolved yet — go back and fix that first.
:::

### App Won't Enable / Stuck Waiting

If an app installed via the Apps menu shows a status like "wait for reverse proxy" and never progresses to downloading:

- Orb doesn't expose a web UI, so the default `use-https=yes` reverse-proxy/certificate step will stall indefinitely. Disable it: `/app/set [find name=orb-sensor] use-https=no`.

### Container Not Starting

If the Orb container fails to start:

- Check container status in **Container > Container** (or **Apps**, if installed via the Apps menu).
- View logs in Terminal: `/log/print` (ensure logging is enabled in container settings).
- Verify the veth interface has the correct IP configuration.
- Ensure the NAT rule is properly configured (manual `/container` setup only — the Apps menu handles this automatically).

### "Not Enough Disk Space" During Download/Extract, or App Crashes Right After Starting

These are two symptoms of the same underlying issue — the app disk is too small:

- **`not enough disk space to download/extract`**: extraction needs more transient headroom than the final image size. Set a separate `tmpdir` on a dedicated scratch disk (see [Step 2](#step-2-configure-app-storage) above) rather than just making the app disk bigger — it's a more effective fix and keeps the app disk small.
- **App extracts fine but exits immediately (`exited with status 1`)**: the app disk is *just barely* big enough to extract into, but leaves too little room for the app to actually write config and certs on first run. Increase the disk size.

### Network Connectivity Issues

If the container cannot reach the internet:

- Verify the NAT rule source address matches your container network (manual `/container` setup only).
- Check firewall rules aren't blocking container traffic.
- Ensure DNS is properly configured for the container.

### Updating the Container

**For /app-based installs**, there are two options:

- **Manual (recommended for predictable timing)**: select **orb-sensor** in WebFig's Apps list and click **Update**, or run `/app/update [find name=orb-sensor]` from the Terminal. This pulls the latest image immediately.
- **Automatic**: set `auto-update=yes` on the app (`/app/set [find name=orb-sensor] auto-update=yes`, or the **Auto Update** checkbox in WebFig — see [Step 4](#step-4-install-and-configure-orb)). There's also a global equivalent, `/app/settings/set auto-update=yes`, which applies to every installed app rather than just Orb. Neither MikroTik's documentation nor the RouterOS community forums specify exactly when or how often an automatic check happens — treat this as a convenience, not a guarantee, and use the manual update above if you need to confirm you're on a specific version.

**For /container-based installs** (manual `/container` setup only), RouterOS does not support a mechanism for easily updating to the latest version of the Orb image — this is specific to raw `/container`, the `/app` system above has its own update commands. The solution is to delete the container and recreate it with the same configuration, which will pull the `:latest` tagged image from Docker Hub. As we set up persistent storage, you will not need to re-link, and your history will be preserved.

### Container Shell Access Issues

If you cannot access the container shell:

- Ensure the container is running.
- Try using the container ID instead of the name pattern.
- Restart the container and try again.

## Additional Resources

- For more details on the Apps menu, see [MikroTik's Apps documentation](https://help.mikrotik.com/docs/spaces/ROS/pages/343244823/Apps).
- For more details on RouterOS containers, see [MikroTik's Container documentation](https://help.mikrotik.com/docs/spaces/ROS/pages/84901929/Container).
- To find compatible devices, use [MikroTik's hardware catalog](https://mikrotik.com/products?filter&s=c&a=%5B%22arm%22,%22arm64%22%5D#).
- For alternative installation methods, see [Install Orb on Docker](/docs/setup-sensor/docker).
- For general Orb troubleshooting, see the [Orb documentation](/docs).
