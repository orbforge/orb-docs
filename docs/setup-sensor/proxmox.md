---
title: Install Orb on Proxmox
shortTitle: Proxmox
metaDescription: Monitor network performance from your Proxmox virtualization host.
section: setup-sensor
layout: guides
# TODO: Add a Proxmox image URL if available, otherwise remove or use a generic Linux one
imageUrl: ../../images/devices/linux.png
subtitle: 'Difficulty: Easy 🧑‍💻'
---

# Install Orb on Proxmox

## Introduction

This guide will walk you through the process of setting up the Orb sensor on a Proxmox Virtual Environment (VE) node. Installing the Orb sensor allows you to monitor the network responsiveness and reliability of your Proxmox node from anywhere in the world using your mobile device or computer.

With the Orb sensor running on your Proxmox node, you can:

- Monitor your node's network connectivity and performance
- Track network reliability and responsiveness over time
- Receive push notifications on your Android or iOS device when your Proxmox node experiences connectivity issues

## Prerequisites

Before you begin, make sure you have:

- A running Proxmox VE instance
- Access to the Proxmox web administration interface
- The Orb app installed on your mobile device or computer (see [Install Orb](/docs/install-orb))
- Login credentials for your Proxmox node (root or a user with sudo privileges)

## Step 1: Access the Proxmox Node Shell

First, you need to access the command-line shell for the Proxmox node where you want to install Orb:

1. Navigate to your Proxmox admin interface in your web browser and log in.
2. In the left-hand server view pane, click on the specific Proxmox node you wish to install Orb on.
3. With the node selected, click the **Shell** button in the main panel. This will open a terminal window connected to your node.

## Step 2: Install Orb

Now, run the Orb installation script:

1. In the Proxmox node shell, execute the following command. This script will download and install the Orb sensor package and configure it to start automatically and receive updates:

    ```bash
    curl -fsSL https://pkgs.orb.net/install.sh | sh
    ```

2. The script will detect your operating system (Proxmox VE is based on Debian) and install the appropriate package. Follow any on-screen prompts if necessary.

## Step 3: Repeat for Other Nodes (Optional)

If you have a Proxmox cluster and want to monitor multiple nodes, repeat Step 1 and Step 2 for each node in your cluster.

## Step 4: Link Your Orb to Your Account

The final step is to link your new Orb sensor(s) to your account:

1. Open the Orb app on your mobile device or computer.
2. Your new Orb sensor(s) running on the Proxmox node(s) should be automatically detected on your local network.
3. Follow the in-app prompts to link each sensor to your Orb account.
4. Once linked, your Proxmox Orb(s) will appear in your Orb dashboard.

## Troubleshooting

### Installation Script Fails

If the `curl` command fails:

- Verify that your Proxmox node has internet connectivity. Try `ping google.com`.
- Ensure `curl` is installed. If not, run `apt update && apt install curl -y`.
- Check for any typos in the command.

### Orb Sensor Not Being Detected by the App

If your Orb sensor is not automatically detected by the app:

- Ensure that your mobile device or computer is on the same network as your Proxmox node(s).
- Check the status of the Orb service on the node: `systemctl status orb`. If it's not running, try starting it: `systemctl start orb`.
