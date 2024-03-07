# Use Raspbian as the base image
FROM debian:latest

# Install any necessary dependencies for your script
# For example, if your script uses the 'dialog' command, you would need to install 'dialog'
RUN apt-get update && apt-get install -y \
    dialog \
    && rm -rf /var/lib/apt/lists/*

# Create two directories to simulate two drives
RUN mkdir /mnt/source /mnt/target
RUN mkdir /mnt/source/550e8400-e29b-41d4-a716-446655440000
RUN mkdir /mnt/source/f47ac10b-58cc-4372-a567-0e02b2c3d479

# Specify that /mnt/source and /mnt/target should be created as mount points
VOLUME [ "/mnt/source", "/mnt/target" ]

# Set the working directory in the Docker image
WORKDIR /usr/src/app

# Copy all files from your current directory to the Docker image
COPY . .

# Make your script executable
RUN chmod +x ./install.sh