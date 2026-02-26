---
title: Install Orb Using Catalyst Center
shortTitle: Catalyst Center
metaDescription: Deploy Orb sensor at scale across Cisco Catalyst 9000 Access Points using Catalyst Center's IoT Services.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Intermediate'
---

# Install Orb Using Catalyst Center

:::warning
This documentation is in beta and intended for advanced users. If you encounter issues or have questions, please reach out to [support@orb.net](mailto:support@orb.net) or join our [Discord community](https://discord.gg/orbforge).
:::

## Introduction

This guide walks you through deploying the Orb sensor across Cisco Catalyst 9000 Access Points using Catalyst Center (formerly DNA Center). This method is ideal for enterprise networks managing multiple APs where centralized deployment and monitoring is required.

With Catalyst Center, you can:

- Deploy Orb to multiple access points simultaneously
- Monitor application health from a central dashboard
- Manage application lifecycle across your wireless infrastructure

## Prerequisites

Before you begin, ensure you have:

- Catalyst Center 2.1.2.x or later
- Cisco IOS XE 17.3.1 or later on your Wireless LAN Controllers
- Catalyst 9000 series access points (see [compatibility list](/docs/setup-sensor/cisco))
- The Application Hosting package installed on Catalyst Center
- A Cisco DNA Advantage license
- An IOx package (`package.tar`) containing the Orb sensor and your deployment token
- An Orb [deployment token](/docs/deploy-and-configure/deployment-tokens)

:::note
Access points require direct, routable (non-NAT) connectivity to Catalyst Center on HTTPS port 8443 for application hosting to function.
:::

## Building Your IOx Package

Pre-built packages are coming soon. In the meantime, you must build your own `package.tar` that includes your deployment token. Follow the [Building the IOx Package](/docs/setup-sensor/cisco/ioxclient#building-the-iox-package) section in the ioxclient guide to create your package using the IOx SDE.

Once you have your `package.tar`, return here to deploy it via Catalyst Center.

## Step 1: Install the Application Hosting Package

The Application Hosting feature must be installed on Catalyst Center before you can deploy IOx applications.

1. Log in to Catalyst Center.
2. Navigate to **System > Software Updates > Installed Apps**.
3. Under **Automation**, locate **Application Hosting**.
4. Click **Install** if not already installed.
5. Wait for the installation to complete.

## Step 2: Prepare Your Wireless Infrastructure

### Verify Controller and AP Status

1. Navigate to **Provision > Inventory**.
2. Ensure your Wireless LAN Controllers show **Managed** status.
3. Verify your Catalyst 9000 APs are discovered and managed.

### Configure Site Hierarchy

1. Navigate to **Design > Network Hierarchy**.
2. Create or verify your site hierarchy.
3. Assign WLCs and APs to appropriate sites.

## Step 3: Upload the Orb Application

1. Navigate to **Provision > IoT Services > App Hosting**.
2. Click **Add Application**.
3. Enter the application details:
   - **Application Name**: `Orb Sensor`
   - **Description**: `Network monitoring sensor`
4. Click **Choose File** and select your `package.tar` file.
5. Click **Upload**.

Wait for the upload to complete. The application will appear in the application list.

## Step 4: Deploy to Access Points

### Select Target Access Points

1. In **IoT Services > App Hosting**, select the **Orb Sensor** application.
2. Click **Enable IoT Services**.
3. Select the site(s) containing your target access points.
4. Choose specific APs or select all APs at the site.

### Configure Deployment Settings

1. **Network Configuration**:
   - By default, applications use NAT with IP addresses from the 192.168.11.x/27 range
   - For custom networking, configure the auxiliary-client interface on your WLC

2. **Resource Allocation**:
   - CPU: 400 units
   - Memory: 80 MB
   - Disk: 10 MB

3. Review the configuration and click **Deploy**.

## Step 5: Monitor Deployment Status

1. Navigate to **Provision > IoT Services > App Hosting**.
2. Select the **Orb Sensor** application.
3. View the deployment status for each access point:
   - **DEPLOYING**: Installation in progress
   - **RUNNING**: Successfully deployed and running
   - **FAILED**: Deployment failed (check logs for details)

### View Application Details

1. Click on a specific access point in the deployment list.
2. Review:
   - Application status
   - Resource utilization
   - Network connectivity
   - Log output

## Step 6: Verify Orb Registration

Once deployed, Orb sensors will automatically register with your account using the deployment token embedded in the package.

1. Log in to your Orb dashboard at [orb.net](https://orb.net).
2. Navigate to the Sensors page.
3. Verify your Catalyst APs appear as registered sensors.

## Network Architecture

### Default NAT Configuration

By default, IOx applications on Catalyst APs:

- Receive IP addresses via DHCP from the 192.168.11.x/27 range
- Communicate externally through NAT using the AP's management IP
- Have internet access through the AP's uplink

### Custom Network Segmentation

For deployments requiring traffic separation:

1. On the WLC, configure an auxiliary-client interface (AHI)
2. Assign a dedicated VLAN for IOx traffic
3. Configure routing for the IOx VLAN
4. Update the deployment to use the custom network

## Managing Deployed Applications

### Stopping an Application

1. Navigate to **IoT Services > App Hosting**.
2. Select the application.
3. Select the target APs.
4. Click **Stop**.

### Removing an Application

1. Stop the application on all APs.
2. Select the application.
3. Click **Remove** to uninstall from selected APs.

### Updating an Application

1. Upload the new version of the package.
2. Stop the running application on target APs.
3. Remove the old version.
4. Deploy the new version.

## Troubleshooting

### Deployment Fails

If deployment fails on specific APs:

- Verify the AP has connectivity to Catalyst Center on port 8443
- Check the AP has sufficient resources (100 MB RAM available)
- Ensure IOS XE version meets minimum requirements (17.3.1+)
- Review Catalyst Center logs for detailed error messages

### Application Shows FAILED Status

Common causes and solutions:

- **Package size**: Ensure the package is under 10 MB
- **Architecture mismatch**: Verify the package is built for aarch64
- **Resource constraints**: Check AP resource availability
- **Network issues**: Verify AP can reach external services

### APs Not Appearing in IoT Services

If APs don't appear as deployment targets:

- Verify APs are in **Managed** status in Inventory
- Check the Application Hosting package is installed
- Ensure APs support IOx (Catalyst 9000 series only)
- Confirm IOS XE version compatibility

### Orb Sensor Not Registering

If sensors deploy but don't appear in your Orb dashboard:

- Verify the deployment token is correct in the package
- Check the AP has internet connectivity
- Review application logs for connection errors
- Ensure DNS resolution is working on the AP

## Limitations

- Maximum 2 concurrent applications per access point
- Package size limit of 10 MB
- Memory allocation of 100 MB per AP
- Requires non-NAT connectivity from APs to Catalyst Center
- USB storage support varies by model and PoE budget

## Additional Resources

- [Cisco Catalyst Center Application Hosting Guide](https://www.cisco.com/c/en/us/products/collateral/wireless/access-points/guide-c07-744305.html)
- [Catalyst Center Documentation](https://www.cisco.com/c/en/us/support/cloud-systems-management/dna-center/series.html)
- [Cisco IOx Overview](/docs/setup-sensor/cisco)
- [Building IOx Packages with ioxclient](/docs/setup-sensor/cisco/ioxclient)
