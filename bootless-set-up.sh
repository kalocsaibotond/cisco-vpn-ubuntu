#!/bin/sh

# This script already assumes an installed system at device_name .
# it does the same as set-up.sh but without boot.

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling install"
  return 1
fi
mount_point="/mnt/cisco-vpn-ubuntu"

# Mount ubuntu root for installation.
if ! findmnt -S "$device_path" -M "$mount_point" > /dev/null; then
  mkdir -p "$mount_point"
  if ! sudo mount "$device_path" "$mount_point"; then
    echo "Could not mount $device_path to $mount_point . Cancelling install!"
    return 1
  fi
fi

./register-boot.sh "$device_name"
./register-fstab.sh "$device_name"

./generate-ubuntu-fstab.sh "$device_name"
sudo mv fstab "$mount_point/etc/"
