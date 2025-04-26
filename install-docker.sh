#!/bin/bash

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "You need root privileges to install Docker."
  exit 1
fi

# Check if Docker is already installed
if command -v docker &> /dev/null
then
    echo "Docker is already installed. Skipping installation."
    exit 0
fi

# Update system and install dnf-plugins-core
echo "Updating system and installing dnf-plugins-core..."
dnf -y install dnf-plugins-core

# Add Docker repository
echo "Adding Docker repository..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine
echo "Installing Docker Engine..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker service
echo "Enabling and starting Docker service..."
systemctl enable --now docker

echo "Docker has been successfully installed and started."
