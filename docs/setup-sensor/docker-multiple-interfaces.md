---
title: Measuring multiple network interfaces (or VLANs)
shortTitle: Multiple Interfaces (or VLANs)
metaDescription: Monitor multiple network interfaces or VLANs simultaneously using separate Docker containers.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/docker.png
subtitle: 'Difficulty: Advanced 🧑‍🔬'
---

# Measuring multiple network interfaces (or VLANs)

## Introduction

On a device or VM with multiple networks (multiple physical network interfaces and/or multiple VLANs), you can run separate Orb sensors in Docker, each one monitoring a different network continuously.

This guide shows how to configure multiple Orb sensors in Docker, where each container attaches to a separate VLAN or network interface and receives its own DHCP lease. This allows a single VM or host to measure multiple network connections independently.

This guide uses:

- Docker + Docker Compose
- Linux host system
- VLAN subinterfaces on the host
- Docker’s `macvlan` network driver

## Prerequisites

Before continuing, ensure you have:

- A Linux host (physical or VM) with Docker installed
- Docker Compose installed
- Multiple network interfaces OR a network interface receiving one or more **802.1Q VLAN tags**
- Basic Linux command-line experience
- Physical connectivity to each network you want to monitor

---

# Prepare VLAN Subinterfaces on the Host (skip if you're not using VLANs)

If the host receives an 802.1Q trunk carrying multiple VLANs, you can create a subinterface for each VLAN.  
Later, we'll attach Orb sensor containers to these subinterfaces the same way we would attach them to a physical interface.

## Identify physical network interface (NIC)

Before creating VLAN subinterfaces, you must determine which physical network interface on your host is receiving the VLAN trunk (the tagged networks).

```sh
ip addr
```

Look for the interface that has your host’s primary IP address (e.g., your management LAN IP).

This is usually one of:

- `ens18`
- `eth0`
- `enp3s0`
- `eno1`

or similar.

Example output:

```sh
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qlen 1000
    link/ether bc:24:11:5d:30:3e brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.141/24 brd 192.168.1.255 scope global dynamic ens18
       valid_lft 85466sec preferred_lft 85466sec
```

In this example, the physical NIC is `ens18`.

## Create subinterfaces for each VLAN

These subinterfaces allow the host (and later Docker) to interact with each tagged VLAN independently.

Each VLAN subinterface is created using the naming pattern:

```
<physical-NIC>.<vlan-id>
```

For example:

- VLAN 10 → `ens18.10`
- VLAN 20 → `ens18.20`
- VLAN 30 → `ens18.30`

Create the subinterfaces:

```sh
sudo ip link add link ens18 name ens18.10 type vlan id 10
sudo ip link add link ens18 name ens18.20 type vlan id 20
sudo ip link add link ens18 name ens18.30 type vlan id 30
```

Bring each interface online:

```sh
sudo ip link set ens18.10 up
sudo ip link set ens18.20 up
sudo ip link set ens18.30 up
```

Verify that the VLAN interfaces are active:

```sh
ip addr show ens18.10
ip addr show ens18.20
ip addr show ens18.30
```

When working correctly, each subinterface will appear with:

- A valid MAC address
- A state of `UP`
- A `BROADCAST,MULTICAST` capability set
- (Optionally) an assigned DHCP IP if you tested with dhclient

Example (VLAN 10):

```sh
3: ens18.10@ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    link/ether bc:24:11:5d:30:3e brd ff:ff:ff:ff:ff:ff
```

If the interface is missing or shows as DOWN, double-check:

- The VLAN ID is correct
- The switch/router port is configured as a trunk
- You created the subinterface using the correct parent NIC (`ens18` in this example)

Once these VLAN subinterfaces are active, Docker can bind `macvlan` networks to them—allowing each container to receive a DHCP lease on its own VLAN.

## (Optional) Test VLAN connectivity using DHCP

Before moving on, you may want to verify that each VLAN subinterface can successfully communicate with its upstream network and receive a DHCP lease. Docker and the Orb containers do **not** require `dhclient` on the host. This step is only to validate your network trunking before involving Docker.

This step confirms:

1. The switch/router trunk is configured correctly
2. The VLAN ID is correct
3. DHCP is enabled on each VLAN
4. The host can reach the correct gateway on that VLAN

Test each interface by requesting a DHCP lease directly on the host:

```sh
sudo dhclient ens18.10
sudo dhclient ens18.20
sudo dhclient ens18.30
```

If the VLAN is configured properly, each command should result in a valid IP being assigned. For example:

```
inet 192.168.154.141/24 brd 192.168.154.255 scope global dynamic ens18.10
```

Check:

```sh
ip addr show ens18.10
```

If `dhclient` hangs, fails, or the interface remains without an IP address:

- Ensure the switch port is set to trunk/tagged mode
- Verify the DHCP server is active for that VLAN
- Confirm the correct VLAN ID is being used
- Ensure nothing upstream filters DHCP packets (UDP 67/68)

---

# Set up your Docker Compose workspace

Create a Docker Compose project folder to hold your `docker-compose.yml` and supporting files.  
You can name this project anything you want.

You'll end up with a project directory like this:

```
<your-project-folder>/
├── docker-compose.yml
├── orb-entrypoint.sh
└── udhcpc-script.sh
```

