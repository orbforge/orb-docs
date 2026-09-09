---
title: Radxa E20C sensorbox build
shortTitle: Radxa E20C
metaDescription: Build a small, low-cost wired Orb sensor from a Radxa E20C.
section: sensorbox
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Radxa E20C

This guide covers installing [Sensorbox](/docs/sensorbox) on a [Radxa E20C](https://radxa.com/products/network-computer/e20c/), allowing you to deploy pre-configured, robust 1 GbE Orbs.

## Why the Radxa E20C?

The E20C is a compact single-board computer that makes a capable always-on sensor:

- **1 GbE** Ethernet
- **Mainline OpenWrt** means no vendor forks
- **eMMC and SD card slot** for flexible storage options
- Very small footprint


### Steps

1. Follow the [instructions](https://github.com/orbforge/sensorbox) on the sensorbox GitHub repo to clone the repo, install prerequisites, configure the environment, and stand up the sensorbox stack.
2. Once sensorbox is running, visit `http://localhost:8080/` in your browser.
3. Under "Device", select "Radxa E20C"
4. In "Orb Deployment Token", enter your [Deployment Token](/docs/deploy-and-configure/deployment-tokens) from Orb Cloud.
5. Set a "Root Password"
6. Most E20C devices come with onboard eMMC. Select the "Install to onboard eMMC on first boot" option to burn sensorbox to eMMC
7. Click "Build"
8. When the build completes, download the image.
9. Insert a blank SD card into your computer.
10. Use Raspberry Pi Imager, Balena Etcher, or the included scripts in the `scripts` folder to write your sensorbox image to the SD card.
11. Insert the SD card into the E20C. Connect an ethernet cable to either of the E20C's ports, and connect the other end to your network.
12. Connect power to your E20C.
13. sensorbox is now booting from the SD card and will write the image to the E20C's built-in eMMC. Once the process is complete, all of the green LEDs on the front of the device will pulse on and off continuously. Remove power, remove the SD card.
14. Reconnect the sensorbox to power and confirm it is linked in Orb Cloud.
