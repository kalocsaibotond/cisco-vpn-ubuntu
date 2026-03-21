#!/bin/sh

mount_point="/mnt/cisco-vpn-ubuntu"

mount_dirs='/dev /dev/pts /proc /sys /run /tmp'
for mount_dir in $mount_dirs; do
  if [ -z "$(findmnt "$mount_point$mount_dir")" ]; then
    sudo mount --bind "$mount_dir" "$mount_point$mount_dir"
  fi
done

sudo chroot "$mount_point" bash

mount_dirs='/dev/pts /dev /proc /sys /run /tmp'
for mount_dir in $mount_dirs; do
  sudo umount "$mount_point$mount_dir"
done
