---
title: Orb for Elgato Stream Deck
shortTitle: Stream Deck
metaDescription: Display real-time Orb network data on your Elgato Stream Deck
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb for Elgato Stream Deck

The Orb Stream Deck plugin allows you to display real-time network connectivity information directly on your Elgato Stream Deck. Monitor your Orb Score, Lag, or Latency at a glance while streaming, gaming, or working.

## Features

- Display your current Orb Score on Stream Deck (or an Orb Score component)
- Monitor network lag and latency in real-time
- Works on both Mac and Windows
- Automatic updates from your local Orb sensor

## Requirements

- Elgato Stream Deck (any model)
- Stream Deck software installed on your computer
- Orb app or sensor running on your machine or local network
- Local API must be configured (see below)

## Installation

### Step 1: Install the Orb App

If you haven't already installed Orb, download and install it for your platform:

- [Orb App](https://orb.net/get-orb)
- [Orb Sensor](/docs/setup-sensor)

### Step 2: Configure the Local API

The Stream Deck plugin requires Orb's Local API to be enabled to access network data.

For detailed instructions on configuring the Local API, see the [Datasets Configuration guide](/docs/deploy-and-configure/datasets-configuration#local-api).

:::warning
The Local API must be enabled for the Stream Deck plugin to access your Orb data. Without this, the plugin will not be able to display metrics.
:::

### Step 3: Install the Stream Deck Plugin

1. Visit the [Orb plugin page](https://marketplace.elgato.com/product/orb-10e40a4f-9022-4220-bad2-edff84f1df98) in the Elgato Marketplace
2. Click "Install" to download and install the plugin
3. The plugin will automatically be added to your Stream Deck software

Alternatively, you can install the plugin directly from the Stream Deck software:

1. Open the Stream Deck application
2. Click the "Store" icon in the bottom right
3. Search for "Orb"
4. Click "Install" on the Orb plugin

## Configuration

### Adding Orb to Your Stream Deck

1. Open the Stream Deck software
2. Locate the Orb plugin in the actions list. Two actions are available to you.
  - Show Score
  - Show Lag
3. Drag the action to a button on your Stream Deck

### Configuring an Action
1. Configure what data you want to display:
  - **Show Score** lets you pick from 4 scores:
    - **Orb Score**: Your overall connectivity quality score
    - **Responsiveness Score**: Your overall connectivity quality score
    - **Speed Score**: Your overall connectivity quality score
    - **Reliability Score**: Your overall connectivity quality score
  - **Show Latency** lets you pick from 2 metrics:
    - **Lag**: Network lag measurements
    - **Latency**: Current latency metrics

2. Specify the Orb to query for the data being displayed

By default, the plugin is configured to query a local orb running on the machine connected to the Stream Deck.
If you want to display data from an Orb running on another machine on your local network:

- Click on the Orb action in your Stream Deck configuration
- Enter the IP address or hostname of the machine running Orb. Make sure to include the port. The default local API port is 7080.
- Ensure the Local API is enabled on that remote machine

## Troubleshooting

### Plugin Shows No Data

If the Stream Deck button is not displaying Orb data:

1. Verify that Orb is running on your machine or the specified remote machine
2. Check that the Local API is enabled in Orb Cloud configuration
3. Ensure your computer and the Orb sensor are on the same local network (if using a remote Orb)
4. Try restarting the Stream Deck software

### Connection Errors

If you receive connection errors:

1. Verify the IP address or hostname is correct (for remote connections)
2. Ensure the Orb app is actively running and not in View Only mode
3. Check that port access is not blocked by your firewall or network configuration

## Support

For additional help with the Stream Deck plugin:

- Join our [Discord community](https://discord.gg/orbforge)
- Contact [support@orb.net](mailto:support@orb.net)
- Visit the [Elgato Marketplace page](https://marketplace.elgato.com/product/orb-10e40a4f-9022-4220-bad2-edff84f1df98)
