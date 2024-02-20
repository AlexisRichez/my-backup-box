# Use Raspbian as the base image
FROM debian:latest

# Install any necessary dependencies for your script
# For example, if your script uses the 'dialog' command, you would need to install 'dialog'
RUN apt-get update && apt-get install -y \
    dialog \
    && rm -rf /var/lib/apt/lists/*

# Create two directories to simulate two drives
RUN mkdir /mnt/source /mnt/target

# Specify that /drive1 and /drive2 should be created as mount points
VOLUME [ "/mnt/source", "/mnt/target" ]

# Set the working directory in the Docker image
WORKDIR /usr/src/app

# Copy all files from your current directory to the Docker image
COPY . .

# Make your script executable
RUN chmod +x ./install.sh