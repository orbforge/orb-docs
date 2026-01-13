---
title: Installing Orb using Docker
shortTitle: Docker
metaDescription: Deploy the Orb sensor as a Docker container on servers, NAS devices, or any Docker-capable system.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/docker.png
subtitle: 'Difficulty: Intermediate 🧑‍🔬'
---

# Installing Orb using Docker

## Introduction

[Docker](https://www.docker.com/) allows you to run applications in isolated environments called containers. This guide shows you how to run the Orb sensor as a Docker container using Docker Compose, which makes managing multi-container Docker applications easier. This method is suitable for running Orb on various systems like servers, firewalls, routers, NAS devices (Synology, QNAP), or personal computers that have Docker installed.

This guide assumes you have Docker and Docker Compose already installed and running on your host system.

## Prerequisites

Before you begin, make sure you have:

- A host machine with Docker installed and running. See the official [Docker installation guides](https://docs.docker.com/engine/install/).
- Docker Compose installed. See the [Docker Compose installation guide](https://docs.docker.com/compose/install/).
- Basic familiarity with using the command line or terminal on your host system.
- Your host machine must be connected to the network you wish to monitor.

:::warning
macOS and Windows are not currently supported for auto-discovery and local-network latency due to limitations in Docker's "host network" capability on these systems. We recommend using the Orb apps for macOS and Windows.
:::

## Quick install

If you'd like to run Orb with auto-updates and don't want to get into the details, run this command in a fresh directory:

```bash
curl -fsSL https://orb.net/docs/scripts/docker/docker-compose.yml -o docker-compose.yml && docker-compose up -d
```

Otherwise, read on!

## Step 1: Prepare the Docker Compose file

1. Create a file named `docker-compose.yml` in this directory.
2. Paste the one of the following content blocks exactly into the `docker-compose.yml` file:

  a. `docker-compose.yml` with [WUD](https://getwud.github.io/wud) for auto-update (**recommended**)
```yaml
services:
  orb-docker:
    image: orbforge/orb:latest
    container_name: orb-sensor # Optional: Give the container a specific name
    network_mode: host # Optional: alternatively you can use 'bridge' mode and map ports :7443 and :5353
    volumes:
      - orb-data:/root/.config/orb # Persists Orb configuration
    restart: always # Ensures Orb restarts if it stops or on system reboot
    labels:
      - "wud.watch=true"
      - "wud.trigger.include=docker.orb"
    #
    # Optional: Limit resources if needed
    #
    # deploy:
    #   resources:
    #     limits:
    #       memory: 512m

  wud:
    image: ghcr.io/getwud/wud
    container_name: wud
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WUD_WATCHER_LOCAL_WATCHBYDEFAULT=false
      - WUD_TRIGGER_DOCKER_ORB_AUTO=true
      - WUD_TRIGGER_DOCKER_ORB_PRUNE=true
    #
    # Optional: expose WUD web interface (default host port 3000, adjust as needed)
    #
    # ports:
    #  - "3000:3000"

volumes:
  orb-data: # Creates a named volume for persistent data
```

  b. `docker-compose.yml` without auto-update (**please ensure some orchestration or process exists to update Orb regularly**)
```yaml
services:
  orb-docker:
    image: orbforge/orb:latest
    container_name: orb-sensor # Optional: Give the container a specific name
    network_mode: host # Optional: alternatively you can use 'bridge' mode and map ports :7443 and :5353
    volumes:
      - orb-data:/root/.config/orb # Persists Orb configuration
    restart: always # Ensures Orb restarts if it stops or on system reboot
    #
    # Optional: Limit resources if needed
    #
    # deploy:
    #   resources:
    #     limits:
    #       memory: 512m

volumes:
  orb-data: # Creates a named volume for persistent data
```
    **Explanation:**

    - `orb-docker`: Defines the main Orb service.
      - `image: orbforge/orb:latest`: Uses the official Orb Docker image.
      - `network_mode: host`: **Crucial** for Orb to monitor network traffic directly from the host's network interfaces.
      - `volumes: - orb-data:/root/.config/orb`: Stores Orb's configuration persistently in a Docker named volume (`orb-data`).
      - `restart: always`: Keeps the Orb container running.
      - `labels`: Used by WUD to know this container should be auto-updated.
    - `wud`: (Optional but recommended) Defines the WUD service to automatically update the Orb container when new images are published.
    - `volumes: orb-data:`: Declares the named volume used by the `orb-docker` service.

## Step 2: Start the Orb Container

1. Make sure you are still in the directory containing your `docker-compose.yml` file in your terminal.
2. Run the following command to download the Orb image (if you don't have it) and start the container(s) in the background:

    ```bash
    docker-compose up -d
    ```

:::warning
Depending on your Docker version, you may need to use "`docker compose`" rather than "`docker-compose`".
:::

3. Docker Compose will pull the necessary images (`orbforge/orb` and `ghcr.io/getwud/wud`) and start the containers. You can check the status with:

    ```bash
    docker-compose ps
    ```

    You should see `orb-sensor` (or `orb-docker` if you didn't set `container_name`) and `wud` with state `Up`.
4. You can view the logs for the Orb container using:

    ```bash
    docker-compose logs orb-docker # Or use 'orb-sensor' if you set container_name
    ```

## Step 3: Link your new Orb sensor

### Device on the same network

If your Docker container is running on the same network as your phone or computer and your network supports Bonjour/zeroconf, you can link it to your account using the Orb app.

1. Once the Orb container is running, it should start broadcasting its presence on your network.
2. Open the Orb app on your phone or personal computer (which must be on the same network).
3. Your new Docker-based Orb sensor should be automatically detected and appear in the app, ready to be linked to your account. Follow the prompts in the app to link it.

### Device on a different network

If your docker container is running on a different network than your phone or computer, you can still link it to your account, but you'll need to do it manually via the Orb CLI in the docker container.

1. Open a terminal on the host machine where the Docker container is running.
2. Run the following command to run the Orb CLI "link" command inside the running container:

    ```bash
    docker exec -it <replace-with-container-name-or-id> /app/orb link
    ```

   Replace `<replace-with-container-name-or-id>` with the name or ID of your running Orb container (e.g., `orb-sensor` or `orb-docker`).
3. The output of that command will give you a short URL. Copy or type that URL into the browser on your phone or computer and login with the same account you use on other Orb devices.
4. Check the Orb app on your phone or computer. Your new Docker-based Orb sensor should now be visible and ready to use.

## You're Done

Congratulations! Your Docker container is now running as an Orb sensor, monitoring your network. Thanks to WUD, it will automatically update when new versions are released.

## Troubleshooting

- **Orb Not Detected:**
  - Ensure the container is running (`docker-compose ps`).
  - Verify `network_mode: host` is set in your `docker-compose.yml`. This is the most common issue. Without host networking, Orb cannot see network traffic or broadcast correctly.
  - Check the container logs (`docker-compose logs orb-docker`) for any errors.
  - Ensure your host machine's firewall is not blocking mDNS/Bonjour traffic (UDP port 5353).
  - Make sure the device running the Orb app is on the _exact same_ network/subnet as the Docker host machine.
- **Permission Errors (especially volume mounts):**
  - Using Docker named volumes (`orb-data:` in the example) usually avoids permission issues compared to bind-mounting host directories. If you switched to bind mounts, ensure Docker has the correct permissions to write to the host directory.
- **Auto-update Issues:**
  - Check WUD logs: `docker-compose logs wud`.
  - Ensure the Docker socket is correctly mounted (`/var/run/docker.sock:/var/run/docker.sock`).
- **Stopping Orb:**
  - Navigate to the directory containing `docker-compose.yml` and run `docker-compose down`.
- **Updating Orb Manually (if not using WUD):**
  - Navigate to the directory containing `docker-compose.yml`.
  - `docker-compose pull orb-docker` (pulls the latest image).
  - `docker-compose up -d` (recreates the container with the new image).
