---
title: Install Orb Using ioxclient
shortTitle: ioxclient
metaDescription: Deploy Orb sensor on Cisco Catalyst 9000 APs and other IOx devices using the ioxclient CLI tool.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Advanced'
---

# Install Orb Using ioxclient

:::warning
This documentation is in beta and intended for advanced users. If you encounter issues or have questions, please reach out to [support@orb.net](mailto:support@orb.net) or join our [Discord community](https://discord.gg/orbforge).
:::

## Introduction

This guide walks you through deploying the Orb sensor on Cisco IOx devices using `ioxclient`, the official CLI tool for IOx application management. This method is recommended for Catalyst 9000 Access Points and developers who prefer command-line workflows.

## Prerequisites

Before you begin, ensure you have:

- A compatible Cisco device with IOx enabled (see [compatibility list](/docs/setup-sensor/cisco))
- Access to the device via SSH or serial console
- The IOx SDE (Software Development Environment) VM
- The [ioxclient](https://developer.cisco.com/docs/iox/) tool installed (included in IOx SDE)
- [Skopeo](https://github.com/containers/skopeo) installed on your workstation
- An Orb [deployment token](/docs/deploy-and-configure/deployment-tokens)

## Building the IOx Package {#building-the-iox-package}

Before deploying Orb to any Cisco IOx device, you must build an IOx package (`package.tar`) that contains the Orb sensor image and your deployment token. This section covers the complete package building process.

:::note
Pre-built packages are coming soon. In the meantime, follow these steps to build your own package using the IOx SDE and ioxclient.
:::

### Step 1: Download and Convert the Orb Image

The Orb Docker image must be converted to a format compatible with the IOx SDE. Use Skopeo to download the image for your target architecture.

#### For ARM64 Devices (Catalyst 9000 APs, IR1101, IE3x00)

```bash
skopeo copy \
  --override-arch=arm64 \
  --override-os=linux \
  docker://orbforge/orb-busybox:latest \
  docker-archive:orb-busybox-arm64.tar
```

#### For x86_64 Devices (Catalyst 9300/9400/9500, ISR)

```bash
skopeo copy \
  --override-arch=amd64 \
  --override-os=linux \
  docker://orbforge/orb-busybox:latest \
  docker-archive:orb-busybox-amd64.tar
```

### Step 2: Transfer Image to IOx SDE

Transfer the image archive to your IOx SDE virtual machine:

```bash
scp orb-busybox-arm64.tar root@<ioxsde-ip>:orb/orb-image.tar
```

### Step 3: Create the Package Descriptor

On the IOx SDE, create a working directory and the required configuration files.

#### Create Working Directory

```bash
mkdir -p ~/orb
cd ~/orb
```

#### Create package.yaml

Create `package.yaml` with the following content. Replace `YOUR_DEPLOYMENT_TOKEN` with your actual Orb deployment token:

```yaml
descriptor-schema-version: "2.10"
info:
  name: orb
  description: "Orb Sensor"
  version: "1.0"
  author-name: "Orb"
app:
  cpuarch: aarch64
  type: docker
  env:
    PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ORB_CONFIG_DIR: /data
    ORB_DATA_DIR: /data
    ORB_EPHEMERAL_MODE: 1
    ORB_DEPLOYMENT_TOKEN: YOUR_DEPLOYMENT_TOKEN
  resources:
    profile: custom
    cpu: 400
    memory: 80
    disk: 10
    network:
      - interface-name: eth0
        ports:
          tcp:
            - "7443"
            - "8081"
  startup:
    rootfs: rootfs.img
    target: "/app/orb sensor"
    workdir: /app
```

:::note
For x86_64 devices, change `cpuarch: aarch64` to `cpuarch: x86_64`.
:::

#### Create activate.json

Create `activate.json` for network activation:

```json
{
  "resources": {
    "network": [
      {
        "interface-name": "eth0",
        "network-name": "iox-nat0",
        "port_map": {
          "mode": "1to1"
        }
      }
    ]
  }
}
```

### Step 4: Build the IOx Package

Load the Docker image and create the IOx package.

#### Load the Image

```bash
docker load -i orb-image.tar
```

#### Verify the Image

```bash
docker images
```

You should see output similar to:

```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
<none>              <none>    f1ad2bf2ebcc   5 days ago     19 MB
```

#### Tag the Image

Tag the image with the hash from the previous command:

```bash
docker tag <IMAGE_ID> orb-busybox:latest
```

#### Create the Package

Build the IOx package using ioxclient:

```bash
ioxclient docker package -p ext2 -r 5 orb-busybox:latest .
```

This creates `package.tar` in the current directory. You can now use this package to deploy Orb via ioxclient (continue below), [IOx Local Manager](/docs/setup-sensor/cisco/iox-local-manager), or [Catalyst Center](/docs/setup-sensor/cisco/catalyst-center).

## Deploying with ioxclient

Once you have built your `package.tar`, you can deploy it to your device using ioxclient.

### Step 5: Configure ioxclient Connection

Set up ioxclient to communicate with your target device:

```bash
ioxclient profiles create
```

Follow the prompts to configure:
- Profile name (e.g., `catalyst-ap`)
- Host IP address
- Port (typically 8443)
- Authentication credentials

Activate the profile:

```bash
ioxclient profiles activate catalyst-ap
```

### Step 6: Deploy the Orb Application

#### Remove Existing Installation (if upgrading)

If you have a previous Orb installation, remove it first:

```bash
ioxclient application stop orb
ioxclient application deactivate orb
ioxclient application uninstall orb
```

#### Install the Application

```bash
ioxclient application install orb package.tar
```

#### Activate with Network Configuration

```bash
ioxclient application activate orb --payload activate.json
```

#### Start the Application

```bash
ioxclient application start orb
```

### Step 7: Verify Installation

Check that the Orb sensor is running:

```bash
ioxclient application status orb
```

The status should show `RUNNING`. Your Orb sensor will automatically register with your account using the deployment token.

View application logs:

```bash
ioxclient application logs orb
```

## Troubleshooting

### Application Not Starting

If the application fails to start:

- Verify the package was created correctly: `ioxclient application info orb`
- Check device resources: Ensure sufficient CPU, memory, and disk space
- Review logs: `ioxclient application logs orb`

### Network Connectivity Issues

If the sensor cannot reach the internet:

- Verify the `iox-nat0` network exists on the device
- Check that NAT is properly configured on the host device
- Ensure DNS resolution is working within the container

### Image Architecture Mismatch

If you see architecture-related errors:

- Verify you downloaded the correct image architecture (ARM64 vs x86_64)
- Check the `cpuarch` setting in `package.yaml` matches your device

### Package Build Failures

If `ioxclient docker package` fails:

- Ensure Docker daemon is running on the IOx SDE
- Verify the image is properly loaded: `docker images`
- Check you have sufficient disk space on the SDE

## Updating the Orb Sensor

To update to a newer version of Orb:

1. Download and transfer the new image
2. Load and tag the new image
3. Rebuild the package with `ioxclient docker package`
4. Stop, deactivate, and uninstall the existing application
5. Install, activate, and start the new package

Your configuration is preserved through updates since the deployment token and settings are embedded in `package.yaml`.

## Additional Resources

- [ioxclient Documentation](https://developer.cisco.com/docs/iox/)
- [IOx Package Descriptor Reference](https://developer.cisco.com/docs/iox/tutorial-create-custom-package-descriptor-for-docker-apps/)
- [Cisco IOx Overview](/docs/setup-sensor/cisco)
