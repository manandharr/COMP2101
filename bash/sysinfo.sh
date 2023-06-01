#!/bin/bash

# Get hostname and fully qualified domain name
hostname=$(hostname)
fqdn=$(hostname -f)

# Get operating system information
os_name=$(lsb_release -ds | cut -d '"' -f 2)
os_version=$(lsb_release -rs)

# Get default IP address
ip_address=$(ip route get 8.8.8.8 | awk '/src/ { print $NF }')

# Get free disk space on root filesystem
disk_space=$(df -h --output=avail / | awk 'NR==2{print $1}')

# Output template
output_template="
Report for $hostname
========================

Hostname: $hostname
Fully Qualified Domain Name: $fqdn

Operating System: $os_name
OS Version: $os_version

Default IP Address: $ip_address

Root Filesystem Space: $disk_space

"

# Display the output
echo "$output_template"
