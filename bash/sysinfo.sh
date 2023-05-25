#!/bin/bash

# Get the fully-qualified domain name (FQDN)
fqdn=$(hostname)

# Get the operating system name and version
os_info=$(hostnamectl | awk '/Operating System:/ {print $3,$4}')

# Get IP addresses excluding 127.0.0.1
ip_addresses=$(hostname -I | tr ' ' '\n' | grep -v '^127')

# Get the available space in the root filesystem
space=$(df -h / | awk '/\// {print $4}')

# Print the information
echo "Fully-Qualified Domain Name (FQDN): $fqdn"
echo "Operating System: $os_info"
echo "IP Addresses: $ip_addresses"
echo "Available Space in Root Filesystem: $space"

