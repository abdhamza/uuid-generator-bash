#!/bin/bash
# Generate UUID version 1
function generate_uuid_v1 {
  # Get the current timestamp in nanoseconds
  local timestamp=$(date +%s%N)
  # Convert the timestamp to a hexadecimal value and subtract the UUID timestamp offset
  local uuid_time=$(printf '%016x' $((0x${timestamp:0:13} - 0x01b21dd213814000)))
  # Get the MAC address of the first network interface
  local uuid_mac=$(ifconfig | awk '/ether/ {print $2; exit}')
  # Generate a random hexadecimal number for the clock sequence
  local uuid_clock_seq=$(printf '%04x' $((RANDOM * RANDOM)))
  # Print the UUID
  printf '%s-%s-%s-%s-%s\n' ${uuid_time:0:8} ${uuid_time:8:4} ${uuid_time:12:4} ${uuid_clock_seq:0:2} ${uuid_clock_seq:2:2}${uuid_mac//:/}
}

# Generate UUID version 4
function generate_uuid_v4 {
  # Define the hexadecimal characters used in a UUID
  local hexchars="0123456789abcdef"
  # Generate a random sequence of hexadecimal characters for each section of the UUID
  local uuid=""
  for i in {1..8}; do uuid+="${hexchars:$((RANDOM % 16)):1}"; done
  uuid+="-"
  for i in {1..4}; do uuid+="${hexchars:$((RANDOM % 16)):1}"; done
  uuid+="-4"
  for i in {1..3}; do uuid+="${hexchars:$((RANDOM % 16)):1}"; done
  uuid+="-${hexchars:$((RANDOM % 4 + 8)):1}"
  for i in {1..3}; do uuid+="${hexchars:$((RANDOM % 16)):1}"; done
  uuid+="-"
  for i in {1..12}; do uuid+="${hexchars:$((RANDOM % 16)):1}"; done
  # Print the UUID
  printf '%s\n' $uuid
}

# Call the relevent function based on the input argument
if [[ "$1" == "v1" ]]; then
  generate_uuid_v1
elif [[ "$1" == "v4" ]]; then
  generate_uuid_v4
else
  echo "Usage: $0 <v1|v4>"
fi