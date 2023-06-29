#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name - must use the while l>
#         If the user includes the option -v on the command line, set the variable $verbose to contain the>
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in fr>
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a >

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed

# TASK 1: Accept options on the command line
verbose="no"
interface="eno1"

# Parse command line options
while getopts ":v" option; do
  case "$option" in
    v) verbose="yes";;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
  esac
done

# Shift the option index so that $1 now refers to the first argument after the options
shift $((OPTIND - 1))

# Check if a non-option argument is provided (interface name)
if [[ $# -eq 1 ]]; then
  interface=$1
fi

#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information"
# we use the hostname command to get our system name and main ip address
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
# the default route can be found in the route table normally
# the router name is obtained with getent
default_router_address=$(ip r s default| awk '{print $3}')
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
# finding external information relies on curl being installed and relies on live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####
# the second part of the output generates a per-interface report
# the task is to change this from something that runs once using a fixed value for the interface name to
#   a dynamic list obtained by parsing the interface names out of a network info command like "ip"
#   and using a loop to run this info gathering section for every interface found

# TASK 2: Dynamically identify the list of interface names
interface_list=$(ip -o link show | awk -F': ' '{print $2}')

# Loop through each interface and generate the report
for interface in $interface_list; do
  [ "$verbose" = "yes" ] && echo "Reporting on interface: $interface"

  [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
  # Find an address and hostname for the interface being summarized
  # we are assuming there is only one IPV4 address assigned to this interface
  ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
  ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

  [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
  # Identify the network number for this interface and its name if it has one
  # Some organizations have enough networks that it makes sense to name them just like how we name hosts
  # To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, a>
  #   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/>
  network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
  network_number=$(cut -d / -f 1 <<<"$network_address")
  network_name=$(getent networks $network_number|awk '{print $1}')

  cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
done
#####
# End of per-interface report
#####
