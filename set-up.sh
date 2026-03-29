#!/bin/sh

# This script sets up the cisco vpn ubuntu system. Its only argument is the
# root partition of the ubuntu installation. It imports the main system's
# fstab into the fstab, and also adds the ubuntu system's root partition
# to main system. Then it registers the ubuntu system into the main
# system's GRUB enties.

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling install"
  return 1
fi

if [ -f "$2" ]; then
  iso_path="$2"
elif [ -f "./ubuntu-22.04.5-live-server-amd64.iso" ]; then
  iso_path="./ubuntu-22.04.5-live-server-amd64.iso"
else
  echo "Invalid device name! Cancelling install"
  return 1
fi
mount_point="/mnt/cisco-vpn-ubuntu"

./register-boot.sh "$device_name"

./make-seed-iso.sh

sudo umount -A "$device_path"

# Aguments and actions in order:
# - Attaching storage device.
# - Attaching ubuntu server image .
# - Conveying cloud-init configuration via seed.iso .
# - Conveying VPN installer and utilies via utilities.iso .
# - Estabilishing internet for the guest.
sudo qemu-system-x86_64 -m 1024 \
-accel kvm \
-accel tcg \
-blockdev driver=raw,node-name=server_image,file.driver=file,file.filename="$iso_path" \
-device virtio-blk-pci,drive=server_image \
-blockdev driver=raw,node-name=seed_image,file.driver=file,file.filename="./seed.iso" \
-device virtio-blk-pci,drive=seed_image \
-blockdev driver=host_device,node-name=root,filename="$device_path" \
-device virtio-blk-pci,drive=root \
-netdev user,id=net0 \
-device virtio-net-pci,netdev=net0


sudo mount "$device_path" "$mount_point"

./register-fstab.sh "$device_name"

./generate-ubuntu-fstab.sh "$device_name"
sudo mv fstab "$mount_point/etc/"
