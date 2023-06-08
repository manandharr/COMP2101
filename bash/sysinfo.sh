#!/bin/bash

# Output template
output_template="
Report for $(hostname)
===============
FQDN: $(hostname --fqdn)
Operating System name and version: $(lsb_release -d | awk -F'\t' '{print $2}')
IP Address: $(ip route get 8.8.8.8 | awk '{print $7}')
Root Filesystem Free Space: $(df -h / | awk 'NR==2 {print $4}')
===============
"

# Display the output
echo "$output_template"
