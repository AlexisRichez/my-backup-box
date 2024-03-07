#!/bin/bash

# Define the dialog box
dialog --title "Installation confirmation" \
--backtitle "My backup box" \
--yesno "Are you sure you want to install this tool?" 7 60

# Check the user's response
response=$?
case $response in
  0) 
    echo "Installation started..."

    echo "Installing required packages..."
    apt-get update && apt-get install -y python3 python3-pip rsync python3-venv uuid-runtime cron

    echo "Creating virtual environment for python..."
    python3 -m venv /opt/venv
    echo "Install Adafruit_SSD1306 in python virtual environment..."
    /opt/venv/bin/pip install Adafruit_SSD1306

    mkdir -p /etc/udev/rules.d/
    cp -r ./usr/local/bin/ /usr/local/
    cp -r ./etc/udev/rules.d/99-usb-mount.rules /etc/udev/rules.d/

    echo "Setting chmod for the USB mount script..."
    chmod 644 /etc/udev/rules.d/99-usb-mount.rules

    echo "Creating log directory..."
    mkdir -p /var/log/my-backup-box/

    chmod +x /usr/local/bin/drives_mount.sh
    chmod +x /usr/local/bin/screen_display.py

    echo "Setting autorun backup on boot..."  
    SCRIPT_PATH="/usr/local/bin/backup_autorun.sh"
    (crontab -l 2>/dev/null; echo "@reboot $SCRIPT_PATH") | crontab -

    echo "Installation completed."
    ;;
  1) 
    # If the user selected 'No', exit the script
    echo "Installation cancelled."
    exit 1
    ;;
  255) 
    # If the user pressed 'Esc', exit the script
    echo "Installation cancelled."
    exit 1
    ;;
esac