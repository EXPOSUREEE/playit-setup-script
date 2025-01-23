#!/bin/bash
# Playit.gg setup script for Debian

# Define the latest Playit version URL
PLAYIT_URL="https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64"
PLAYIT_BIN="/usr/local/bin/playit"

# Stop existing Playit service if running
if systemctl list-units --full -all | grep -q "playit.service"; then
    echo "Stopping existing Playit service..."
    sudo systemctl stop playit.service
    sudo systemctl disable playit.service
fi

# Remove old Playit binary if it exists
if [ -f "$PLAYIT_BIN" ]; then
    echo "Removing old Playit binary..."
    sudo rm -f "$PLAYIT_BIN"
fi

# Download latest Playit binary
echo "Downloading latest Playit version..."
curl -L "$PLAYIT_URL" -o playit-linux-amd64
chmod +x playit-linux-amd64
sudo mv playit-linux-amd64 "$PLAYIT_BIN"

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/playit.service
[Unit]
Description=Playit.gg Tunnel Host
After=network-online.target

[Service]
Type=simple
Restart=always
User=$USER
ExecStart=$PLAYIT_BIN

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable playit.service
sudo systemctl start playit.service

# Confirm installation
echo "Playit.gg has been installed and is running as a service."
echo "Use 'systemctl status playit' to check the service status."
