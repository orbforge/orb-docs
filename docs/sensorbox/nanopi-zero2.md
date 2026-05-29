---
title: NanoPi Zero2 Hardware Build
shortTitle: NanoPi Zero2
metaDescription: Build a small, low-cost dedicated Orb sensor from a FriendlyElec NanoPi Zero2, with an optional eMMC and Wi-Fi 7 upgrade.
section: sensorbox
layout: guides
subtitle: 'Difficulty: Advanced 🛠️'
---

# NanoPi Zero2 Hardware Build

This guide covers assembling a [FriendlyElec NanoPi Zero2](https://www.friendlyelec.com/index.php?route=product/product&product_id=304) into a small, low-cost dedicated Orb sensor. Once the hardware is assembled, build and flash an image for it with [Sensorbox](/docs/sensorbox).

## Why the NanoPi Zero2

The NanoPi Zero2 is a compact single-board computer that makes a capable always-on sensor:

- **1 GbE** Ethernet
- **M.2 Key E** slot for an internal Wi-Fi card
- **USB-C OTG**
- Very small footprint

## Bill of materials

| Item |
| --- |
| Device + case (includes shipping) |
| 64 GB eMMC (optional) |
| **Wi-Fi 7 upgrade (optional):** |
| Intel BE200 |
| 6 GHz antennas |
| 0.5 mm thermal pad |

The eMMC and Wi-Fi 7 upgrade are both optional. A basic build that relies on Ethernet or the stock wireless costs considerably less.

## Optional: Wi-Fi 7 upgrade

If you want Wi-Fi 7, you'll install an Intel BE200 card in the M.2 Key E slot. The stock antennas do not reliably support 6 GHz, so you'll also need new antennas. These have been tested and work: [Leankon dipole flex Wi-Fi 6E antennas](https://www.leankon.com/product/dipole-flex-bluetooth-wifi-6e-antenna/).

:::warning
A **0.5 mm thermal pad** on the BE200 is required — don't skip it. The card needs the pad to transfer heat to the case and run reliably.
:::

### Steps

1. Remove the stock antennas.
2. Install the new 6 GHz antennas in the same locations.
3. Install the Intel BE200 card in the M.2 Key E slot.
4. Add the 0.5 mm thermal pad to the BE200.
5. Route the antenna wires and attach them to the BE200.
6. Close the case.

## Build the sensor image

With the hardware assembled, follow the [Sensorbox guide](/docs/sensorbox) to build and flash an OpenWrt-based Orb sensor image for the NanoPi Zero2. Select the NanoPi Zero2 in the configurator, provide your Wi-Fi credentials, and flash the resulting image to your SD card or eMMC.
