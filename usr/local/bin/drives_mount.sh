#!/bin/bash

# Function to check if a device exists and mount it
mount_device() {
    if [ -b "/dev/$1" ]; then
        # Create a directory for mounting
        mount_dir="/mnt/$2"
        sudo mkdir -p "$mount_dir"
        # Mount the device
        sudo mount "/dev/$1" "$mount_dir"
        echo "Mounted /dev/$1 at $mount_dir"
    else
        echo "Device /dev/$1 not found."
    fi
}

# Mount USB drive at /mnt/target
usb_mounted=false
for usb_device in $(lsblk -o NAME -n | grep -e '^sd[b-z][0-9]*$'); do
    mount_device "$usb_device" "target"
    usb_mounted=true
done

# Mount SD card at /mnt/{$uuid}
declare -a sd_mount_points
for sd_device in $(lsblk -o NAME -n | grep -e '^mmcblk[0-9]$' -e '^sd[a-z][0-9]*$'); do
    # Get the UUID of the SD card
    sd_card_uuid=$(blkid -s UUID -o value /dev/$sd_device)

    # Create a mount point using the UUID
    mount_point="/mnt/$sd_card_uuid"
    mkdir -p $mount_point

    # Mount the SD card at the new mount point
    mount_device /dev/$sd_device $mount_point

    # Store the mount point in the array
    sd_mount_points+=("$mount_point")
done

# Check if both USB drive and SD card are mounted
if [ "$usb_mounted" = true ] && [ ${#sd_mount_points[@]} -gt 0 ]; then
    echo "Both USB drive and SD card are mounted successfully..."
    # Run backup_autorun.sh script
    /usr/local/bin/backup_autorun.sh "${sd_mount_points[@]}"
else
    echo "Failed to mount both USB drive and SD card."
fi
