---
title: Install Orb Using IOx Local Manager
shortTitle: IOx Local Manager
metaDescription: Deploy Orb sensor on Cisco switches, routers, and IoT gateways using the web-based IOx Local Manager interface.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Intermediate'
---

# Install Orb Using IOx Local Manager

:::warning
This documentation is in beta and intended for advanced users. If you encounter issues or have questions, please reach out to [support@orb.net](mailto:support@orb.net) or join our [Discord community](https://discord.gg/orbforge).
:::

## Introduction

This guide walks you through deploying the Orb sensor using IOx Local Manager, a web-based interface for managing IOx applications on Cisco devices. This method is ideal for Catalyst switches, ISR routers, and industrial IoT gateways where you prefer a GUI-based workflow.

## Prerequisites

Before you begin, ensure you have:

- A compatible Cisco device with IOx enabled (see [compatibility list](/docs/setup-sensor/cisco))
- IOS XE 16.12.1 or later
- Web browser access to the device's IOx Local Manager interface
- An IOx package (`package.tar`) containing the Orb sensor and your deployment token
- An Orb [deployment token](/docs/deploy-and-configure/deployment-tokens)

## Building Your IOx Package

Pre-built packages are coming soon. In the meantime, you must build your own `package.tar` that includes your deployment token. Follow the [Building the IOx Package](/docs/setup-sensor/cisco/ioxclient) section in the ioxclient guide to create your package using the IOx SDE.

Once you have your `package.tar`, return here to deploy it via IOx Local Manager.

## Step 1: Enable IOx on Your Device

Before accessing IOx Local Manager, enable IOx on your Cisco device via CLI.

### Enable IOx Framework

Connect to your device via SSH or console and enter configuration mode:

```ios
configure terminal
iox
end
```

### Verify IOx Services

Wait a few minutes for IOx services to initialize, then verify:

```ios
show iox-service
```

All services should show as `Running`:

```
IOx Infrastructure Summary:
---------------------------
IOx service (CAF)    : Running
IOx service (HA)     : Not Supported
IOx service (IOxman) : Running
Libvirtd             : Running
Dockerd              : Running
```

## Step 2: Access IOx Local Manager

Open a web browser and navigate to the IOx Local Manager interface:

- **IR1101, IE3x00 series**: `https://<device-ip>/iox/login`
- **Other devices**: `https://<device-ip>:8443`

Log in using your IOS XE credentials.

## Step 3: Upload the Orb Application

1. Navigate to **Applications** in the left menu.
2. Click **Add New**.
3. Enter an **Application ID**: `orb`
4. Click **Choose File** and select your `package.tar` file.
5. Click **OK** to upload.

Wait for the upload to complete. The application will appear in the list with status **DEPLOYED**.

## Step 4: Activate the Application

1. Select the **orb** application from the list.
2. Click **Activate**.

### Configure Resources

On the Resources tab:
- **CPU**: 400 units (or as specified in your package)
- **Memory**: 80 MB
- **Disk**: 10 MB

### Configure Network

On the Network Configuration tab:
1. Click **eth0** to configure the network interface.
2. Select **Network Name**: `iox-nat0` (or your configured network)
3. For IP assignment, select either:
   - **DHCP**: For automatic IP assignment
   - **Static**: Enter a specific IP address, netmask, and gateway
4. Click **OK**.

### Apply Activation

Click **Activate App** to complete the activation process.

The application status will change to **ACTIVATED**.

## Step 5: Start the Application

1. Select the **orb** application.
2. Click **Start**.

The status will change to **RUNNING**.

## Step 6: Verify Installation

### Check Application Status

1. Select the **orb** application.
2. Click **Manage**.
3. Review the **App Info** tab to confirm the application is running.

### View Logs

1. In the Manage view, click the **Logs** tab.
2. Select the log file to view Orb sensor output.
3. Verify the sensor has connected to the Orb service.

Your Orb sensor will automatically register with your account using the deployment token embedded in the package.

## Step 7: Configure Persistent Storage (Optional)

To preserve data across reboots, configure a data volume:

1. In the **Manage** view, click **App-DataDir**.
2. The `/data` directory contains Orb configuration and measurement data.
3. This directory persists across application restarts.

## Network Configuration Options

IOx supports several network configurations depending on your deployment needs:

### NAT Mode (Default)

The container uses the device's management IP with network address translation. This is the simplest configuration and works for most deployments.

### Bridge Mode

For direct Layer 2 connectivity:

1. Create a dedicated VLAN on the device
2. Configure an AppGigabitEthernet interface as a trunk
3. Assign the VLAN to the container network

### Static IP

For deployments requiring a specific IP address:

1. During activation, select **Static** for IP assignment
2. Enter the desired IP address, netmask, and gateway
3. Ensure the IP is routable from the device

## Troubleshooting

### Cannot Access IOx Local Manager

If you cannot reach the Local Manager interface:

- Verify IOx services are running: `show iox-service`
- Check the management interface has connectivity
- Ensure HTTPS (port 8443) is not blocked by ACLs
- Try accessing via HTTP if HTTPS fails: `http://<device-ip>:8080`

### Application Won't Start

If the application fails to start:

- Check resource allocation doesn't exceed device limits
- Verify the network configuration is correct
- Review application logs for error messages
- Ensure the package was built for the correct architecture

### Network Connectivity Issues

If the Orb sensor cannot reach the internet:

- Verify NAT is configured on the device for the container network
- Check DNS resolution is available to the container
- Ensure firewall rules allow outbound HTTPS traffic
- Test connectivity from the device management interface first

### Out of Disk Space

If you see disk space errors:

- Check available storage: `show platform software iox-service storage`
- Remove unused applications to free space
- Consider using external USB storage for data-intensive deployments

## Updating the Orb Sensor

To update to a newer version:

1. Stop the running application: Click **Stop**
2. Deactivate the application: Click **Deactivate**
3. Delete the application: Click **Delete**
4. Upload the new package following the installation steps

:::note
Your deployment token and configuration are embedded in the package, so you'll need to rebuild the package with your token before uploading.
:::

## Additional Resources

- [IOx Local Manager Documentation](https://developer.cisco.com/docs/iox/iox-local-manager/)
- [Cisco IOx Overview](/docs/setup-sensor/cisco)
- [Building IOx Packages with ioxclient](/docs/setup-sensor/cisco/ioxclient)
