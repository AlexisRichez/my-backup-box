# Use Raspbian as the base image
FROM debian:latest

# Install packages
RUN apt-get update && apt-get install -y python3 python3-pip rsync python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Install Adafruit_SSD1306 in the virtual environment
RUN /opt/venv/bin/pip install Adafruit_SSD1306

# Create directories for simulated drives and copy initial files
COPY ./mnt/source /mnt/source
COPY ./mnt/target /mnt/target

# Copy mount_script.sh and 99-usb-mount.rules into the image
COPY ./usr/local/bin/ /usr/local/bin/
COPY ./etc/udev/rules.d/99-usb-mount.rules /etc/udev/rules.d/

# Make 99-usb-mount.rules readable by udev
RUN chmod 644 /etc/udev/rules.d/99-usb-mount.rules

# Create directories
RUN mkdir /var/log/my-backup-box/

# Make scripts executable
RUN chmod +x /usr/local/bin/drives_mount.sh
RUN chmod +x /usr/local/bin/screen_display.py

# Entrypoint or CMD instruction if needed
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["run_application"]
