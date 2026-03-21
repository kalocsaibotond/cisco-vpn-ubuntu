#!/bin/sh

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! /etc/fstab registration."
  return 1
fi
mount_point="/mnt/cisco-vpn-ubuntu"

device_uuid=$(blkid -s UUID -o value "$device_path")
if ! grep -q "$mount_point" /etc/fstab; then
  echo "set number
/ \/ / append
UUID=$device_uuid $mount_point ext4 defaults 0 0
.
xit" | sudo ex /etc/fstab
else
  echo "set number
/cisco-vpn-ubuntu/ change
UUID=$device_uuid $mount_point ext4 defaults 0 0
.
xit" | sudo ex /etc/fstab
fi
sudo mkdir -p "$mount_point"
sudo mount -a
