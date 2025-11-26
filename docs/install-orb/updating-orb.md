---
title: Updating Orb
shortTitle: Updating Orb
metaDescription: Learn how to keep your Orb app and sensors up to date on all platforms.
section: Install Orb
---

# Updating Orb

Keeping your Orb app and sensors up to date ensures you have access to the latest features, improvements, and security updates. This guide explains how to update Orb on different platforms.

## Updating the Orb app

### iOS

1. Open Orb on TestFlight
2. Click "Update" next to the Orb app if available

### Android

1. Open the Google Play Store on your Android device
2. Tap your profile icon in the top right
3. Tap "Manage apps & device"
4. Look for Orb under "Updates available"
5. Tap "Update" next to Orb, or "Update all"
6. Alternatively, enable automatic updates in the Play Store settings

### macOS

1. Open Orb on TestFlight
2. Click "Update" next to the Orb app if available

### Windows

Automatic updates coming soon!

1. Download the latest version from the [Windows installation page](/docs/install-orb/windows.md)
2. Once the .exe file is downloaded, double-click on the file to run the installer
3. Follow the installation prompts to update Orb

## Updating Orb Sensors

### Dedicated Sensors

Most dedicated sensors (Raspberry Pi, Debian/Ubuntu systems, etc.) are configured for automatic updates. To manually update:

#### Debian/Ubuntu/Raspberry Pi OS

```bash
sudo apt-get update
sudo apt-get upgrade orb
```

#### Docker

```bash
docker pull orbforge/orb:latest
# Then restart your container
```

### Router Sensors (GL-MT2500, etc.)

Router-based sensors typically update automatically. You can check for updates in the router's web interface:

1. Log in to your router's admin panel
2. Navigate to the Orb plugin or application section
3. Look for an "Update" button or option

## Update Frequency

We recommend keeping automatic updates enabled for all Orb installations. Our typical update schedule is:

- **Critical Updates**: Released as needed for security or major bug fixes
- **Feature Updates**: Released every 2-4 weeks
- **Minor Updates**: Released weekly for small improvements

## Troubleshooting Updates

### Update Fails to Install

If an update fails to install:

1. Check your internet connection
2. Ensure you have enough free storage space
3. Restart your device and try again
4. For dedicated sensors, check system logs for errors

### Version Verification

To verify your current Orb version:

1. Open the Orb app
2. Go to Settings
3. Look for "About" or "Version Information"
