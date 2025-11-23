#!/bin/bash

# Get the default gateway
default_gateway=$(ip route | grep default | awk '{print $3}')
#echo "Default Gateway: $default_gateway"

# Get all IP addresses on the system
ip_addresses=$(ip -4 addr show | sed -n 's/.*inet \([0-9.]*\).*/\1/p')

# Loop through each IP address and find the one that matches the default gateway's subnet
for ip in $ip_addresses; do
  # Extract IP and CIDR
  ip_with_cidr=$(ip -4 addr show | grep "$ip" | awk '{print $2}')
  ip=${ip_with_cidr%/*}
  cidr=${ip_with_cidr#*/}

  # Function to calculate the network address
  calculate_network() {
    local ip=$1
    local cidr=$2

    # Split IP into octets
    IFS='.' read -r i1 i2 i3 i4 <<< "$ip"

    # Generate subnet mask from CIDR
    local mask=$((0xffffffff << (32 - cidr) & 0xffffffff))
    local m1=$((mask >> 24 & 0xff))
    local m2=$((mask >> 16 & 0xff))
    local m3=$((mask >> 8 & 0xff))
    local m4=$((mask & 0xff))

    # Perform bitwise AND to calculate network address
    local n1=$((i1 & m1))
    local n2=$((i2 & m2))
    local n3=$((i3 & m3))
    local n4=$((i4 & m4))

    echo "$n1.$n2.$n3.$n4"
  }

  network_ip=$(calculate_network "$ip" "$cidr")
  network_gateway=$(calculate_network "$default_gateway" "$cidr")

  if [ "$network_ip" == "$network_gateway" ]; then
    # Return the HOST_IP value instead of exporting it
    echo "$ip"
    exit 0
  fi
done

# If no matching IP is found
echo "No matching IP found!"
exit 1
