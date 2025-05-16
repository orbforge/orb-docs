---
title: Installing Orb on WLAN Pi
shortTitle: WLAN Pi
metaDescription: Install the Orb sensor on your WLAN Pi device using a simple command.
section: setup-sensor
layout: guides
imageUrl: ../../images/devices/raspberry-pi.png
subtitle: 'Difficulty: Easy 🧑‍💻'
---

# Installing Orb on WLAN Pi

## Introduction

The [WLAN Pi](https://www.wlanpi.com/) is a popular multi-tool for Wi-Fi engineers, built on Raspberry Pi hardware. If you have a WLAN Pi connected to your network, you can easily install the Orb sensor on it to monitor your network's performance.

This guide assumes your WLAN Pi is already set up, connected to your network, and has internet access. We will connect to the device using SSH and run a simple command to install Orb.

## Prerequisites

Before you begin, make sure you have:

- A WLAN Pi device already configured and connected to your network with internet access.
- SSH access enabled on your WLAN Pi device (this is typically enabled by default).
- The IP address of your WLAN Pi device. You can often find this on the device's display or using network scanning tools.
- The username and password for your WLAN Pi device (default is usually `wlanpi` / `wlanpi`).
- A computer on the same network as the WLAN Pi device.

## Step 1: Connect to your WLAN Pi device via SSH

1.  Open a terminal or command prompt on your computer.
    - **macOS/Linux:** Use the Terminal application.
    - **Windows:** Use PowerShell or Command Prompt.
2.  Connect to your WLAN Pi device using the following command, replacing `<your-wlanpi-ip-address>` with the actual IP address:
    ```bash
    ssh wlanpi@<your-wlanpi-ip-address>
    ```
3.  If prompted about the authenticity of the host, type `yes` and press Enter.
4.  Enter the password for your WLAN Pi device when prompted (default is `wlanpi`). You should now have a command prompt logged into your WLAN Pi device.

## Step 2: Install Orb

1.  At the WLAN Pi command prompt, run the following command exactly as shown:
    ```bash
    curl -fsSL https://pkgs.orb.net/install.sh | sh
    ```
2.  This command downloads the Orb setup script and executes it. The script will:
    - Detect the device's architecture and operating system.
    - Add the Orb package repository.
    - Install the Orb package (`orb`) and its dependencies using the system's package manager (apt).
    - Start the Orb Sensor service using systemd.
    - Enable auto-updates to keep Orb up-to-date.
3.  Wait for the script to complete. You should see output indicating the progress of the installation. You might be prompted for your password again during the installation if `sudo` is required.

## Step 3: Open Firewall Port

1.  WLAN Pi uses `ufw` (Uncomplicated Firewall). To allow the Orb app to communicate with the sensor, you need to open port 7443. Run the following command:
    ```bash
    sudo ufw allow 7443/tcp
    ```
2.  Enter your password if prompted. This command configures the firewall to allow incoming TCP traffic on port 7443, which Orb uses.

## Step 4: Link your new Orb Sensor

1.  Once the installation and firewall configuration are done, the Orb Sensor should be running on your WLAN Pi device.
2.  Open the Orb app on your phone or personal computer.
3.  Your new Orb Sensor should be automatically detected on your network and appear in the app, ready to be linked to your account. Follow the prompts in the app to link it.

Congratulations! Your WLAN Pi device is now running as an Orb Sensor, monitoring your network.

## Troubleshooting

- **Installation Fails:**
  - Ensure your WLAN Pi device has a working internet connection. Try pinging an external address like `ping google.com` from the SSH session.
  - Look for errors in the installation script output.
- **Orb Not Detected:**
  - Verify the Orb service is running on the WLAN Pi device: `systemctl status orb`.
  - Check the Orb logs for errors: `journalctl -u orb` or look in `~/.config/orb/logs`.
  - Ensure your phone/computer running the Orb app is on the same network as the WLAN Pi device.
  - Check firewall status: `sudo ufw status`. Ensure port 7443/tcp is listed as ALLOW.
- **General WLAN Pi Issues:** Refer to the official [WLAN Pi Documentation](https://userguide.wlanpi.com/).
