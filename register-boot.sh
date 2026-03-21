#/bin/sh

device_name=$1
device_path="/dev/$device_name"
if [ ! -b "$device_path" ]; then
  echo "Invalid device name! Cancelling grub registration."
  return 1
fi

root_uuid=$(blkid -s UUID -o value "$device_path")

if ! grep -q "Cisco VPN Ubuntu" /etc/grub.d/40_custom; then
  echo "set number
$ append

menuentry \"Cisco VPN Ubuntu (22.04)\" {
	insmod ext2
	search --no-floppy --set=root --fs-uuid $root_uuid
	linux /boot/vmlinuz root=UUID=$root_uuid ro quiet
	initrd /boot/initrd.img
}
.
xit" | sudo ex /etc/grub.d/40_custom
else
  echo "set number
/Cisco VPN Ubuntu/,/}/ change
menuentry \"Cisco VPN Ubuntu (22.04)\" {
	insmod ext2
	search --no-floppy --set=root --fs-uuid $root_uuid
	linux /boot/vmlinuz root=UUID=$root_uuid ro quiet
	initrd /boot/initrd.img
}
.
xit" | sudo ex /etc/grub.d/40_custom
fi
# sudo grub-mkconfig -o /boot/grub/grub.cfg

