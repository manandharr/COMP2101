#!/bin/bash

# Function: cpureport
# Description: Generates a report for CPU information
function cpureport {
  echo "=== CPU Report ==="
  echo "CPU Manufacturer and Model: $cpu_manufacturer $cpu_model"
  echo "CPU Architecture: $cpu_architecture"
  echo "CPU Core Count: $cpu_core_count"
  echo "CPU Maximum Speed: $cpu_max_speed"
  echo "Cache Sizes:"
  echo "  - L1 Cache: $l1_cache_size"
  echo "  - L2 Cache: $l2_cache_size"
  echo "  - L3 Cache: $l3_cache_size"
  echo
}

# Function: computerreport
# Description: Generates a report for computer information
function computerreport {
  echo "=== Computer Report ==="
  echo "Computer Manufacturer: $computer_manufacturer"
  echo "Computer Description/Model: $computer_description"
  echo "Computer Serial Number: $computer_serial_number"
  echo
}

# Function: osreport
# Description: Generates a report for OS information
function osreport {
  echo "=== OS Report ==="
  echo "Linux Distro: $linux_distro"
  echo "Distro Version: $distro_version"
  echo
}

# Function: ramreport
# Description: Generates a report for RAM information
function ramreport {
  echo "=== RAM Report ==="
  echo "Installed Memory Components:"
  echo "Manufacturer | Model | Size | Speed | Location"
  echo "-----------------------------------------------"
  # Loop through memory components and display information
  for component in "${memory_components[@]}"; do
    echo "$component"
  done
  echo "Total Installed RAM: $total_ram_size"
  echo
}

# Function: videoreport
# Description: Generates a report for video card/chipset information
function videoreport {
  echo "=== Video Report ==="
  echo "Video Card/Chipset Manufacturer: $video_manufacturer"
  echo "Video Card/Chipset Description/Model: $video_description"
  echo
}

# Function: diskreport
# Description: Generates a report for disk drive information
function diskreport {
  echo "=== Disk Report ==="
  echo "Installed Disk Drives:"
  echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Free Space"
  echo "----------------------------------------------------------------------------------"
  # Loop through disk drives and display information
  for drive in "${disk_drives[@]}"; do
    echo "$drive"
  done
  echo
}

# Function: networkreport
# Description: Generates a report for network interface information
function networkreport {
  echo "=== Network Report ==="
  echo "Installed Network Interfaces:"
  echo "Manufacturer | Model/Description | Link State | Current Speed | IP Addresses | Bridge Master | DNS Servers | Search Domains"
  echo "-----------------------------------------------------------------------------------------------------------------------"
  # Loop through network interfaces and display information
  for interface in "${network_interfaces[@]}"; do
    echo "$interface"
  done
  echo
}

# Function: errormessage
# Description: Saves the error message with a timestamp into a logfile and displays the error message to the user
# Parameters:
#   - error_message: The error message to be logged and displayed
function errormessage {
  local error_message=$1
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $error_message" >> /var/log/systeminfo.log
  echo "$error_message" >&2
}
