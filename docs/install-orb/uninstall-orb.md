---
title: Uninstall Orb
shortTitle: Uninstall Orb
metaDescription: Instructions for completely removing Orb from your devices.
section: Install Orb
---

# Uninstall Orb

If you need to remove Orb from your devices, this guide provides instructions for different platforms. Note that uninstalling the app will stop all monitoring on that device and remove local data, but your account data will remain stored on our servers.

## Uninstalling from Mobile Devices

### iOS (iPhone and iPad)

1. Find the Orb app icon on your Home Screen or App Library.
2. Press and hold the app icon until a menu appears.
3. Tap "Remove App".
4. Tap "Delete App" in the confirmation dialog.
5. Tap "Delete" to confirm.

### Android

1. Open the Settings app on your Android device.
2. Tap "Apps" or "Applications".
3. Find and tap on Orb in the list of apps.
4. Tap "Uninstall".
5. Tap "OK" to confirm.

Alternatively:

1. Press and hold the Orb app icon in your app drawer or home screen.
2. Drag it to the "Uninstall" option that appears.
3. Tap "OK" to confirm.

## Uninstalling from Desktop

### macOS

1. Open Finder.
2. Click "Applications" in the sidebar.
3. Find the Orb app.
4. Drag it to the Trash, or right-click and select "Move to Trash".
5. Empty the Trash to completely remove the app.

### Windows

1. In Settings, go to Apps > Installed Apps.
2. Find Orb in the list of installed apps.
3. Click on the ... menu and select "Uninstall".
4. Confirm the uninstallation.

## Removing Dedicated Sensors

### Raspberry Pi / Debian / Ubuntu

```bash
# Stop the Orb service
sudo systemctl stop orb

# Disable the service from starting at boot
sudo systemctl disable orb

# Remove the Orb package
sudo apt-get remove --purge orb

# Remove the Orb repository
sudo rm /etc/apt/sources.list.d/orb.list

# Remove the Orb GPG key
sudo rm /usr/share/keyrings/orbforge-keyring.gpg

# Clean up any remaining configuration files
sudo apt-get autoremove
```

### Docker

```bash
# Stop and remove the Orb container
docker stop orb-container
docker rm orb-container

# Remove the Orb image
docker rmi orbforge/orb:latest

# Remove any volumes (optional, this will delete all Orb data)
docker volume rm orb-data
```

## Removing Account Data

Uninstalling the app does not automatically delete your account data from our servers. If you wish to delete your account and all associated data, request account deletion by following the steps here: [request account deletion](/support/deletion-request) on our website after uninstalling.

## Feedback

We're sorry to see you go! If you're uninstalling due to an issue or concern, we'd appreciate your feedback to help us improve. Please consider sending your feedback via our [Contact Us](https://orb.net/contact) page.
