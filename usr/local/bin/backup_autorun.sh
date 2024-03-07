#!/bin/bash
source config.sh

clear

# Source and target directories
source_dir="/mnt/source"
target_dir="/mnt/target"

# Generate timestamp for log file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
log_file="$conf_log_directory/backup_autorun_$timestamp.log"

# Redirect stdout ( > ) and stderr (2>&1) to a log file and also display on console
exec > >(tee -a "$log_file") 2>&1

# Function to perform the incremental backup using rsync
perform_backup() {
    #/opt/venv/bin/python3 /usr/local/bin/screen_display.py "Perform backup..."
    backup_source_dir=$source_dir/$1
    backup_target_dir=$target_dir/$1

    mkdir -p $target_dir

    echo "-> Source directory: $backup_source_dir"
    echo "-> Target directory: $backup_target_dir"

    # Check if source and target directories exist
    if [ ! -d "$backup_source_dir" ]; then
        echo "Source directory $backup_source_dir does not exist."
        return 1
    fi
    if [ ! -d "$target_dir" ]; then
        echo "[Error] Target directory $target_dir does not exist."
        return 1
    fi

    if rsync -avh --delete --exclude='.git' --info=progress2 "$backup_source_dir" "$backup_target_dir" 2>&1
    then
        message="[Success] Rsync backup completed successfully"
    else
        message="[Error] Rsync backup failed"
    fi
        
    # Display message
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

# Get the UUIDs of the directories under source directory
for uuid in $(ls $source_dir)
do
    mount_point="$source_dir/$uuid"
    echo "Performing backup for SD card at $mount_point..."
    perform_backup "$uuid"
done

echo "Finished auto incremental backup."