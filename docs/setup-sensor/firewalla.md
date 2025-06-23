---
title: Install Orb on Firewalla
shortTitle: Firewalla
metaDescription: Install the Orb sensor on your Firewalla device for network monitoring.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Easy 🧑‍💻'
---

# Install Orb on Firewalla

## Introduction

This guide will walk you through the process of setting up the Orb sensor on your Firewalla device. Installing the Orb sensor allows you to monitor the network responsiveness and reliability of your network from anywhere in the world using your mobile device or computer.

With the Orb sensor running on your Firewalla, you can:

- Monitor your network connectivity and performance
- Track network reliability and responsiveness over time
- Receive push notifications on your Android or iOS device when your Firewalla experiences connectivity issues

## Compatibility

The following Firewalla devices noted as "Supported" support Docker and should be able to run the Orb sensor:

| Device | Supported | Validated | Notes |
|--------|----------------|-----------|--|
| Gold | ✓ | | |
| Gold SE | ✓ | ✓ | |
| Gold Plus | ✓ | ✓ | |
| Gold Pro | ✓ | | |
| Purple | ✓ | | |
| Purple SE | ✓ | | |
| Blue Plus | ✓ | | |
| Blue | ✗ | | |
| Red | ✗ | | |

The "Validated" column denotes device models that have been verified to run Orb by the Orb Forge team or members of the Orb community.

## Prerequisites

Before you begin, make sure you have:

- A Firewalla device (Gold, Purple, or Blue Plus)
- SSH access enabled on your Firewalla
- The Orb app installed on your mobile device or computer (see [Install Orb](/docs/install-orb))
- A terminal application on a device connected to the same network as your Firewalla

## Step 1: SSH into Your Firewalla

First, you need to access your Firewalla via SSH:

1. From a terminal on the same local network as your Firewalla, run:

   ```bash
   ssh pi@fire.walla
   ```

   > **Note**: If Firewalla is your DNS resolver, the hostname `fire.walla` will work. Otherwise, use your Firewalla's IP address or local DNS hostname.

2. When prompted for a password, find it in your Firewalla app:
   **Settings** > **Advanced** > **Configurations** > **SSH Console**

## Step 2: Enable Docker Service

Ensure Docker is running and set to start automatically:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Step 3: Install Orb Using Docker Compose

Now, create the Orb configuration and start the container:

1. Create a directory for the Orb Docker configuration:

   ```bash
   mkdir -p ~/.firewalla/run/docker/orb/ && cd ~/.firewalla/run/docker/orb/
   ```

2. Download the Docker Compose configuration and start Orb:

   ```bash
   curl -fsSL https://orb.net/docs/scripts/docker/docker-compose.yml -o docker-compose.yml && sudo docker-compose up -d
   ```

   This command will download the configuration file and start the Orb sensor in the background. Orb will automatically be kept up-to-date. See [Install Orb on Docker](/docs/setup-sensor/docker) for more details.

## Step 4: Link Your Orb to Your Account

The final step is to link your new Orb sensor to your account:

1. Open the Orb app on your mobile device or computer
2. Your new Orb sensor should be automatically detected on your local network
3. Follow the in-app prompts to link the sensor to your Orb account
4. Once linked, your Firewalla Orb will appear in your Orb dashboard

## Troubleshooting

### SSH Connection Failed

If you cannot connect via SSH:

- Verify SSH is enabled in your Firewalla app settings
- Ensure you're on the same network as your Firewalla
- Try using the IP address instead of `fire.walla`

### Orb Container Not Starting

If the Orb container fails to start:

- Check container status: `docker ps -a`
- View container logs: `docker logs orb-sensor`
- Ensure no other services are using the required ports

### Orb Sensor Not Being Detected

If your Orb sensor is not automatically detected by the app:

- Ensure your mobile device or computer is on the same network as your Firewalla
- Verify the container is running: `docker ps`
- Restart the container: `docker-compose restart`

## Additional Resources

- For more details on running Orb with Docker, see [Install Orb on Docker](/docs/setup-sensor/docker)
- For more information about using Docker on Firewalla, see [Firewalla's Docker documentation](https://help.firewalla.com/hc/en-us/articles/360048882174-Firewalla-Tutorial-Expanding-With-Docker-Containers)
- For more details on SSH and Firewalla, see [Firewalla's SSH documentation](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH)