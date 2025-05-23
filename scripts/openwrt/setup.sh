#!/bin/sh

ARCHITECTURE=$(opkg info busybox | awk '$1 == "Architecture:" { print $2; exit }')
URL="https://pkgs.orb.net/stable/openwrt/$ARCHITECTURE"
KEY_URL="https://pkgs.orb.net/stable/openwrt/key.pub"
KEY_PATH="/etc/opkg/keys/744a82bfef3c5690"
ORB_BINARY="/usr/bin/orb"
FEED_LINE="src/gz orb_packages $URL"
FEED_CONF="/etc/opkg/customfeeds.conf"

# Create persistent orb config directory
mkdir -p /overlay/orb
mkdir -p /.config
[ -L /.config/orb ] || ln -s /overlay/orb /.config/orb

# Add orb feed
grep -Fxq "$FEED_LINE" "$FEED_CONF" || echo "$FEED_LINE" >> "$FEED_CONF"

# Fetch and install key
wget -q -O "$KEY_PATH" "$KEY_URL" || {
	echo "Failed to download key from $KEY_URL"
	exit 1
}

# Install orb
opkg update
opkg install orb || {
	echo "Failed to install orb package"
	exit 1
}

# Set up auto-updates
if [ -x "$ORB_BINARY" ]; then
	/usr/bin/orb-update install
else
	echo "Orb binary not found or not executable at $ORB_BINARY"
	exit 1
fi
