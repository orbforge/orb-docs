---
title: Install Orb on QNAP NAS
shortTitle: QNAP NAS
metaDescription: Install the Orb sensor on your QNAP NAS using Container Station for network monitoring.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Install Orb on QNAP NAS

## Introduction

This guide will walk you through setting up the Orb sensor on your QNAP NAS using Container Station. The Orb sensor allows you to monitor your NAS's network connectivity and performance from anywhere in the world.

With the Orb sensor running on your QNAP NAS, you can:

- Monitor your NAS's network connectivity and performance
- Track network reliability and responsiveness over time
- Receive push notifications when your NAS experiences connectivity issues

## Prerequisites

Before you begin, make sure you have:

- Container Station installed on your QNAP NAS
- Administrator access to your QNAP NAS
- The Orb app installed on your mobile device or computer (see [Install Orb](/docs/install-orb))

## Step 1: Open Container Station

First, access the Container Station application:

1. Open your QNAP interface in a web browser.
2. Open the **Container Station** application from the main menu.

## Step 2: Search & Create the Orb Container

In Container Station:

1. Navigate to the **Containers** option on the left-hand side.
2. Click the **Create** button.
3. In the **Image** field, enter **orbforge/orb**.
4. Give the container a name.

## Step 3: Configure Network Settings

The Orb sensor requires host network mode to function properly:

1. In the container configuration where you name the container, find **Advanced Settings** at the bottom left.
2. Click **Networks** in the left-hand side menu.
3. Select **Custom** for the Network mode.
4. In the drop-down, select **Host**.
5. Select **Apply**.
6. This allows the container to access your network directly.

## Step 4: Start the Container

Now you're ready to launch the Orb sensor:

1. Review your settings to ensure the network mode is set to Host.
2. Click **Finish** to start the container.
3. Orb should now be running on your QNAP NAS.

## Step 5: Link Your Orb to Your Account

The final step is to link your new Orb sensor to your account:

1. Open the Orb app on your mobile device or computer.
2. Your new Orb sensor should be automatically detected on your local network.
3. Follow the in-app prompts to link the sensor to your Orb account.
4. Once linked, your QNAP Orb will appear in your Orb dashboard.

## Troubleshooting

### Container Fails to Start

If the container fails to start:

- Verify you selected "Host" network mode in the settings.
- Check that no other services are using the required ports.
- Review the container logs for error messages.

### Orb Sensor Not Being Detected

If your Orb sensor is not automatically detected by the app:

- Ensure your mobile device or computer is on the same network as your QNAP NAS.
- Check that the container is running in Container Station.
- Restart the container and try again.
- Verify your NAS firewall settings aren't blocking the discovery process.

### Performance Considerations

Running Orb on your QNAP NAS has minimal impact on performance. The sensor uses very few resources and won't interfere with your NAS's primary functions like file serving or media streaming.
