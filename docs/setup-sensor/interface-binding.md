---
title: Binding Orb to a specific network interface
shortTitle: Interface Binding
metaDescription: Bind an Orb sensor to a specific network interface and run multiple isolated sensor instances side by side on the same host.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/linux.png
subtitle: 'Difficulty: Advanced 🧑‍🔬'
---

# Binding Orb to a specific network interface

## Introduction

On a Linux or macOS host with more than one network interface (multiple NICs, or VLAN subinterfaces), Orb can be bound to a single interface using `--interface`. Combined with `--instance`, this allows multiple sensors to run on the same host, each measuring a different interface with its own isolated identity in Orb Cloud.

Interface binding and named instances require Orb sensor version 1.5.6 and above.

**Note:** `--interface` is only implemented on Linux and macOS.

:::warning
This features is experimental, and not yet intended for production environments. We appreciate your testing and feedback. Please use our [Help & Support](https://orb.net/support) page or [Discord](https://discord.gg/orbforge) to report issues and ask questions.
:::

## Prerequisites

- A Linux or macOS host with the interfaces to be measured already configured (DHCP or static, VLAN subinterfaces, etc.)
- The `orb` CLI installed
- The interface names, as reported by `ip addr` (Linux) or `ifconfig` / `networksetup -listallhardwareports` (macOS)

---

# Bind a sensor to a network interface

Add `--interface` to the `sensor` subcommand to restrict a sensor's measurements to one interface:

```sh
orb sensor --interface eth0
```

---

# Run multiple bound sensors on the same host

Give each `orb sensor --interface ...` process its own identity with `--instance`:

```sh
orb --instance wired sensor --interface eth0
orb --instance wifi sensor --interface wlan0
```

---

# Instance-specific environment variables

Some [environment variables](/docs/deploy-and-configure/configuration#environment-variables) can be scoped to a single instance by prefixing the variable name with `ORB_<INSTANCE>_`, using the instance name in uppercase. For example, with `--instance wired`:

```sh
ORB_WIRED_FIRSTHOP_DISABLED=1 orb --instance wired sensor --interface eth0
```

sets `ORB_FIRSTHOP_DISABLED` for the `wired` instance only.

---

# Link each instance

```sh
orb --instance wired link
orb --instance wifi link
```

