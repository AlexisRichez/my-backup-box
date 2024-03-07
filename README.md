# My Backup Box

This project provides a set of scripts for automating backups using a Raspberry Pi and external storage devices.

## Structure

The project is structured as follows:

- `Dockerfile`: This file is used to build a Docker image for the project.
- `install.sh`: This script installs the necessary dependencies and sets up the environment for the backup scripts.
- `usr/local/bin/`: This directory contains the main scripts for the project:
  - `backup_autorun.sh`: This script performs the actual backup operation.
  - `config.sh`: This script contains configuration variables for the project.
  - `devices_list.sh`: This script lists the devices connected to the Raspberry Pi.
  - `drives_mount.sh`: This script mounts the drives connected to the Raspberry Pi.
  - `screen_display.py`: This script displays messages on an attached OLED screen.
- `etc/udev/rules.d/99-usb-mount.rules`: This file contains udev rules for automatically mounting USB drives when they are connected.

## Installation

To install the project, run the `install.sh` script. This will install the necessary dependencies, set up a Python virtual environment, and copy the scripts to the appropriate locations.

## Usage

To use the project, connect a source drive and a target drive to the Raspberry Pi. The `backup_autorun.sh` script will automatically perform an incremental backup from the source drive to the target drive.

## Docker

A Dockerfile is provided for running the project in a Docker container. To build the Docker image, use the command `docker build -t my-backup-box . --no-cache`. 

To run the Docker container, use the command `docker run -it --rm my-backup-box /bin/bash`.

## Logging

Logs for the backup operations are stored in `/var/log/my-backup-box/`.

## Display

The `screen_display.py` script can be used to display messages on an attached OLED screen. The script takes a single argument, which is the message to display.