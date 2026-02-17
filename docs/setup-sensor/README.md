---
title: Set up an Orb sensor
shortTitle: Set up an Orb sensor
metaDescription: Learn how to set up a dedicated Orb sensor on various devices and platforms.
section: setup-sensor
---

# Setup an Orb Sensor

An Orb sensor is the Orb software that continuously monitors your network connectivity. This section guides you through setting up sensors on different devices.

## Orb sensor vs. Orb app

The Orb app can be installed on phones, tablets, or computers and runs an Orb sensor while active. However, for continuous monitoring, we recommend setting up a dedicated device (like a Raspberry Pi or a spare phone) that runs an Orb sensor 24/7. You can access the information from this device through any Orb app.

## Choosing the Right Device

The best sensor device for you depends on your specific needs:

- **Always-on monitoring**: Choose a dedicated device like a Raspberry Pi or a repurposed old phone.
- **Monitoring a specific location**: Set up a sensor at that location for accurate results.
- **Quick setup**: Use your existing smartphone, tablet, or computer with the Orb app installed.
- **High reliability**: Consider a router-based sensor or a dedicated single-board computer.

## Orb Sensor Setup Guides

- [Windows](/docs/setup-sensor/windows.md)
- [macOS](/docs/setup-sensor/macos.md)
- [Linux](/docs/setup-sensor/linux) 
- [FreeBSD](/docs/setup-sensor/freebsd.md)
- [Raspberry Pi](/docs/setup-sensor/raspberry-pi.md)
- [OpenWrt](/docs/setup-sensor/linux/openwrt.md)
- [Docker](/docs/setup-sensor/docker.md)
- [Docker Multi-WAN](/docs/setup-sensor/docker-multiple-interfaces.md)
- [Podman](/docs/setup-sensor/podman.md)
- [Home Assistant](/docs/setup-sensor/home-assistant.md)
- [Proxmox](/docs/setup-sensor/proxmox.md)
- [UniFi Routers](/docs/setup-sensor/unifi-routers.md)
- [MikroTik](/docs/setup-sensor/mikrotik.md)
- [Cisco IOx](/docs/setup-sensor/cisco)
- [Firewalla](/docs/setup-sensor/firewalla.md)
- [Synology NAS](/docs/setup-sensor/synology.md)
- [QNAP NAS](/docs/setup-sensor/qnap.md)
- [Steam Deck](/docs/setup-sensor/steam-deck.md)
- [GL.iNet Brume 2](/docs/setup-sensor/gl-mt2500-standalone.md)
- [Spare iPhone](/docs/setup-sensor/spare-iphone.md)
- [Spare Android](/docs/setup-sensor/spare-android.md)
- [WLAN Pi](/docs/setup-sensor/wlan-pi.md)

## Sensor Placement

For the best results:

- Place your sensor in a location where you most commonly use the internet.
- To monitor your internet without Wi-Fi, make sure the sensor device is wired via Ethernet to your network.
- If monitoring Wi-Fi, move the sensor device around or use multiple devices to fully assess your Wi-Fi picture.
- For monitoring multiple locations, set up distinct sensors in each area.

## Multiple Sensors

You can add multiple sensors to your Orb account to monitor different networks or locations. This is particularly useful for:

- Monitoring different areas of a large home or office.
- Tracking both wired and wireless connections.
- Keeping an eye on a vacation home or remote location.
- Checking internet connectivity at home while on the go.
- Comparing home and work connectivity.

To add multiple sensors, simply follow the setup guide for each device and link them all to the same Orb account.
