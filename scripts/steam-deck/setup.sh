#!/bin/bash

set -e

DOWNLOAD_URL="https://orb-binaries-6c666f0aaa0743cda7fcd01dfb71dcb7.orb.link/orb/edge/orb-linux-amd64.zip"
INSTALL_DIR="$HOME/.local/bin"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/orb.service"
UPDATE_SCRIPT_PATH="$HOME/.local/bin/orb-update.sh"
TIMER_FILE="$SERVICE_DIR/orb-update.timer"
TMP_ZIP_PATH="/tmp/orb_download.zip"
TMP_BIN_PATH="/tmp/orb_extracted"

# Downloads and extracts the orb binary to a temporary location
download_and_extract_orb() {
    local url="$1"
    local zip_dest="$2"
    local bin_dest="$3"
    local zip_entry="orb-linux-amd64" # Entry name inside the zip

    echo "Downloading Orb from $url..."
    wget -O "$zip_dest" "$url"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Orb."
        exit 1
    fi

    echo "Extracting Orb to $bin_dest..."
    unzip -p "$zip_dest" "$zip_entry" > "$bin_dest"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract Orb from $zip_dest."
        rm -f "$zip_dest" # Clean up zip on extraction failure
        exit 1
    fi
    echo "Extraction successful."
}

# --- Main Installation ---
echo "🔮 Preparing Orb installation..."

# Download and extract
download_and_extract_orb "$DOWNLOAD_URL" "$TMP_ZIP_PATH" "$TMP_BIN_PATH"

echo "🌀 Installing orb to $INSTALL_DIR..."

# Create bin dir if missing
mkdir -p "$INSTALL_DIR"

# Copy extracted binary to final location
cp "$TMP_BIN_PATH" "$INSTALL_DIR/orb"
chmod +x "$INSTALL_DIR/orb"

# Clean up temporary files
rm -f "$TMP_BIN_PATH" "$TMP_ZIP_PATH"

echo "✅ orb binary installed."

# Create systemd service directory
mkdir -p "$SERVICE_DIR"

# Create the systemd user service
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Orb Sensor
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/orb sensor
Restart=on-failure

[Install]
WantedBy=default.target
EOF

echo "✅ systemd user service created at $SERVICE_FILE."

echo "🔄 Creating Orb update script..."

# Create the update script
# Note: We redefine the download function and variables inside the script
# to make it self-contained and avoid issues with environment/sourcing.
cat > "$UPDATE_SCRIPT_PATH" <<EOF
#!/bin/bash
set -e

# TODO - final url (ensure this matches the main script)
DOWNLOAD_URL="https://orb-binaries-6c666f0aaa0743cda7fcd01dfb71dcb7.orb.link/orb/edge/orb-linux-amd64.zip"
INSTALL_DIR="\$HOME/.local/bin" # Use escaped \$HOME
TMP_ZIP_PATH="/tmp/orb_update.zip" # Use different temp names for update
TMP_BIN_PATH="/tmp/orb_update_extracted"

download_and_extract_orb() {
    local url="\$1"
    local zip_dest="\$2"
    local bin_dest="\$3"
    local zip_entry="orb-linux-amd64" # Entry name inside the zip

    echo "Downloading Orb update from \$url..."
    wget -O "\$zip_dest" "\$url"
    if [ \$? -ne 0 ]; then
        echo "Error: Failed to download Orb update."
        exit 1
    fi

    echo "Extracting Orb update to \$bin_dest..."
    unzip -p "\$zip_dest" "\$zip_entry" > "\$bin_dest"
    if [ \$? -ne 0 ]; then
        echo "Error: Failed to extract Orb update from \$zip_dest."
        rm -f "\$zip_dest" # Clean up zip on extraction failure
        exit 1
    fi
    echo "Update extraction successful."
}

echo "Updating Orb..."

# Download and extract the new version
download_and_extract_orb "\$DOWNLOAD_URL" "\$TMP_ZIP_PATH" "\$TMP_BIN_PATH"

# Stop the service before replacing the binary
echo "Stopping Orb service..."
systemctl --user stop orb.service
# Allow some time for the process to exit gracefully
sleep 2

# Replace the old binary
echo "Replacing old binary in \$INSTALL_DIR..."
cp "\$TMP_BIN_PATH" "\$INSTALL_DIR/orb"
chmod +x "\$INSTALL_DIR/orb"

# Clean up temporary files
rm -f "\$TMP_BIN_PATH" "\$TMP_ZIP_PATH"

# Restart the service to use the new binary
echo "Restarting Orb service..."
systemctl --user restart orb.service
if [ \$? -ne 0 ]; then
    echo "Warning: Failed to restart orb.service. It might not have been running."
fi

echo "Orb updated successfully."
EOF

chmod +x "$UPDATE_SCRIPT_PATH"
echo "✅ Orb update script created at $UPDATE_SCRIPT_PATH."

echo "⏲️ Creating systemd timer for Orb updates..."

# Create the systemd timer unit
cat > "$TIMER_FILE" <<EOF
[Unit]
Description=Run orb-update daily and on boot

[Timer]
OnCalendar=daily
Persistent=true
Unit=orb-update.service

[Install]
WantedBy=timers.target
EOF

# Create a simple service file for the update script itself
cat > "$SERVICE_DIR/orb-update.service" <<EOF
[Unit]
Description=Orb Update Service

[Service]
Type=oneshot
ExecStart=$UPDATE_SCRIPT_PATH
EOF

echo "✅ systemd timer created at $TIMER_FILE."

# Reload systemd, enable/start the service and the timer
systemctl --user daemon-reload
systemctl --user enable orb.service
systemctl --user enable orb-update.timer # Enable the timer
systemctl --user restart orb.service
systemctl --user start orb-update.timer # Start the timer

echo "🎉 Orb is installed and running as a sensor!"
echo "🔄 Orb will now automatically update daily."
