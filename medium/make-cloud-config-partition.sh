#!/bin/sh

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling install"
  return 1
fi
mount_point="/mnt/cloud-config"

sudo umount -A "$device_path"

sudo mkfs.vfat -F 32 -n CIDATA "$device_path"

sudo mkdir -p "$mount_point"
sudo mount "$device_path" "$mount_point"

sudo cp user-data "$mount_point"
sudo touch "$mount_point/meta-data"
