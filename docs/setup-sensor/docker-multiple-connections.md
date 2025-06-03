---
title: Measuring multiple connections
shortTitle: Multiple Connections
metaDescription: Run the Orb sensor in a setup with multiple connections
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/docker.png
subtitle: 'Difficulty: Advanced 🧑‍🔬'
---

# Installing multiple Orbs to monitor multiple connections

## Introduction

On a device with multiple subnets and gateways, you can configure multiple orbs to measure each connection simultaneously. For this setup we're going to be using Docker on Linux. This guide will show you how to configure Orb in a multi-sensor setup, using [Docker](https://www.docker.com/) and the `macvlan` driver.

This guide assumes you have Docker and Docker Compose already installed and running on your host system.

## Prerequisites

Before you begin, make sure you have:

- A host machine with Docker installed and running. See the official [Docker installation guides](https://docs.docker.com/engine/install/). We're using the `macvlan` module. This module is currently only available on linux. But depending on your setup, it is possible to use the default network module, and skip the `macvlan` module in the config below.
- All interfaces should be available for use on the host.
- Subnet and gateway information for each network you want to monitor.
- Docker Compose installed. See the [Docker Compose installation guide](https://docs.docker.com/compose/install/).
- Good familiarity with using the command line or terminal on your host system.
- Your host machine must be physically connected to the networks you wish to monitor.

## Step 1: Prepare the Docker Compose file

1.  Create a file named `docker-compose.yml` in a working directory.
2.  Paste the following content exactly into the `docker-compose.yml` file:

    ```yaml
    services:
    
      orb_primary:
        image: orbforge/orb:latest
        container_name: orb-primary-isp
        hostname: orb-primary-isp
        restart: always
        labels:
          - "com.centurylinklabs.watchtower.enable=true"
          - "com.centurylinklabs.watchtower.scope=orb"
        networks:
          isp_primary:
            # optional, if you need to set a static ip, this is the place to do it
            # if not, it will just use dhcp by default
            # ipv4_address: 10.0.10.50
            # ipv6_address: 
        # optional: set a mac address
        # mac_address: '02:42:0A:00:01:AA'
        cap_add:
          - NET_RAW
        volumes:
          - primary_isp_data:/root/.config/orb

	   # you can add as many orb sensors as you want to test for
      orb_secondary:
        image: orbforge/orb:latest
        container_name: orb-secondary-isp
        hostname: orb-secondary-isp
        restart: always
        labels:
          - "com.centurylinklabs.watchtower.enable=true"
          - "com.centurylinklabs.watchtower.scope=orb"
        networks:
          isp_secondary:
            ipv4_address: 10.0.20.50
        # mac_address: '02:42:0A:00:01:BB'
        cap_add:
          - NET_RAW
        volumes:
          - secondary_isp_data:/root/.config/orb

      watchtower:
        image: containrrr/watchtower
        container_name: watchtower
        restart: unless-stopped
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
        command: --label-enable --scope orb --interval 86400

    networks:
      isp_primary:
        driver_opts:
          parent: enp8s0f1  # the interface you want to monitor
  
      isp_secondary:
        driver: macvlan  # if the host interfaces have their own gateways already setup, you can skip this driver
        driver_opts:
          parent: enp9s0f1 # the 2nd interface you want to monitor
  
    volumes:
      primary_isp_data:
      secondary_isp_data:
    ```

    **Explanation:**

    - `orb_primary/orb_secondary`: Defines the Orb services, add as many as you want to monitor
      - `image: orbforge/orb:latest`: Uses the official Orb Docker image.
      - `volumes:`: Stores Orb's configuration persistently in a Docker volume. Each service/connection needs it's own volume
      - `restart: always`: Keeps the Orb container running.
      - `labels`: Used by Watchtower to know this container should be auto-updated.
    - `watchtower`: (Optional but recommended) Defines the Watchtower service to automatically update the Orb container when new images are published.
    - `volumes:`: Sets up different volumes for each Orb container, so each get's it's own config.

## Step 2: Start the Orb Container

1.  Make sure you are still in the directory containing your `docker-compose.yml` file in your terminal.
2.  Run the following command to download the Orb image (if you don't have it) and start the container(s) in the background:
    ```bash
    docker-compose up -d
    ```
3.  Docker Compose will pull the necessary images (`orbforge/orb` and `containrrr/watchtower`) and start the containers. You can check the status with:
    ```bash
    docker-compose ps
    ```
    You should see containers for each sensor you have configured.

## Step 3: Link your new Orb sensors

As the instances are all running inside their own network, zeroconf discovery is unreliable. Instead, use the `orb link` command to link each sensor to your account:

1. For each sensor, run this command:
```
docker exec [name-of-container] /app/orb link
# ie:
# docker exec orb_primary /app/orb link
```

The output will be something like:
```
docker exec -ti orb-primary-isp /app/orb link
2025/05/29 07:46:55 INFO Orb ID orbID=123p5x7xmehfs456xyzs83uqwff
To link your device, visit the following URL in a web browser and log into your Orb account:
Device link: https://orb.net/v/xyz (expires May 7 13:37)
```

2. Follow that link to add the sensor to your account. Repeat for each sensor.
3. Check the Orb app on your phone or computer. Your new Docker-based Orb sensor should now be visible and ready to use.

## You're Done! 🥳