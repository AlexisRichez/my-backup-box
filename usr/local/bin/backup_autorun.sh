#!/bin/bash
source config.sh

clear

# Get the mount points from the command-line arguments
sd_mount_points=("$@")

# Source and target directories
source_dir="/mnt/source/"
target_dir="/mnt/target/"

# Generate timestamp for log file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
log_file="$conf_log_directory/backup_autorun_$timestamp.log"

# Redirect stdout ( > ) and stderr (2>&1) to a log file and also display on console
exec > >(tee -a "$log_file") 2>&1

# Function to perform the incremental backup using rsync
perform_backup() {
    # Get the mount point from the function argument
    #mount_point="$1"
    source_dir="$mount_point/"
    target_dir="/mnt/target/"

    mkdir -p $target_dir

    echo "-> Source directory: $source_dir"
    echo "-> Target directory: $target_dir"

    # Check if source and target directories exist
    if [ ! -d "$source_dir" ]; then
        echo "Source directory $source_dir does not exist."
        return 1
    fi
    if [ ! -d "$target_dir" ]; then
        echo "Target directory $target_dir does not exist."
        return 1
    fi

    if rsync -avh --delete --exclude='.git' --info=progress2 "$source_dir" "$target_dir" 2>&1
    then
        message="Rsync backup completed successfully :)"
    else
        message="Rsync backup failed :("
    fi
        
    # Display and log message
    echo "$message"
    #/opt/venv/bin/python3 /usr/local/bin/screen_display.py "$message"
}

# Display script information
echo '=============================================================================='
echo ''
echo '  __  __         ____             _                  ____        '    
echo ' |  \/  |       |  _ \           | |                |  _ \           '
echo ' | \  / |_   _  | |_) | __ _  ___| | ___   _ _ __   | |_) | _____  __'
echo ' | |\/| | | | | |  _ < / _` |/ __| |/ / | | | '\''_ \  |  _ < / _ \ \/ /'
echo ' | |  | | |_| | | |_) | (_| | (__|   <| |_| | |_) | | |_) | (_) >  < '
echo ' |_|  |_|\__, | |____/ \__,_|\___|_|\_\\__,_| .__/  |____/ \___/_/\_\'
echo '          __/ |                             | |                      '
echo '         |___/                              |_|                      '
echo ''
echo '=============================================================================='
echo "Version : $conf_version"
echo '=============================================================================='
echo "Log file: $log_file"
echo "Starting auto incremental backup..."

# Display the contents of the sd_mount_points variable
echo "Mount points: $sd_mount_points"

# Perform the incremental backup
for mount_point in "${sd_mount_points[@]}"; do
    # Perform backup operation for each SD card
    # Replace this with your actual backup command
    echo "Performing backup for SD card at $mount_point..."
    perform_backup "$mount_point"
done

echo "Finished auto incremental backup."