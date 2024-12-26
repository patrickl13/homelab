#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
DRIVE="/dev/sda2"
MOUNT_POINT="/mnt/external_drive"
FILESYSTEM="ext4"

echo "Starting the external drive setup process..."

# Step 1: Unmount the partition if it's already mounted
if mount | grep "$DRIVE"; then
    echo "Unmounting $DRIVE..."
    sudo umount "$DRIVE"
fi

# Step 2: Wipe the partition
echo "Wiping the partition $DRIVE..."
sudo wipefs -a "$DRIVE"

# Step 3: Format the partition
echo "Formatting $DRIVE as $FILESYSTEM..."
sudo mkfs.$FILESYSTEM "$DRIVE"

# Step 4: Create the mount point
echo "Creating mount point at $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"

# Step 5: Mount the partition
echo "Mounting $DRIVE to $MOUNT_POINT..."
sudo mount "$DRIVE" "$MOUNT_POINT"

# Step 6: Set permissions
echo "Setting permissions for $MOUNT_POINT..."
sudo chown -R pi:pi "$MOUNT_POINT"
sudo chmod -R 775 "$MOUNT_POINT"

# Step 7: Add to fstab for automatic mounting
echo "Configuring /etc/fstab for automatic mounting..."
FSTAB_ENTRY="$DRIVE $MOUNT_POINT $FILESYSTEM defaults 0 2"
if ! grep -q "$DRIVE" /etc/fstab; then
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
else
    echo "Entry for $DRIVE already exists in /etc/fstab."
fi

# Step 8: Verify the configuration
echo "Testing the fstab configuration..."
sudo mount -a

# Step 9: Confirm the setup
echo "Verifying the setup..."
df -h | grep "$MOUNT_POINT"

echo "External drive setup complete! Your drive is mounted at $MOUNT_POINT."