## Create DHCP Hook Script

Each Orb container needs a DHCP client so it can obtain and renew its VLAN-specific IP address. Orb’s container image is based on Alpine Linux and includes `udhcpc`, but the lease must be applied via a custom hook script we need to add.

Create a file named `udhcpc-script.sh`:

```sh
#!/bin/sh

case "$1" in
  bound|renew)
    ip addr flush dev "$interface" 2>/dev/null || true
    ip addr add "$ip"/"$mask" dev "$interface"
    ip route del default 2>/dev/null || true
    ip route add default via "$router" dev "$interface"
    echo "nameserver $dns" > /etc/resolv.conf
    ;;
esac
```

Make executable:

```sh
chmod +x udhcpc-script.sh
```

---

## Create Orb Entrypoint Script

We override the default container entrypoint so that DHCP runs first, then the Orb sensor starts normally.

Create a file named `orb-entrypoint.sh`:

```
#!/bin/sh
set -e

# Acquire DHCP lease; udhcpc then daemonizes for ongoing renewals.
udhcpc -i eth0 -s /udhcpc-script.sh -R

# Start Orb
exec /app/orb sensor
```

Make executable:

```sh
chmod +x orb-entrypoint.sh
```

---

## Create the Docker Compose File

Each Orb instance runs on its own macvlan network.  
Because Docker requires an IPAM subnet even when using DHCP, we use **TEST-NET placeholder ranges** defined in RFC 5737.

Docker uses these TEST-NET ranges only to satisfy macvlan’s IPAM requirement. The Orb containers will receive their **real** IP addresses from your actual DHCP server.

This example creates 3 Orb containers, each attached to a different VLAN subinterface:

- `ens18.10`
- `ens18.20`
- `ens18.30`

You may add as many containers as needed, as long as each macvlan network’s `parent` maps to a valid interface or VLAN subinterface.

Create `docker-compose.yml`:

```yaml
services:
  orb_vlan10:
    image: orbforge/orb:latest
    container_name: orb_vlan10
    entrypoint: ['/orb-entrypoint.sh']
    volumes:
      - ./orb-entrypoint.sh:/orb-entrypoint.sh:ro
      - ./udhcpc-script.sh:/udhcpc-script.sh:ro
    cap_add: ['NET_ADMIN']
    networks: ['vlan10']
    restart: unless-stopped

  orb_vlan20:
    image: orbforge/orb:latest
    container_name: orb_vlan20
    entrypoint: ['/orb-entrypoint.sh']
    volumes:
      - ./orb-entrypoint.sh:/orb-entrypoint.sh:ro
      - ./udhcpc-script.sh:/udhcpc-script.sh:ro
    cap_add: ['NET_ADMIN']
    networks: ['vlan20']
    restart: unless-stopped

  orb_vlan30:
    image: orbforge/orb:latest
    container_name: orb_vlan30
    entrypoint: ['/orb-entrypoint.sh']
    volumes:
      - ./orb-entrypoint.sh:/orb-entrypoint.sh:ro
      - ./udhcpc-script.sh:/udhcpc-script.sh:ro
    cap_add: ['NET_ADMIN']
    networks: ['vlan30']
    restart: unless-stopped

networks:
  vlan10:
    driver: macvlan
    driver_opts:
      parent: ens18.10
    ipam:
      config:
        - subnet: 192.0.2.0/24
          gateway: 192.0.2.1

  vlan20:
    driver: macvlan
    driver_opts:
      parent: ens18.20
    ipam:
      config:
        - subnet: 198.51.100.0/24
          gateway: 198.51.100.1

  vlan30:
    driver: macvlan
    driver_opts:
      parent: ens18.30
    ipam:
      config:
        - subnet: 203.0.113.0/24
          gateway: 203.0.113.1
```

---

# Start the Orb Containers

From your project directory:

```sh
docker compose up -d
```

Check status:

```sh
docker compose ps
```

Each container will:

1. Start
2. Run udhcpc to obtain its VLAN-specific DHCP lease
3. Apply IP/route/DNS via the hook script
4. Launch the Orb sensor
5. Renew its DHCP lease automatically over time

---

# Confirm the DHCP Lease

Check the assigned address:

```sh
docker exec -it orb_vlan10 ip addr
```

You should see a valid DHCP address from VLAN 10.

Repeat for the other containers.

---

# (Optional) Link Each Orb Sensor to an Orb Account

These Orbs can be linked to your Orb account like any other Orb device. It may be easiest to link them now via the CLI, since each Orb runs on a separate network and may not be directly accessible from your current device.

Alternatively, you can use a Deployment Token via the container’s `environment:` section to automatically link at startup.

Link manually:

```sh
docker exec -it orb_vlan10 /app/orb link
docker exec -it orb_vlan20 /app/orb link
docker exec -it orb_vlan30 /app/orb link
```

Follow the link provided in each command’s output to associate the sensor with your Orb account.

---

# You're Done! 🥳

You now have multiple Orb sensors running in Docker on a single host or VM, each bound to a unique VLAN or network interface, each obtaining its own DHCP-assigned IP address.

This is the recommended solution for environments where a single machine must measure multiple independent networks.
