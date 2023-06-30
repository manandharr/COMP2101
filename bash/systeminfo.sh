#!/bin/bash

# Script: systeminfo.sh
# Description: Generates a system report using various functions
# Author: Kunjan Manandhar

# Import function library
source reportfunctions.sh

# Function: print_help
# Description: Displays help information for the script
function print_help {
  echo "Usage: systeminfo.sh [options]"
  echo "Options:"
  echo "  -h  Display help information and exit"
  echo "  -v  Run script verbosely, showing errors to the user"
  echo "  -system  Generate system report (computer, OS, CPU, RAM, video)"
  echo "  -disk  Generate disk report"
  echo "  -network  Generate network report"
  echo
}

# Function: handle_error
# Description: Handles errors by logging them and displaying them to the user
# Parameters:
#   - error_message: The error message to be logged and displayed
function handle_error {
  local error_message=$1
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $error_message" >> /var/log/systeminfo.log

  if [[ "$VERBOSE" == "true" ]]; then
    echo "Error: $error_message" >&2
  else
    errormessage "$error_message"
  fi
}

# Variables to store command line options
VERBOSE=false
GENERATE_SYSTEM_REPORT=false
GENERATE_DISK_REPORT=false
GENERATE_NETWORK_REPORT=false

# Process command line options
while getopts ":hvsystemdisknetwork" opt; do
  case $opt in
    h)
      print_help
      exit 0
      ;;
    v)
      VERBOSE=true
      ;;
    s)
      GENERATE_SYSTEM_REPORT=true
      ;;
    d)
      GENERATE_DISK_REPORT=true
      ;;
    n)
      GENERATE_NETWORK_REPORT=true
      ;;
    \?)
      handle_error "Invalid option: -$OPTARG"
      print_help
      exit 1
      ;;
  esac
done

# Check for root permission
if [[ $EUID -ne 0 ]]; then
  handle_error "This script must be run as root"
  exit 1
fi

# Generate system report
if [[ "$GENERATE_SYSTEM_REPORT" == "true" ]]; then
  computerreport
  osreport
  cpureport
  ramreport
  videoreport
fi

# Generate disk report
if [[ "$GENERATE_DISK_REPORT" == "true" ]]; then
  diskreport
fi

# Generate network report
if [[ "$GENERATE_NETWORK_REPORT" == "true" ]]; then
  networkreport
fi

# If no specific report options are provided, generate full system report
if [[ "$GENERATE_SYSTEM_REPORT" == "false" && "$GENERATE_DISK_REPORT" == "false" && "$GENERATE_NETWORK_REPORT" == "false" ]]; then
  computerreport
  osreport
  cpureport
  ramreport
  videoreport
  diskreport
  networkreport
fi
