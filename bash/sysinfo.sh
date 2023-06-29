#!/bin/bash
# Check if the user has root privilege
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi
######################
# System Description #
######################

# Get system description using dmidecode
system_manufacturer=$(dmidecode -s system-manufacturer)
system_product_name=$(dmidecode -s system-product-name)
system_serial_number=$(dmidecode -s system-serial-number)

# Print system description section
echo "System Description"
echo "=================="
echo "Manufacturer: $system_manufacturer"
echo "Model: $system_product_name"
echo "Serial Number: $system_serial_number"
echo

################
# CPU Information #
################

# Get CPU information using lshw
cpu_info=$(lshw -class processor)

# Print CPU information section
echo "CPU Information"
echo "==============="
while read -r line; do
  if [[ $line =~ "product:" ]]; then
    cpu_model=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "vendor:" ]]; then
    cpu_vendor=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "configuration: cores=" ]]; then
    cpu_cores=$(echo "$line" | awk -F'=' '{print $2}')
  elif [[ $line =~ "clock: " ]]; then
    cpu_speed=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "size: " ]]; then
    cpu_cache=$(echo "$line" | awk -F': ' '{print $2}')
  fi
done <<< "$cpu_info"

echo "Vendor: $cpu_vendor"
echo "Model: $cpu_model"
echo "Architecture: $(uname -m)"
echo "Core Count: $cpu_cores"
echo "Maximum Speed: $cpu_speed"
echo "Cache Sizes: $cpu_cache"
echo

#############################
# Operating System Information #
#############################

# Get operating system information
distro_name=$(lsb_release -ds)
distro_version=$(lsb_release -rs)

# Print operating system information section
echo "Operating System Information"
echo "============================"
echo "Distro: $distro_name"
echo "Version: $distro_version"
echo

##########
# RAM #
##########

# Get RAM information using dmidecode
ram_info=$(dmidecode -t memory)

# Print RAM section
echo "RAM"
echo "==="
echo "Installed Memory Components:"

total_ram_size=0

while IFS= read -r line; do
  if [[ $line =~ "Manufacturer:" ]]; then
    manufacturer=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "Part Number:" ]]; then
    part_number=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "Size:" ]]; then
    size=$(echo "$line" | awk -F': ' '{print $2}')
    total_ram_size=$((total_ram_size + size))
  elif [[ $line =~ "Speed:" ]]; then
    speed=$(echo "$line" | awk -F': ' '{print $2}')
  elif [[ $line =~ "Locator:" ]]; then
    locator=$(echo "$line" | awk -F': ' '{print $2}')
    echo "-------------------------"
    echo "Manufacturer: $manufacturer"
    echo "Part Number: $part_number"
    echo "Size: $size"
    echo "Speed: $speed"
    echo "Location: $locator"
  fi
done <<< "$ram_info"

echo "-------------------------"
echo "Total Installed RAM: $total_ram_size"
echo

##################
# Disk Storage #
##################

# Get disk storage information using lsblk
disk_info=$(lsblk -bo NAME,SIZE,MODEL,MOUNTPOINT,FSTYPE)

# Print disk storage section
echo "Disk Storage"
echo "============"
echo "Installed Disk Drives:"

while read -r name size model mountpoint fstype; do
  if [[ $name != "NAME" ]]; then
    echo "-------------------------"
    echo "Drive: $model"
    echo "Manufacturer: $(hdparm -I /dev/$name | awk -F':' '/Model Number/ {print $2}')"
    echo "Size: $size"
    echo "Partition: $name"
    if [[ -n $mountpoint ]]; then
      echo "Mount Point: $mountpoint"
      echo "Filesystem Size: $(df -h /dev/$name | awk 'NR==2 {print $2}')"
      echo "Free Space: $(df -h /dev/$name | awk 'NR==2 {print $4}')"
    fi
  fi
done <<< "$disk_info"

echo "-------------------------"
