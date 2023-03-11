#!/bin/bash
# Generate UUID version 1

function generate_uuid_v1 {
  # Get the current time in 100-nanosecond intervals since 1582-10-15 00:00:00 UTC
timestamp=$(($(date -u "+%s") * 10000000 + 0x01b21dd213814000))

# Convert the timestamp to a hex string
timestamp_hex=$(printf "%016x" $timestamp)

# Reorder the bytes in the timestamp
uuid_time=$(echo ${timestamp_hex:0:8}${timestamp_hex:8:4}${timestamp_hex:12:4})

# Insert the UUID version (1) into the timestamp
uuid_time=$(echo ${uuid_time:0:12}1${uuid_time:13:16})

# Generate a random clock sequence
clock_seq=$(od -An -N2 -t u2 /dev/random)
#remove white spaces from clock_seq
clock_seq=$(echo $clock_seq | tr -d ' ')

# Set the reserved and variant bits
reserved_hex="80"
variant_hex=$(echo ${clock_seq:0:2} | awk '{print sprintf("%02x", and(0xC0, $1) + 0x80)}')

# Generate the UUID
uuid="${uuid_time:0:8}-${uuid_time:8:4}-$reserved_hex${uuid_time:13:16}-$variant_hex${clock_seq:0:2}-${clock_seq:2:5}"

# Print the UUID
echo "$uuid"
}

# Generate UUID version 4
function generate_uuid_v4 {
  local hexchars="0123456789abcdef"
  # Use provided random 16-byte string
  local random_string="567D61C2EE3B23914141110256D2385"
  # Set the version bits to 0100 for UUID version 4
  local version_bits="4"
  # Set the variant bits to 10 for RFC 4122
  local variant_bits="${hexchars:$((RANDOM % 4 + 8)):1}${hexchars:$((RANDOM % 16)):1}"
  local uuid="${random_string:0:8}-${random_string:8:4}-${version_bits}${random_string:13:3}-${variant_bits}${random_string:16:3}-${random_string:19:12}"
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