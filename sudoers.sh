#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with root privileges."
    exit 1
fi

# Ensure the script receives the username and password as parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <password>"
    exit 1
fi

# Get the username and password from the arguments
username=$1
password=$2

# Create the new user and set the password
useradd $username
echo "$username:$password" | chpasswd

# Add the user to the 'wheel' group (grant sudo privileges)
usermod -aG wheel $username

# Add the user to sudoers file to allow them to execute commands as root without password
echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Check if the user was successfully created and granted sudo privileges
echo "User $username has been created and granted sudo privileges."
