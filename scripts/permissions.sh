#!/bin/bash

# Define the host directory to be mounted as /var/lib/grafana in the container
HOST_DIR="/data/grafana"

# Function to run commands with sudo and handle errors
run_with_sudo() {
    echo "$SUDO_PASS" | sudo -S "$@"
}

# Prompt for the sudo password
read -sp "Enter your sudo password: " SUDO_PASS
echo

# Create the directory if it doesn't exist
if [ ! -d "$HOST_DIR" ]; then
    echo "Creating directory $HOST_DIR..."
    run_with_sudo mkdir -p "$HOST_DIR"
fi

# Set ownership to the Grafana user (UID 472) and group (GID 472)
echo "Setting ownership to UID 472 and GID 472..."
run_with_sudo chown -R 472:472 "$HOST_DIR"

# Ensure the directory is writable
echo "Setting permissions to 775..."
run_with_sudo chmod -R 775 "$HOST_DIR"

# Verify the changes
echo "Verifying permissions..."
ls -ld "$HOST_DIR"

# Print success message
echo "The directory $HOST_DIR is ready for Grafana."

