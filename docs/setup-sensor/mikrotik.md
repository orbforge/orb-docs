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
| hEX refresh | ✓ | ✓ | Consider disabling bandwidth tests¹ |
| hEX S (2025) | ✓ | ✓ | Consider disabling bandwidth tests¹ |
| L009UiGS-RM | ✓ | | Consider disabling bandwidth tests¹ |
| RB4011iGS+RM | ✓ | | |
| RB5009UG+S+IN | ✓ | | |
| RB5009UPr+S+IN | ✓ | | |
| RB5009UPr+S+OUT | ✓ | | |
| RB1100AHx4 | ✓ | | |
| RB1100AHx4 Dude Edition | ✓ | | |
| CCR2004-16G-2S+PC | ✓ | | |
| CCR2004-16G-2S+ | ✓ | | |
| CCR2004-1G-12S+2XS | ✓ | | |
| ROSE Data server (RDS) | ✓ | | |
| CCR2216-1G-12XS-2XQ | ✓ | | |
| CRS520-4XS-16XQ-RM | ✓ | | |
| SXTsq 5 ax | ✓ | | |
| LHG-5axD | ✓ | | |
| NetBox 5 ax | ✓ | | |
| LHG XL 5 ax | ✓ | | |
| NetMetal ax | ✓ | | |
| mANTBox ax 15s | ✓ | | |
| hAP ax lite | ✓ | | |
| wAP ax | ✓ | | |
| hAP ax² | ✓ | | |
| hAP ax lite LTE6 | ✓ | | |
| hAP ac³ | ✓ | | |
| cAP ax | ✓ | | |
| L009UiGS-2HaxD-IN | ✓ | | |
| hAP ax³ | ✓ | | |
| Chateau LTE6 | ✓ | | Requires USB storage |
| Audience | ✓ | | |
| Chateau PRO ax | ✓ | | |
| RB4011iGS+5HacQ2HnD-IN | ✓ | | |
| L11UG-5HaxD | ✓ | | |
| L23UGSR-5HaxD2HaxD | ✓ | | |
| RB450Gx4 | ✓ | | |
| Chateau LTE6 ax | ✓ | | |
| cAP LTE12 ax | ✓ | | |
| Chateau LTE18 ax | ✓ | | |
| Chateau 5G R17 ax | ✓ | | |
| Chateau 5G R16 | ✓ | | Requires USB storage |

¹ ARMv5 devices have limited CPU performance. If using these devices for routing without hardware offload, disable bandwidth tests using `ORB_BANDWIDTH_DISABLED=1` to prevent CPU spikes.

:::note
After installation, ensure the device has at least 20MB of disk space remaining for the Orb database and logs.
:::

## Prerequisites

Before you begin, make sure you have:

- A compatible MikroTik device running RouterOS v7.x
- Physical access to your MikroTik device (required for device mode update)
- Access to your MikroTik device via WebFig
- Basic familiarity with RouterOS configuration

## Step 1: Enable Container Support

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

## Step 2: Configure Container Networking

Create a dedicated network for the Orb container:

### Create Container Bridge

Navigate to **Bridge > New**.
   - Name: `containers`
   - Click **OK**.

### Create Virtual Ethernet Interface

Navigate to **Interfaces > New > VETH**.
   - Name: `veth-orb`
   - Click the **+** next to **Address**.
   - Enter IP: `172.19.0.2/24` (or alternate if this network is in use).
   - Gateway: `172.19.0.1`.
   - Click **OK**.

### Add Interface to Bridge

Navigate to **Bridge > Ports > New**.
   - Interface: `veth-orb`.
   - Bridge: `containers`.
   - Click **OK**.

## Step 3: Configure Container Storage and Environment

### Create Data Mount

Navigate to **Container > Mounts > New**.
   - Name: `MOUNT_ORB_DATA`.
   - Src: `/orb-data`.
   - Dst: `/root/.config/orb`.
   - Click **OK**.

### Configure Environment Variables

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

## Step 4: Deploy the Orb Container

### Add Container

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

### Configure NAT for Outbound Traffic

1. Select the **Terminal** tab.
2. Enter the following command:

   ```routeros
   /ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.19.0.0/24
   ```

## Step 5: Link Your Orb to Your Account

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

### Container Not Starting

If the Orb container fails to start:

- Check container status in **Container > Container**.
- View logs in Terminal: `/log/print` (ensure logging is enabled in container settings).
- Verify the veth interface has the correct IP configuration.
- Ensure the NAT rule is properly configured.

### Network Connectivity Issues

If the container cannot reach the internet:

- Verify the NAT rule source address matches your container network.
- Check firewall rules aren't blocking container traffic.
- Ensure DNS is properly configured for the container.

### Resource Constraints

For devices experiencing high CPU usage:

- Ensure `ORB_BANDWIDTH_DISABLED=1` is set for ARMv5 devices.
- Monitor CPU usage via **System > Resources**.
- Consider upgrading to a more powerful device if issues persist.

### Updating the Container

Unfortunately, RouterOS does not support a mechanism for easily updating to the latest version of the Orb image—automated or otherwise. The solution is to delete the container and create a new container with the same configuration, which will pull the :latest tagged image from Docker Hub. As we set up persistent storage, you will not need to re-link, and your history will be preserved.

### Container Shell Access Issues

If you cannot access the container shell:

- Ensure the container is running.
- Try using the container ID instead of the name pattern.
- Restart the container and try again.

## Additional Resources

- For more details on RouterOS containers, see [MikroTik's Container documentation](https://help.mikrotik.com/docs/spaces/ROS/pages/84901929/Container).
- To find compatible devices, use [MikroTik's hardware catalog](https://mikrotik.com/products?filter&s=c&a=%5B%22arm%22,%22arm64%22%5D#).
- For alternative installation methods, see [Install Orb on Docker](/docs/setup-sensor/docker).
- For general Orb troubleshooting, see the [Orb documentation](/docs).
