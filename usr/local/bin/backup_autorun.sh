#!/bin/bash
source config.sh

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
    # Check if source and target directories exist
    if [ ! -d "$source_dir" ]; then
        echo "Source directory $source_dir does not exist."
        return 1
    fi
    if [ ! -d "$target_dir" ]; then
        echo "Target directory $target_dir does not exist."
        return 1
    fi

    # Check if there are changes between source and target directories
    changes=$(rsync -avn --delete --exclude='.git' "$source_dir" "$target_dir" | grep -E '^[<>c.]')
    if [ -n "$changes" ]; then
        if rsync -avh --delete --exclude='.git' --info=progress2 "$source_dir" "$target_dir" 2>&1 | tee -a "$log_file"; then
            message="Backup successful :)"
        else
            message="Backup failed :("
        fi
    else
        message="No files to backup !"
    fi

    # Display and log message
    echo "$message" | tee -a "$log_file"
    #/opt/venv/bin/python3 /usr/local/bin/screen_display.py "$message"
}

# Display script information
echo "================================================================" | tee -a "$log_file"
echo "My Backup Box by ARZ" | tee -a "$log_file"
echo "================================================================" | tee -a "$log_file"
echo "Version : $conf_version" | tee -a "$log_file"
echo "================================================================" | tee -a "$log_file"
echo "Starting auto incremental backup..." | tee -a "$log_file"
echo "-> Source directory: $source_dir" | tee -a "$log_file"
echo "-> Target directory: $target_dir" | tee -a "$log_file"
echo "Log file: $log_file" | tee -a "$log_file"

# Perform the incremental backup
perform_backup

echo "Finished auto incremental backup." | tee -a "$log_file"