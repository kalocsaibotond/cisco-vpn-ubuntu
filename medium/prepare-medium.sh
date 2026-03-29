#!/bin/sh

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling install"
  return 1
fi
mount_point="/mnt/cloud-config"

if [ -f "$2" ]; then
  iso_path="$2"
elif [ -f "../ubuntu-22.04.5-live-server-amd64.iso" ]; then
  iso_path="../ubuntu-22.04.5-live-server-amd64.iso"
else
  echo "Invalid device name! Cancelling install"
  return 1
fi

sudo umount -A $device_path*

sudo dd if="$iso_path" of="$device_path" bs=4M status=progress

sudo sgdisk -e "$device_path" -n "4:0:+1M" -t "4:0700" -c "4:Cloud config"

./make-cloud-config-partition.sh "${device_name}4"
