---
title: Install Orb on Cisco IOx
shortTitle: Cisco IOx
metaDescription: Monitor network performance from Cisco switches, routers, access points, and IoT edge devices using IOx Application Hosting.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Advanced'
---

# Install Orb on Cisco IOx

:::warning
This documentation is in beta and intended for advanced users. If you encounter issues or have questions, please reach out to [support@orb.net](mailto:support@orb.net) or join our [Discord community](https://discord.gg/orbforge).
:::

## Introduction

This guide covers installing the Orb sensor on Cisco devices that support IOx Application Hosting. IOx enables you to run containerized applications directly on Cisco infrastructure, making it ideal for deploying network monitoring sensors at the edge.

With Orb running on your Cisco IOx devices, you can:

- Monitor network responsiveness and reliability from switches, routers, access points, and IoT gateways.
- Deploy sensors at the network edge without additional hardware.
- Track connectivity issues from the perspective of your Cisco infrastructure.
- Receive push notifications when your devices experience network problems.

## Compatibility

Orb on Cisco IOx requires devices running IOS XE with IOx support. The following device families are supported:

### Catalyst Access Points (ARM64)

| Device | Architecture | Notes |
|--------|--------------|-------|
| C9105AXI/W | aarch64 | Requires Catalyst Center or ioxclient |
| C9115AX | aarch64 | Requires Catalyst Center or ioxclient |
| C9117AX | aarch64 | Requires Catalyst Center or ioxclient |
| C9120AX | aarch64 | Requires Catalyst Center or ioxclient |
| C9130AX | aarch64 | Requires Catalyst Center or ioxclient |
| C9124AX | aarch64 | Requires Catalyst Center or ioxclient |
| C9136I | aarch64 | Requires Catalyst Center or ioxclient |
| C9162I | aarch64 | Requires Catalyst Center or ioxclient |
| C9164I | aarch64 | Requires Catalyst Center or ioxclient |
| C9166I/D1 | aarch64 | Requires Catalyst Center or ioxclient |

### Catalyst Switches (x86_64)

| Device | Architecture | Notes |
|--------|--------------|-------|
| Catalyst 9300/9300-X | x86_64 | IOx Local Manager supported |
| Catalyst 9400 | x86_64 | IOx Local Manager supported |
| Catalyst 9500H | x86_64 | IOx Local Manager supported |
| Catalyst 9600 | x86_64 | IOx Local Manager supported |

### Industrial Routers and IoT Gateways

| Device | Architecture | Notes |
|--------|--------------|-------|
| IR1101 | aarch64 | IOx Local Manager supported |
| IR1821/IR1831/IR1833 | aarch64 | IOx Local Manager supported |
| IR1835 | aarch64 | IOx Local Manager supported |
| IR8140 | aarch64 | IOx Local Manager supported |
| IR8340 | x86_64 | IOx Local Manager supported |
| IE3300/IE3400 | aarch64 | IOx Local Manager supported |
| IE9300 | aarch64 | IOx Local Manager supported |

### ISR Routers (x86_64)

| Device | Architecture | Notes |
|--------|--------------|-------|
| ISR 4331 | x86_64 | IOx Local Manager supported |
| ISR 4351 | x86_64 | IOx Local Manager supported |
| ISR 4451 | x86_64 | IOx Local Manager supported |

:::note
For the complete and current platform support matrix, see [Cisco's IOx Platform Support Matrix](https://developer.cisco.com/docs/iox/platform-support-matrix/).
:::

## Installation Methods

Choose the installation method that best fits your environment:

| Method | Best For | Guide |
|--------|----------|-------|
| [ioxclient](/docs/setup-sensor/cisco/ioxclient) | Catalyst 9000 APs, developers, CLI workflows | Recommended for AP deployments |
| [IOx Local Manager](/docs/setup-sensor/cisco/iox-local-manager) | Switches, routers, single-device deployments | Web-based GUI |
| [Catalyst Center](/docs/setup-sensor/cisco/catalyst-center) | Large-scale AP deployments, enterprise networks | Centralized management |

## Prerequisites

Before you begin, ensure you have:

- A compatible Cisco device with IOx support enabled
- IOS XE 17.3.1 or later (for APs) or IOS XE 16.12.1 or later (for switches/routers)
- Network connectivity from the device to the internet
- An Orb account with a [deployment token](/docs/deploy-and-configure/deployment-tokens)

## Environment Variables

All installation methods require setting these environment variables in your package configuration:

| Variable | Required | Description |
|----------|----------|-------------|
| `ORB_DEPLOYMENT_TOKEN` | Yes | Your Orb deployment token for automatic linking |
| `ORB_EPHEMERAL_MODE` | Yes | Set to `1` to prevent excessive flash writes |
| `ORB_CONFIG_DIR` | Yes | Set to `/data` for persistent storage |
| `ORB_DATA_DIR` | Yes | Set to `/data` for persistent storage |
| `ORB_FIRSTHOP_DISABLED` | Optional | Set to `1` to disable first-hop monitoring |
| `ORB_BANDWIDTH_DISABLED` | Optional | Set to `1` to disable bandwidth tests on constrained devices |

:::warning
Always enable ephemeral mode (`ORB_EPHEMERAL_MODE=1`) on Cisco IOx devices to minimize flash storage writes and extend device lifespan.
:::

## Additional Resources

- [Cisco IOx Developer Documentation](https://developer.cisco.com/docs/iox/)
- [IOx Local Manager Guide](https://developer.cisco.com/docs/iox/iox-local-manager/)
- [Catalyst Center Application Hosting Guide](https://www.cisco.com/c/en/us/products/collateral/wireless/access-points/guide-c07-744305.html)
- For alternative installation methods, see [Install Orb on Docker](/docs/setup-sensor/docker)
