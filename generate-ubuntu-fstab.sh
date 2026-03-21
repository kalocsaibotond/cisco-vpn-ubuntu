#!/bin/sh

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling install"
  return 1
fi

root_uuid=$(blkid -s UUID -o value "$device_path")
main_root_uuid=$(findmnt -no UUID /)

fstab="UUID=$root_uuid / ext4 defaults 0 0
UUID=$main_root_uuid /mnt/main-root ext4 defaults 0 0"

main_efi_uuid=$(findmnt -no UUID /boot/efi)
if [ -n "$main_efi_uuid" ]; then
  fstab="$fstab\nUUID=$main_efi_uuid /boot/efi vfat defaults 0 0
/boot/efi $mount_point/boot/efi none bind 0 0"
fi

main_home_uuid=$(findmnt -no UUID /home)
if [ -n "$main_home_uuid" ]; then
  fstab="$fstab\nUUID=$main_home_uuid /mnt/main-root/home ext4 defaults 0 0"
fi

swap_uuids=$(swapon --noheadings --show=UUID)
for swap_uuid in $swap_uuids; do
  fstab="$fstab\nUUID=$swap_uuid none swap sw 0 0"
done

echo "$fstab" > ./fstab
chmod uo+r ./fstab
