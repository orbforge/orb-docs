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

# Host ID

Each instance is a separate Orb in Orb Cloud. To show which Orbs run on the same machine, every instance reports a shared **host ID**.

The first instance to start generates a random 12-character ID and saves it to `host_id` in the Orb configuration directory (by default `~/.config/orb/host_id`). That directory sits above the per-instance directories, so every instance on the machine reads the same ID.

To set the host ID yourself, for example to match an asset tag, use `ORB_HOST_ID`:

```sh
ORB_HOST_ID=rack3-probe1 orb --instance wired sensor --interface eth0
```

`ORB_HOST_ID` takes precedence over the file. Use the same value for every Orb on the machine. The value must be at most 64 characters: letters, digits, and `- . _ ~`. An invalid value is logged and no host ID is reported.

`ORB_HOST_ID` can't be scoped to one instance: `ORB_<INSTANCE>_HOST_ID` is ignored, since the ID is shared by every instance.

In Orb Cloud, the host ID appears as `host_id` on devices in the [Orb Cloud API](/docs/integrations/api). Dataset queries can select, filter, group by, or count distinct `host_id`, so instances on the same machine can be combined or counted once. Dataset records themselves don't contain it.

---

# Link each instance

```sh
orb --instance wired link
orb --instance wifi link
```

